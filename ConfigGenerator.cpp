#include "ConfigGenerator.h"
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

ConfigGenerator::ConfigGenerator(QObject *parent) : QObject(parent) {}

/**
 * @brief Retrieves the current configuration map.
 * @return A QVariantMap containing the current configuration settings.
 */
QVariantMap ConfigGenerator::config() const {
    return m_config;
}

/**
 * @brief Sets a new configuration map, merging it with the existing one.
 * @param newConfig The new configuration map to merge.
 */
void ConfigGenerator::setConfig(const QVariantMap &newConfig) {
    QVariantMap mergedConfig = m_config;
    for (auto it = newConfig.constBegin(); it != newConfig.constEnd(); ++it) {
        mergedConfig[it.key()] = it.value();
    }
    if (m_config != mergedConfig) {
        m_config = mergedConfig;
        emit configChanged();
    }
}

/**
 * @brief Sets a specific value in the configuration using a dot-notated key.
 * @param key The dot-notated path to the configuration key (e.g., "section.key").
 * @param value The value to set for the specified key.
 */
void ConfigGenerator::setValue(const QString &key, const QVariant &value) {
    QVariantMap newConfig = m_config;
    setNestedValue(newConfig, key, value);
    if (newConfig != m_config) {
        m_config = newConfig;
        emit configChanged();
    }
}

/**
 * @brief Updates the configuration based on a new configuration map.
 * @param newConfig The new configuration map to apply.
 */
void ConfigGenerator::onConfigUpdated(const QVariantMap &newConfig) {
    setConfig(newConfig);
}

/**
 * @brief Retrieves the schema defining the configuration structure.
 * @return A QVariantMap representing the schema.
 */
QVariantMap ConfigGenerator::schema() const {
    return m_schema;
}

/**
 * @brief Retrieves the list of enum options for a given configuration key.
 * @param key The dot-notated path to the configuration key.
 * @return A QVariantList containing the enum options, or an empty list if not found.
 */
QVariantList ConfigGenerator::enumOptions(const QString &key) const {
    QStringList parts = key.split('.');
    QVariantMap current = m_schema;
    for (const QString &part : parts) {
        current = current.value(part).toMap();
        if (current.isEmpty()) return QVariantList();
    }
    return current.value("values").toList();
}

/**
 * @brief Loads a schema from a JSON file.
 * @param filePath The path to the schema JSON file.
 * @return true if the schema was loaded successfully, false otherwise.
 */
bool ConfigGenerator::loadSchema(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        emit errorOccurred("Cannot open schema: " + filePath);
        return false;
    }

    const QByteArray data = file.readAll();
    if (data.isEmpty()) {
        emit errorOccurred("Schema file is empty.");
        return false;
    }

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        emit errorOccurred("Schema parse error: " + parseError.errorString());
        return false;
    }

    const QJsonObject rootObj = doc.object();
    QVariantMap config;
    QVariantMap defaults;
    QVariantMap schema;

    std::function<void(const QJsonObject &, QVariantMap &, QVariantMap &, QVariantMap &, const QString &)> processGroup;
    processGroup = [&](const QJsonObject &obj, QVariantMap &conf, QVariantMap &defs, QVariantMap &sch, const QString &prefix) {
        for (const auto &[key, value] : obj.toVariantMap().asKeyValueRange()) {
            QString fullKey = prefix.isEmpty() ? key : prefix + "." + key;
            if (value.canConvert<QVariantMap>()) {
                QVariantMap nestedConf, nestedDefs, nestedSchema;
                processGroup(QJsonObject::fromVariantMap(value.toMap()), nestedConf, nestedDefs, nestedSchema, fullKey);
                sch[key] = nestedSchema;
                if (!nestedConf.isEmpty()) {
                    conf[key] = nestedConf;
                }
                if (!nestedDefs.isEmpty()) {
                    defs[key] = nestedDefs;
                }
            } else if (value.canConvert<QVariantList>()) {
                sch[key] = value;
            } else {
                sch[key] = value;
                if (key == "default") {
                    conf[fullKey] = value;
                    defs[fullKey] = value;
                }
            }
        }
    };

    processGroup(rootObj, config, defaults, schema, "");

    m_config = std::move(config);
    m_defaults = std::move(defaults);
    m_schema = std::move(schema);

    emit configChanged();
    emit schemaChanged();
    return true;
}

/**
 * @brief Loads a configuration from a header file.
 * @param filePath The path to the configuration header file.
 * @return true if the configuration was loaded successfully, false otherwise.
 */
bool ConfigGenerator::loadConfig(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit errorOccurred("Cannot open config file: " + filePath);
        return false;
    }

    QVariantMap newConfig = m_config;
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.startsWith("#define")) {
            QStringList parts = line.split(" ", Qt::SkipEmptyParts);
            if (parts.size() >= 2) {
                QString key = parts[1];
                QString value = parts.size() >= 3 ? parts[2] : "";
                QString schemaType = getSchemaType(key);
                if (schemaType == "enum" || schemaType == "string" || schemaType == "map") {
                    newConfig[key] = value;
                } else if (schemaType == "integer") {
                    bool ok;
                    int intValue = value.toInt(&ok);
                    if (ok) {
                        newConfig[key] = intValue;
                    }
                } else {
                    newConfig[key] = true;
                }
            }
        } else if (line.startsWith("#undef")) {
            QStringList parts = line.split(" ", Qt::SkipEmptyParts);
            if (parts.size() >= 2) {
                QString key = parts[1];
                newConfig[key] = false;
            }
        }
    }
    file.close();

    if (newConfig != m_config) {
        m_config = newConfig;
        emit configChanged();
    }
    return true;
}

/**
 * @brief Generates and saves a configuration header file.
 * @param fileUrl The URL or path where the header file should be saved.
 * @return true if the file was generated and saved successfully, false otherwise.
 */
bool ConfigGenerator::generateConfigFile(const QString &fileUrl) {
    QString filePath = QUrl(fileUrl).toLocalFile();
    if (fileUrl.isEmpty() || filePath.isEmpty()) {
        emit errorOccurred("Invalid file path.");
        return false;
    }

    QFileInfo fileInfo(filePath);
    QDir dir = fileInfo.dir();
    if (!dir.exists() && !dir.mkpath(".")) {
        emit errorOccurred("Cannot create directory.");
        return false;
    }

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit errorOccurred("Cannot open file for writing.");
        return false;
    }

    QTextStream out(&file);
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    out.setEncoding(QStringConverter::Utf8);
#else
    out.setCodec("UTF-8");
#endif
    out << generateConfigHeader();
    file.close();

    if (file.error() != QFile::NoError) {
        emit errorOccurred("File write error: " + file.errorString());
        return false;
    }

    return true;
}

/**
 * @brief Generates the content of the configuration header as a string.
 * @return A QString containing the header file content.
 */
QString ConfigGenerator::generateConfigHeader() const {
    QString content;
    QTextStream out(&content);

    out << "// Auto-generated configuration file\n";
    out << "/**\n";
    out << " * @brief " << (m_config.contains("descriptionBrief") ? m_config["descriptionBrief"].toString() : "MISSING") << "\n";
    out << " * @version " << (m_config.contains("descriptionVersion") ? m_config["descriptionVersion"].toString() : "MISSING") << "\n";
    out << " * @date " << (m_config.contains("descriptionDate") ? m_config["descriptionDate"].toString() : "MISSING") << "\n";
    out << " * @author " << (m_config.contains("descriptionAuthor") ? m_config["descriptionAuthor"].toString() : "MISSING") << "\n";
    out << " * @details " << (m_config.contains("descriptionDetails") ? m_config["descriptionDetails"].toString() : "MISSING") << "\n";
    out << " */\n";
    out << "#ifndef CONFIGURABLE_METER_OPTIONS_H\n";
    out << "#define CONFIGURABLE_METER_OPTIONS_H\n\n";

    QStringList configKeys;
    std::function<void(const QVariantMap &, const QString &)> collectKeys;
    collectKeys = [&](const QVariantMap &schema, const QString &prefix) {
        for (auto it = schema.constBegin(); it != schema.constEnd(); ++it) {
            QString key = it.key();
            if (it.value().canConvert<QVariantMap>()) {
                QVariantMap nested = it.value().toMap();
                if (nested.contains("type")) {
                    QString fullKey = prefix.isEmpty() ? key : prefix + "." + key;
                    configKeys.append(fullKey);
                } else {
                    collectKeys(nested, prefix.isEmpty() ? key : prefix + "." + key);
                }
            }
        }
    };

    collectKeys(m_schema, "");

    QMap<QString, QStringList> sectionKeys;
    for (const QString &key : configKeys) {
        QString section = key.contains(".") ? key.split(".").first() : "General";
        sectionKeys[section].append(key);
    }

    for (auto it = sectionKeys.constBegin(); it != sectionKeys.constEnd(); ++it) {
        const QString &section = it.key();
        const QStringList &keys = it.value();
        out << "// " << section << " Settings\n";
        for (const QString &key : keys) {
            if (m_config.contains(key)) {
                const QVariant &val = m_config[key];
                QString schemaType = getSchemaType(key);
                if (schemaType == "boolean") {
                    if (val.toBool()) {
                        out << "#define " << key.split(".").last() << "\n";
                    } else {
                        out << "#undef " << key.split(".").last() << "\n";
                    }
                } else if (schemaType == "enum") {
                    if (val.canConvert<QString>()) {
                        out << "#define " << key.split(".").last() << " " << val.toString() << "\n";
                    }
                } else if (schemaType == "string") {
                    if (val.canConvert<QString>()) {
                        out << "#define " << key.split(".").last() << " '" << val.toString() << "'\n";
                    }
                } else if (schemaType == "map") {
                    if (val.canConvert<QString>()) {
                        out << "#define " << key.split(".").last() << " " << val.toString() << "\n";
                    }
                } else if (schemaType == "integer") {
                    if (val.canConvert<int>()) {
                        out << "#define " << key.split(".").last() << " " << val.toInt() << "\n";
                    }
                }
            }
        }
        out << "\n";
    }

    out << "#endif // CONFIGURABLE_METER_OPTIONS_H\n";
    return content;
}

/**
 * @brief Retrieves the type of a configuration key from the schema.
 * @param key The dot-notated path to the configuration key.
 * @return A QString representing the type (e.g., "boolean", "integer"), or empty if not found.
 */
QString ConfigGenerator::getSchemaType(const QString &key) const {
    QStringList parts = key.split('.');
    QVariantMap current = m_schema;
    for (const QString &part : parts) {
        current = current.value(part).toMap();
        if (current.isEmpty()) return "";
    }
    return current.value("type").toString();
}

/**
 * @brief Sets a nested value in a QVariantMap using a dot-notated path.
 * @param map The QVariantMap to modify.
 * @param path The dot-notated path to the value.
 * @param value The value to set.
 */
void ConfigGenerator::setNestedValue(QVariantMap &map, const QString &path, const QVariant &value) {
    QStringList parts = path.split('.');
    if (parts.isEmpty()) return;

    QVariantMap *current = &map;
    for (int i = 0; i < parts.size() - 1; ++i) {
        const QString &part = parts[i];
        QVariant &nextVar = (*current)[part];
        if (!nextVar.canConvert<QVariantMap>()) {
            nextVar = QVariantMap();
        }
        current = static_cast<QVariantMap *>(nextVar.data());
        if (!current) {
            nextVar = QVariantMap();
            current = static_cast<QVariantMap *>(nextVar.data());
        }
    }
    (*current)[parts.last()] = value;
}
