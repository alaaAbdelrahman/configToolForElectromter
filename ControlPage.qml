import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: ({
        rfidBoardPinEnabled: true,
        powerFailPinFeature: true,
        batteryType: "non_chargeable",
        magneticSwitchEnabled: false,
        magneticSensorEnabled: false,
        gprsModuleCoverSwitch: true,
        coverSwitch: true,
        terminalSwitch: true,
        upSwitch: true,
        downSwitch: true,
        actionsEnabled: true,
        relayControl: true,
        tamperLedControl: true,
        lowCreditLedControl: true,
        buzzerEnabled: true,
        acBuzzer: true,
        alarmIconControl: true,
      keypadFeature: true,
      touchKeypad: true,
      rubberKeypad: false
    })
    signal configUpdated(var newConfig)

    Component.onCompleted: {
        console.log("ControlPage config at load:", JSON.stringify(config))
    }

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

               Label {
                   text: "Control Configurations"
                   font.bold: true
                   font.pixelSize: 20
                   font.family: "Roboto"
                   color: "#1A2526"
                   Layout.topMargin: 16
                   Layout.bottomMargin: 12
               }

               // Pins Section
               GroupBox {
                   Layout.fillWidth: true
                   background: Rectangle {
                       color: "#FFFFFF"
                       radius: 8
                       border.color: "#E0E5E8"
                       border.width: 1
                   }
                   padding: 16

                   ColumnLayout {
                       width: parent.width
                       spacing: 12

                       Label {
                           text: "Control Pins"
                           font.bold: true
                           font.pixelSize: 16
                           color: "#1A2526"
                       }

                       CheckBox {
                           text: "Enable RFID Board Pin"
                           checked: config.rfidBoardPinEnabled || false
                           onCheckedChanged: updateConfig("rfidBoardPinEnabled", checked)
                       }
                       CheckBox {
                           text: "Power Fail Pin Feature"
                           checked: config.powerFailPinFeature || false
                           onCheckedChanged: updateConfig("powerFailPinFeature", checked)
                       }
                       CheckBox {
                           text: "GPRS Module Cover Switch"
                           checked: config.gprsModuleCoverSwitch || false
                           onCheckedChanged: updateConfig("gprsModuleCoverSwitch", checked)
                       }
                       CheckBox {
                           text: "Cover Switch"
                           checked: config.coverSwitch || false
                           onCheckedChanged: updateConfig("coverSwitch", checked)
                       }
                       CheckBox {
                           text: "Terminal Switch"
                           checked: config.terminalSwitch || false
                           onCheckedChanged: updateConfig("terminalSwitch", checked)
                       }
                       CheckBox {
                           text: "Up Switch"
                           checked: config.upSwitch || false
                           onCheckedChanged: updateConfig("upSwitch", checked)
                       }
                       CheckBox {
                           text: "Down Switch"
                           checked: config.downSwitch || false
                           onCheckedChanged: updateConfig("downSwitch", checked)
                       }

                       GroupBox {
                           title: "Detection Method"
                           Layout.fillWidth: true
                           background: Rectangle {
                               color: "#FFFFFF"
                               radius: 6
                               border.color: "#E0E5E8"
                               border.width: 1
                           }
                           padding: 10

                           RowLayout {
                               width: parent.width
                               spacing: 16

                               CheckBox {
                                   text: "Magnetic Switch Detection"
                                   checked: config.magneticSwitchEnabled || false
                                   onCheckedChanged: updateConfig("magneticSwitchEnabled", checked)
                               }
                               CheckBox {
                                   text: "Magnetic Sensor Detection"
                                   checked: config.magneticSensorEnabled || false
                                   onCheckedChanged: updateConfig("magneticSensorEnabled", checked)
                               }
                           }
                       }
                   }
               }

               // Actions Section
               GroupBox {
                   Layout.fillWidth: true
                   background: Rectangle {
                       color: "#FFFFFF"
                       radius: 8
                       border.color: "#E0E5E8"
                       border.width: 1
                   }
                   padding: 16

                   ColumnLayout {
                       width: parent.width
                       spacing: 12

                       Label {
                           text: "Action Controls"
                           font.bold: true
                           font.pixelSize: 16
                           color: "#1A2526"
                       }

                       CheckBox {
                           id: actionsEnabledCheck
                           text: "Enable Actions"
                           checked: config.actionsEnabled || false
                           onCheckedChanged: updateConfig("actionsEnabled", checked)
                       }

                       CheckBox {
                           visible: actionsEnabledCheck.checked
                           text: "Relay Control"
                           enabled: actionsEnabledCheck.checked
                           checked: config.relayControl || false
                           onCheckedChanged: updateConfig("relayControl", checked)
                       }
                       CheckBox {
                           visible: actionsEnabledCheck.checked
                           text: "Tamper LED Control"
                           enabled: actionsEnabledCheck.checked
                           checked: config.tamperLedControl || false
                           onCheckedChanged: updateConfig("tamperLedControl", checked)
                       }
                       CheckBox {
                           visible: actionsEnabledCheck.checked
                           text: "Low Credit LED Control"
                           enabled: actionsEnabledCheck.checked
                           checked: config.lowCreditLedControl || false
                           onCheckedChanged: updateConfig("lowCreditLedControl", checked)
                       }
                       CheckBox {
                           id: buzzerEnabledCheck
                           visible: actionsEnabledCheck.checked
                           text: "Buzzer Enabled"
                           enabled: actionsEnabledCheck.checked
                           checked: config.buzzerEnabled || false
                           onCheckedChanged: updateConfig("buzzerEnabled", checked)
                       }
                       CheckBox {
                           visible: actionsEnabledCheck.checked && buzzerEnabledCheck.checked
                           text: "AC Buzzer"
                           enabled: actionsEnabledCheck.checked && buzzerEnabledCheck.checked
                           checked: config.acBuzzer || false
                           onCheckedChanged: updateConfig("acBuzzer", checked)
                       }
                       CheckBox {
                           visible: actionsEnabledCheck.checked
                           text: "Alarm Icon Control"
                           enabled: actionsEnabledCheck.checked
                           checked: config.alarmIconControl || false
                           onCheckedChanged: updateConfig("alarmIconControl", checked)
                       }
                       CheckBox {
                         id: ctrlRtcCheck
                         property bool localChecked: config.ctrlRtc !== undefined ? config.ctrlRtc : false
                         text: "Enable RTC"
                         checked: localChecked
                         visible: config.batteryType !== "super_capacitor"
                         onCheckedChanged: {
                             localChecked = checked
                             updateConfig("ctrlRtc", checked)
                         }
                         Component.onCompleted: localChecked = config.ctrlRtc !== undefined ? config.ctrlRtc : false
                        }
                     }
               }
                       Label {
                           text: "Keypad System"
                           font.bold: true
                           font.pixelSize: 16
                           color: "#1A2526"
                           Layout.topMargin: 12
                       }

                       GroupBox {
                           Layout.fillWidth: true
                           title: "Keypad Settings"
                           background: Rectangle {
                               color: "#FFFFFF"
                               radius: 6
                               border.color: "#E0E5E8"
                               border.width: 1
                           }
                           padding: 10

                           ColumnLayout {
                               width: parent.width
                               spacing: 8

                               CheckBox {
                                   id: keypadFeatureCheck
                                   property bool localChecked: config.keypadFeature || false
                                   text: "Enable Keypad Feature"
                                   checked: localChecked
                                   onCheckedChanged: {
                                       localChecked = checked
                                       updateConfig("keypadFeature", checked)
                                   }
                                   Component.onCompleted: localChecked = config.keypadFeature || false
                               }

                               CheckBox {
                                   id: touchKeypadCheck
                                   property bool localChecked: config.touchKeypad || false
                                   text: "Enable Touch Keypad"
                                   visible: keypadFeatureCheck.checked
                                   checked: localChecked
                                   onCheckedChanged: {
                                       localChecked = checked
                                       updateConfig("touchKeypad", checked)
                                   }
                                   Component.onCompleted: localChecked = config.touchKeypad || false
                               }

                               CheckBox {
                                   id: rubberKeypadCheck
                                   property bool localChecked: config.rubberKeypad || false
                                   text: "Enable Rubber Keypad"
                                   visible: keypadFeatureCheck.checked
                                   checked: localChecked
                                   onCheckedChanged: {
                                       localChecked = checked
                                       updateConfig("rubberKeypad", checked)
                                   }
                                   Component.onCompleted: localChecked = config.rubberKeypad || false
                               }
                           }
}


               // Application Section
               GroupBox {
                   Layout.fillWidth: true
                   background: Rectangle {
                       color: "#FFFFFF"
                       radius: 8
                       border.color: "#E0E5E8"
                       border.width: 1
                   }
                   padding: 16

                   ColumnLayout {
                       width: parent.width
                       spacing: 12

                       Label {
                           text: "Application"
                           font.bold: true
                           font.pixelSize: 16
                           color: "#1A2526"
                       }

                       Label {
                           text: "Battery Type:"
                           font.pixelSize: 14
                       }
                       ComboBox {
                           Layout.fillWidth: true
                           model: ["Non-chargeable Battery", "Chargeable Battery", "Super Capacitor"]
                           currentIndex: {
                               switch (config.batteryType || "non_chargeable") {
                                   case "non_chargeable": return 0
                                   case "chargeable": return 1
                                   case "super_capacitor": return 2
                                   default: return 0
                               }
                           }
                           onActivated: function(index) {
                               const types = ["non_chargeable", "chargeable", "super_capacitor"]
                               updateConfig("batteryType", types[index])
                           }
                       }
                   }
               }

               Item { Layout.fillWidth: true; Layout.preferredHeight: 32 }
           }
       }


    function updateConfig(key, value) {
        var newConfig = JSON.parse(JSON.stringify(config))
        newConfig[key] = value

        if (key === "batteryType") {
            newConfig.hasBattery = undefined
            newConfig.superCapEnabled = undefined
        }

        if (key === "magneticSwitchEnabled" && value) newConfig.magneticSensorEnabled = false
        else if (key === "magneticSensorEnabled" && value) newConfig.magneticSwitchEnabled = false

        if (key === "actionsEnabled" && !value) {
            newConfig.relayControl = false
            newConfig.tamperLedControl = false
            newConfig.lowCreditLedControl = false
            newConfig.buzzerEnabled = false
            newConfig.acBuzzer = false
            newConfig.alarmIconControl = false
            newConfig.touchKeypadEnabled = false
        }

        if (key === "buzzerEnabled" && !value) newConfig.acBuzzer = false

        // Reset dependent fields
        if (key === "keypadFeature" && !value) {
            newConfig.touchKeypad = false
            newConfig.rubberKeypad = false
        }
        if (key === "touchKeypad" && value) {
            newConfig.rubberKeypad = false
        }
        if (key === "rubberKeypad" && value) {
            newConfig.touchKeypad = false
        }
        configUpdated(newConfig)
        config = newConfig
    }
}
