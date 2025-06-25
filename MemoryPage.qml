import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: memoryPage
    property var config: ({
        fileSysUseInt: true,
        fileSysLog: false,
        ctrlEvntLog: false,
        eventLogRecordNum: 0,
        ctrlCfgMeterLog: false,
        cfgMeterRecordNum: 0,
        fm24c128dEeprom: true,
        flashFm25w32: true,
        pymtMonyTrans: false,
        pmytMnyTransRec: 0,
        ctrlRtc: false
    })
    // ctrlSuperCap should be set externally from ControlPage based on batteryType
    // (e.g., via Connections: ctrlSuperCap = (controlPage.config.batteryType !== "super_capacitor" ? 1 : 0))
    signal configUpdated(var newConfig)

    background: Rectangle {
        color: "#F5F7FA"
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 24
        clip: true
        contentWidth: parent.width

        ColumnLayout {
            width: parent.width - 48
            spacing: 24

            // Header
            Label {
                text: "Memory Management Configurations"
                font.bold: true
                font.pixelSize: 18
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            // Logs and Files Section
            Label {
                text: "Logs and Files"
                font.bold: true
                font.pixelSize: 16
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            GroupBox {
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 16

                    CheckBox {
                        id: fileSysUseIntCheck
                        property bool localChecked: config.fileSysUseInt !== undefined ? config.fileSysUseInt : false
                        text: "Use Internal MCU Memory in File System"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("fileSysUseInt", checked)
                        }
                        Component.onCompleted: localChecked = config.fileSysUseInt !== undefined ? config.fileSysUseInt : false
                    }



                    CheckBox {
                        id: ctrlEvntLogCheck
                        property bool localChecked: config.ctrlEvntLog !== undefined ? config.ctrlEvntLog : false
                        text: "Enable Events Logging"
                        checked: localChecked
                        visible: config.batteryType !== "super_capacitor"
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("ctrlEvntLog", checked)
                        }
                        Component.onCompleted: localChecked = config.ctrlEvntLog !== undefined ? config.ctrlEvntLog : false
                    }
                    CheckBox {
                           id: fileSysLogCheck
                           property bool localChecked: config.fileSysLog !== undefined ? config.fileSysLog : false
                           text: "Enable Logging APIs"
                           checked: localChecked
                           enabled: (config.ctrlEvntLog || config.pymtMonyTrans || config.ctrlRtc) || false
                           onCheckedChanged: {
                               localChecked = checked
                               updateConfig("fileSysLog", checked)
                           }
                           Component.onCompleted: localChecked = config.fileSysLog !== undefined ? config.fileSysLog : false
                       }

                    CheckBox {
                        id: ctrlCfgMeterLogCheck
                        property bool localChecked: config.ctrlCfgMeterLog !== undefined ? config.ctrlCfgMeterLog : false
                        text: "Enable Configure Meter Logging"
                        checked: localChecked
                        visible: config.batteryType !== "super_capacitor"
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("ctrlCfgMeterLog", checked)
                        }
                        Component.onCompleted: localChecked = config.ctrlCfgMeterLog !== undefined ? config.ctrlCfgMeterLog : false
                    }


                    RowLayout {
                        visible: (config.ctrlCfgMeterLog  !== undefined ? config.ctrlCfgMeterLog : false) && (config.batteryType !== "super_capacitor")
                        Layout.fillWidth: true
                        spacing: 20
                        Layout.alignment: Qt.AlignHCenter
                        Label {
                            text: "Max Events Log Records:"
                            font.pixelSize: 14
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 180
                            verticalAlignment: Label.AlignVCenter
                        }

                        SpinBox {
                            id: eventLogSpinBox
                            value: config.eventLogRecordNum !== undefined ? config.eventLogRecordNum : 0
                            from: 0
                            to: 402
                            editable: true
                            onValueChanged: updateConfig("eventLogRecordNum", value)
                        }
                    }

                    CheckBox {
                        id: pymtMonyTransCheck
                        property bool localChecked: config.pymtMonyTrans !== undefined ? config.pymtMonyTrans : false
                        text: "Enable Money Transaction Logging"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("pymtMonyTrans", checked)
                        }
                        Component.onCompleted: localChecked = config.pymtMonyTrans !== undefined ? config.pymtMonyTrans : false
                    }

                    RowLayout {
                        visible: (config.pymtMonyTrans !== undefined ? config.pymtMonyTrans :false) && (config.batteryType !== "super_capacitor")
                        Layout.fillWidth: true
                        spacing: 25
                        Layout.alignment: Qt.AlignHCenter
                        Label {
                            text: "Max Money Transaction Records:"
                            font.pixelSize: 14
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 250
                            padding: 20
                            verticalAlignment: Label.AlignVCenter
                        }

                        SpinBox {
                            id: pymtMnyTransSpinBox
                            value: config.pmytMnyTransRec !== undefined ? config.pmytMnyTransRec : 0
                            from: 0
                            to: 20
                            editable: true
                            onValueChanged: updateConfig("pmytMnyTransRec", value)
                        }
                    }




                }
            }

            // Deal with External Memory Section
            Label {
                text: "Deal with External Memory"
                font.bold: true
                font.pixelSize: 16
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            GroupBox {
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 16

                    CheckBox {
                        id: fm24c128dEepromCheck
                        property bool localChecked: config.fm24c128dEeprom !== undefined ? config.fm24c128dEeprom : false
                        text: "Enable FM24C128D 2-Wire Serial EEPROM"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("fm24c128dEeprom", checked)
                        }
                        Component.onCompleted: localChecked = config.fm24c128dEeprom !== undefined ? config.fm24c128dEeprom : false
                    }
                }
            }

            // Flash/EEPROM Section
            Label {
                text: "Flash/EEPROM"
                font.bold: true
                font.pixelSize: 16
                font.family: "Roboto"
                color: "#1A2526"
                Layout.topMargin: 16
                Layout.bottomMargin: 8
            }

            GroupBox {
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 8
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 16

                    CheckBox {
                        id: flashFm25w32Check
                        property bool localChecked: config.flashFm25w32 !== undefined ? config.flashFm25w32 : false
                        text: "Enable Flash FM25W32"
                        checked: localChecked
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig("flashFm25w32", checked)
                        }
                        Component.onCompleted: localChecked = config.flashFm25w32 !== undefined ? config.flashFm25w32 : false
                    }
                }
            }

            // Bottom Spacer
            Item { Layout.fillWidth: true; Layout.preferredHeight: 24 }
        }
    }

    function updateConfig(key, value) {
        var newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value

        // Update fileSysLog based on logging conditions
        newConfig.fileSysLog = (newConfig.ctrlEvntLog || newConfig.pymtMonyTrans || newConfig.ctrlRtc) || false

        // Apply default record numbers based on enable/disable conditions and CTRL_SUPER_CAP
        if (key !== "superCapEnabled" ) {
            if (key === "ctrlEvntLog") newConfig.eventLogRecordNum = newConfig.ctrlEvntLog ? 402 : 0
            else if (key === "ctrlCfgMeterLog") newConfig.cfgMeterRecordNum = newConfig.ctrlCfgMeterLog ? 30 : 0
        } else {
            newConfig.ctrlEvntLog = false
            newConfig.eventLogRecordNum = 0
            newConfig.ctrlCfgMeterLog = false
            newConfig.cfgMeterRecordNum = 0
        }

        // Handle SpinBox values directly, clamping within bounds
        if (key === "eventLogRecordNum" && newConfig.ctrlEvntLog) newConfig.eventLogRecordNum = Math.min(Math.max(value, 0), 402)
        if (key === "cfgMeterRecordNum" && newConfig.ctrlCfgMeterLog) newConfig.cfgMeterRecordNum = Math.min(Math.max(value, 0), 30)
        if (key === "pmytMnyTransRec" && newConfig.pymtMonyTrans) newConfig.pmytMnyTransRec = Math.min(Math.max(value, 0), 20)

        configUpdated(newConfig)
        config = newConfig
    }
}



