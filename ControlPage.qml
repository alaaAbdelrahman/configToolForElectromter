import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "Control.CTRL_RFID_BOARD_PIN_ENABLE": false,
        "Control.POWER_FAIL_PIN_FEATURE": false,
        "Control.CTRL_GPRS_MODULE_CVR_SW": false,
        "Control.CTRL_CVR_SW": false,
        "Control.CTRL_TRMNL_SW": false,
        "Control.CTRL_UP_SW": false,
        "Control.CTRL_DN_SW": false,
        "Control.CTRL_MGNT_SW": false,
        "Control.CTRL_MGNT_SENSOR": false,
        "Control.CTRL_ACTIONS": false,
        "Control.CTRL_RLY": false,
        "Control.CTRL_TMPR_LED": false,
        "Control.CTRL_LOW_CRDT_LED": false,
        "Control.CTRL_BZR": false,
        "Control.AC_BUZZER_FEATURE": false,
        "Control.CTRL_ALRM_ICON": false,
        "Control.CTRL_RTC": false,
        "Control.KEYPAD_FEATURE": false,
        "Control.SUPERCAP_FEATURE": false,
        "Control.BATTERY_TYPE": "CTRL_BTRY_NON_CHRG",
        "Control.KEYPAD_TYPE": "TOUCH_KEYPAD"
    }
    signal configUpdated(var newConfig)

    property string pageId: "ControlPage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        const schema = configGenerator.schema["Control"] || {}
        for (let key in schema) {
            const fullKey = "Control." + key
            if (config[fullKey] === undefined && schema[key].default !== undefined) {
                config[fullKey] = schema[key].default
                console.log(pageId, "Initialized missing config key:", fullKey, "with default:", config[fullKey])
            }
        }
        updateConfigAll()
    }

    Connections {
        target: configGenerator
        function onErrorOccurred(error) {
            console.error(pageId, "Backend error:", error)
        }
        function onConfigChanged() {
            console.log(pageId, "Backend config changed:", JSON.stringify(configGenerator.config))
            config = configGenerator.config
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

                Label {
                    text: "Control Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Arial, sans-serif"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            // Control Pins Section
            GroupBox {
                title: "Control Pins"
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    CheckBox {
                        id: rfidCheck
                        text: configGenerator.schema["Control"]?.CTRL_RFID_BOARD_PIN_ENABLE?.label || "Enable RFID Board Pin"
                        checked: config["Control.CTRL_RFID_BOARD_PIN_ENABLE"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_RFID_BOARD_PIN_ENABLE !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_RFID_BOARD_PIN_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_RFID_BOARD_PIN_ENABLE?.description || ""
                    }

                    CheckBox {
                        id: powerFailCheck
                        text: configGenerator.schema["Control"]?.POWER_FAIL_PIN_FEATURE?.label || "Power Fail Pin Feature"
                        checked: config["Control.POWER_FAIL_PIN_FEATURE"] || false
                        visible: configGenerator.schema["Control"]?.POWER_FAIL_PIN_FEATURE !== undefined
                        onCheckedChanged: updateConfig("Control.POWER_FAIL_PIN_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.POWER_FAIL_PIN_FEATURE?.description || ""
                    }

                    CheckBox {
                        id: gprsCoverCheck
                        text: configGenerator.schema["Control"]?.CTRL_GPRS_MODULE_CVR_SW?.label || "GPRS Module Cover Switch"
                        checked: config["Control.CTRL_GPRS_MODULE_CVR_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_GPRS_MODULE_CVR_SW !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_GPRS_MODULE_CVR_SW", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_GPRS_MODULE_CVR_SW?.description || ""
                    }

                    CheckBox {
                        id: coverSwitchCheck
                        text: configGenerator.schema["Control"]?.CTRL_CVR_SW?.label || "Cover Switch"
                        checked: config["Control.CTRL_CVR_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_CVR_SW !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_CVR_SW", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_CVR_SW?.description || ""
                    }

                    CheckBox {
                        id: terminalSwitchCheck
                        text: configGenerator.schema["Control"]?.CTRL_TRMNL_SW?.label || "Terminal Switch"
                        checked: config["Control.CTRL_TRMNL_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_TRMNL_SW !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_TRMNL_SW", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_TRMNL_SW?.description || ""
                    }

                    CheckBox {
                        id: upSwitchCheck
                        text: configGenerator.schema["Control"]?.CTRL_UP_SW?.label || "Up Switch"
                        checked: config["Control.CTRL_UP_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_UP_SW !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_UP_SW", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_UP_SW?.description || ""
                    }

                    CheckBox {
                        id: downSwitchCheck
                        text: configGenerator.schema["Control"]?.CTRL_DN_SW?.label || "Down Switch"
                        checked: config["Control.CTRL_DN_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_DN_SW !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_DN_SW", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_DN_SW?.description || ""
                    }
                }
            }

            // Detection Method Section
            GroupBox {
                title: "Detection Method"
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    CheckBox {
                        id: magneticSwitchCheck
                        text: configGenerator.schema["Control"]?.CTRL_MGNT_SW?.label || "Magnetic Switch Detection"
                        checked: config["Control.CTRL_MGNT_SW"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_MGNT_SW !== undefined
                        onCheckedChanged: {
                            updateConfig("Control.CTRL_MGNT_SW", checked)
                            if (checked) updateConfig("Control.CTRL_MGNT_SENSOR", false)
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_MGNT_SW?.description || ""
                    }

                    CheckBox {
                        id: magneticSensorCheck
                        text: configGenerator.schema["Control"]?.CTRL_MGNT_SENSOR?.label || "Magnetic Sensor Detection"
                        checked: config["Control.CTRL_MGNT_SENSOR"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_MGNT_SENSOR !== undefined
                        onCheckedChanged: {
                            updateConfig("Control.CTRL_MGNT_SENSOR", checked)
                            if (checked) updateConfig("Control.CTRL_MGNT_SW", false)
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_MGNT_SENSOR?.description || ""
                    }
                }
            }

            // Action Controls Section
            GroupBox {
                title: "Action Controls"
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    CheckBox {
                        id: actionsEnabledCheck
                        text: configGenerator.schema["Control"]?.CTRL_ACTIONS?.label || "Enable Actions"
                        checked: config["Control.CTRL_ACTIONS"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_ACTIONS !== undefined
                        onCheckedChanged: {
                            updateConfig("Control.CTRL_ACTIONS", checked)
                            if (!checked) {
                                updateConfig("Control.CTRL_RLY", false)
                                updateConfig("Control.CTRL_TMPR_LED", false)
                                updateConfig("Control.CTRL_LOW_CRDT_LED", false)
                                updateConfig("Control.CTRL_BZR", false)
                                updateConfig("Control.AC_BUZZER_FEATURE", false)
                                updateConfig("Control.CTRL_ALRM_ICON", false)
                            }
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_ACTIONS?.description || ""
                    }

                    CheckBox {
                        id: relayControlCheck
                        text: configGenerator.schema["Control"]?.CTRL_RLY?.label || "Relay Control"
                        checked: config["Control.CTRL_RLY"] || false
                        enabled: actionsEnabledCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.CTRL_RLY !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_RLY", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_RLY?.description || ""
                    }

                    CheckBox {
                        id: tamperLedCheck
                        text: configGenerator.schema["Control"]?.CTRL_TMPR_LED?.label || "Tamper LED Control"
                        checked: config["Control.CTRL_TMPR_LED"] || false
                        enabled: actionsEnabledCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.CTRL_TMPR_LED !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_TMPR_LED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_TMPR_LED?.description || ""
                    }

                    CheckBox {
                        id: lowCreditLedCheck
                        text: configGenerator.schema["Control"]?.CTRL_LOW_CRDT_LED?.label || "Low Credit LED Control"
                        checked: config["Control.CTRL_LOW_CRDT_LED"] || false
                        enabled: actionsEnabledCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.CTRL_LOW_CRDT_LED !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_LOW_CRDT_LED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_LOW_CRDT_LED?.description || ""
                    }

                    CheckBox {
                        id: buzzerControlCheck
                        text: configGenerator.schema["Control"]?.CTRL_BZR?.label || "Buzzer Control"
                        checked: config["Control.CTRL_BZR"] || false
                        enabled: actionsEnabledCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.CTRL_BZR !== undefined
                        onCheckedChanged: {
                            updateConfig("Control.CTRL_BZR", checked)
                            if (!checked) updateConfig("Control.AC_BUZZER_FEATURE", false)
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_BZR?.description || ""
                    }

                    CheckBox {
                        id: acBuzzerCheck
                        text: configGenerator.schema["Control"]?.AC_BUZZER_FEATURE?.label || "AC Buzzer"
                        checked: config["Control.AC_BUZZER_FEATURE"] || false
                        enabled: actionsEnabledCheck.checked && buzzerControlCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.AC_BUZZER_FEATURE !== undefined
                        onCheckedChanged: updateConfig("Control.AC_BUZZER_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.AC_BUZZER_FEATURE?.description || ""
                    }

                    CheckBox {
                        id: alarmIconCheck
                        text: configGenerator.schema["Control"]?.CTRL_ALRM_ICON?.label || "Alarm Icon Control"
                        checked: config["Control.CTRL_ALRM_ICON"] || false
                        enabled: actionsEnabledCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        visible: configGenerator.schema["Control"]?.CTRL_ALRM_ICON !== undefined
                        onCheckedChanged: updateConfig("Control.CTRL_ALRM_ICON", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_ALRM_ICON?.description || ""
                    }
                }
            }

            // Battery Configuration Section
            GroupBox {
                title: "Power Configuration"
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["Control"]?.BATTERY_TYPE?.label || "Battery Type"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: batteryTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Control"]?.BATTERY_TYPE || {}
                            model: schema.labels || ["Non-chargeable Battery", "Chargeable Battery"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: batteryTypeCombo.displayText
                                font: batteryTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: batteryTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: batteryTypeCombo.height
                                width: batteryTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: batteryTypeCombo.popup.visible ? batteryTypeCombo.delegateModel : null
                                    currentIndex: batteryTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: batteryTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: batteryTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: batteryTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Control.BATTERY_TYPE"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "BatteryTypeCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Control.BATTERY_TYPE", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    CheckBox {
                        id: rtcCheck
                        text: configGenerator.schema["Control"]?.CTRL_RTC?.label || "Enable RTC"
                        checked: config["Control.CTRL_RTC"] || false
                        visible: configGenerator.schema["Control"]?.CTRL_RTC !== undefined && !(config["Control.BATTERY_TYPE"] === "CTRL_SUPER_CAP")
                        onCheckedChanged: updateConfig("Control.CTRL_RTC", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.CTRL_RTC?.description || ""
                    }

                    CheckBox {
                        id: superCapCheck
                        text: configGenerator.schema["Control"]?.SUPERCAP_FEATURE?.label || "Super Capacitor Feature"
                        checked: config["Control.SUPERCAP_FEATURE"] || false
                        visible: configGenerator.schema["Control"]?.SUPERCAP_FEATURE !== undefined
                        onCheckedChanged: updateConfig("Control.SUPERCAP_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.SUPERCAP_FEATURE?.description || ""
                    }
                }
            }

            // Keypad System Section
            GroupBox {
                title: "Keypad System"
                Layout.fillWidth: true
                padding: 20
                spacing: 16

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    CheckBox {
                        id: keypadFeatureCheck
                        text: configGenerator.schema["Control"]?.KEYPAD_FEATURE?.label || "Enable Keypad Feature"
                        checked: config["Control.KEYPAD_FEATURE"] || false
                        visible: configGenerator.schema["Control"]?.KEYPAD_FEATURE !== undefined
                        onCheckedChanged: {
                            updateConfig("Control.KEYPAD_FEATURE", checked)
                            if (!checked) {
                                updateConfig("Control.KEYPAD_TYPE", "TOUCH_KEYPAD")
                            }
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Control"]?.KEYPAD_FEATURE?.description || ""
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        visible: keypadFeatureCheck.checked && configGenerator.schema["Control"]?.KEYPAD_TYPE !== undefined
                        enabled: keypadFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Control"]?.KEYPAD_TYPE?.label || "Keypad Type"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: keypadTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Control"]?.KEYPAD_TYPE || {}
                            model: schema.labels || ["Touch Keypad", "Rubber Keypad"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: keypadTypeCombo.displayText
                                font: keypadTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: keypadTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: keypadTypeCombo.height
                                width: keypadTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: keypadTypeCombo.popup.visible ? keypadTypeCombo.delegateModel : null
                                    currentIndex: keypadTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: keypadTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: keypadTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: keypadTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Control.KEYPAD_TYPE"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "KeypadTypeCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Control.KEYPAD_TYPE", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
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
        console.log(pageId, "Updating config for", key, "with value:", value, "new config:", JSON.stringify(newConfig))
        config = newConfig
        configUpdated(newConfig)
        console.log(pageId, "Syncing with C++ backend:", JSON.stringify(newConfig))
        configGenerator.setConfig(newConfig)
    }

    function updateConfigAll(): void {
        const newConfig = JSON.parse(JSON.stringify(config || {}))
        console.log(pageId, "Syncing all config with C++ backend:", JSON.stringify(newConfig))
        configUpdated(newConfig)
        configGenerator.setConfig(newConfig)
    }
}
