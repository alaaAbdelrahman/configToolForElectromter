import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || { systemClock: 25000 }
    signal configUpdated(var newConfig)

    // Unique identifier for debugging
    property string pageId: "DevicePage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "initialized with config:", JSON.stringify(config))
    }

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

            // Configuration Description Section
            Label {
                text: "Configuration Description (Doxygen Format)"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }


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

                    // Brief Description
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "@brief:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 80
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: briefTextField
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            font.pixelSize: 14
                            font.family: "Roboto"
                            text: config.descriptionBrief || ""
                            placeholderText: text ? "" : "Brief description"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: briefTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: briefTextField.focus ? 2 : 1
                                radius: 6
                            }

                            onActiveFocusChanged: {
                                if (activeFocus && !text) placeholderText = ""
                                else if (!activeFocus && !text) placeholderText = "Brief description"
                            }

                            onTextChanged: {
                                updateConfig("descriptionBrief", text)
                                console.log("Brief updated to:", text)
                            }
                        }
                    }

                    // Version
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "@version:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 80
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: versionTextField
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            font.pixelSize: 14
                            font.family: "Roboto"
                            text: config.descriptionVersion || ""
                            placeholderText: text ? "" : "Version number"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: versionTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: versionTextField.focus ? 2 : 1
                                radius: 6
                            }

                            onActiveFocusChanged: {
                                if (activeFocus && !text) placeholderText = ""
                                else if (!activeFocus && !text) placeholderText = "Version number"
                            }

                            onTextChanged: {
                                updateConfig("descriptionVersion", text)
                                console.log("Version updated to:", text)
                            }
                        }
                    }

                    // Date
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "@date:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 80
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: dateTextField
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            font.pixelSize: 14
                            font.family: "Roboto"
                            text: config.descriptionDate || ""
                            placeholderText: text ? "" : "YYYY-MM-DD"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: dateTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: dateTextField.focus ? 2 : 1
                                radius: 6
                            }

                            onActiveFocusChanged: {
                                if (activeFocus && !text) placeholderText = ""
                                else if (!activeFocus && !text) placeholderText = "YYYY-MM-DD"
                            }

                            onTextChanged: {
                                updateConfig("descriptionDate", text)
                                console.log("Date updated to:", text)
                            }
                        }
                    }

                    // Author
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "@author:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 80
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: authorTextField
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            font.pixelSize: 14
                            font.family: "Roboto"
                            text: config.descriptionAuthor || ""
                            placeholderText: text ? "" : "Author name"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: authorTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: authorTextField.focus ? 2 : 1
                                radius: 6
                            }

                            onActiveFocusChanged: {
                                if (activeFocus && !text) placeholderText = ""
                                else if (!activeFocus && !text) placeholderText = "Author name"
                            }

                            onTextChanged: {
                                updateConfig("descriptionAuthor", text)
                                console.log("Author updated to:", text)
                            }
                        }
                    }

                    // Details
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "@details:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 80
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextArea {
                            id: detailsTextArea
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.minimumHeight: 100
                            Layout.preferredHeight: Math.min(contentHeight, 300)
                            Layout.maximumHeight: 300
                            font.pixelSize: 14
                            font.family: "Roboto"
                            wrapMode: Text.WordWrap
                            text: config.descriptionDetails || ""
                            placeholderText: text ? "" : "Detailed description"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: detailsTextArea.focus ? "#007BFF" : "#CED4DA"
                                border.width: detailsTextArea.focus ? 2 : 1
                                radius: 6
                            }

                            onActiveFocusChanged: {
                                if (activeFocus && !text) placeholderText = ""
                                else if (!activeFocus && !text) placeholderText = "Detailed description"
                            }

                            onTextChanged: {
                                updateConfig("descriptionDetails", text)
                                console.log("Details updated to:", text)
                            }
                        }
                    }

                    Label {
                        text: "Use Doxygen tags for structured documentation. Separate fields will be combined into a comment block."
                        font.pixelSize: 12
                        font.family: "Roboto"
                        color: "#6B7280"
                        wrapMode: Text.WordWrap
                    }
                }
            }


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
                    text: "Device Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Roboto"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            // Device Settings Title
            Label {
                text: "Device Settings"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            // Device Settings Group
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

                    // Microcontroller Row
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Microcontroller:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: microCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8

                            model: configGenerator.schema["MicroController"] || ["Micro_V85XX", "Micro_V94XX", "Micro_V77XX"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: microCombo.displayText
                                font: microCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: microCombo.width - 20
                            }

                            popup: Popup {
                                y: microCombo.height
                                width: microCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: microCombo.popup.visible ? microCombo.delegateModel : null
                                    currentIndex: microCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: microCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: microCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: microCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = configGenerator.schema["MicroController"] || ["Micro_V85XX", "Micro_V94XX", "Micro_V77XX"]
                                const current = config["MicroController"] || "Micro_V85XX"
                                const idx = options.indexOf(current)
                                if (idx >= 0) {
                                    currentIndex = idx
                                    console.log(pageId, "MicroCombo initialized with index:", idx, "value:", current)
                                }
                            }

                            onCurrentIndexChanged: {
                                if (model.length > 0 && model[currentIndex] !== undefined) {
                                    console.log(pageId, "Selected MicroController:", model[currentIndex])
                                    updateConfig("MicroController", model[currentIndex])
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#E4E7EB"
                    }

                    // Board Type Row
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Board Type:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: boardCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8

                            model: configGenerator.schema["boardType"] || ["EM130_BOARD", "EM122U_BOARD", "EM124_BOARD"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: boardCombo.displayText
                                font: boardCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: boardCombo.width - 20
                            }

                            popup: Popup {
                                y: boardCombo.height
                                width: boardCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: boardCombo.popup.visible ? boardCombo.delegateModel : null
                                    currentIndex: boardCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: boardCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: boardCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: boardCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = configGenerator.schema["boardType"] || ["EM130_BOARD", "EM122U_BOARD", "EM124_BOARD"]
                                const current = config["boardType"] || "EM130_BOARD"
                                const idx = options.indexOf(current)
                                if (idx >= 0) {
                                    currentIndex = idx
                                    console.log(pageId, "BoardCombo initialized with index:", idx, "value:", current)
                                }
                            }

                            onCurrentIndexChanged: {
                                if (model.length > 0 && model[currentIndex] !== undefined) {
                                    console.log(pageId, "Selected boardType:", model[currentIndex])
                                    updateConfig("boardType", model[currentIndex])
                                }
                            }
                        }
                    }
                }
            }

            // Clock Settings Title
            Label {
                text: "Clock Settings"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            // Clock Settings Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    Label {
                        text: "System Clock:"
                        font.pixelSize: 16
                        font.family: "Roboto"
                        color: "#1A2526"
                        Layout.preferredWidth: 160
                        verticalAlignment: Label.AlignVCenter
                    }

                    ComboBox {
                        id: systemClockCombo
                        Layout.fillWidth: true
                        Layout.minimumWidth: 280
                        Layout.maximumWidth: 480
                        font.pixelSize: 14
                        padding: 8

                        model: ["8 MHz", "16 MHz", "25 MHz"]
                        currentIndex: (config.systemClock || 25000) === 8000 ? 0 :
                                     (config.systemClock || 25000) === 16000 ? 1 : 2

                        contentItem: Text {
                            leftPadding: 10
                            rightPadding: 10
                            text: systemClockCombo.displayText
                            font: systemClockCombo.font
                            color: "#1A2526"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            width: systemClockCombo.width - 20
                        }

                        popup: Popup {
                            y: systemClockCombo.height
                            width: systemClockCombo.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 2

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: systemClockCombo.popup.visible ? systemClockCombo.delegateModel : null
                                currentIndex: systemClockCombo.highlightedIndex
                                ScrollIndicator.vertical: ScrollIndicator {}
                            }
                        }

                        background: Rectangle {
                            color: systemClockCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                            border.color: systemClockCombo.focus ? "#007BFF" : "#CED4DA"
                            border.width: systemClockCombo.focus ? 2 : 1
                            radius: 6
                        }

                        onActivated: function(index) {
                            var typeMap = [8000, 16000, 25000]
                            console.log(pageId, "Selected systemClock:", typeMap[index])
                            updateConfig("systemClock", typeMap[index])
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
        const newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value
        console.log(pageId, "Emitting configUpdated for", key, "with value:", value, "new config:", JSON.stringify(newConfig))
        configUpdated(newConfig)
        config = newConfig
    }
}
