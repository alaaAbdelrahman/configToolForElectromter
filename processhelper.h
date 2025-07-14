#ifndef PROCESSHELPER_H
#define PROCESSHELPER_H

#include <QObject>
#include <QProcess>

class ProcessHelper : public QObject
{
    Q_OBJECT

public:
    explicit ProcessHelper(QObject *parent = nullptr);
    ~ProcessHelper();

    Q_INVOKABLE void start(const QString &command);

signals:
    void finished(int exitCode, const QByteArray &output, const QByteArray &error);

private slots:
    void onProcessFinished(int exitCode, QProcess::ExitStatus status);

private:
    QProcess *m_process;
};

#endif // PROCESSHELPER_H
