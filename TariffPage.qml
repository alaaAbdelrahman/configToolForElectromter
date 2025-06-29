import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property string pageId: "TariffPage_" + Math.random().toString(36).slice(2)
    property var config: {
        if (configGenerator && configGenerator.config) {
            return configGenerator.config
        } else {
            console.warn(pageId, "configGenerator.config is empty, using defaults")
            return {
                "Tariff.TARIFF_SYS": false,
                "Tariff.OPTIMIZATION_TARIFF": false,
                "Tariff.TRF_BP_HISTORY": false,
                "Tariff.TRF_BP_HISTORY_RECORDS": 12,
                "Tariff.TRF_USE_MD_KW": false,
                "Tariff.TRF_USE_MD_A": false,
                "Tariff.PAYMENT_SYS": false,
                "Tariff.PYMT_LOW_TWO_LVL": false,
                "Tariff.PMYT_LVL": 2,
                "Tariff.PMYT_MONY_TRANS": false,
                "Tariff.PMYT_MNY_TRANS_REC": 20,
                "Tariff.PYMT_TAX": false,
                "Tariff.PYMT_FRIENDLY": false,
                "Tariff.PYMT_VACATION_TRF": false
            }
        }
    }
    signal configUpdated(var newConfig)

    background: Rectangle {
        color: "#F5F7FA"
    }

    Component.onCompleted: {
        console.log(pageId, "Initial config:", JSON.stringify(config))
        if (!configGenerator || !configGenerator.schema) {
            console.warn(pageId, "configGenerator or schema not available")
        } else {
            console.log(pageId, "Schema loaded:", JSON.stringify(configGenerator.schema))
        }
    }

    Connections {
        target: configGenerator
        function onConfigChanged() {
            config = configGenerator.config
            console.log(pageId, "Config updated from ConfigGenerator:", JSON.stringify(config))
        }
        function onSchemaChanged() {
            console.log(pageId, "Schema updated:", JSON.stringify(configGenerator.schema))
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 24
        clip: true
        contentWidth: parent.width

        ColumnLayout {
            width: scrollView.width - 48 // Account for margins

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
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.TARIFF_SYS?.label || "Enable Tariff System"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: tariffSysCheck
                            property bool localChecked: config["Tarrif.TARIFF_SYS"] !== undefined ? config["Tarrif.TARIFF_SYS"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.TARIFF_SYS", checked)
                                console.log(pageId, "Updating TARIFF_SYS to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.TARIFF_SYS"] !== undefined ? config["Tarrif.TARIFF_SYS"] : false
                                console.log(pageId, "TARIFF_SYS initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.OPTIMIZATION_TARIFF?.label || "Enable Optimization Tariff"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: optimizationTariffCheck
                            property bool localChecked: config["Tarrif.OPTIMIZATION_TARIFF"] !== undefined ? config["Tarrif.OPTIMIZATION_TARIFF"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.OPTIMIZATION_TARIFF", checked)
                                console.log(pageId, "Updating OPTIMIZATION_TARIFF to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.OPTIMIZATION_TARIFF"] !== undefined ? config["Tarrif.OPTIMIZATION_TARIFF"]: false
                                console.log(pageId, "OPTIMIZATION_TARIFF initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.TRF_BP_HISTORY?.label || "Enable Billing Period History"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: billingHistoryCheck
                            property bool localChecked: config["Tarrif.TRF_BP_HISTORY"] !== undefined ? config["Tarrif.TRF_BP_HISTORY"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.TRF_BP_HISTORY", checked)
                                console.log(pageId, "Updating TRF_BP_HISTORY to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.TRF_BP_HISTORY"] !== undefined ? config["Tarrif.TRF_BP_HISTORY"] : false
                                console.log(pageId, "TRF_BP_HISTORY initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: !!(config["Tarrif.TRF_BP_HISTORY"])

                        Label {
                            text: configGenerator.schema?.Tarrif?.TRF_BP_HISTORY_RECORDS?.label || "Billing History Records"
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
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 14
                            padding: 8
                            text: config["Tarrif.TRF_BP_HISTORY_RECORDS"] !== undefined ? config["Tarrif.TRF_BP_HISTORY_RECORDS"].toString() : "12"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                var value = parseInt(text) || 12
                                if (value !== config["Tarrif.TRF_BP_HISTORY_RECORDS"]) {
                                    updateConfig("Tariff.TRF_BP_HISTORY_RECORDS", value)
                                    console.log(pageId, "Updating TRF_BP_HISTORY_RECORDS to", value)
                                }
                            }
                            background: Rectangle {
                                color: historyRecordsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: historyRecordsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: historyRecordsField.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                console.log(pageId, "TRF_BP_HISTORY_RECORDS initialized to", text)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.TRF_USE_MD_KW?.label || "Record MD of Active Energy"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mdKwCheck
                            property bool localChecked: config["Tarrif.TRF_USE_MD_KW"] !== undefined ? config["Tarrif.TRF_USE_MD_KW"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.TRF_USE_MD_KW", checked)
                                console.log(pageId, "Updating TRF_USE_MD_KW to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.TRF_USE_MD_KW"] !== undefined ? config["Tarrif.TRF_USE_MD_KW"] : false
                                console.log(pageId, "TRF_USE_MD_KW initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.TRF_USE_MD_A?.label || "Record MD of Current"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mdACheck
                            property bool localChecked: config["Tarrif.TRF_USE_MD_A"] !== undefined ? config["Tarrif.TRF_USE_MD_A"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.TRF_USE_MD_A", checked)
                                console.log(pageId, "Updating TRF_USE_MD_A to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.TRF_USE_MD_A"] !== undefined ? config["Tarrif.TRF_USE_MD_A"] : false
                                console.log(pageId, "TRF_USE_MD_A initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PAYMENT_SYS?.label || "Enable Payment System"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: paymentSystemCheck
                            property bool localChecked: config["Tarrif.PAYMENT_SYS"] !== undefined ? config["Tarrif.PAYMENT_SYS"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PAYMENT_SYS", checked)
                                console.log(pageId, "Updating PAYMENT_SYS to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PAYMENT_SYS"] !== undefined ? config["Tarrif.PAYMENT_SYS"] : false
                                console.log(pageId, "PAYMENT_SYS initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PYMT_LOW_TWO_LVL?.label || "Enable Two-Level Low Credit"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: lowTwoLevelCheck
                            property bool localChecked: config["Tarrif.PYMT_LOW_TWO_LVL"] !== undefined ? config["Tarrif.PYMT_LOW_TWO_LVL"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PYMT_LOW_TWO_LVL", checked)
                                if(checked === true)
                                {
                                 updateConfig("Tariff.PMYT_LVL", 2)
                                }else
                                {
                                    updateConfig("Tariff.PMYT_LVL", 1)
                                }

                                console.log(pageId, "Updating PYMT_LOW_TWO_LVL to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PYMT_LOW_TWO_LVL"] !== undefined ? config["Tarrif.PYMT_LOW_TWO_LVL"] : false
                                console.log(pageId, "PYMT_LOW_TWO_LVL initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PMYT_LVL?.label || "Number of Low Credit Levels"
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
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 14
                            padding: 8
                            text: config["Tarrif.PMYT_LVL"] !== undefined ? config["Tarrif.PMYT_LVL"].toString() : "2"
                            validator: IntValidator { bottom: 1; top: 10 }
                            onEditingFinished: {
                                var value = parseInt(text) || 2
                                if (value !== config["Tarrif.PMYT_LVL"]) {
                                    updateConfig("Tariff.PMYT_LVL", value)
                                    console.log(pageId, "Updating PMYT_LVL to", value)
                                }
                            }
                            background: Rectangle {
                                color: lowCreditLevelsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: lowCreditLevelsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: lowCreditLevelsField.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                console.log(pageId, "PMYT_LVL initialized to", text)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PMYT_MONY_TRANS?.label || "Enable Money Transaction Logging"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: moneyTransCheck
                            property bool localChecked: config["Tarrif.PMYT_MONY_TRANS"] !== undefined ? config["Tarrif.PMYT_MONY_TRANS"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PMYT_MONY_TRANS", checked)
                                if(checked === true)
                                {
                                 updateConfig("Tariff.PMYT_MNY_TRANS_REC", 20)
                                }else
                                {
                                    updateConfig("Tariff.PMYT_MNY_TRANS_REC", 0)
                                }
                                console.log(pageId, "Updating PMYT_MONY_TRANS to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PMYT_MONY_TRANS"] !== undefined ? config["Tarrif.PMYT_MONY_TRANS"] : false
                                console.log(pageId, "PMYT_MONY_TRANS initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: configGenerator.schema?.Tarrif?.PMYT_MNY_TRANS
                        Label {
                            text: configGenerator.schema?.Tarrif?.PMYT_MNY_TRANS_REC?.label || "Money Transaction Records"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: moneyTransRecordsField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 14
                            padding: 8
                            text: config["Tarrif.PMYT_MNY_TRANS_REC"] !== undefined ? config["Tarrif.PMYT_MNY_TRANS_REC"].toString() : "20"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                var value = parseInt(text) || 20
                                if (value !== config["Tarrif.PMYT_MNY_TRANS_REC"]) {
                                    updateConfig("Tariff.PMYT_MNY_TRANS_REC", value)
                                    console.log(pageId, "Updating PMYT_MNY_TRANS_REC to", value)
                                }
                            }
                            background: Rectangle {
                                color: moneyTransRecordsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: moneyTransRecordsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: moneyTransRecordsField.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                console.log(pageId, "PMYT_MNY_TRANS_REC initialized to", text)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PYMT_TAX?.label || "Enable Taxes"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: taxesCheck
                            property bool localChecked: config["Tarrif.PYMT_TAX"] !== undefined ? config["Tarrif.PYMT_TAX"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PYMT_TAX", checked)
                                console.log(pageId, "Updating PYMT_TAX to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PYMT_TAX"] !== undefined ? config["Tarrif.PYMT_TAX"] : false
                                console.log(pageId, "PYMT_TAX initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PYMT_FRIENDLY?.label || "Enable Friendly Periods"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: friendlyPeriodsCheck
                            property bool localChecked: config["Tarrif.PYMT_FRIENDLY"] !== undefined ? config["Tarrif.PYMT_FRIENDLY"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PYMT_FRIENDLY", checked)
                                console.log(pageId, "Updating PYMT_FRIENDLY to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PYMT_FRIENDLY"] !== undefined ? config["Tarrif.PYMT_FRIENDLY"] : false
                                console.log(pageId, "PYMT_FRIENDLY initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Tarrif?.PYMT_VACATION_TRF?.label || "Enable Vacation Tariff"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: vacationTariffCheck
                            property bool localChecked: config["Tarrif.PYMT_VACATION_TRF"] !== undefined ? config["Tarrif.PYMT_VACATION_TRF"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Tariff.PYMT_VACATION_TRF", checked)
                                console.log(pageId, "Updating PYMT_VACATION_TRF to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Tarrif.PYMT_VACATION_TRF"] !== undefined ? config["Tarrif.PYMT_VACATION_TRF"] : false
                                console.log(pageId, "PYMT_VACATION_TRF initialized to", localChecked)
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
        console.log(pageId, "Updating config for", key, "with value:", value, "new config:", JSON.stringify(newConfig))
        configUpdated(newConfig)
        config = newConfig
    }
}
