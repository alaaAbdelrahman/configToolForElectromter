import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: ({
        meterType: "singlePhase",
        directMeasurement: true,
        numOfPhases: 1,
        numOfChannels: 2,
        meteringChips: ["V9381"], // Ensure initial array
        pulseConstant: "CONSTANT_3200",
        loadProfile: true,
        profileRecordNum: 3360,
        profileTestRecords: 20,
        reverseTamper: true,
        earthTamper: true,
        enableLimiter: true,
        mismatchNeutral: false,
        pulseCountEnable: true,
        sagZxtoFlags: true,
        tariffType: "Single",
        tariffRate: "Standard",
        enableTariffSwitching: false,
        maxTariffLevels: 2,
        optimizationTariff: true,
        billingHistory: true,
        historyRecords: 12,
        mdKw: true,
        mdKva: true,
        mdA: true,
        paymentSystem: true,
        lowCreditLevels: 2,
        moneyTransRecords: 20,
        enableTaxes: true,
        friendlyPeriods: true,
        vacationTariff: true,
        gracePeriod: true,
        pymtMonyTrans: false,
        ctrlCfgMeterLog: false
    })
    signal configUpdated(var newConfig)

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
            width: parent.width

            // Tariff Configuration Group
            Label {
                text: "Tariff Configuration"
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
                padding: 20
                spacing: 20

                background: Rectangle {
                    color: "#FFFFFF"
                    radius: 4
                    border.color: "#E4E7EB"
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 20
                    width: parent.width - 40
                    Layout.alignment: Qt.AlignHCenter

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Tariff Optimization:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: optimizationTariffCheck
                            property bool localChecked: config.optimizationTariff !== undefined ? config.optimizationTariff : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("optimizationTariff", checked)
                            }
                            Component.onCompleted: localChecked = config.optimizationTariff !== undefined ? config.optimizationTariff : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Billing History:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: billingHistoryCheck
                            property bool localChecked: config.billingHistory !== undefined ? config.billingHistory : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("billingHistory", checked)
                            }
                            Component.onCompleted: localChecked = config.billingHistory !== undefined ? config.billingHistory : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: config.billingHistory

                        Label {
                            text: "History Records:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: historyRecordsField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            Layout.alignment: Qt.AlignRight // Shift to the right
                            font.pixelSize: 14
                            padding: 8
                            text: config.historyRecords !== undefined ? config.historyRecords.toString() : "12"
                            validator: IntValidator { bottom: 0; top: 12 }
                            onEditingFinished: {
                                var value = parseInt(text) || 12
                                if (value !== config.historyRecords) {
                                    updateConfig("historyRecords", value)
                                }
                            }
                            background: Rectangle {
                                color: historyRecordsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: historyRecordsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: historyRecordsField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Record MD (kW):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mdKwCheck
                            property bool localChecked: config.mdKw !== undefined ? config.mdKw : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("mdKw", checked)
                            }
                            Component.onCompleted: localChecked = config.mdKw !== undefined ? config.mdKw : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Record MD (kVA):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mdKvaCheck
                            property bool localChecked: config.mdKva !== undefined ? config.mdKva : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("mdKva", checked)
                            }
                            Component.onCompleted: localChecked = config.mdKva !== undefined ? config.mdKva : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Record MD (A):"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mdACheck
                            property bool localChecked: config.mdA !== undefined ? config.mdA : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("mdA", checked)
                            }
                            Component.onCompleted: localChecked = config.mdA !== undefined ? config.mdA : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Payment System:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: paymentSystemCheck
                            property bool localChecked: config.paymentSystem !== undefined ? config.paymentSystem : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("paymentSystem", checked)
                            }
                            Component.onCompleted: localChecked = config.paymentSystem !== undefined ? config.paymentSystem : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Low Credit Levels:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: lowCreditLevelsField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            Layout.alignment: Qt.AlignRight // Shift to the right
                            font.pixelSize: 14
                            padding: 8
                            text: config.lowCreditLevels !== undefined ? config.lowCreditLevels.toString() : "2"
                            validator: IntValidator { bottom: 1; top: 2 }
                            onEditingFinished: {
                                var value = parseInt(text) || 2
                                if (value !== config.lowCreditLevels) {
                                    updateConfig("lowCreditLevels", value)
                                }
                            }
                            background: Rectangle {
                                color: lowCreditLevelsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: lowCreditLevelsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: lowCreditLevelsField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }



                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Enable Taxes:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: taxesCheck
                            property bool localChecked: config.enableTaxes !== undefined ? config.enableTaxes : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("enableTaxes", checked)
                            }
                            Component.onCompleted: localChecked = config.enableTaxes !== undefined ? config.enableTaxes : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Friendly Periods:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: friendlyPeriodsCheck
                            property bool localChecked: config.friendlyPeriods !== undefined ? config.friendlyPeriods : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("friendlyPeriods", checked)
                            }
                            Component.onCompleted: localChecked = config.friendlyPeriods !== undefined ? config.friendlyPeriods : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Vacation Tariff:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: vacationTariffCheck
                            property bool localChecked: config.vacationTariff !== undefined ? config.vacationTariff : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("vacationTariff", checked)
                            }
                            Component.onCompleted: localChecked = config.vacationTariff !== undefined ? config.vacationTariff : true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "48-Hour Grace Period:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: gracePeriodCheck
                            property bool localChecked: config.gracePeriod !== undefined ? config.gracePeriod : true
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("gracePeriod", checked)
                            }
                            Component.onCompleted: localChecked = config.gracePeriod !== undefined ? config.gracePeriod : true
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
        var newConfig = JSON.parse(JSON.stringify(config || {}))
        if (!newConfig) newConfig = {}
        newConfig[key] = value
        // Update dependent fields
        if (key === "meterType") {
            if (value === "singlePhase") {
                newConfig.numOfPhases = 1
                newConfig.numOfChannels = 2
            } else if (value === "twoPhase") {
                newConfig.numOfPhases = 2
                newConfig.numOfChannels = 2
            } else { // threePhase
                newConfig.numOfPhases = 3
                newConfig.numOfChannels = 3
            }
        } else if (key === "directMeasurement" && newConfig.meterType === "threePhase") {
            // No additional dependencies, just update
        } else if (key === "meteringChips") {
            // Ensure value is an array
            newConfig.meteringChips = Array.isArray(value) ? value : [value]
            if (!newConfig.meteringChips || newConfig.meteringChips.length === 0) {
                newConfig.meteringChips = ["V9381"] // Default fallback
            }
        }
        configUpdated(newConfig)
        config = newConfig
    }

    function updateChipSelection(chip: string, add: bool){
        var chips = Array.isArray(config.meteringChips) ? [...config.meteringChips] : ["V9381"]
        if (add && !chips.includes(chip)) {
            chips.push(chip)
        } else if (!add && chips.includes(chip)) {
            chips = chips.filter(c => c !== chip)
        }
        return chips.length > 0 ? chips : ["V9381"] // Default to V9381 if no chips selected
    }
}
