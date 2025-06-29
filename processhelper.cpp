#include "processhelper.h"
#include <QDebug>

ProcessHelper::ProcessHelper(QObject *parent) : QObject(parent), m_process(new QProcess(this)) {
    connect(m_process, &QProcess::destroyed, this, [this]() { m_process = nullptr; });
    connect(m_process, &QProcess::finished, this, &ProcessHelper::onProcessFinished);

    // Set the process environment to inherit the system environment
    m_process->setProcessEnvironment(QProcessEnvironment::systemEnvironment());
}

ProcessHelper::~ProcessHelper() {
    if (m_process) {
        m_process->terminate();
        m_process->waitForFinished(2000); // Increased timeout for cleanup
        delete m_process;
        m_process = nullptr;
    }
}

void ProcessHelper::start(const QString &command) {
    if (!m_process) {
        emit finished(-1, QByteArray(), QString("Process instance is null").toUtf8());
        return;
    }

    // Split the command into program and arguments using QProcess::splitCommand-like behavior
    QStringList args = QProcess::splitCommand(command);
    if (args.isEmpty()) {
        qCritical() << "Invalid command:" << command;
        emit finished(-1, QByteArray(), QString("Invalid command").toUtf8());
        return;
    }

    QString program = args.takeFirst(); // First argument is the program
    QStringList arguments = args;       // Remaining are arguments
    qDebug() << "Starting process:" << program << "with arguments:" << arguments;

    m_process->setProgram(program);
    m_process->setArguments(arguments);

    m_process->start();
    if (!m_process->waitForStarted(5000)) { // Increased timeout to 5 seconds
        qCritical() << "Failed to start process:" << m_process->errorString();
        emit finished(-1, QByteArray(), (QString("Failed to start process: ") + m_process->errorString()).toUtf8());
        m_process->close();
        return;
    }

    if (!m_process->waitForFinished(-1)) { // Wait indefinitely for completion
        qCritical() << "Process did not finish:" << m_process->errorString();
        emit finished(-1, m_process->readAllStandardOutput(), (QString("Process timeout: ") + m_process->errorString()).toUtf8());
        m_process->close();
        return;
    }
}

void ProcessHelper::onProcessFinished(int exitCode, QProcess::ExitStatus status) {
    if (m_process) {
        QByteArray output = m_process->readAllStandardOutput();
        QByteArray error = m_process->readAllStandardError();
        qDebug() << "Process finished with exit code:" << exitCode << "output:" << output << "error:" << error;
        emit finished(exitCode, output, error);
        m_process->close();
    }
}
