// main.cpp
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>

#include "ConfigGenerator.h"
#include "processhelper.h"

int main(int argc, char *argv[])
{
    // ✅ Set global style before the app is initialized
    QQuickStyle::setStyle("Material");

    QGuiApplication app(argc, argv);

    // Optional: set window icon if you have one
    app.setWindowIcon(QIcon(":/icons/icon.png"));

    // Instantiate engine
    QQmlApplicationEngine engine;

    // ✅ Create and expose configGenerator to QML
    ConfigGenerator configGenerator;
    configGenerator.loadSchema(":/configurations/config_schema.json"); // Load schema from file
    engine.rootContext()->setContextProperty("Process", new ProcessHelper(&engine));
    engine.rootContext()->setContextProperty("configGenerator", &configGenerator);



    // Load QML UI from resources
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}

