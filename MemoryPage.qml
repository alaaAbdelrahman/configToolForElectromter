import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "Memory.FILE_SYS_USE_INT": false,
        "Memory.FILE_SYS_LOG": false,
        "Memory.CTRL_EVNT_LOG": false,
        "Memory.EVENT_LOG_RECORD_NUM": 0,
        "Memory.CTRL_CFG_METER_LOG": false,
        "Memory.CFG_METER_RECORD_NUM": 0,
        "Memory.PMYT_MNY_TRANS_REC": 0,
        "Memory.FM24C128D_2_Wire_Serial_EEPROM": false,
        "Memory.FLASH_FM25W32_ENABLE": false
    }
    signal configUpdated(var newConfig)
    property string pageId: "MemoryPage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        const schema = configGenerator.schema["Memory"] || {}
        for (let key in schema) {
            const fullKey = "Memory." + key
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
            config = JSON.parse(JSON.stringify(configGenerator.config || {}))
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

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                color: "#FFFFFF"
                radius: 8
                border.color: "#E4E7EB"
                border.width: 1

                Label {
                    text: "Memory Management Configurations"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Arial, sans-serif"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            GroupBox {
                title: "Logs and Files"
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
                        id: fileSysUseIntCheck
                        text: configGenerator.schema.Memory?.FILE_SYS_USE_INT?.label || "Use Internal MCU Memory in File System"
                        checked: config["Memory.FILE_SYS_USE_INT"] !== undefined ? config["Memory.FILE_SYS_USE_INT"]  : false
                        visible: configGenerator.schema.Memory?.FILE_SYS_USE_INT !== undefined
                        onClicked: updateConfig("Memory.FILE_SYS_USE_INT", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.FILE_SYS_USE_INT?.description || ""
                    }


                    CheckBox {
                        id: ctrlEvntLogCheck
                        text: configGenerator.schema.Memory?.CTRL_EVNT_LOG?.label || "Enable Events Logging"
                        checked: config["Memory.CTRL_EVNT_LOG"] !== undefined ? config["Memory.CTRL_EVNT_LOG"]  : false
                        visible: configGenerator.schema.Memory?.CTRL_EVNT_LOG !== undefined && config["Control.BATTERY_TYPE"] !== "CTRL_SUPER_CAP"
                        enabled: config["Control.BATTERY_TYPE"] !== "CTRL_SUPER_CAP"
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Memory.CTRL_EVNT_LOG", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.CTRL_EVNT_LOG?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ctrlEvntLogCheck.checked && config["Control.BATTERY_TYPE"] !== "CTRL_SUPER_CAP"&& configGenerator.schema.Memory?.EVENT_LOG_RECORD_NUM !== undefined
                        enabled: ctrlEvntLogCheck.checked && config["Control.BATTERY_TYPE"] !== "CTRL_SUPER_CAP"
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Memory?.EVENT_LOG_RECORD_NUM?.label || "Max Events Log Records"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: eventLogRecordNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Memory.EVENT_LOG_RECORD_NUM"] !== undefined ? config["Memory.EVENT_LOG_RECORD_NUM"].toString() : "0"
                            validator: IntValidator { bottom: 0; top: 402 }
                            onEditingFinished: {
                                const value = parseInt(text) || 0
                                if (value !== config["Memory.EVENT_LOG_RECORD_NUM"]) {
                                    updateConfig("Memory.EVENT_LOG_RECORD_NUM", value)
                                }
                            }
                            background: Rectangle {
                                color: eventLogRecordNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: eventLogRecordNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: eventLogRecordNumField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Memory?.EVENT_LOG_RECORD_NUM?.description || ""
                        }
                    }

                    CheckBox {
                        id: ctrlCfgMeterLogCheck
                        text: configGenerator.schema.Memory?.CTRL_CFG_METER_LOG?.label || "Enable Configure Meter Logging"
                        checked: config["Memory.CTRL_CFG_METER_LOG"] !== undefined ? config["Memory.CTRL_CFG_METER_LOG"] !== undefined : false
                        visible: configGenerator.schema.Memory?.CTRL_CFG_METER_LOG !== undefined && !config["Control.CTRL_SUPER_CAP"]
                        enabled: !config["Control.CTRL_SUPER_CAP"]
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Memory.CTRL_CFG_METER_LOG", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.CTRL_CFG_METER_LOG?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ctrlCfgMeterLogCheck.checked && config["Control.BATTERY_TYPE"] !== "CTRL_SUPER_CAP"&& configGenerator.schema.Memory?.CFG_METER_RECORD_NUM !== undefined
                        enabled: ctrlCfgMeterLogCheck.checked && !config["Control.CTRL_SUPER_CAP"]
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Memory?.CFG_METER_RECORD_NUM?.label || "Max Configure Meter Records"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: cfgMeterRecordNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Memory.CFG_METER_RECORD_NUM"] !== undefined ? config["Memory.CFG_METER_RECORD_NUM"].toString() : "0"
                            validator: IntValidator { bottom: 0; top: 30 }
                            onEditingFinished: {
                                const value = parseInt(text) || 0
                                if (value !== config["Memory.CFG_METER_RECORD_NUM"]) {
                                    updateConfig("Memory.CFG_METER_RECORD_NUM", value)
                                }
                            }
                            background: Rectangle {
                                color: cfgMeterRecordNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: cfgMeterRecordNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: cfgMeterRecordNumField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Memory?.CFG_METER_RECORD_NUM?.description || ""
                        }
                    }


                    CheckBox {
                        id: fileSysLogCheck
                        text: configGenerator.schema.Memory?.FILE_SYS_LOG?.label || "Enable Logging APIs"
                        checked: config["Memory.FILE_SYS_LOG"] !== undefined ? config["Memory.FILE_SYS_LOG"] : false
                        visible: configGenerator.schema.Memory?.FILE_SYS_LOG !== undefined
                        enabled: config["Memory.CTRL_EVNT_LOG"] || config["Tariff.PYMT_MONY_TRANS"] !== undefined
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Memory.FILE_SYS_LOG", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.FILE_SYS_LOG?.description || ""
                    }
                }
            }

            GroupBox {
                title: "External Memory"
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
                        id: fm24c128dEepromCheck
                        text: configGenerator.schema.Memory?.FM24C128D_2_Wire_Serial_EEPROM?.label || "Enable FM24C128D 2-Wire Serial EEPROM"
                        checked: config["Memory.FM24C128D_2_Wire_Serial_EEPROM"] !== undefined ? config["Memory.FM24C128D_2_Wire_Serial_EEPROM"] : false
                        visible: configGenerator.schema.Memory?.FM24C128D_2_Wire_Serial_EEPROM !== undefined
                        onClicked: updateConfig("Memory.FM24C128D_2_Wire_Serial_EEPROM", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.FM24C128D_2_Wire_Serial_EEPROM?.description || ""
                    }

                    CheckBox {
                        id: flashFm25w32Check
                        text: configGenerator.schema.Memory?.FLASH_FM25W32_ENABLE?.label || "Enable Flash FM25W32"
                        checked: config["Memory.FLASH_FM25W32_ENABLE"] !== undefined ? config["Memory.FLASH_FM25W32_ENABLE"] : false
                        visible: configGenerator.schema.Memory?.FLASH_FM25W32_ENABLE !== undefined
                        onClicked: updateConfig("Memory.FLASH_FM25W32_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Memory?.FLASH_FM25W32_ENABLE?.description || ""
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
            }
        }
    }

    function updateConfig(key: string, value: variant): void {
        const newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value

        // Update FILE_SYS_LOG based on dependencies
        newConfig["Memory.FILE_SYS_LOG"] = newConfig["Memory.CTRL_EVNT_LOG"] || newConfig["Tariff.PYMT_MONY_TRANS"] !== undefined

        // Reset dependent fields to schema defaults
        if (key === "Control.CTRL_SUPER_CAP" && value) {
            newConfig["Memory.CTRL_EVNT_LOG"] = configGenerator.schema.Memory?.CTRL_EVNT_LOG?.default || false
            newConfig["Memory.EVENT_LOG_RECORD_NUM"] = configGenerator.schema.Memory?.EVENT_LOG_RECORD_NUM?.default || 0
            newConfig["Memory.CTRL_CFG_METER_LOG"] = configGenerator.schema.Memory?.CTRL_CFG_METER_LOG?.default || false
            newConfig["Memory.CFG_METER_RECORD_NUM"] = configGenerator.schema.Memory?.CFG_METER_RECORD_NUM?.default || 0
        }
        if (key === "Memory.CTRL_EVNT_LOG" && !value) {
            newConfig["Memory.EVENT_LOG_RECORD_NUM"] = configGenerator.schema.Memory?.EVENT_LOG_RECORD_NUM?.default || 0
        }
        if (key === "Memory.CTRL_CFG_METER_LOG" && !value) {
            newConfig["Memory.CFG_METER_RECORD_NUM"] = configGenerator.schema.Memory?.CFG_METER_RECORD_NUM?.default || 0
        }

        // Clamp integer values within schema bounds
        if (key === "Memory.EVENT_LOG_RECORD_NUM" && newConfig["Memory.CTRL_EVNT_LOG"]) {
            newConfig["Memory.EVENT_LOG_RECORD_NUM"] = Math.min(Math.max(value, 0), 402)
        }
        if (key === "Memory.CFG_METER_RECORD_NUM" && newConfig["Memory.CTRL_CFG_METER_LOG"]) {
            newConfig["Memory.CFG_METER_RECORD_NUM"] = Math.min(Math.max(value, 0), 30)
        }


        console.log(pageId, "Updating config for", key, "with value:", value, "new config:", JSON.stringify(newConfig))
        config = newConfig
        configUpdated(newConfig)
        console.log(pageId, "Syncing with C++ backend:", JSON.stringify(newConfig))
        configGenerator.setConfig(newConfig)
    }

    function updateConfigAll(): void {
        const newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig["Memory.FILE_SYS_LOG"] = newConfig["Memory.CTRL_EVNT_LOG"] || newConfig["Tariff.PYMT_MONY_TRANS"] !== undefined
        console.log(pageId, "Syncing all config with C++ backend:", JSON.stringify(newConfig))
        configUpdated(newConfig)
        configGenerator.setConfig(newConfig)
    }
}
