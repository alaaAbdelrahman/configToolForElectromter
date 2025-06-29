#include "processhelper.h"

ProcessHelper::ProcessHelper(QObject *parent) : QObject(parent), m_process(new QProcess(this)) {
    connect(m_process, &QProcess::destroyed, this, [this]() { m_process = nullptr; });
}

ProcessHelper::~ProcessHelper() {
    if (m_process) {
        m_process->terminate();
        m_process->waitForFinished(1000);
        delete m_process;
        m_process = nullptr;
    }
}

void ProcessHelper::start(const QString &command) {
    if (m_process) {
        connect(m_process, &QProcess::finished, this, [this]() {
            int exitCode = m_process->exitCode();
            QByteArray output = m_process->readAllStandardOutput();
            QByteArray error = m_process->readAllStandardError();
            emit finished(exitCode, output, error);
            m_process->close();
        }, Qt::UniqueConnection);
        m_process->start(command);
        if (!m_process->waitForStarted(3000)) {
            emit finished(-1, QByteArray(), "Failed to start process");
            m_process->close();
        }
    } else {
        emit finished(-1, QByteArray(), "Process instance is null");
    }
}
