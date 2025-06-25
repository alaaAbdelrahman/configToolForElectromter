import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    // Default config in QML as a fallback
    property var config: ({
        dlmsEnabled: false,
        protocolLayers: "HDLC_DLMS",
        gprsChannel: 1,
        sagSwellValueType: "PERCENTAGE",
        tenderType: "Meter_Direct",
        activityCalendar: false,
        calendarManager: false,
        registerActivation: false,
        specialDays: false,
        tariffRegisters: false,
        powerQuality: false,
        newLimiter: false,
        eventLog: false,
        eventNotification: false,
        loadLimitPlan: false,
        profileDlms: false,
        tamperDlms: false
    })
    signal configUpdated(var newConfig)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        Label {
            text: "DLMS Configuration"
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        GroupBox {
            Layout.fillWidth: true
            title: "Protocol Settings"

            ColumnLayout {
                width: parent.width
                spacing: 10

                CheckBox {
                    id: dlmsEnabledCheck
                    property bool localChecked: config.dlmsEnabled || false
                    text: "Enable DLMS"
                    checked: localChecked
                    onCheckedChanged: {
                        localChecked = checked
                        updateConfig("dlmsEnabled", checked)
                    }
                    Component.onCompleted: localChecked = config.dlmsEnabled || false
                }

                ComboBox {
                    Layout.fillWidth: true
                    model: ["HDLC_DLMS", "IEC_62056_21"]
                    currentIndex: (config.protocolLayers || "HDLC_DLMS") === "HDLC_DLMS" ? 0 : 1
                    onActivated: function(index) {
                        var typeMap = ["HDLC_DLMS", "IEC_62056_21"]
                        updateConfig("protocolLayers", typeMap[index])
                    }
                    enabled: config.dlmsEnabled || false
                }
                GroupBox
                {
                    title: "GPRS Channel"
                    SpinBox {
                        Layout.fillWidth: true
                        from: 1
                        to: 4
                        value: config.gprsChannel || 1
                        onValueChanged: updateConfig("gprsChannel", value)
                        enabled: config.dlmsEnabled || false
                    }
                }

                ComboBox {
                    Layout.fillWidth: true
                    model: ["PERCENTAGE", "RAW"]
                    currentIndex: (config.sagSwellValueType || "PERCENTAGE") === "PERCENTAGE" ? 0 : 1
                    onActivated: function(index) {
                        var typeMap = ["PERCENTAGE", "RAW"]
                        updateConfig("sagSwellValueType", typeMap[index])
                    }
                    enabled: config.dlmsEnabled || false
                }

                ComboBox {
                    Layout.fillWidth: true
                    model: ["Meter_Direct", "Meter_CT"]
                    currentIndex: (config.tenderType || "Meter_Direct") === "Meter_Direct" ? 0 : 1
                    onActivated: function(index) {
                        var typeMap = ["Meter_Direct", "Meter_CT"]
                        updateConfig("tenderType", typeMap[index])
                    }
                    enabled: config.dlmsEnabled || false
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            title: "DLMS Application Features"

            ColumnLayout {
                width: parent.width
                spacing: 10

                Repeater {
                    model: [
                        { key: "activityCalendar", label: "Activity Calendar" },
                        { key: "calendarManager", label: "Calendar Manager" },
                        { key: "registerActivation", label: "Register Activation" },
                        { key: "specialDays", label: "Special Days" },
                        { key: "tariffRegisters", label: "Tariff Registers" },
                        { key: "powerQuality", label: "Power Quality" },
                        { key: "newLimiter", label: "New Limiter" },
                        { key: "eventLog", label: "Event Log" },
                        { key: "eventNotification", label: "Event Notification" },
                        { key: "loadLimitPlan", label: "Load Limit Plan" },
                        { key: "profileDlms", label: "Profile DLMS" },
                        { key: "tamperDlms", label: "Tamper DLMS" }
                    ]

                    delegate: CheckBox {
                        id: featureCheck
                        property bool localChecked: config[modelData.key] || false
                        text: modelData.label
                        checked: localChecked
                        enabled: config.dlmsEnabled || false
                        onCheckedChanged: {
                            localChecked = checked
                            updateConfig(modelData.key, checked)
                        }
                        Component.onCompleted: localChecked = config[modelData.key] || false
                    }
                }
            }
        }
    }

    function updateConfig(key, value) {
        var newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value
        // Reset dependent fields if DLMS is disabled
        if (key === "dlmsEnabled" && !value) {
            newConfig.protocolLayers = "HDLC_DLMS"
            newConfig.gprsChannel = 1
            newConfig.sagSwellValueType = "PERCENTAGE"
            newConfig.tenderType = "Meter_Direct"
            newConfig.activityCalendar = false
            newConfig.calendarManager = false
            newConfig.registerActivation = false
            newConfig.specialDays = false
            newConfig.tariffRegisters = false
            newConfig.powerQuality = false
            newConfig.newLimiter = false
            newConfig.eventLog = false
            newConfig.eventNotification = false
            newConfig.loadLimitPlan = false
            newConfig.profileDlms = false
            newConfig.tamperDlms = false
        }
        configUpdated(newConfig)
        // Update local config to reflect changes
        config = newConfig
    }
}
