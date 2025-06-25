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
        sagZxtoFlags: true
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
                    text: "Metering Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Roboto"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            // Meter Type Group
            Label {
                text: "Meter Type"
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
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Meter Type:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: meterTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: {
                                let schemaValues = configGenerator.schema["Metering"]?.meterType?.values || ["singlePhase", "twoPhase", "threePhase"]
                                return schemaValues.map(v => v.charAt(0).toUpperCase() + v.slice(1).replace(/([A-Z])/g, ' $1'))
                            }

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: meterTypeCombo.displayText
                                font: meterTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: meterTypeCombo.width - 20
                            }

                            popup: Popup {
                                y: meterTypeCombo.height
                                width: meterTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: meterTypeCombo.popup.visible ? meterTypeCombo.delegateModel : null
                                    currentIndex: meterTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: meterTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: meterTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: meterTypeCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = model.map(v => v.toLowerCase().replace(/\s/g, ''))
                                const current = config.meterType || "singlePhase"
                                currentIndex = options.indexOf(current)
                            }

                            onActivated: function(index) {
                                const typeMap = model.map(v => v.toLowerCase().replace(/\s/g, ''))
                                updateConfig("meterType", typeMap[index])
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        visible: config.meterType === "threePhase"

                        Label {
                            text: "Measurement Type:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: measurementTypeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: ["Direct", "Indirect"]
                            currentIndex: config.directMeasurement ? 0 : 1
                            onActivated: function(index) {
                                var typeMap = [true, false]
                                updateConfig("directMeasurement", typeMap[index])
                            }
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: measurementTypeCombo.displayText
                                font: measurementTypeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: measurementTypeCombo.width - 20
                            }
                            popup: Popup {
                                y: measurementTypeCombo.height
                                width: measurementTypeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: measurementTypeCombo.popup.visible ? measurementTypeCombo.delegateModel : null
                                    currentIndex: measurementTypeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: measurementTypeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: measurementTypeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: measurementTypeCombo.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Number of Phases:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        Label {
                            text: "" + (config.numOfPhases || 1)
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Number of Channels:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        Label {
                            text: "" + (config.numOfChannels || 2)
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // Metering Chip Group
            Label {
                text: "Metering Chip"
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
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Select Chips:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: configGenerator.schema["meteringChips"]
                                delegate: CheckBox {
                                    text: modelData
                                    property bool localChecked: Array.isArray(config.meteringChips) && config.meteringChips.includes(modelData)
                                    checked: localChecked
                                    onCheckedChanged: {
                                        if (checked !== localChecked) {
                                            localChecked = checked
                                            updateConfig("meteringChips", updateChipSelection(modelData, checked))
                                        }
                                    }
                                    Component.onCompleted: localChecked = Array.isArray(config.meteringChips) && config.meteringChips.includes(modelData)
                                }
                            }
                        }
                    }
                }
            }

            // Constants Pulses per Watt Group
            Label {
                text: "Constants Pulses per Watt"
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
                        spacing: 12
                        Layout.fillWidth: true

                        Label {
                            text: "Pulse Constant:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: pulseConstantCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema["pulseConstant"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: pulseConstantCombo.displayText
                                font: pulseConstantCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: pulseConstantCombo.width - 20
                            }

                            popup: Popup {
                                y: pulseConstantCombo.height
                                width: pulseConstantCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: pulseConstantCombo.popup.visible ? pulseConstantCombo.delegateModel : null
                                    currentIndex: pulseConstantCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: pulseConstantCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: pulseConstantCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: pulseConstantCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const options = model
                                const current = config.pulseConstant || "CONSTANT_3200"
                                currentIndex = options.indexOf(current)
                            }

                            onActivated: function(index) {
                                const typeMap = model
                                updateConfig("pulseConstant", typeMap[index])
                            }
                        }
                    }
                }
            }

            // Metering Features Group
            Label {
                text: "Metering Features"
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
                            text: "Load Profile:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: loadProfileCheck
                            property bool localChecked: config.loadProfile !== undefined ? config.loadProfile : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("loadProfile", checked)
                            }
                            Component.onCompleted: localChecked = config.loadProfile !== undefined ? config.loadProfile : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: config.loadProfile

                        Label {
                            text: "Profile Record Number:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: profileRecordNumField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.profileRecordNum !== undefined ? config.profileRecordNum.toString() : "3360"
                            validator: IntValidator { bottom: 0; top: 9999 }
                            onEditingFinished: {
                                var value = parseInt(text) || 3360
                                if (value !== config.profileRecordNum) {
                                    updateConfig("profileRecordNum", value)
                                }
                            }
                            background: Rectangle {
                                color: profileRecordNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: profileRecordNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: profileRecordNumField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: config.loadProfile

                        Label {
                            text: "Profile Test Records:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: profileTestRecordsField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config.profileTestRecords !== undefined ? config.profileTestRecords.toString() : "20"
                            validator: IntValidator { bottom: 0; top: 999 }
                            onEditingFinished: {
                                var value = parseInt(text) || 20
                                if (value !== config.profileTestRecords) {
                                    updateConfig("profileTestRecords", value)
                                }
                            }
                            background: Rectangle {
                                color: profileTestRecordsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: profileTestRecordsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: profileTestRecordsField.focus ? 2 : 1
                                radius: 6
                            }
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Reverse Tamper:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: reverseTamperCheck
                            property bool localChecked: config.reverseTamper !== undefined ? config.reverseTamper : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("reverseTamper", checked)
                            }
                            Component.onCompleted: localChecked = config.reverseTamper !== undefined ? config.reverseTamper : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Earth Tamper:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: earthTamperCheck
                            property bool localChecked: config.earthTamper !== undefined ? config.earthTamper : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("earthTamper", checked)
                            }
                            Component.onCompleted: localChecked = config.earthTamper !== undefined ? config.earthTamper : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Load Limiter:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: enableLimiterCheck
                            property bool localChecked: config.enableLimiter !== undefined ? config.enableLimiter : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("enableLimiter", checked)
                            }
                            Component.onCompleted: localChecked = config.enableLimiter !== undefined ? config.enableLimiter : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Mismatch Neutral:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: mismatchNeutralCheck
                            property bool localChecked: config.mismatchNeutral !== undefined ? config.mismatchNeutral : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("mismatchNeutral", checked)
                            }
                            Component.onCompleted: localChecked = config.mismatchNeutral !== undefined ? config.mismatchNeutral : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Pulse Count:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: pulseCountCheck
                            property bool localChecked: config.pulseCountEnable !== undefined ? config.pulseCountEnable : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("pulseCountEnable", checked)
                            }
                            Component.onCompleted: localChecked = config.pulseCountEnable !== undefined ? config.pulseCountEnable : false
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: "Sag/Zero-Crossing:"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                        }

                        CheckBox {
                            id: sagZxtoCheck
                            property bool localChecked: config.sagZxtoFlags !== undefined ? config.sagZxtoFlags : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("sagZxtoFlags", checked)
                            }
                            Component.onCompleted: localChecked = config.sagZxtoFlags !== undefined ? config.sagZxtoFlags : false
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

    function updateChipSelection(chip: string, add: bool) {
        var chips = Array.isArray(config.meteringChips) ? [...config.meteringChips] : ["V9381"]
        if (add && !chips.includes(chip)) {
            chips.push(chip)
        } else if (!add && chips.includes(chip)) {
            chips = chips.filter(c => c !== chip)
        }
        return chips.length > 0 ? chips : ["V9381"] // Default to V9381 if no chips selected
    }
}
