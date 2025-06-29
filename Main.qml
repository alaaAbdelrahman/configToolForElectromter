import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    width: 1024
    height: 768
    visible: true
    title: "Meter Configuration Tool"
    color: "#f5f5f5"

    property int animationDuration: 200
    property var config: configGenerator.config
    property var selectedSourceFiles: []

    FileDialog {
        id: fileDialog
        title: "Save Configuration Header"
        defaultSuffix: "h"
        nameFilters: ["Header files (*.h)"]
        fileMode: FileDialog.SaveFile

        onAccepted: {
            var filePath = selectedFile.toString();
            console.log("Saving config file to:", filePath);
            if (configGenerator.generateConfigFile(filePath)) {
                statusBar.showMessage("Successfully saved to: " + filePath, 3000);
            } else {
                statusBar.showMessage("Failed to save configuration", 4000);
            }
        }
    }

    FileDialog {
        id: buildOutputDialog
        title: "Save Executable"
        defaultSuffix: "exe"
        nameFilters: ["Executable files (*.exe)"]
        fileMode: FileDialog.SaveFile

        onAccepted: {
            var exePath = selectedFile.toString();
            buildAndRun(exePath);
        }
    }

    FileDialog {
        id: sourceFileDialog
        title: "Select Source Files"
        nameFilters: ["C source files (*.c)", "All files (*)"]
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            root.selectedSourceFiles = selectedFiles.map(file => file.toString());
            console.log("Selected source files:", root.selectedSourceFiles);
            buildOutputDialog.open();
        }
    }

    header: ToolBar {
        background: Rectangle { color: "#4CAF50" }

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: menuButton
                text: "☰"
                onClicked: drawer.open()
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 8
                }
                background: Rectangle {
                    color: parent.pressed ? "#388E3C" : "transparent"
                    radius: 4
                    border.color: "#FFFFFF"
                    border.width: 1
                }
            }

            Label {
                text: "Meter Configuration Tool"
                color: "white"
                font.bold: true
                font.pixelSize: 16
                Layout.fillWidth: true
            }

            ToolButton {
                id: backButton
                text: "<"
                visible: stackView.depth > 1
                onClicked: stackView.pop()
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 8
                }
                background: Rectangle {
                    color: parent.pressed ? "#388E3C" : "transparent"
                    radius: 4
                    border.color: "#FFFFFF"
                    border.width: 1
                }
            }

            ToolButton {
                id: generateButton
                text: "Generate"
                onClicked: fileDialog.open()
                contentItem: Row {
                    spacing: 5
                    anchors.centerIn: parent
                    anchors.leftMargin: 8
                    Image {
                        source: "qrc:/icons/save.png"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: parent.parent.text
                        color: "white"
                        font.pixelSize: 14
                    }
                }
                background: Rectangle {
                    color: parent.pressed ? "#388E3C" : "transparent"
                    radius: 4
                    border.color: "#FFFFFF"
                    border.width: 1
                }
            }

            ToolButton {
                id: buildButton
                text: "Build Executable"
                onClicked: sourceFileDialog.open()
                contentItem: Row {
                    spacing: 5
                    anchors.centerIn: parent
                    anchors.leftMargin: 8
                    Image {
                        source: "qrc:/icons/build.png"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: parent.parent.text
                        color: "white"
                        font.pixelSize: 14
                    }
                }
                background: Rectangle {
                    color: parent.pressed ? "#388E3C" : "transparent"
                    radius: 4
                    border.color: "#FFFFFF"
                    border.width: 1
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: 200
        height: parent.height
        background: Rectangle {
            color: "#ffffff"
        }

        ListView {
            id: categoryList
            anchors.fill: parent
            clip: true
            highlight: Rectangle {
                color: "#E0E0E0"
                radius: 4
            }
            highlightMoveDuration: animationDuration
            highlightResizeDuration: animationDuration

            model: ListModel {
                ListElement { name: "Device"; icon: "qrc:/icons/microchip.png"; component: "qrc:/DevicePage.qml" }
                ListElement { name: "Display"; icon: "qrc:/icons/display.png"; component: "qrc:/DisplayPage.qml" }
                ListElement { name: "Metering"; icon: "qrc:/icons/gauge.png"; component: "qrc:/MeteringPage.qml" }
                ListElement { name: "Tariff"; icon: "qrc:/icons/tariff.png"; component: "qrc:/TariffPage.qml" }
                ListElement { name: "Communication"; icon: "qrc:/icons/wifi.png"; component: "qrc:/CommunicationPage.qml" }
                ListElement { name: "Control"; icon: "qrc:/icons/control.png"; component: "qrc:/ControlPage.qml" }
                ListElement { name: "Memory"; icon: "qrc:/icons/microchip.png"; component: "qrc:/MemoryPage.qml" }
                ListElement { name: "DLMS"; icon: "qrc:/icons/dlms.png"; component: "qrc:/DLMSPage.qml" }
            }

            delegate: ItemDelegate {
                width: parent.width
                height: 48
                highlighted: categoryList.currentIndex === index

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    Image {
                        source: model.icon
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 24
                        sourceSize.height: 24
                    }

                    Label {
                        text: model.name
                        font.pixelSize: 16
                        font.bold: highlighted
                        color: highlighted ? "#1976D2" : "black"
                        Layout.fillWidth: true
                    }
                }

                background: Rectangle {
                    color: highlighted ? "#E0E0E0" : "transparent"
                    radius: 4
                }

                onClicked: {
                    categoryList.currentIndex = index
                    let component = Qt.createComponent(model.component)
                    if (component.status === Component.Ready) {
                        let item = component.createObject(stackView, {
                            config: Qt.binding(() => configGenerator.config || {})
                        })
                        if (item) {
                            if (item.configUpdated) {
                                // Disconnect any existing connection to avoid duplicates
                                item.configUpdated.disconnect(configGenerator.onConfigUpdated)
                                item.configUpdated.connect(function(updated) {
                                    console.log("Connected configUpdated for", model.name, "pageId:", item.pageId || "unknown", "with config:", JSON.stringify(updated))
                                    configGenerator.onConfigUpdated(updated)
                                })
                                console.log("Signal connection established for", model.name, "pageId:", item.pageId || "unknown")
                            } else {
                                console.warn("No configUpdated signal found for", model.name)
                            }
                            stackView.replace(item, StackView.PushTransition)
                        } else {
                            console.error("Failed to create page from", model.component)
                            statusBar.showMessage("Error loading " + model.name + " page", 3000)
                        }
                    } else {
                        console.error("Component loading error for", model.component, ":", component.errorString())
                        statusBar.showMessage("Error loading " + model.name + " page: " + component.errorString(), 3000)
                    }
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Qt.createComponent("qrc:/DevicePage.qml").createObject(stackView, {
            config: Qt.binding(() => configGenerator.config || {})
        })

        replaceEnter: Transition {
            ParallelAnimation {
                PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: animationDuration }
                PropertyAnimation { property: "x"; from: (stackView.mirrored ? -20 : 20); to: 0; duration: animationDuration }
            }
        }

        replaceExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: animationDuration }
        }

        Connections {
            target: stackView.currentItem
            enabled: !!(target && target.pageId && target.pageId)
            function onConfigUpdated(updated) {
                console.log("ConfigUpdated from initial page pageId:", target.pageId, ":", JSON.stringify(updated))
                configGenerator.onConfigUpdated(updated)
            }
        }

        onCurrentItemChanged: {
            if (currentItem && currentItem.pageId) {
                console.log("Current item changed to:", currentItem.pageId)
            }
        }
    }

    footer: Rectangle {
        id: statusBar
        height: 30
        anchors.bottom: parent.bottom
        color: "#f0f0f0"
        border.color: "#d3d3d3"
        border.width: 1

        Label {
            id: statusLabel
            anchors.fill: parent
            text: "Ready"
            padding: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        function showMessage(message, duration) {
            statusLabel.text = message
            clearTimer.interval = duration || 3000
            clearTimer.restart()
        }

        Timer {
            id: clearTimer
            onTriggered: statusLabel.text = "Ready"
        }
    }

    Connections {
        target: configGenerator
        function onErrorOccurred(message) {
            statusBar.showMessage("Error: " + message, 3000)
        }
    }

    function loadPage(pageComponent) {
        let component = Qt.createComponent(pageComponent)
        if (component.status === Component.Ready) {
            let item = component.createObject(stackView, {
                config: Qt.binding(() => configGenerator.config || {})
            })
            if (item) {
                if (item.configUpdated) {
                    // Disconnect any existing connection to avoid duplicates
                    item.configUpdated.disconnect(configGenerator.onConfigUpdated)
                    item.configUpdated.connect(function(updated) {
                        console.log("LoadPage configUpdated for", item.pageId || pageComponent, ":", JSON.stringify(updated))
                        configGenerator.onConfigUpdated(updated)
                    })
                    console.log("Signal connection established for loadPage:", item.pageId || pageComponent)
                }
                stackView.push(item)
            } else {
                console.error("Failed to create page from", pageComponent)
                statusBar.showMessage("Error loading page from " + pageComponent, 4000)
            }
        } else {
            console.error("Component loading error for", pageComponent, ":", component.errorString())
            statusBar.showMessage("Error loading page: " + component.errorString(), 4000)
        }
    }

    function buildAndRun(exePath) {
            if (root.selectedSourceFiles.length === 0) {
                statusBar.showMessage("No source files selected. Please select files first.", 5000)
                return
            }
            var configPath = fileDialog.selectedFile.toString() || "config_output.h"
            var sourceFiles = root.selectedSourceFiles.join(" ")

            // Extract directory from configPath and remove file://
            var configDir = configPath.substring(0, configPath.lastIndexOf("/")).replace("file://", "")
            var localExePath = exePath.replace("file://", "").trim()
            var localSourceFiles = sourceFiles.replace(/file:\/\//g, "").trim()
            var localConfigPath = configPath.replace("file://", "").trim()

            // Ensure configDir is a valid directory
            if (!configDir) {
                configDir = "."
                console.warn("Config directory not found, defaulting to current directory")
            }

            // Construct gcc command with corrected -I path and verbose output
            var command = `gcc -o "${localExePath}" ${localSourceFiles} -I"${configDir}" -include "${localConfigPath}" -v`
            console.log("Executing build command:", command)

            // Disconnect previous connection to avoid duplicates
            Process.finished.disconnect(root.onProcessFinished)
            // Set the working directory
            //Process.setWorkingDirectory(configDir)
            Process.start(command)
            Process.finished.connect(root, root.onProcessFinished)
        }

        function onProcessFinished(exitCode, output, error) {
            console.log("Build process finished - exitCode:", exitCode, "output:", output, "error:", error)
            if (exitCode === 0) {
                statusBar.showMessage("Build successful, executable saved to: " + exePath, 5000)
            } else {
                statusBar.showMessage("Build failed: " + (error || "Unknown error, check console logs"), 5000)
            }
        }}
