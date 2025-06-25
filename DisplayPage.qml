import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: ({
        displayType: "segmented",
        useNewLcd: true,
        hq30774Enabled: false,
        cnkd0802Enabled: false,
        newCnkd0802Enabled: true,
        st7033Enabled: false,
        newSt7033Enabled: false,
        dotMatrixLcd: false,
        dotMatrixLowPwr: false,
        forDialTest: false,
        backlightTimeoutEnabled: false,
        screenOrder: "CHANGEABLE",
        screenLanguage: "ENGLISH",
        recordNewCustomerDate: true,
        serialNumberChange: true,
        displayMapScreen: true,
        displayObis: 0,

                                  systemClock: 25000,
                                  descriptionBrief: "Configuration for Ashntti V94XX 1-phase meter",
                                  descriptionVersion: "1.0",
                                  descriptionDate: "2025-06-24",
                                  descriptionAuthor: "User",
                                  descriptionDetails: "Initial setup for device configuration created at 05:43 PM EEST, Tuesday, June 24, 2025.\nThis is a longer description to test fitting and scrolling behavior."
                              })

    signal configUpdated(var newConfig)

    background: Rectangle {
        color: "#F5F7FA"
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 24
        clip: true
        contentWidth: parent.width

        ColumnLayout {
            id: formLayout
            width: parent.width - 48
            spacing: 24



            // Header Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                color: "#FFFFFF"
                radius: 8
                border.color: "#E4E7EB"
                border.width: 1
                Layout.topMargin: 16

                Label {
                    text: "Display System"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Roboto"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            // Display Type Selection Title
            Label {
                text: "Display Type Selection"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            // Display Type Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 16
                    width: parent.width - 24

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Display Type:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: displayTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8

                            model: configGenerator.schema["displayType"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: displayTypeCombo.displayText
                                font: displayTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: displayTypeCombo.width - 20
                            }

                            popup: Popup {
                                y: displayTypeCombo.height
                                width: displayTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: displayTypeCombo.popup.visible ? displayTypeCombo.delegateModel : null
                                    currentIndex: displayTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: displayTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: displayTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: displayTypeCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = model
                                const current = config.displayType || "segmented"
                                const idx = options ? options.indexOf(current) : -1
                                if (idx >= 0) currentIndex = idx
                            }

                            onCurrentIndexChanged: {
                                if (model.length > 0 && model[currentIndex] !== undefined) {
                                    updateConfig("displayType", model[currentIndex])
                                }
                            }
                        }
                    }
                }
            }

            // Segmented Displays Title
            Label {
                text: "Segmented Displays"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
                visible: config.displayType === "segmented"
            }

            // Segmented Displays Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config.displayType === "segmented"

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 16
                    width: parent.width - 24

                    CheckBox {
                        id: useNewLcdCheck
                        property bool localChecked: config.useNewLcd || false
                        text: "Use New LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("useNewLcd", checked)
                        }
                        Component.onCompleted: localChecked = config.useNewLcd || false
                    }

                    CheckBox {
                        id: hq30774Check
                        property bool localChecked: config.hq30774Enabled || false
                        text: "Enable HQ30774 LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("hq30774Enabled", checked)
                        }
                        Component.onCompleted: localChecked = config.hq30774Enabled || false
                    }

                    CheckBox {
                        id: cnkd0802Check
                        property bool localChecked: config.cnkd0802Enabled || false
                        text: "Enable CNKD0802 LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("cnkd0802Enabled", checked)
                        }
                        Component.onCompleted: localChecked = config.cnkd0802Enabled || false
                    }

                    CheckBox {
                        id: newCnkd0802Check
                        property bool localChecked: config.newCnkd0802Enabled || false
                        text: "Enable New CNKD0802 LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("newCnkd0802Enabled", checked)
                        }
                        Component.onCompleted: localChecked = config.newCnkd0802Enabled || false
                    }

                    CheckBox {
                        id: st7033Check
                        property bool localChecked: config.st7033Enabled || false
                        text: "Enable ST7033 LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("st7033Enabled", checked)
                        }
                        Component.onCompleted: localChecked = config.st7033Enabled || false
                    }

                    CheckBox {
                        id: newSt7033Check
                        property bool localChecked: config.newSt7033Enabled || false
                        text: "Enable New ST7033 LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("newSt7033Enabled", checked)
                        }
                        Component.onCompleted: localChecked = config.newSt7033Enabled || false
                    }
                }
            }

            // Dot Matrix Displays Title
            Label {
                text: "Dot Matrix Displays"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
                visible: config.displayType === "dotMatrix"
            }

            // Dot Matrix Displays Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config.displayType === "dotMatrix"

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 16
                    width: parent.width - 24

                    CheckBox {
                        id: dotMatrixLcdCheck
                        property bool localChecked: config.dotMatrixLcd || false
                        text: "Enable Dot Matrix LCD"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("dotMatrixLcd", checked)
                        }
                        Component.onCompleted: localChecked = config.dotMatrixLcd || false
                    }

                    CheckBox {
                        id: dotMatrixLowPwrCheck
                        property bool localChecked: config.dotMatrixLowPwr || false
                        text: "Enable Dot Matrix Low Power Feature"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("dotMatrixLowPwr", checked)
                        }
                        Component.onCompleted: localChecked = config.dotMatrixLowPwr || false
                    }
                }
            }

            // Display Features Title
            Label {
                text: "Display Features"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
                visible: config.displayType !== ""
            }

            // Display Features Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config.displayType !== ""

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 16
                    width: parent.width - 24

                    CheckBox {
                        id: backlightCheck
                        property bool localChecked: config.backlightTimeoutEnabled || false
                        text: "Enable Backlight Timeout"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("backlightTimeoutEnabled", checked)
                        }
                        Component.onCompleted: localChecked = config.backlightTimeoutEnabled || false
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Screen Order:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: screenOrderCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8

                            model: configGenerator.schema["screenOrder"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: screenOrderCombo.displayText
                                font: screenOrderCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: screenOrderCombo.width - 20
                            }

                            popup: Popup {
                                y: screenOrderCombo.height
                                width: screenOrderCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: screenOrderCombo.popup.visible ? screenOrderCombo.delegateModel : null
                                    currentIndex: screenOrderCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: screenOrderCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: screenOrderCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: screenOrderCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = model
                                const current = config.screenOrder || "CHANGEABLE"
                                const idx = options ? options.indexOf(current) : -1
                                if (idx >= 0) currentIndex = idx
                            }

                            onCurrentIndexChanged: {
                                if (model.length > 0 && model[currentIndex] !== undefined) {
                                    updateConfig("screenOrder", model[currentIndex])
                                }
                            }
                        }
                    }

                    CheckBox {
                        id: mapScreenCheck
                        property bool localChecked: config.displayMapScreen || false
                        text: "Enable Map Screen"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("displayMapScreen", checked)
                        }
                        Component.onCompleted: localChecked = config.displayMapScreen || false
                    }
                }
            }

            // Screen Language Title
            Label {
                text: "Screen Language"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
                visible: config.displayType !== ""
            }

            // Screen Language Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config.displayType !== ""

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 16
                    width: parent.width - 24

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Language:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: screenLanguageCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8

                            model: configGenerator.schema["screenLanguage"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: screenLanguageCombo.displayText
                                font: screenLanguageCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: screenLanguageCombo.width - 20
                            }

                            popup: Popup {
                                y: screenLanguageCombo.height
                                width: screenLanguageCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: screenLanguageCombo.popup.visible ? screenLanguageCombo.delegateModel : null
                                    currentIndex: screenLanguageCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: screenLanguageCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: screenLanguageCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: screenLanguageCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = model
                                const current = config.screenLanguage || "ENGLISH"
                                const idx = options ? options.indexOf(current) : -1
                                if (idx >= 0) currentIndex = idx
                            }

                            onCurrentIndexChanged: {
                                if (model.length > 0 && model[currentIndex] !== undefined) {
                                    updateConfig("screenLanguage", model[currentIndex])
                                }
                            }
                        }
                    }
                }
            }

            // Bottom Spacer
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
            }
        }
    }

    function updateConfig(key: string, value: variant): void {
        var newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value
        configUpdated(newConfig)
        config = newConfig
    }
}
