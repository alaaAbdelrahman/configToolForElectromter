import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "Display.displayType": "SEGMENTED_LCD_ENABLE",
        "Display.DOT_MATRIX_LOW_PWR_FEATURE": false,
        "Display.USE_NEW_LCD": false,
        "Display.LCD_HQ30774_ENABLE": false,
        "Display.LCD_CNKD0802_24SEG_8COM": false,
        "Display.LCD_NEW_CNKD0802_24SEG_8COM": false,
        "Display.screenLanguage": "ENGLISH_SCREEN",
        "Display.CD0066_MH6531AHSP_ENGLISH": false,
        "Display.RECORD_NEW_CUSTOMER_DATE": false,
        "Display.SERIAL_NUMBER_CHANGE": false,
        "Display.DISPLAY_MAP_SCREEN": false,
        "Display.DISPLAY_OBIS": false,
        "Display.DISPLAY_SCREEN_ORDER": "CONSTANT_SCREEN_ORDER"
    }
    signal configUpdated(var newConfig)

    property string pageId: "DisplayPage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        // Initialize missing config keys with schema defaults
        const displaySchema = configGenerator.schema["Display"] || {}
        for (let key in displaySchema) {
            const fullKey = "Display." + key;
            if (config[fullKey] === undefined && displaySchema[key].default !== undefined) {
                config[fullKey] = displaySchema[key].default;
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
                            text: configGenerator.schema["Display"]?.displayType?.label || "Display Type"
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
                            property var schema: configGenerator.schema["Display"]?.displayType || {}
                            model: schema.labels || ["Segmented LCD", "Dot Matrix LCD"]
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
                                if (schema.values) {
                                    const current = config["Display.displayType"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "DisplayTypeCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Display.displayType", schema.values[index]);
                                }
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Label {
                            text: configGenerator.schema["Display"]?.USE_NEW_LCD?.label || "Use New LCD"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }
                        CheckBox {
                            id: useNewLcdCheck
                            checked: config["Display.USE_NEW_LCD"] || false
                            onCheckedChanged: updateConfig("Display.USE_NEW_LCD", checked)
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
                visible: config["Display.displayType"] === "SEGMENTED_LCD_ENABLE"
            }

            // Segmented Displays Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config["Display.displayType"] === "SEGMENTED_LCD_ENABLE"
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
                        id: hq30774Check
                        text: configGenerator.schema["Display"]?.LCD_HQ30774_ENABLE?.label || "Enable LCD HQ30774"
                        checked: config["Display.LCD_HQ30774_ENABLE"] || false
                        onCheckedChanged: updateConfig("Display.LCD_HQ30774_ENABLE", checked)
                    }

                    CheckBox {
                        id: cnkd0802Check
                        text: configGenerator.schema["Display"]?.LCD_CNKD0802_24SEG_8COM?.label || "Enable LCD CNKD0802 24SEG 8COM"
                        checked: config["Display.LCD_CNKD0802_24SEG_8COM"] || false
                        onCheckedChanged: updateConfig("Display.LCD_CNKD0802_24SEG_8COM", checked)
                    }

                    CheckBox {
                        id: newCnkd0802Check
                        text: configGenerator.schema["Display"]?.LCD_NEW_CNKD0802_24SEG_8COM?.label || "Enable New LCD CNKD0802 24SEG 8COM"
                        checked: config["Display.LCD_NEW_CNKD0802_24SEG_8COM"] || false
                        onCheckedChanged: updateConfig("Display.LCD_NEW_CNKD0802_24SEG_8COM", checked)
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
                visible: config["Display.displayType"] === "DOT_MATRIX_LCD_ENABLE"
            }

            // Dot Matrix Displays Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config["Display.displayType"] === "DOT_MATRIX_LCD_ENABLE"
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
                        id: dotMatrixLowPwrCheck
                        text: configGenerator.schema["Display"]?.DOT_MATRIX_LOW_PWR_FEATURE?.label || "Enable Dot Matrix Low Power"
                        checked: config["Display.DOT_MATRIX_LOW_PWR_FEATURE"] || false
                        onCheckedChanged: updateConfig("Display.DOT_MATRIX_LOW_PWR_FEATURE", checked)
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
                visible: config["Display.displayType"] !== ""
            }

            // Display Features Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config["Display.displayType"] !== ""
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
                        id: recordNewCustomerDateCheck
                        text: configGenerator.schema["Display"]?.RECORD_NEW_CUSTOMER_DATE?.label || "Record New Customer Date"
                        checked: config["Display.RECORD_NEW_CUSTOMER_DATE"] || false
                        onCheckedChanged: updateConfig("Display.RECORD_NEW_CUSTOMER_DATE", checked)
                    }

                    CheckBox {
                        id: serialNumberChangeCheck
                        text: configGenerator.schema["Display"]?.SERIAL_NUMBER_CHANGE?.label || "Enable Serial Number Change"
                        checked: config["Display.SERIAL_NUMBER_CHANGE"] || false
                        onCheckedChanged: updateConfig("Display.SERIAL_NUMBER_CHANGE", checked)
                    }

                    CheckBox {
                        id: displayMapScreenCheck
                        text: configGenerator.schema["Display"]?.DISPLAY_MAP_SCREEN?.label || "Display Map Screen"
                        checked: config["Display.DISPLAY_MAP_SCREEN"] || false
                        onCheckedChanged: updateConfig("Display.DISPLAY_MAP_SCREEN", checked)
                    }

                    CheckBox {
                        id: displayObisCheck
                        text: configGenerator.schema["Display"]?.DISPLAY_OBIS?.label || "Display OBIS"
                        checked: config["Display.DISPLAY_OBIS"] || false
                        onCheckedChanged: updateConfig("Display.DISPLAY_OBIS", checked)
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Label {
                            text: configGenerator.schema["Display"]?.DISPLAY_SCREEN_ORDER?.label || "Display Screen Order"
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
                            property var schema: configGenerator.schema["Display"]?.DISPLAY_SCREEN_ORDER || {}
                            model: schema.labels
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
                                if (schema.values) {
                                    const current = config["Display.DISPLAY_SCREEN_ORDER"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "ScreenOrderCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Display.DISPLAY_SCREEN_ORDER", schema.values[index]);
                                }
                            }
                        }
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
                visible: config["Display.displayType"] !== ""
            }

            // Screen Language Group
            GroupBox {
                title: ""
                Layout.fillWidth: true
                padding: 12
                spacing: 16
                visible: config["Display.displayType"] !== ""
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
                            text: configGenerator.schema["Display"]?.screenLanguage?.label || "Screen Language"
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
                            property var schema: configGenerator.schema["Display"]?.screenLanguage || {}
                            model: schema.labels || ["English", "Arabic"]
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
                                if (schema.values) {
                                    const current = config["Display.screenLanguage"] || schema.default || schema.values[0];
                                    currentIndex = schema.values.indexOf(current);
                                    console.log(pageId, "ScreenLanguageCombo initialized with index:", currentIndex, "value:", current);
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Display.screenLanguage", schema.values[index]);
                                }
                            }
                        }
                    }

                    CheckBox {
                        id: cd0066Check
                        text: configGenerator.schema["Display"]?.CD0066_MH6531AHSP_ENGLISH?.label || "Enable CD0066 MH6531AHSP English"
                        checked: config["Display.CD0066_MH6531AHSP_ENGLISH"] || false
                        onCheckedChanged: updateConfig("Display.CD0066_MH6531AHSP_ENGLISH", checked)
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
