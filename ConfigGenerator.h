#ifndef CONFIGGENERATOR_H
#define CONFIGGENERATOR_H

#include <QObject>
#include <QVariantMap>
#include <QFile>
#include <QTextStream>

class ConfigGenerator : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantMap config READ config NOTIFY configChanged)
    Q_PROPERTY(QVariantMap schema READ schema NOTIFY schemaChanged)

public:
    explicit ConfigGenerator(QObject *parent = nullptr);

    QVariantMap config() const;
    QVariantMap schema() const;

    //Q_INVOKABLE QVariant getValue(const QString &key) const;
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    // Q_INVOKABLE QVariant getSchemaProperty(const QString &path, const QString &property) const;
    Q_INVOKABLE bool loadSchema(const QString &filePath);
    Q_INVOKABLE bool loadConfig(const QString &filePath);
    // Q_INVOKABLE bool saveConfig(const QString &filePath);
    Q_INVOKABLE QString generateConfigHeader() const;
    Q_INVOKABLE bool generateConfigFile(const QString &fileUrl);
    Q_INVOKABLE QString getSchemaType(const QString &key) const;
    //Q_INVOKABLE QString findSchemaKey(const QString &key) const;

    Q_INVOKABLE void setConfig(const QVariantMap &newConfig);
    Q_INVOKABLE QVariantList enumOptions(const QString &key) const;

public slots:
    void onConfigUpdated(const QVariantMap &updatedConfig);

signals:
    void configChanged();
    void schemaChanged();
    void errorOccurred(const QString &message);

private:

    void processJsonObject(const QJsonObject &obj, QVariantMap &config, QVariantMap &schema);
    QVariant getNestedValue(const QVariantMap &map, const QString &path) const;
    void setNestedValue(QVariantMap &map, const QString &path, const QVariant &value);

    QVariantMap m_defaults;
    QVariantMap m_config;
    QVariantMap m_schema;
};

#endif // CONFIGGENERATOR_H
