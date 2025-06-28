// configurator.h
#ifndef CONFIGURATOR_H
#define CONFIGURATOR_H

#include <QMainWindow>
#include <QMap>
#include <QPropertyAnimation>
#include <QSettings>
#include <QStackedWidget>
#include <QTreeWidget>

QT_BEGIN_NAMESPACE
namespace Ui {
class Configurator;
}
QT_END_NAMESPACE

class Configurator : public QMainWindow
{
    Q_OBJECT

public:
    Configurator(QWidget *parent = nullptr);
    ~Configurator();

private slots:
    void onCategorySelected(QTreeWidgetItem *item, int column);
    void onConfigChanged();
    void saveConfiguration();
    void loadConfiguration();
    void generateConfigFile();

private:
    Ui::Configurator *ui;
    QStackedWidget *configStack;
    QPropertyAnimation *animation;
    QSettings *settings;

    // Configuration data
    QMap<QString, bool> boolConfigs;
    QMap<QString, int> intConfigs;
    QMap<QString, QString> stringConfigs;

    void setupCategories();
    void setupMicrocontrollerPage();
    void setupMeterTypePage();
    void setupDisplayPage();
    void setupMeteringPage();
    void setupTariffPage();
    void setupCommunicationPage();
    void setupControlPage();
    void setupKeypadPage();
    void setupDLMSPage();
    void setupClockPage();

    void updateDependencies();
    void animateTransition(int index);
};

#endif // CONFIGURATOR_H
