#pragma once
#include <QObject>
#include <QVariantMap>
#include <QString>

class ConfigGenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap config READ config WRITE setConfig NOTIFY configChanged)
    Q_PROPERTY(QVariantMap schema READ schema NOTIFY schemaChanged)

public:
    explicit ConfigGenerator(QObject *parent = nullptr);

    QVariantMap config() const;
    QVariantMap schema() const;

    void setConfig(const QVariantMap &newConfig);
    Q_INVOKABLE void onConfigUpdated(const QVariantMap &newConfig);
    Q_INVOKABLE bool generateConfigFile(const QString &fileUrl);
    Q_INVOKABLE QString generateConfigHeader() const;
    Q_INVOKABLE bool loadSchema(const QString &filePath);
    Q_INVOKABLE QVariantList enumOptions(const QString &key) const;

signals:
    void configChanged();
    void errorOccurred(const QString &message);
    void schemaChanged();

private:
    QVariantMap m_config;
    QVariantMap m_defaults;
    QVariantMap m_schema;
};
