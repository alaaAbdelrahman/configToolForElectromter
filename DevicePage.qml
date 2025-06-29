import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "descriptionBrief": "",
        "descriptionVersion": "",
        "descriptionDate": "",
        "descriptionAuthor": "",
        "descriptionDetails": "",
        "Device.MicroController": "Micro_V94XX",
        "Device.BOARD_TYPE": "EM130_BOARD",
        "Device.SYSTEM_CLOCK": 25000
    }
    signal configUpdated(var newConfig)

    property string pageId: "DevicePage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        // Initialize missing config keys with schema defaults
        const deviceSchema = configGenerator.schema?.Device || {}
        for (let key in deviceSchema) {
            const fullKey = "Device." + key;
            if (config[fullKey] === undefined && deviceSchema[key].default !== undefined) {
                config[fullKey] = deviceSchema[key].default;
                console.log(pageId, "Initialized missing config key:", fullKey, "with default:", config[fullKey]);
            }
        }
        // Sync initial config with backend
        updateConfigAll();
    }

    Connections {
        target: configGenerator
        function onErrorOccurred(error) {
            console.error(pageId, "Backend error:", error);
        }
        function onConfigChanged() {
            console.log(pageId, "Backend config changed:", JSON.stringify(configGenerator.config));
            config = configGenerator.config;
        }
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
                            text: config["descriptionBrief"] || ""
                            placeholderText: text ? "" : "Brief description"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: briefTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: briefTextField.focus ? 2 : 1
                                radius: 6
                            }
                            onTextChanged: updateConfig("descriptionBrief", text)
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
                            text: config["descriptionVersion"] || ""
                            placeholderText: text ? "" : "Version number"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: versionTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: versionTextField.focus ? 2 : 1
                                radius: 6
                            }
                            onTextChanged: updateConfig("descriptionVersion", text)
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
                            text: config["descriptionDate"] || ""
                            placeholderText: text ? "" : "YYYY-MM-DD"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: dateTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: dateTextField.focus ? 2 : 1
                                radius: 6
                            }
                            onTextChanged: updateConfig("descriptionDate", text)
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
                            text: config["descriptionAuthor"] || ""
                            placeholderText: text ? "" : "Author name"
                            background: Rectangle {
                                color: "#F8FAFC"
                                border.color: authorTextField.focus ? "#007BFF" : "#CED4DA"
                                border.width: authorTextField.focus ? 2 : 1
                                radius: 6
                            }
                            onTextChanged: updateConfig("descriptionAuthor", text)
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
                        Item {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.minimumHeight: 100
                            Layout.preferredHeight: 100
                            Rectangle {
                                id: textAreaBackground
                                anchors.fill: parent
                                color: "#F8FAFC"
                                border.color: detailsTextArea.focus ? "#007BFF" : "#CED4DA"
                                border.width: detailsTextArea.focus ? 2 : 1
                                radius: 6
                                ScrollView {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                                    TextArea {
                                        id: detailsTextArea
                                        width: parent.width
                                        font.pixelSize: 14
                                        font.family: "Roboto"
                                        wrapMode: Text.WordWrap
                                        text: config["descriptionDetails"] || ""
                                        background: Item {}
                                        onTextChanged: updateConfig("descriptionDetails", text)
                                    }
                                    Text {
                                        id: placeholderText
                                        anchors.fill: parent
                                        font: detailsTextArea.font
                                        text: detailsTextArea.text ? "" : "Detailed description"
                                        color: "#CED4DA"
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WordWrap
                                        visible: !detailsTextArea.text && !detailsTextArea.activeFocus
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        text: "Use Doxygen tags for structured documentation."
                        font.pixelSize: 12
                        font.family: "Roboto"
                        color: "#6B7280"
                        wrapMode: Text.WordWrap
                    }
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

                    // MicroController Row
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Label {
                            text: configGenerator.schema?.Device?.MicroController?.label || "Micro Controller"
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
                            property var schema: configGenerator.schema?.Device?.MicroController || {}
                            model: schema.values || ["Micro_V85XX", "Micro_V94XX", "Micro_V87XX", "Micro_V77XX", "Mixco_V77XX"]
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
                                if (schema.values) {
                                    const current = config["Device.MicroController"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "MicroCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Device.MicroController", schema.values[index]);
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
                            text: configGenerator.schema?.Device?.BOARD_TYPE?.label || "Board Type"
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
                            property var schema: configGenerator.schema?.Device?.BOARD_TYPE || {}
                            model: schema.values || ["EM130_BOARD", "EM122U_BOARD", "SPAIN_BOARD", "EM122_BOARD", "EM110_BOARD", "Mixco_BOARD"]
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
                                if (schema.values) {
                                    const current = config["Device.BOARD_TYPE"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "BoardCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Device.BOARD_TYPE", schema.values[index]);
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#E4E7EB"
                    }

                    // System Clock Row
                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Label {
                            text: configGenerator.schema?.Device?.SYSTEM_CLOCK?.label || "System Clock (kHz)"
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
                            property var schema: configGenerator.schema?.Device?.SYSTEM_CLOCK || {}
                            property var clockValues: schema.values || [16000, 25000]
                            model: schema.labels || schema.values|| ["16 MHz", "25 MHz"]
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
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Device.SYSTEM_CLOCK"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "SystemClockCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Device.SYSTEM_CLOCK", schema.values[index]);
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
        const newConfig = JSON.parse(JSON.stringify(config || {}));
        newConfig[key] = value;
        console.log(pageId, "Updating config for", key, "with value:", value, "new config:", JSON.stringify(newConfig));
        config = newConfig;
        configUpdated(newConfig);
        console.log(pageId, "Syncing with C++ backend:", JSON.stringify(newConfig));
        configGenerator.setConfig(newConfig);
    }

    function updateConfigAll(): void {
        const newConfig = JSON.parse(JSON.stringify(config || {}));
        console.log(pageId, "Syncing all config with C++ backend:", JSON.stringify(newConfig));
        configUpdated(newConfig);
        configGenerator.setConfig(newConfig);
    }
}
