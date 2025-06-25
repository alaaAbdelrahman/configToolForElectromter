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
    if (m_config != newConfig) {
        m_config = newConfig;
        emit configChanged();
    }
}

void ConfigGenerator::onConfigUpdated(const QVariantMap &newConfig) {
    setConfig(newConfig);
    qDebug() << "Config updated:" << newConfig;
}

QVariantMap ConfigGenerator::schema() const {
    return m_schema;
}
QVariantList ConfigGenerator::enumOptions(const QString &key) const {
    return m_schema.value(key).toList();
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

    for (const auto &[groupKey, groupVal] : rootObj.toVariantMap().asKeyValueRange()) {
        const auto fields = groupVal.toMap();
        for (const auto &[fieldKey, fieldVal] : fields.asKeyValueRange()) {
            const auto fieldMap = fieldVal.toMap();

            if (fieldMap.contains("default")) {
                const auto defVal = fieldMap["default"];
                config[fieldKey] = defVal;
                defaults[fieldKey] = defVal;
            }

            if (fieldMap.value("type").toString() == "enum" && fieldMap.contains("values")) {
                const auto valuesList = fieldMap["values"].toList();
                schema[fieldKey] = valuesList;
            }
        }
    }

    m_config = std::move(config);
    m_defaults = std::move(defaults);
    m_schema = std::move(schema);



    emit configChanged();
    emit schemaChanged();
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

    for (auto it = m_config.begin(); it != m_config.end(); ++it) {
        const QString &key = it.key();
        const QVariant &val = it.value();

        if (key.startsWith("description")) continue; // Skip description fields

        if (val.type() == QVariant::Bool) {
           // out << (val.toBool() ? "#define " : "#undef ") << key.toUpper() << "\n";
        } else if (val.canConvert<QString>()) {
            out << "#define " << key << " " << val.toString() << "\n";
        }
    }

    out << "\n#endif // CONFIGURABLE_METER_OPTIONS_H\n";
    return content;
}
