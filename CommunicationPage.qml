import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "Communication.I2C_SPI_ENABLE": false,
        "Communication.I2C_STATUS": "SEPARATE_I2C",
        "Communication.HW_SPI": true,
        "Communication.SW_SPI": true,
        "Communication.RF_LINK_FEATURE": true,
        "Communication.RF_LINK_MBUS_DEVICE": "RF_LINK_METER",
        "Communication.RF_LINK_TI_CC1120_ENABLE": true,
        "Communication.RF_LINK_TI_CC1120_PORT": "USART2",
        "Communication.RF_LINK_TI_CC1120_RESET_POWER": true,
        "Communication.RFID_FEATURE": true,
        "Communication.MFRC522_ENABLE": true,
        "Communication.MFRC522_CARD_TYPE": "MFRC522_CARD_32K",
        "Communication.MFRC522_CARD_32k_TYPE": "CARD_32k_MASRIA_MTCOS_FLEX_ID",
        "Communication.MFRC522_INCREASE_SPEED": true,
        "Communication.RFID_SEQ_READ_WRITE": true,
        "Communication.RFID_BUFFER_LEN": 2000,
        "Communication.RFID_PAR_LIMITED": true,
        "Communication.RFID_PREPAID_PAR_NUM": 100,
        "Communication.RFID_PAR_PREDEFINED": true,
        "Communication.RFID_PAR_POSTDEFINED": true,
        "Communication.RFID_POSTPAID_PAR_NUM": 1000,
        "Communication.RS485_FEATURE": true,
        "Communication.MODEM_ENABLE": true,
        "Communication.MODEM_BAUD_RATE": "5",
        "Communication.GPRS_FEATURE": true,
        "Communication.GPRS_SEND_NOTIFICATION_FEATURE": true,
        "Communication.SCREEN_GPRS_FEATURE": true,
        "Communication.GPRS_DATA_BUFFER_SIZE": 1500,
        "Communication.GPRS_SRT_CARD": true,
        "Communication.IEC_62056_21_SLAVE": true,
        "Communication.IEC_BUFFER_SIZE": 1056,
        "Communication.IEC_62056_21_ISR_ENABLE": true,
        "Communication.OPTICAL_DMA_ENABLE": true
    }
    signal configUpdated(var newConfig)
    property string pageId: "CommunicationPage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        const schema = configGenerator.schema["Communication"] || {}
        for (let key in schema) {
            const fullKey = "Communication." + key
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
                    text: "Communication Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Arial, sans-serif"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            GroupBox {
                title: "I2C and SPI Settings"
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
                    spacing: 100
                    width: parent.width

                    CheckBox {
                        id: i2cSpiEnableCheck
                        text: configGenerator.schema["Communication"]?.I2C_SPI_ENABLE?.label || "Enable I2C/SPI Settings"
                        checked: config["Communication.I2C_SPI_ENABLE"] || false
                        visible: configGenerator.schema["Communication"]?.I2C_SPI_ENABLE !== undefined
                        onClicked: updateConfig("Communication.I2C_SPI_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.I2C_SPI_ENABLE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: i2cSpiEnableCheck.checked && configGenerator.schema["Communication"]?.I2C_STATUS !== undefined
                        enabled: i2cSpiEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.I2C_STATUS?.label || "I2C Status"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: i2cStatusCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Communication"]?.I2C_STATUS || {}
                            model: schema.labels || schema.values || ["Shared I2C", "Separate I2C"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: i2cStatusCombo.displayText
                                font: i2cStatusCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: i2cStatusCombo.width - 20
                            }
                            popup: Popup {
                                y: i2cStatusCombo.height
                                width: i2cStatusCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: i2cStatusCombo.popup.visible ? i2cStatusCombo.delegateModel : null
                                    currentIndex: i2cStatusCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: i2cStatusCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: i2cStatusCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: i2cStatusCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Communication.I2C_STATUS"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "I2CStatusCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Communication.I2C_STATUS", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    CheckBox {
                        id: hwSpiCheck
                        text: configGenerator.schema["Communication"]?.HW_SPI?.label || "Enable Hardware SPI"
                        checked: config["Communication.HW_SPI"] || false
                        visible: i2cSpiEnableCheck.checked && configGenerator.schema["Communication"]?.HW_SPI !== undefined
                        enabled: i2cSpiEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.HW_SPI", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.HW_SPI?.description || ""
                    }

                    CheckBox {
                        id: swSpiCheck
                        text: configGenerator.schema["Communication"]?.SW_SPI?.label || "Enable Software SPI"
                        checked: config["Communication.SW_SPI"] || false
                        visible: i2cSpiEnableCheck.checked && configGenerator.schema["Communication"]?.SW_SPI !== undefined
                        enabled: i2cSpiEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.SW_SPI", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.SW_SPI?.description || ""
                    }
                }
            }

            GroupBox {
                title: "RF Link Settings"
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
                    spacing: 15
                    width: parent.width

                    CheckBox {
                        id: rfLinkFeatureCheck
                        text: configGenerator.schema["Communication"]?.RF_LINK_FEATURE?.label || "Enable RF Link"
                        checked: config["Communication.RF_LINK_FEATURE"] || false
                        visible: configGenerator.schema["Communication"]?.RF_LINK_FEATURE !== undefined
                        onClicked: updateConfig("Communication.RF_LINK_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RF_LINK_FEATURE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked && configGenerator.schema["Communication"]?.RF_LINK_MBUS_DEVICE !== undefined
                        enabled: rfLinkFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.RF_LINK_MBUS_DEVICE?.label || "RF Link Device"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rfLinkMbusDeviceCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Communication"]?.RF_LINK_MBUS_DEVICE || {}
                            model: schema.labels || schema.values || ["RF Link Meter"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rfLinkMbusDeviceCombo.displayText
                                font: rfLinkMbusDeviceCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rfLinkMbusDeviceCombo.width - 20
                            }
                            popup: Popup {
                                y: rfLinkMbusDeviceCombo.height
                                width: rfLinkMbusDeviceCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rfLinkMbusDeviceCombo.popup.visible ? rfLinkMbusDeviceCombo.delegateModel : null
                                    currentIndex: rfLinkMbusDeviceCombo_highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rfLinkMbusDeviceCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfLinkMbusDeviceCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfLinkMbusDeviceCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Communication.RF_LINK_MBUS_DEVICE"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "RFLinkMbusDeviceCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Communication.RF_LINK_MBUS_DEVICE", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    CheckBox {
                        id: rfLinkTiCc1120EnableCheck
                        text: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_ENABLE?.label || "Enable TI CC1120"
                        checked: config["Communication.RF_LINK_TI_CC1120_ENABLE"] || false
                        visible: rfLinkFeatureCheck.checked && configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_ENABLE !== undefined
                        enabled: rfLinkFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RF_LINK_TI_CC1120_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_ENABLE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnableCheck.checked && configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_PORT !== undefined
                        enabled: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_PORT?.label || "TI CC1120 Port"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rfLinkTiCc1120PortCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_PORT || {}
                            model: schema.labels || schema.values || ["USART2"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rfLinkTiCc1120PortCombo.displayText
                                font: rfLinkTiCc1120PortCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rfLinkTiCc1120PortCombo.width - 20
                            }
                            popup: Popup {
                                y: rfLinkTiCc1120PortCombo.height
                                width: rfLinkTiCc1120PortCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rfLinkTiCc1120PortCombo.popup.visible ? rfLinkTiCc1120PortCombo.delegateModel : null
                                    currentIndex: rfLinkTiCc1120PortCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rfLinkTiCc1120PortCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfLinkTiCc1120PortCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfLinkTiCc1120PortCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Communication.RF_LINK_TI_CC1120_PORT"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "RFLinkTiCc1120PortCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Communication.RF_LINK_TI_CC1120_PORT", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    CheckBox {
                        id: rfLinkTiCc1120ResetPowerCheck
                        text: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_RESET_POWER?.label || "Enable TI CC1120 Reset Power"
                        checked: config["Communication.RF_LINK_TI_CC1120_RESET_POWER"] || false
                        visible: rfLinkFeatureCheck.checked && configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_RESET_POWER !== undefined
                        enabled: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RF_LINK_TI_CC1120_RESET_POWER", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_RESET_POWER?.description || ""
                    }
                }
            }

            GroupBox {
                title: "RFID Settings"
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
                    spacing: 15
                    width: parent.width

                    CheckBox {
                        id: rfidFeatureCheck
                        text: configGenerator.schema["Communication"]?.RFID_FEATURE?.label || "Enable RFID Feature"
                        checked: config["Communication.RFID_FEATURE"] || false
                        visible: configGenerator.schema["Communication"]?.RFID_FEATURE !== undefined
                        onClicked: updateConfig("Communication.RFID_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RFID_FEATURE?.description || ""
                    }

                    CheckBox {
                        id: mfrc522EnableCheck
                        text: configGenerator.schema["Communication"]?.MFRC522_ENABLE?.label || "Enable RFID"
                        checked: config["Communication.MFRC522_ENABLE"] || false
                        visible: configGenerator.schema["Communication"]?.MFRC522_ENABLE !== undefined
                        enabled: rfidFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.MFRC522_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.MFRC522_ENABLE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.MFRC522_CARD_TYPE !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.MFRC522_CARD_TYPE?.label || "RFID Card Type"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: mfrc522CardTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Communication"]?.MFRC522_CARD_TYPE || {}
                            model: schema.labels || schema.values || ["MFRC522 Card 32K"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: mfrc522CardTypeCombo.displayText
                                font: mfrc522CardTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: mfrc522CardTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: mfrc522CardTypeCombo.height
                                width: mfrc522CardTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: mfrc522CardTypeCombo.popup.visible ? mfrc522CardTypeCombo.delegateModel : null
                                    currentIndex: mfrc522CardTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: mfrc522CardTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: mfrc522CardTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: mfrc522CardTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Communication.MFRC522_CARD_TYPE"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "MFRC522CardTypeCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    const selectedValue = schema.values[index]
                                    updateConfig("Communication.MFRC522_CARD_TYPE", selectedValue)
                                    if (selectedValue !== "MFRC522_CARD_32K") {
                                        updateConfig("Communication.MFRC522_CARD_32k_TYPE", schema["MFRC522_CARD_32k_TYPE"]?.default || null)
                                        updateConfig("Communication.MFRC522_INCREASE_SPEED", schema["MFRC522_INCREASE_SPEED"]?.default || false)
                                        updateConfig("Communication.RFID_SEQ_READ_WRITE", schema["RFID_SEQ_READ_WRITE"]?.default || false)
                                    }
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE !== undefined && config["Communication.MFRC522_CARD_TYPE"] === "MFRC522_CARD_32K"
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE?.label || "RFID 32K Card Type"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: mfrc522Card32kTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE || {}
                            model: schema.labels || schema.values || ["CARD_32k_MASRIA_MTCOS_FLEX_ID"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: mfrc522Card32kTypeCombo.displayText
                                font: mfrc522Card32kTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: mfrc522Card32kTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: mfrc522Card32kTypeCombo.height
                                width: mfrc522Card32kTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: mfrc522Card32kTypeCombo.popup.visible ? mfrc522Card32kTypeCombo.delegateModel : null
                                    currentIndex: mfrc522Card32kTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: mfrc522Card32kTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: mfrc522Card32kTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: mfrc522Card32kTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Communication.MFRC522_CARD_32k_TYPE"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "MFRC522Card32kTypeCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Communication.MFRC522_CARD_32k_TYPE", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    CheckBox {
                        id: mfrc522IncreaseSpeedCheck
                        text: configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED?.label || "Enable MFRC522 Increase Speed"
                        checked: config["Communication.MFRC522_INCREASE_SPEED"] || false
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED !== undefined && config["Communication.MFRC522_CARD_TYPE"] === "MFRC522_CARD_32K"
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.MFRC522_INCREASE_SPEED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED?.description || ""
                    }

                    CheckBox {
                        id: rfidSeqReadWriteCheck
                        text: configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE?.label || "Enable RFID Sequential Read/Write"
                        checked: config["Communication.RFID_SEQ_READ_WRITE"] || false
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE !== undefined && config["Communication.MFRC522_CARD_TYPE"] === "MFRC522_CARD_32K"
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RFID_SEQ_READ_WRITE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.RFID_BUFFER_LEN !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.RFID_BUFFER_LEN?.label || "RFID Buffer Length"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rfidBufferLenField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.RFID_BUFFER_LEN"] !== undefined ? config["Communication.RFID_BUFFER_LEN"].toString() : "2000"
                            validator: IntValidator { bottom: 0; top: 5000 }
                            onEditingFinished: {
                                const value = parseInt(text) || 2000
                                if (value !== config["Communication.RFID_BUFFER_LEN"]) {
                                    updateConfig("Communication.RFID_BUFFER_LEN", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidBufferLenField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidBufferLenField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidBufferLenField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.RFID_BUFFER_LEN?.description || ""
                        }
                    }

                    CheckBox {
                        id: rfidParLimitedCheck
                        text: configGenerator.schema["Communication"]?.RFID_PAR_LIMITED?.label || "Enable Limited Parameters"
                        checked: config["Communication.RFID_PAR_LIMITED"] || false
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && configGenerator.schema["Communication"]?.RFID_PAR_LIMITED !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RFID_PAR_LIMITED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RFID_PAR_LIMITED?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked && configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM?.label || "Prepaid Parameter Number"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rfidPrepaidParNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.RFID_PREPAID_PAR_NUM"] !== undefined ? config["Communication.RFID_PREPAID_PAR_NUM"].toString() : "100"
                            validator: IntValidator { bottom: 0; top: 1000 }
                            onEditingFinished: {
                                const value = parseInt(text) || 100
                                if (value !== config["Communication.RFID_PREPAID_PAR_NUM"]) {
                                    updateConfig("Communication.RFID_PREPAID_PAR_NUM", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidPrepaidParNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidPrepaidParNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidPrepaidParNumField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM?.description || ""
                        }
                    }

                    CheckBox {
                        id: rfidParPredefinedCheck
                        text: configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED?.label || "Enable Predefined Parameters"
                        checked: config["Communication.RFID_PAR_PREDEFINED"] || false
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked && configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RFID_PAR_PREDEFINED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED?.description || ""
                    }

                    CheckBox {
                        id: rfidParPostdefinedCheck
                        text: configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED?.label || "Enable Postdefined Parameters"
                        checked: config["Communication.RFID_PAR_POSTDEFINED"] || false
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked && configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.RFID_PAR_POSTDEFINED", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked && rfidParPostdefinedCheck.checked && configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM !== undefined
                        enabled: rfidFeatureCheck.checked && mfrc522EnableCheck.checked && rfidParLimitedCheck.checked && rfidParPostdefinedCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.label || "Postpaid Parameter Number"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rfidPostpaidParNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.RFID_POSTPAID_PAR_NUM"] !== undefined ? config["Communication.RFID_POSTPAID_PAR_NUM"].toString() : "1000"
                            validator: IntValidator { bottom: 0; top: 2000 }
                            onEditingFinished: {
                                const value = parseInt(text) || 1000
                                if (value !== config["Communication.RFID_POSTPAID_PAR_NUM"]) {
                                    updateConfig("Communication.RFID_POSTPAID_PAR_NUM", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidPostpaidParNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidPostpaidParNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidPostpaidParNumField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.description || ""
                        }
                    }
                }
            }

            GroupBox {
                title: "RS485 Settings"
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
                    spacing: 100
                    width: parent.width

                    CheckBox {
                        id: rs485FeatureCheck
                        text: configGenerator.schema["Communication"]?.RS485_FEATURE?.label || "Enable RS485"
                        checked: config["Communication.RS485_FEATURE"] || false
                        visible: configGenerator.schema["Communication"]?.RS485_FEATURE !== undefined
                        onClicked: updateConfig("Communication.RS485_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.RS485_FEATURE?.description || ""
                    }
                }
            }

            GroupBox {
                title: "Modem Settings"
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
                    spacing: 15
                    width: parent.width

                    CheckBox {
                        id: modemEnableCheck
                        text: configGenerator.schema["Communication"]?.MODEM_ENABLE?.label || "Enable Modem"
                        checked: config["Communication.MODEM_ENABLE"] || false
                        visible: configGenerator.schema["Communication"]?.MODEM_ENABLE !== undefined
                        onClicked: updateConfig("Communication.MODEM_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.MODEM_ENABLE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: modemEnableCheck.checked && configGenerator.schema["Communication"]?.MODEM_BAUD_RATE !== undefined
                        enabled: modemEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.MODEM_BAUD_RATE?.label || "Modem Baud Rate"
                            font.pixelSize: each16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }
                        TextField {
                            id: modemBaudRateComboNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.MODEM_BAUD_RATE"] !== undefined ? config["Communication.MODEM_BAUD_RATE"].toString() : 5
                            validator: IntValidator { bottom: configGenerator.schema["Communication"]?.MODEM_BAUD_RATE.min; top: configGenerator.schema["Communication"]?.MODEM_BAUD_RATE?.max}
                            onEditingFinished: {
                                const value = parseInt(text) || 1000
                                if (value !== config["Communication.MODEM_BAUD_RATE"]) {
                                    updateConfig("Communication.MODEM_BAUD_RATE", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidPostpaidParNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidPostpaidParNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidPostpaidParNumField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.MODEM_BAUD_RATE?.description || ""
                        }
                       }
                }
            }

            GroupBox {
                title: "GPRS Settings"
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
                    spacing: 100
                    width: parent.width

                    CheckBox {
                        id: gprsFeatureCheck
                        text: configGenerator.schema["Communication"]?.GPRS_FEATURE?.label || "Enable GPRS"
                        checked: config["Communication.GPRS_FEATURE"] || false
                        visible: configGenerator.schema["Communication"]?.GPRS_FEATURE !== undefined
                        onClicked: updateConfig("Communication.GPRS_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.GPRS_FEATURE?.description || ""
                    }

                    CheckBox {
                        id: gprsSendNotificationCheck
                        text: configGenerator.schema["Communication"]?.GPRS_SEND_NOTIFICATION_FEATURE?.label || "Enable Send Notification"
                        checked: config["Communication.GPRS_SEND_NOTIFICATION_FEATURE"] || false
                        visible:gprsFeatureCheck.checked && configGenerator.schema["Communication"]?.GPRS_SEND_NOTIFICATION_FEATURE !== undefined
                        enabled: gprsFeatureCheck.checked && gprsFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.GPRS_SEND_NOTIFICATION_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.GPRS_SEND_NOTIFICATION_FEATURE?.description || ""
                    }

                    CheckBox {
                        id: screenGprsFeatureCheck
                        text: configGenerator.schema["Communication"]?.SCREEN_GPRS_FEATURE?.label || "Enable GPRS Screen Feature"
                        checked: config["Communication.SCREEN_GPRS_FEATURE"] || false
                        visible: gprsFeatureCheck.checked && configGenerator.schema["Communication"]?.SCREEN_GPRS_FEATURE !== undefined
                        enabled: gprsFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.SCREEN_GPRS_FEATURE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.SCREEN_GPRS_FEATURE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: gprsFeatureCheck.checked && configGenerator.schema["Communication"]?.GPRS_DATA_BUFFER_SIZE !== undefined
                        enabled: gprsFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.GPRS_DATA_BUFFER_SIZE?.label || "GPRS Data Buffer Size"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: gprsDataBufferSizeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.GPRS_DATA_BUFFER_SIZE"] !== undefined ? config["Communication.GPRS_DATA_BUFFER_SIZE"].toString() : "1500"
                            validator: IntValidator { bottom: 0; top: 2000 }
                            onEditingFinished: {
                                const value = parseInt(text) || 1500
                                if (value !== config["Communication.GPRS_DATA_BUFFER_SIZE"]) {
                                    updateConfig("Communication.GPRS_DATA_BUFFER_SIZE", value)
                                }
                            }
                            background: Rectangle {
                                color: gprsDataBufferSizeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: gprsDataBufferSizeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: gprsDataBufferSizeField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.GPRS_DATA_BUFFER_SIZE?.description || ""
                        }
                    }

                    CheckBox {
                        id: gprsSrtCardCheck
                        text: configGenerator.schema["Communication"]?.GPRS_SRT_CARD?.label || "Enable SRT Card"
                        checked: config["Communication.GPRS_SRT_CARD"] || false
                        visible: gprsFeatureCheck.checked && configGenerator.schema["Communication"]?.GPRS_SRT_CARD !== undefined
                        enabled: gprsFeatureCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.GPRS_SRT_CARD", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.GPRS_SRT_CARD?.description || ""
                    }
                }
            }

            GroupBox {
                title: "IEC Settings"
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
                    spacing: 15
                    width: parent.width

                    CheckBox {
                        id: iec62056SlaveCheck
                        text: configGenerator.schema["Communication"]?.IEC_62056_21_SLAVE?.label || "Enable IEC 62056-21 Slave"
                        checked: config["Communication.IEC_62056_21_SLAVE"] || false
                        visible: configGenerator.schema["Communication"]?.IEC_62056_21_SLAVE !== undefined
                        onClicked: updateConfig("Communication.IEC_62056_21_SLAVE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.IEC_62056_21_SLAVE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked && configGenerator.schema["Communication"]?.IEC_BUFFER_SIZE !== undefined
                        enabled: iec62056SlaveCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema["Communication"]?.IEC_BUFFER_SIZE?.label || "IEC Buffer Size"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: iecBufferSizeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Communication.IEC_BUFFER_SIZE"] !== undefined ? config["Communication.IEC_BUFFER_SIZE"].toString() : "1056"
                            validator: IntValidator { bottom: 0; top: 2000 }
                            onEditingFinished: {
                                const value = parseInt(text) || 1056
                                if (value !== config["Communication.IEC_BUFFER_SIZE"]) {
                                    updateConfig("Communication.IEC_BUFFER_SIZE", value)
                                }
                            }
                            background: Rectangle {
                                color: iecBufferSizeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: iecBufferSizeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: iecBufferSizeField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema["Communication"]?.IEC_BUFFER_SIZE?.description || ""
                        }
                    }

                    CheckBox {
                        id: iecIsrEnableCheck
                        text: configGenerator.schema["Communication"]?.IEC_62056_21_ISR_ENABLE?.label || "Enable IEC ISR"
                        checked: config["Communication.IEC_62056_21_ISR_ENABLE"] || false
                        visible: iec62056SlaveCheck.checked && configGenerator.schema["Communication"]?.IEC_62056_21_ISR_ENABLE !== undefined
                        enabled: iec62056SlaveCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.IEC_62056_21_ISR_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.IEC_62056_21_ISR_ENABLE?.description || ""
                    }

                    CheckBox {
                        id: opticalDmaEnableCheck
                        text: configGenerator.schema["Communication"]?.OPTICAL_DMA_ENABLE?.label || "Enable Optical DMA"
                        checked: config["Communication.OPTICAL_DMA_ENABLE"] || false
                        visible: iec62056SlaveCheck.checked && configGenerator.schema["Communication"]?.OPTICAL_DMA_ENABLE !== undefined
                        enabled: iec62056SlaveCheck.checked
                        opacity: enabled ? 1.0 : 0.6
                        onClicked: updateConfig("Communication.OPTICAL_DMA_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema["Communication"]?.OPTICAL_DMA_ENABLE?.description || ""
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
        if (key === "Communication.I2C_SPI_ENABLE" && !value) {
            newConfig["Communication.I2C_STATUS"] = configGenerator.schema["Communication"]?.I2C_STATUS?.default || "SEPARATE_I2C"
            newConfig["Communication.HW_SPI"] = configGenerator.schema["Communication"]?.HW_SPI?.default || false
            newConfig["Communication.SW_SPI"] = configGenerator.schema["Communication"]?.SW_SPI?.default || false
        }
        if (key === "Communication.RF_LINK_FEATURE" && !value) {
            newConfig["Communication.RF_LINK_MBUS_DEVICE"] = configGenerator.schema["Communication"]?.RF_LINK_MBUS_DEVICE?.default || "RF_LINK_METER"
            newConfig["Communication.RF_LINK_TI_CC1120_ENABLE"] = configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_ENABLE?.default || false
            newConfig["Communication.RF_LINK_TI_CC1120_PORT"] = configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_PORT?.default || "USART2"
            newConfig["Communication.RF_LINK_TI_CC1120_RESET_POWER"] = configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_RESET_POWER?.default || false
        }
        if (key === "Communication.RF_LINK_TI_CC1120_ENABLE" && !value) {
            newConfig["Communication.RF_LINK_TI_CC1120_PORT"] = configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_PORT?.default || "USART2"
            newConfig["Communication.RF_LINK_TI_CC1120_RESET_POWER"] = configGenerator.schema["Communication"]?.RF_LINK_TI_CC1120_RESET_POWER?.default || false
        }
        if (key === "Communication.RFID_FEATURE" && !value) {
            newConfig["Communication.MFRC522_ENABLE"] = configGenerator.schema["Communication"]?.MFRC522_ENABLE?.default || false
            newConfig["Communication.MFRC522_CARD_TYPE"] = configGenerator.schema["Communication"]?.MFRC522_CARD_TYPE?.default || "MFRC522_CARD_32K"
            newConfig["Communication.MFRC522_CARD_32k_TYPE"] = configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE?.default || "CARD_32k_MASRIA_MTCOS_FLEX_ID"
            newConfig["Communication.MFRC522_INCREASE_SPEED"] = configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED?.default || false
            newConfig["Communication.RFID_SEQ_READ_WRITE"] = configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE?.default || false
            newConfig["Communication.RFID_BUFFER_LEN"] = configGenerator.schema["Communication"]?.RFID_BUFFER_LEN?.default || 2000
            newConfig["Communication.RFID_PAR_LIMITED"] = configGenerator.schema["Communication"]?.RFID_PAR_LIMITED?.default || false
            newConfig["Communication.RFID_PREPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM?.default || 100
            newConfig["Communication.RFID_PAR_PREDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED?.default || false
            newConfig["Communication.RFID_PAR_POSTDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED?.default || false
            newConfig["Communication.RFID_POSTPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.default || 1000
        }
        if (key === "Communication.MFRC522_ENABLE" && !value) {
            newConfig["Communication.MFRC522_CARD_TYPE"] = configGenerator.schema["Communication"]?.MFRC522_CARD_TYPE?.default || "MFRC522_CARD_32K"
            newConfig["Communication.MFRC522_CARD_32k_TYPE"] = configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE?.default || "CARD_32k_MASRIA_MTCOS_FLEX_ID"
            newConfig["Communication.MFRC522_INCREASE_SPEED"] = configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED?.default || false
            newConfig["Communication.RFID_SEQ_READ_WRITE"] = configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE?.default || false
            newConfig["Communication.RFID_BUFFER_LEN"] = configGenerator.schema["Communication"]?.RFID_BUFFER_LEN?.default || 2000
            newConfig["Communication.RFID_PAR_LIMITED"] = configGenerator.schema["Communication"]?.RFID_PAR_LIMITED?.default || false
            newConfig["Communication.RFID_PREPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM?.default || 100
            newConfig["Communication.RFID_PAR_PREDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED?.default || false
            newConfig["Communication.RFID_PAR_POSTDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED?.default || false
            newConfig["Communication.RFID_POSTPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.default || 1000
        }
        if (key === "Communication.MFRC522_CARD_TYPE" && value !== "MFRC522_CARD_32K") {
            newConfig["Communication.MFRC522_CARD_32k_TYPE"] = configGenerator.schema["Communication"]?.MFRC522_CARD_32k_TYPE?.default || null
            newConfig["Communication.MFRC522_INCREASE_SPEED"] = configGenerator.schema["Communication"]?.MFRC522_INCREASE_SPEED?.default || false
            newConfig["Communication.RFID_SEQ_READ_WRITE"] = configGenerator.schema["Communication"]?.RFID_SEQ_READ_WRITE?.default || false
        }
        if (key === "Communication.RFID_PAR_LIMITED" && !value) {
            newConfig["Communication.RFID_PREPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_PREPAID_PAR_NUM?.default || 100
            newConfig["Communication.RFID_PAR_PREDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_PREDEFINED?.default || false
            newConfig["Communication.RFID_PAR_POSTDEFINED"] = configGenerator.schema["Communication"]?.RFID_PAR_POSTDEFINED?.default || false
            newConfig["Communication.RFID_POSTPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.default || 1000
        }
        if (key === "Communication.RFID_PAR_POSTDEFINED" && !value) {
            newConfig["Communication.RFID_POSTPAID_PAR_NUM"] = configGenerator.schema["Communication"]?.RFID_POSTPAID_PAR_NUM?.default || 1000
        }
        if (key === "Communication.GPRS_FEATURE" && !value) {
            newConfig["Communication.GPRS_SEND_NOTIFICATION_FEATURE"] = configGenerator.schema["Communication"]?.GPRS_SEND_NOTIFICATION_FEATURE?.default || false
            newConfig["Communication.SCREEN_GPRS_FEATURE"] = configGenerator.schema["Communication"]?.SCREEN_GPRS_FEATURE?.default || false
            newConfig["Communication.GPRS_DATA_BUFFER_SIZE"] = configGenerator.schema["Communication"]?.GPRS_DATA_BUFFER_SIZE?.default || 1500
            newConfig["Communication.GPRS_SRT_CARD"] = configGenerator.schema["Communication"]?.GPRS_SRT_CARD?.default || false
        }
        if (key === "Communication.MODEM_ENABLE" && !value) {
            newConfig["Communication.MODEM_BAUD_RATE"] = configGenerator.schema["Communication"]?.MODEM_BAUD_RATE?.default || "4800"
        }
        if (key === "Communication.IEC_62056_21_SLAVE" && !value) {
            newConfig["Communication.IEC_BUFFER_SIZE"] = configGenerator.schema["Communication"]?.IEC_BUFFER_SIZE?.default || 1056
            newConfig["Communication.IEC_62056_21_ISR_ENABLE"] = configGenerator.schema["Communication"]?.IEC_62056_21_ISR_ENABLE?.default || false
            newConfig["Communication.OPTICAL_DMA_ENABLE"] = configGenerator.schema["Communication"]?.OPTICAL_DMA_ENABLE?.default || false
        }
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
