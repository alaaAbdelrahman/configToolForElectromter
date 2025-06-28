#include "ConfigGenerator.h"
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStringConverter>
#include <QJsonArray>

ConfigGenerator::ConfigGenerator(QObject *parent) : QObject(parent) {}

QVariantMap ConfigGenerator::config() const {
    return m_config;
}

void ConfigGenerator::setConfig(const QVariantMap &newConfig) {
    qDebug() << "setConfig called with:" << newConfig;
    QVariantMap mergedConfig = m_config;
    for (auto it = newConfig.constBegin(); it != newConfig.constEnd(); ++it) {
        mergedConfig[it.key()] = it.value();
    }
    if (m_config != mergedConfig) {
        m_config = mergedConfig;
        qDebug() << "Merged config:" << m_config;
        emit configChanged();
    }
}

void ConfigGenerator::setValue(const QString &key, const QVariant &value) {
    QVariantMap newConfig = m_config;
    setNestedValue(newConfig, key, value);
    if (newConfig != m_config) {
        m_config = newConfig;
        emit configChanged();
    }
}

void ConfigGenerator::onConfigUpdated(const QVariantMap &newConfig) {
    qDebug() << "onConfigUpdated called with:" << newConfig;
    setConfig(newConfig);
}

QVariantMap ConfigGenerator::schema() const {
    return m_schema;
}

QVariantList ConfigGenerator::enumOptions(const QString &key) const {
    QStringList parts = key.split('.');
    QVariantMap current = m_schema;
    for (const QString &part : parts) {
        current = current.value(part).toMap();
        if (current.isEmpty()) return QVariantList();
    }
    return current.value("values").toList();
}

bool ConfigGenerator::loadSchema(const QString &filePath) {
    qDebug() << "Loading schema from:" << filePath;
    qDebug() << "Absolute path:" << QFileInfo(filePath).absoluteFilePath();
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open schema file:" << filePath;
        emit errorOccurred("Cannot open schema: " + filePath);
        return false;
    }

    const QByteArray data = file.readAll();
    if (data.isEmpty()) {
        qWarning() << "Schema file is empty.";
        emit errorOccurred("Schema file is empty.");
        return false;
    }

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        qWarning() << "Failed to parse schema JSON:" << parseError.errorString();
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

    qDebug() << "Loaded schema:" << QJsonDocument::fromVariant(schema).toJson(QJsonDocument::Indented);
    m_config = std::move(config);
    m_defaults = std::move(defaults);
    m_schema = std::move(schema);

    emit configChanged();
    emit schemaChanged();
    return true;
}

bool ConfigGenerator::loadConfig(const QString &filePath) {
    qDebug() << "Loading config from:" << filePath;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open config file:" << filePath;
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
                // Determine type from schema
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
                    newConfig[key] = true; // #define KEY means true for booleans
                }
                qDebug() << "Loaded config key:" << key << "value:" << newConfig[key];
            }
        } else if (line.startsWith("#undef")) {
            QStringList parts = line.split(" ", Qt::SkipEmptyParts);
            if (parts.size() >= 2) {
                QString key = parts[1];
                newConfig[key] = false; // #undef KEY means false
                qDebug() << "Loaded config key:" << key << "value:" << newConfig[key];
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

QString ConfigGenerator::generateConfigHeader() const {
    qDebug() << "generateConfigHeader called, m_config:" << m_config;
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

    // Collect all configuration keys from schema
    QStringList configKeys;
    std::function<void(const QVariantMap &, const QString &)> collectKeys;
    collectKeys = [&](const QVariantMap &schema, const QString &prefix) {
        for (auto it = schema.constBegin(); it != schema.constEnd(); ++it) {
            QString key = it.key();
            if (it.value().canConvert<QVariantMap>()) {
                QVariantMap nested = it.value().toMap();
                if (nested.contains("type")) {
                    // Leaf node with type (e.g., bool, enum, integer)
                    QString fullKey = prefix.isEmpty() ? key : prefix + "." + key;
                    configKeys.append(fullKey);
                } else {
                    // Nested group (e.g., Control, Device)
                    collectKeys(nested, prefix.isEmpty() ? key : prefix + "." + key);
                }
            }
        }
    };

    collectKeys(m_schema, "");

    // Group keys by section for output
    QMap<QString, QStringList> sectionKeys;
    for (const QString &key : configKeys) {
        QString section = key.contains(".") ? key.split(".").first() : "General";
        sectionKeys[section].append(key);
    }

    // Generate configuration for each section
    for (auto it = sectionKeys.constBegin(); it != sectionKeys.constEnd(); ++it) {
        const QString &section = it.key();
        const QStringList &keys = it.value();
        out << "// " << section << " Settings\n";
        for (const QString &key : keys) {
            if (m_config.contains(key)) {
                const QVariant &val = m_config[key];
                QString schemaType = getSchemaType(key);
                if (schemaType == "boolean" && val.type() == QVariant::Bool) {
                    if (val.toBool()) {
                        out << "#define " << key.split(".").last() << "\n";
                    } else {
                        out << "#undef " << key.split(".").last() << "\n";
                    }
                } else if (schemaType == "enum" ) {
                    if (val.canConvert<QString>()) {
                        out << "#define " << " " << val.toString() << "\n";
                    }
                    else if(schemaType == "string"){
                        out << "#define " << " " <<"'"<< val.toString() <<"'"<< "\n";
                    }
                }else if (schemaType == "map") {
                    if (val.canConvert<QString>()) {
                        out << "#define " << key.split(".").last() << " " << val.toString() << "\n";
                    }
                }else if (schemaType == "integer") {
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

QString ConfigGenerator::getSchemaType(const QString &key) const {
    QStringList parts = key.split('.');
    QVariantMap current = m_schema;
    for (const QString &part : parts) {
        current = current.value(part).toMap();
        if (current.isEmpty()) return "";
    }
    return current.value("type").toString();
}

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
