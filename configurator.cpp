// configurator.cpp
#include "configurator.h"
#include <QCheckBox>
#include <QComboBox>
#include <QFileDialog>
#include <QGroupBox>
#include <QMessageBox>
#include <QSpinBox>
#include "ui_configurator.h"

Configurator::Configurator(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::Configurator)
{
    ui->setupUi(this);
    setWindowTitle("Meter Configuration Tool");

    // Initialize settings
    settings = new QSettings("MeterConfig", "ConfigTool");

    // Setup stacked widget for pages
    configStack = new QStackedWidget(this);
    ui->centralwidget->layout()->addWidget(configStack);

    // Setup animation
    animation = new QPropertyAnimation(configStack, "pos", this);
    animation->setDuration(300);
    animation->setEasingCurve(QEasingCurve::OutQuad);

    // Setup all configuration pages
    setupCategories();
    setupMicrocontrollerPage();
    setupMeterTypePage();
    setupDisplayPage();
    setupMeteringPage();
    setupTariffPage();
    setupCommunicationPage();
    setupControlPage();
    setupKeypadPage();
    setupDLMSPage();
    setupClockPage();

    // Connect signals
    connect(ui->treeWidget, &QTreeWidget::itemClicked, this, &Configurator::onCategorySelected);
    connect(ui->actionSave, &QAction::triggered, this, &Configurator::saveConfiguration);
    connect(ui->actionLoad, &QAction::triggered, this, &Configurator::loadConfiguration);
    connect(ui->actionGenerate, &QAction::triggered, this, &Configurator::generateConfigFile);

    // Load last configuration
    loadConfiguration();
}

Configurator::~Configurator()
{
    delete ui;
}

void Configurator::setupCategories()
{
    ui->treeWidget->setHeaderHidden(true);

    QTreeWidgetItem *categories[]
        = {new QTreeWidgetItem(ui->treeWidget, QStringList("1. Microcontroller Target")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("2. Meter Type Configuration")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("3. LCD and Display")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("4. Metering Features")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("5. Tariff & Payment")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("6. Communication")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("7. Control Features")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("8. Keypad")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("9. DLMS & Protocol")),
           new QTreeWidgetItem(ui->treeWidget, QStringList("10. System Clock"))};

    ui->treeWidget->expandAll();
}

void Configurator::setupMicrocontrollerPage()
{
    QWidget *page = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(page);

    QGroupBox *group = new QGroupBox("Microcontroller Selection");
    QVBoxLayout *groupLayout = new QVBoxLayout(group);

    QComboBox *mcCombo = new QComboBox();
    mcCombo->addItem("V85XX", "Micro_V85XX");
    mcCombo->addItem("V94XX", "Micro_V94XX");
    mcCombo->setCurrentIndex(1); // Default to V94XX

    connect(mcCombo, QOverload<int>::of(&QComboBox::currentIndexChanged), [this, mcCombo]() {
        stringConfigs["MicroController"] = mcCombo->currentData().toString();
        onConfigChanged();
    });

    groupLayout->addWidget(mcCombo);
    group->setLayout(groupLayout);
    layout->addWidget(group);
    layout->addStretch();
    page->setLayout(layout);
    configStack->addWidget(page);
}

void Configurator::setupMeterTypePage()
{
    QWidget *page = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(page);

    // Meter Type Selection
    QGroupBox *typeGroup = new QGroupBox("Meter Type");
    QVBoxLayout *typeLayout = new QVBoxLayout(typeGroup);

    QRadioButton *singlePhase = new QRadioButton("Single Phase");
    QRadioButton *threePhase = new QRadioButton("Three Phase");
    singlePhase->setChecked(true);

    connect(singlePhase, &QRadioButton::toggled, [this](bool checked) {
        boolConfigs["MTR_SINGLE_PH"] = checked;
        boolConfigs["MTR_THREE_PH"] = !checked;
        onConfigChanged();
        updateDependencies();
    });

    typeLayout->addWidget(singlePhase);
    typeLayout->addWidget(threePhase);
    typeGroup->setLayout(typeLayout);
    layout->addWidget(typeGroup);

    // Single Phase Options
    QGroupBox *singlePhaseGroup = new QGroupBox("Single Phase Options");
    QVBoxLayout *spLayout = new QVBoxLayout(singlePhaseGroup);

    QCheckBox *directMeasure = new QCheckBox("Direct Measurement");
    directMeasure->setChecked(true);

    connect(directMeasure, &QCheckBox::stateChanged, [this](int state) {
        boolConfigs["MTR_DIRECT"] = (state == Qt::Checked);
        onConfigChanged();
    });

    spLayout->addWidget(directMeasure);
    singlePhaseGroup->setLayout(spLayout);
    layout->addWidget(singlePhaseGroup);

    // Three Phase Options (initially hidden)
    QGroupBox *threePhaseGroup = new QGroupBox("Three Phase Options");
    QVBoxLayout *tpLayout = new QVBoxLayout(threePhaseGroup);

    QCheckBox *tpDirectMeasure = new QCheckBox("Direct Measurement");
    tpDirectMeasure->setChecked(true);

    connect(tpDirectMeasure, &QCheckBox::stateChanged, [this](int state) {
        boolConfigs["MTR_DIRECT"] = (state == Qt::Checked);
        onConfigChanged();
    });

    tpLayout->addWidget(tpDirectMeasure);
    threePhaseGroup->setLayout(tpLayout);
    threePhaseGroup->setVisible(false);
    layout->addWidget(threePhaseGroup);

    // Connect phase change to show/hide options
    connect(singlePhase, &QRadioButton::toggled, [singlePhaseGroup, threePhaseGroup](bool checked) {
        singlePhaseGroup->setVisible(checked);
        threePhaseGroup->setVisible(!checked);
    });

    layout->addStretch();
    page->setLayout(layout);
    configStack->addWidget(page);
}

// Similar setup functions for other pages would follow...

void Configurator::onCategorySelected(QTreeWidgetItem *item, int column)
{
    Q_UNUSED(column);

    int index = ui->treeWidget->indexOfTopLevelItem(item);
    if (index >= 0 && index < configStack->count()) {
        animateTransition(index);
        configStack->setCurrentIndex(index);
    }
}

void Configurator::animateTransition(int index)
{
    int currentIndex = configStack->currentIndex();
    if (currentIndex == -1 || currentIndex == index)
        return;

    int width = configStack->width();
    animation->stop();

    if (index > currentIndex) {
        // Slide from right
        animation->setStartValue(QPoint(width, 0));
        animation->setEndValue(QPoint(0, 0));
    } else {
        // Slide from left
        animation->setStartValue(QPoint(-width, 0));
        animation->setEndValue(QPoint(0, 0));
    }

    configStack->setCurrentIndex(index);
    animation->start();
}

void Configurator::onConfigChanged()
{
    ui->statusbar->showMessage("Configuration modified", 2000);
    updateDependencies();
}

void Configurator::updateDependencies()
{
    // Example dependency: If single phase is selected, enable single phase options
    bool singlePhase = boolConfigs.value("MTR_SINGLE_PH", true);

    // Update other controls based on this selection
    // This is where you would enable/disable dependent options
}

void Configurator::saveConfiguration()
{
    QString fileName = QFileDialog::getSaveFileName(this,
                                                    "Save Configuration",
                                                    "",
                                                    "Config Files (*.mcfg)");
    if (!fileName.isEmpty()) {
        QSettings fileSettings(fileName, QSettings::IniFormat);

        // Save boolean configurations
        fileSettings.beginGroup("BooleanConfigs");
        QMapIterator<QString, bool> itBool(boolConfigs);
        while (itBool.hasNext()) {
            itBool.next();
            fileSettings.setValue(itBool.key(), itBool.value());
        }
        fileSettings.endGroup();

        // Save other configuration types similarly...

        ui->statusbar->showMessage("Configuration saved", 2000);
    }
}

void Configurator::loadConfiguration()
{
    QString fileName = QFileDialog::getOpenFileName(this,
                                                    "Load Configuration",
                                                    "",
                                                    "Config Files (*.mcfg)");
    if (!fileName.isEmpty()) {
        QSettings fileSettings(fileName, QSettings::IniFormat);

        // Load boolean configurations
        fileSettings.beginGroup("BooleanConfigs");
        QStringList boolKeys = fileSettings.childKeys();
        foreach (QString key, boolKeys) {
            boolConfigs[key] = fileSettings.value(key).toBool();
        }
        fileSettings.endGroup();

        // Load other configuration types similarly...

        // Update UI based on loaded values
        updateDependencies();
        ui->statusbar->showMessage("Configuration loaded", 2000);
    }
}

void Configurator::generateConfigFile()
{
    QString fileName = QFileDialog::getSaveFileName(this,
                                                    "Generate Config Header",
                                                    "",
                                                    "Header Files (*.h)");
    if (!fileName.isEmpty()) {
        QFile file(fileName);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QTextStream out(&file);

            out << "// Auto-generated configuration file\n";
            out << "// Created by Meter Configuration Tool\n\n";
            out << "#ifndef CONFIGURABLE_METER_OPTIONS_H\n";
            out << "#define CONFIGURABLE_METER_OPTIONS_H\n\n";

            // 1. Microcontroller Target
            out << "// =====================================================\n";
            out << "// 1. Microcontroller Target\n";
            out << "// =====================================================\n";
            out << "#define MicroController "
                << stringConfigs.value("MicroController", "Micro_V94XX") << "\n\n";

            // 2. Meter Type Configuration
            out << "// =====================================================\n";
            out << "// 2. Meter Type Configuration\n";
            out << "// =====================================================\n";
            if (boolConfigs.value("MTR_SINGLE_PH", true)) {
                out << "#define MTR_SINGLE_PH\n";
                out << "#define MTR_DIRECT\n";
                out << "#define MTR_NUM_OF_PHASE 1\n";
                out << "#define MTR_NUM_OF_CH 2\n";
            } else {
                out << "#define MTR_THREE_PH\n";
                out << "#define MTR_DIRECT\n";
                out << "#define MTR_NUM_OF_PHASE 3\n";
                out << "#define MTR_NUM_OF_CH 3\n";
            }
            out << "\n";

            // Continue with other sections...

            out << "#endif // CONFIGURABLE_METER_OPTIONS_H\n";

            file.close();
            ui->statusbar->showMessage("Configuration file generated", 2000);
        } else {
            QMessageBox::warning(this, "Error", "Could not open file for writing");
        }
    }
}
