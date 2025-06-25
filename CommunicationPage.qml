import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: ({
        i2cStatus: "SEPARATE_I2C",
        spiMode: "HW_SPI",
        rfLinkFeature: false,
        rfLinkMbusDevice: "RF_LINK_METER",
        rfLinkTiCc1120Enabled: false,
        rfLinkTiCc1120Port: "USART2",
        rfLinkTiCc1120ResetPower: false,
        rfidFeature: false,
        rfidEnabled: false,
        rfidCardType: "MFRC522_CARD_32K",
        rfidParLimited: false,
        rfidPrepaidParNum: 100,
        rfidParPredefined: false,
        rfidParPostdefined: false,
        rfidPostpaidParNum: 100,
        rs485Feature: false,
        rs485BaudRate: "Dlms_eBaud9600",
        rs485Itf: 2,
        modemEnable: false,
        modemBaudRate: "5",
        irCom: 13,
        irDefaultBaudRate: "Dlms_eBaud300",
        irNormalBaudRate: "Dlms_eBaud9600",
        irItb: 20,
        gprsFeature: false,
        gprsSendNotification: false,
        gprsScreenFeature: false,
        gprsDataBufferSize: 1500,
        gprsSrtCard: false,
        iec62056Slave: false,
        iecBufferSize: 1056,
        iecBaudRate: "4",
        iecTimeoutSec: 7,
        iecIsrEnable: false,
        opticalDmaEnable: false,
        ipEnable: false,
        ipInactivityTime: 55,
        ipPort: 4059,
        ipCommProfile: "Dlms_eIpTcp"
    })
    signal configUpdated(var newConfig)

    Component.onCompleted: {
        var defaultConfig = {
            i2cStatus: "SEPARATE_I2C",
            spiMode: "HW_SPI",
            rfLinkFeature: false,
            rfLinkMbusDevice: "RF_LINK_METER",
            rfLinkTiCc1120Enabled: false,
            rfLinkTiCc1120Port: "USART2",
            rfLinkTiCc1120ResetPower: false,
            rfidFeature: false,
            rfidEnabled: false,
            rfidCardType: "MFRC522_CARD_32K",
            rfidParLimited: false,
            rfidPrepaidParNum: 100,
            rfidParPredefined: false,
            rfidParPostdefined: false,
            rfidPostpaidParNum: 100,
            rs485Feature: false,
            rs485BaudRate: "Dlms_eBaud9600",
            rs485Itf: 2,
            modemEnable: false,
            modemBaudRate: "5",
            irCom: 13,
            irDefaultBaudRate: "Dlms_eBaud300",
            irNormalBaudRate: "Dlms_eBaud9600",
            irItb: 20,
            gprsFeature: false,
            gprsSendNotification: false,
            gprsScreenFeature: false,
            gprsDataBufferSize: 1500,
            gprsSrtCard: false,
            iec62056Slave: false,
            iecBufferSize: 1056,
            iecBaudRate: "4",
            iecTimeoutSec: 7,
            iecIsrEnable: false,
            opticalDmaEnable: false,
            ipEnable: false,
            ipInactivityTime: 55,
            ipPort: 4059,
            ipCommProfile: "Dlms_eIpTcp"
        }
        for (var key in defaultConfig) {
            if (config[key] === undefined) {
                config[key] = defaultConfig[key]
            }
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
                Layout.topMargin: 16

                Label {
                    text: "Communication Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Roboto"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            // I2C and SPI Settings
            Label {
                text: "I2C and SPI Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["I2C_SPI"]?.i2cSpiEnable?.label || "Enable I2C/SPI Settings:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: i2cSpiEnableCheck
                            checked: config.i2cSpiEnable || false
                            onCheckedChanged: updateConfig("i2cSpiEnable", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: i2cSpiEnableCheck.checked
                        enabled: i2cSpiEnableCheck.checked

                        Label {
                            text: configGenerator.schema["I2C_SPI"]?.i2cStatus?.label || "I2C Status:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: i2cStatusCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["I2C_SPI"]?.i2cStatus?.values || ["SHARED_I2C", "SEPARATE_I2C"]
                            currentIndex: model.indexOf(config.i2cStatus || "SEPARATE_I2C")
                            onActivated: updateConfig("i2cStatus", model[index])
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
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: i2cSpiEnableCheck.checked
                        enabled: i2cSpiEnableCheck.checked

                        Label {
                            text:"SPI Mode:" // configGenerator.schema["spiMode"].label|| "SPI Mode:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: spiModeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["spiMode"]                     //?.spiMode?.values || ["HW_SPI", "SW_SPI"]
                            currentIndex: model.indexOf(config.spiMode || "HW_SPI")
                            onActivated: updateConfig("spiMode", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: spiModeCombo.displayText
                                font: spiModeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: spiModeCombo.width - 20
                            }
                            popup: Popup {
                                y: spiModeCombo.height
                                width: spiModeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: spiModeCombo.popup.visible ? spiModeCombo.delegateModel : null
                                    currentIndex: spiModeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: spiModeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: spiModeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: spiModeCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // RF Link Settings
            Label {
                text: "RF Link Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["RF_Link"]?.rfLinkFeature?.label || "Enable RF Link:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfLinkFeatureCheck
                            checked: config.rfLinkFeature || false
                            onCheckedChanged: updateConfig("rfLinkFeature", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked
                        enabled: rfLinkFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["RF_Link"]?.rfLinkMbusDevice?.label || "RF Link Device:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rfLinkMbusDeviceCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["rfLinkMbusDevice"]  //?.rfLinkMbusDevice?.values || ["RF_LINK_COLLECTOR", "RF_LINK_METER"]
                            currentIndex: model.indexOf(config.rfLinkMbusDevice || "RF_LINK_METER")
                            onActivated: updateConfig("rfLinkMbusDevice", model[index])
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
                                    currentIndex: rfLinkMbusDeviceCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rfLinkMbusDeviceCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfLinkMbusDeviceCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfLinkMbusDeviceCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked
                        enabled: rfLinkFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["RF_Link"]?.rfLinkTiCc1120Enabled?.label || "Enable TI CC1120:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfLinkTiCc1120EnabledCheck
                            checked: config.rfLinkTiCc1120Enabled || false
                            onCheckedChanged: updateConfig("rfLinkTiCc1120Enabled", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnabledCheck.checked
                        enabled: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnabledCheck.checked

                        Label {
                            text: configGenerator.schema["RF_Link"]?.rfLinkTiCc1120Port?.label || "TI CC1120 Port:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rfLinkTiCc1120PortCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["rfLinkTiCc1120Port"]  //?.rfLinkTiCc1120Port?.values || ["USART1", "USART2", "USART3"]
                            currentIndex: model.indexOf(config.rfLinkTiCc1120Port || "USART2")
                            onActivated: updateConfig("rfLinkTiCc1120Port", model[index])
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
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnabledCheck.checked
                        enabled: rfLinkFeatureCheck.checked && rfLinkTiCc1120EnabledCheck.checked

                        Label {
                            text: configGenerator.schema["RF_Link"]?.rfLinkTiCc1120ResetPower?.label || "Enable TI CC1120 Reset Power:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 220
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfLinkTiCc1120ResetPowerCheck
                            checked: config.rfLinkTiCc1120ResetPower || false
                            onCheckedChanged: updateConfig("rfLinkTiCc1120ResetPower", checked)
                        }
                    }
                }
            }

            // RFID Settings
            Label {
                text: "RFID Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidFeature?.label || "Enable RFID Feature:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfidFeatureCheck
                            checked: config.rfidFeature || false
                            onCheckedChanged: updateConfig("rfidFeature", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked
                        enabled: rfidFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidEnabled?.label || "Enable RFID:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfidEnabledCheck
                            checked: config.rfidEnabled || false
                            onCheckedChanged: updateConfig("rfidEnabled", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidCardType?.label || "RFID Card Type:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rfidCardTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["rfidCardType"]   //?.rfidCardType?.values || ["MFRC522_CARD_1K", "MFRC522_CARD_4K", "MFRC522_CARD_32K"]
                            currentIndex: model.indexOf(config.rfidCardType || "MFRC522_CARD_32K")
                            onActivated: updateConfig("rfidCardType", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rfidCardTypeCombo.displayText
                                font: rfidCardTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rfidCardTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: rfidCardTypeCombo.height
                                width: rfidCardTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rfidCardTypeCombo.popup.visible ? rfidCardTypeCombo.delegateModel : null
                                    currentIndex: rfidCardTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rfidCardTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidCardTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidCardTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidParLimited?.label || "Enable Limited Parameters:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfidParLimitedCheck
                            checked: config.rfidParLimited || false
                            onCheckedChanged: updateConfig("rfidParLimited", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidPrepaidParNum?.label || "Prepaid Parameter Number:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rfidPrepaidParNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.rfidPrepaidParNum !== undefined ? config.rfidPrepaidParNum.toString() : "100"
                            validator: IntValidator { bottom: 0; top: 1000 }
                            onEditingFinished: {
                                var value = parseInt(text) || 100
                                if (value !== config.rfidPrepaidParNum) {
                                    updateConfig("rfidPrepaidParNum", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidPrepaidParNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidPrepaidParNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidPrepaidParNumField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidParPredefined?.label || "Enable Predefined Parameters:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfidParPredefinedCheck
                            checked: config.rfidParPredefined || false
                            onCheckedChanged: updateConfig("rfidParPredefined", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidParPostdefined?.label || "Enable Postdefined Parameters:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rfidParPostdefinedCheck
                            checked: config.rfidParPostdefined || false
                            onCheckedChanged: updateConfig("rfidParPostdefined", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked && rfidParPostdefinedCheck.checked
                        enabled: rfidFeatureCheck.checked && rfidEnabledCheck.checked && rfidParLimitedCheck.checked && rfidParPostdefinedCheck.checked

                        Label {
                            text: configGenerator.schema["RFID"]?.rfidPostpaidParNum?.label || "Postpaid Parameter Number:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rfidPostpaidParNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.rfidPostpaidParNum !== undefined ? config.rfidPostpaidParNum.toString() : "100"
                            validator: IntValidator { bottom: 0; top: 1000 }
                            onEditingFinished: {
                                var value = parseInt(text) || 100
                                if (value !== config.rfidPostpaidParNum) {
                                    updateConfig("rfidPostpaidParNum", value)
                                }
                            }
                            background: Rectangle {
                                color: rfidPostpaidParNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rfidPostpaidParNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rfidPostpaidParNumField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // RS485 Settings
            Label {
                text: "RS485 Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["RS485"]?.rs485Feature?.label || "Enable RS485:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: rs485FeatureCheck
                            checked: config.rs485Feature || false
                            onCheckedChanged: updateConfig("rs485Feature", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rs485FeatureCheck.checked
                        enabled: rs485FeatureCheck.checked

                        Label {
                            text: configGenerator.schema["RS485"]?.rs485BaudRate?.label || "RS485 Baud Rate:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rs485BaudRateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["rs485BaudRate"]   //?.rs485BaudRate?.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            currentIndex: model.indexOf(config.rs485BaudRate || "Dlms_eBaud9600")
                            onActivated: updateConfig("rs485BaudRate", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rs485BaudRateCombo.displayText
                                font: rs485BaudRateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rs485BaudRateCombo.width - 20
                            }
                            popup: Popup {
                                y: rs485BaudRateCombo.height
                                width: rs485BaudRateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rs485BaudRateCombo.popup.visible ? rs485BaudRateCombo.delegateModel : null
                                    currentIndex: rs485BaudRateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rs485BaudRateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rs485BaudRateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rs485BaudRateCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: rs485FeatureCheck.checked
                        enabled: rs485FeatureCheck.checked

                        Label {
                            text: configGenerator.schema["RS485"]?.rs485Itf?.label || "RS485 Interface Timeout:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rs485ItfField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.rs485Itf !== undefined ? config.rs485Itf.toString() : "2"
                            validator: IntValidator { bottom: 0; top: 10 }
                            onEditingFinished: {
                                var value = parseInt(text) || 2
                                if (value !== config.rs485Itf) {
                                    updateConfig("rs485Itf", value)
                                }
                            }
                            background: Rectangle {
                                color: rs485ItfField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rs485ItfField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rs485ItfField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // Modem Settings
            Label {
                text: "Modem Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["Modem"]?.modemEnable?.label || "Enable Modem:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: modemEnableCheck
                            checked: config.modemEnable || false
                            onCheckedChanged: updateConfig("modemEnable", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: modemEnableCheck.checked
                        enabled: modemEnableCheck.checked

                        Label {
                            text: configGenerator.schema["Modem"]?.modemBaudRate?.label || "Modem Baud Rate:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: modemBaudRateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["modemBaudRate"]   //?.modemBaudRate?.values || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
                            currentIndex: model.indexOf(config.modemBaudRate || "5")
                            onActivated: updateConfig("modemBaudRate", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: modemBaudRateCombo.displayText
                                font: modemBaudRateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: modemBaudRateCombo.width - 20
                            }
                            popup: Popup {
                                y: modemBaudRateCombo.height
                                width: modemBaudRateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: modemBaudRateCombo.popup.visible ? modemBaudRateCombo.delegateModel : null
                                    currentIndex: modemBaudRateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: modemBaudRateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: modemBaudRateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: modemBaudRateCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // IR Settings
            Label {
                text: "IR Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["IR"]?.irEnable?.label || "Enable IR Settings:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: irEnableCheck
                            checked: config.irEnable || false
                            onCheckedChanged: updateConfig("irEnable", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked
                        enabled: irEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IR"]?.irCom?.label || "IR Com Port:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: irComField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.irCom !== undefined ? config.irCom.toString() : "13"
                            validator: IntValidator { bottom: 0; top: 20 }
                            onEditingFinished: {
                                var value = parseInt(text) || 13
                                if (value !== config.irCom) {
                                    updateConfig("irCom", value)
                                }
                            }
                            background: Rectangle {
                                color: irComField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irComField.focus ? "#007BFF" : "#CED4DA"
                                border.width: irComField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked
                        enabled: irEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IR"]?.irDefaultBaudRate?.label || "IR Default Baud Rate:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: irDefaultBaudRateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["irDefaultBaudRate"]     //?.irDefaultBaudRate?.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            currentIndex: model.indexOf(config.irDefaultBaudRate || "Dlms_eBaud300")
                            onActivated: updateConfig("irDefaultBaudRate", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: irDefaultBaudRateCombo.displayText
                                font: irDefaultBaudRateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: irDefaultBaudRateCombo.width - 20
                            }
                            popup: Popup {
                                y: irDefaultBaudRateCombo.height
                                width: irDefaultBaudRateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: irDefaultBaudRateCombo.popup.visible ? irDefaultBaudRateCombo.delegateModel : null
                                    currentIndex: irDefaultBaudRateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: irDefaultBaudRateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irDefaultBaudRateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: irDefaultBaudRateCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked
                        enabled: irEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IR"]?.irNormalBaudRate?.label || "IR Normal Baud Rate:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: irNormalBaudRateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["irNormalBaudRate"] //?.irNormalBaudRate?.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            currentIndex: model.indexOf(config.irNormalBaudRate || "Dlms_eBaud9600")
                            onActivated: updateConfig("irNormalBaudRate", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: irNormalBaudRateCombo.displayText
                                font: irNormalBaudRateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: irNormalBaudRateCombo.width - 20
                            }
                            popup: Popup {
                                y: irNormalBaudRateCombo.height
                                width: irNormalBaudRateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: irNormalBaudRateCombo.popup.visible ? irNormalBaudRateCombo.delegateModel : null
                                    currentIndex: irNormalBaudRateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: irNormalBaudRateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irNormalBaudRateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: irNormalBaudRateCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked
                        enabled: irEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IR"]?.irItb?.label || "IR Frame Timeout (10ms):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: irItbField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.irItb !== undefined ? config.irItb.toString() : "20"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                var value = parseInt(text) || 20
                                if (value !== config.irItb) {
                                    updateConfig("irItb", value)
                                }
                            }
                            background: Rectangle {
                                color: irItbField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irItbField.focus ? "#007BFF" : "#CED4DA"
                                border.width: irItbField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }
                }
            }

            // GPRS Settings
            Label {
                text: "GPRS Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["GPRS"]?.gprsFeature?.label || "Enable GPRS:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: gprsFeatureCheck
                            checked: config.gprsFeature || false
                            onCheckedChanged: updateConfig("gprsFeature", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: gprsFeatureCheck.checked
                        enabled: gprsFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["GPRS"]?.gprsSendNotification?.label || "Enable Send Notification:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: gprsSendNotificationCheck
                            checked: config.gprsSendNotification || false
                            onCheckedChanged: updateConfig("gprsSendNotification", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: gprsFeatureCheck.checked
                        enabled: gprsFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["GPRS"]?.gprsScreenFeature?.label || "Enable GPRS Screen Feature:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: gprsScreenFeatureCheck
                            checked: config.gprsScreenFeature || false
                            onCheckedChanged: updateConfig("gprsScreenFeature", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: gprsFeatureCheck.checked
                        enabled: gprsFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["GPRS"]?.gprsDataBufferSize?.label || "GPRS Data Buffer Size:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: gprsDataBufferSizeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.gprsDataBufferSize !== undefined ? config.gprsDataBufferSize.toString() : "1500"
                            validator: IntValidator { bottom: 0; top: 2000 }
                            onEditingFinished: {
                                var value = parseInt(text) || 1500
                                if (value !== config.gprsDataBufferSize) {
                                    updateConfig("gprsDataBufferSize", value)
                                }
                            }
                            background: Rectangle {
                                color: gprsDataBufferSizeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: gprsDataBufferSizeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: gprsDataBufferSizeField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: gprsFeatureCheck.checked
                        enabled: gprsFeatureCheck.checked

                        Label {
                            text: configGenerator.schema["GPRS"]?.gprsSrtCard?.label || "Enable SRT Card:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: gprsSrtCardCheck
                            checked: config.gprsSrtCard || false
                            onCheckedChanged: updateConfig("gprsSrtCard", checked)
                        }
                    }
                }
            }

            // IEC Settings
            Label {
                text: "IEC Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["IEC"]?.iec62056Slave?.label || "Enable IEC 62056-21 Slave:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: iec62056SlaveCheck
                            checked: config.iec62056Slave || false
                            onCheckedChanged: updateConfig("iec62056Slave", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked
                        enabled: iec62056SlaveCheck.checked

                        Label {
                            text: configGenerator.schema["IEC"]?.iecBufferSize?.label || "IEC Buffer Size:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: iecBufferSizeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.iecBufferSize !== undefined ? config.iecBufferSize.toString() : "1056"
                            validator: IntValidator { bottom: 0; top: 2000 }
                            onEditingFinished: {
                                var value = parseInt(text) || 1056
                                if (value !== config.iecBufferSize) {
                                    updateConfig("iecBufferSize", value)
                                }
                            }
                            background: Rectangle {
                                color: iecBufferSizeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: iecBufferSizeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: iecBufferSizeField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked
                        enabled: iec62056SlaveCheck.checked

                        Label {
                            text: configGenerator.schema["IEC"]?.iecBaudRate?.label || "IEC Baud Rate:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: iecBaudRateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["iecBaudRate"]    //?.iecBaudRate?.values || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
                            currentIndex: model.indexOf(config.iecBaudRate || "4")
                            onActivated: updateConfig("iecBaudRate", model[index])
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: iecBaudRateCombo.displayText
                                font: iecBaudRateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: iecBaudRateCombo.width - 20
                            }
                            popup: Popup {
                                y: iecBaudRateCombo.height
                                width: iecBaudRateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: iecBaudRateCombo.popup.visible ? iecBaudRateCombo.delegateModel : null
                                    currentIndex: iecBaudRateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: iecBaudRateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: iecBaudRateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: iecBaudRateCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked
                        enabled: iec62056SlaveCheck.checked

                        Label {
                            text: configGenerator.schema["IEC"]?.iecTimeoutSec?.label || "IEC Timeout (sec):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: iecTimeoutSecField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.iecTimeoutSec !== undefined ? config.iecTimeoutSec.toString() : "7"
                            validator: IntValidator { bottom: 0; top: 255 }
                            onEditingFinished: {
                                var value = parseInt(text) || 7
                                if (value !== config.iecTimeoutSec) {
                                    updateConfig("iecTimeoutSec", value)
                                }
                            }
                            background: Rectangle {
                                color: iecTimeoutSecField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: iecTimeoutSecField.focus ? "#007BFF" : "#CED4DA"
                                border.width: iecTimeoutSecField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked
                        enabled: iec62056SlaveCheck.checked

                        Label {
                            text: configGenerator.schema["IEC"]?.iecIsrEnable?.label || "Enable IEC ISR:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: iecIsrEnableCheck
                            checked: config.iecIsrEnable || false
                            onCheckedChanged: updateConfig("iecIsrEnable", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: iec62056SlaveCheck.checked
                        enabled: iec62056SlaveCheck.checked

                        Label {
                            text: configGenerator.schema["IEC"]?.opticalDmaEnable?.label || "Enable Optical DMA:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: opticalDmaEnableCheck
                            checked: config.opticalDmaEnable || false
                            onCheckedChanged: updateConfig("opticalDmaEnable", checked)
                        }
                    }
                }
            }

            // IP Settings
            Label {
                text: "IP Settings"
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

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["IP"]?.ipEnable?.label || "Enable IP Communication:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: ipEnableCheck
                            checked: config.ipEnable || false
                            onCheckedChanged: updateConfig("ipEnable", checked)
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked
                        enabled: ipEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IP"]?.ipInactivityTime?.label || "IP Inactivity Time (sec):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: ipInactivityTimeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.ipInactivityTime !== undefined ? config.ipInactivityTime.toString() : "55"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                var value = parseInt(text) || 55
                                if (value !== config.ipInactivityTime) {
                                    updateConfig("ipInactivityTime", value)
                                }
                            }
                            background: Rectangle {
                                color: ipInactivityTimeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipInactivityTimeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipInactivityTimeField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked
                        enabled: ipEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IP"]?.ipPort?.label || "IP Port:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: ipPortField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.ipPort !== undefined ? config.ipPort.toString() : "4059"
                            validator: IntValidator { bottom: 0; top: 65535 }
                            onEditingFinished: {
                                var value = parseInt(text) || 4059
                                if (value !== config.ipPort) {
                                    updateConfig("ipPort", value)
                                }
                            }
                            background: Rectangle {
                                color: ipPortField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipPortField.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipPortField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 24
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked
                        enabled: ipEnableCheck.checked

                        Label {
                            text: configGenerator.schema["IP"]?.ipCommProfile?.label || "IP Communication Profile:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 200
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: ipCommProfileCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["ipCommProfile"]   //?.ipCommProfile?.values || ["Dlms_eIpTcp", "Dlms_eIpUdp"]
                            currentIndex: (config.ipCommProfile || "Dlms_eIpTcp") === "Dlms_eIpTcp" ? 0 : 1
                            onActivated: {
                                var typeMap = ["Dlms_eIpTcp", "Dlms_eIpUdp"]
                                updateConfig("ipCommProfile", typeMap[index])
                            }
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: ipCommProfileCombo.displayText
                                font: ipCommProfileCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: ipCommProfileCombo.width - 20
                            }
                            popup: Popup {
                                y: ipCommProfileCombo.height
                                width: ipCommProfileCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: ipCommProfileCombo.popup.visible ? ipCommProfileCombo.delegateModel : null
                                    currentIndex: ipCommProfileCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: ipCommProfileCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipCommProfileCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipCommProfileCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
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
        var newConfig = JSON.parse(JSON.stringify(config || {}))
        if (!newConfig) newConfig = {}
        newConfig[key] = value
        if (key === "rfLinkFeature" && !value) {
            newConfig.rfLinkMbusDevice = "RF_LINK_METER"
            newConfig.rfLinkTiCc1120Enabled = false
            newConfig.rfLinkTiCc1120Port = "USART2"
            newConfig.rfLinkTiCc1120ResetPower = false
        }
        if (key === "rfLinkTiCc1120Enabled" && !value) {
            newConfig.rfLinkTiCc1120Port = "USART2"
            newConfig.rfLinkTiCc1120ResetPower = false
        }
        if (key === "rfidFeature" && !value) {
            newConfig.rfidEnabled = false
            newConfig.rfidCardType = "MFRC522_CARD_32K"
            newConfig.rfidParLimited = false
            newConfig.rfidPrepaidParNum = 100
            newConfig.rfidParPredefined = false
            newConfig.rfidParPostdefined = false
            newConfig.rfidPostpaidParNum = 100
        }
        if (key === "rfidEnabled" && !value) {
            newConfig.rfidCardType = "MFRC522_CARD_32K"
            newConfig.rfidParLimited = false
            newConfig.rfidPrepaidParNum = 100
            newConfig.rfidParPredefined = false
            newConfig.rfidParPostdefined = false
            newConfig.rfidPostpaidParNum = 100
        }
        if (key === "rfidParLimited" && !value) {
            newConfig.rfidPrepaidParNum = 100
            newConfig.rfidParPredefined = false
            newConfig.rfidParPostdefined = false
            newConfig.rfidPostpaidParNum = 100
        }
        if (key === "rfidParPostdefined" && !value) {
            newConfig.rfidPostpaidParNum = 100
        }
        if (key === "rfidParPostdefined" && value) {
            newConfig.rfidPostpaidParNum = 1000
        }
        if (key === "iec62056Slave" && !value) {
            newConfig.iecBufferSize = 1056
            newConfig.iecBaudRate = "4"
            newConfig.iecTimeoutSec = 7
            newConfig.iecIsrEnable = false
            newConfig.opticalDmaEnable = false
        }
        if (key === "gprsFeature" && !value) {
            newConfig.gprsSendNotification = false
            newConfig.gprsScreenFeature = false
            newConfig.gprsDataBufferSize = 1500
            newConfig.gprsSrtCard = false
        }
        if (key === "ipEnable" && !value) {
            newConfig.ipInactivityTime = 55
            newConfig.ipPort = 4059
            newConfig.ipCommProfile = "Dlms_eIpTcp"
        }
        configUpdated(newConfig)
        config = newConfig
    }
}
