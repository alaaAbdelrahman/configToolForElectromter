import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property string pageId: "MeteringPage_" + Math.random().toString(36).slice(2)
    property var config: {
        if (configGenerator && configGenerator.config) {
            return configGenerator.config
        } else {
            console.warn(pageId, "configGenerator.config is empty, using defaults")
            return {
                "Metering.meterType": "MTR_SINGLE_PH",
                "Metering.MTR_REACTIVE": false,
                "Metering.meterMeasurement": "MTR_DIRECT",
                "Metering.meteringChips": "V9381_ENABLE",
                "Metering.MTR_NUM_OF_PHASE": 1,
                "Metering.MTR_NUM_OF_CH": 2,
                "Metering.pulseConstant": "CONSTANT_3200",
                "Metering.MTR_LOAD_PROFILE": false,
                "Metering.PROFILE_RECORD_NUM": 3360,
                "Metering.PROFILE_RECORD_TEST_MODE_NUM": 20,
                "Metering.MTR_RVS_TMPR": false,
                "Metering.MTR_ERTH_TMPR": false,
                "Metering.MTR_ENABLE_LMT": false,
                "Metering.PULSE_COUNT_ENABLE": false,
                "Metering.BIG_ENDIAN": false
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
            console.log(pageId, "Schema loaded:", JSON.stringify(configGenerator.schema.Metering))
        }
    }

    Connections {
        target: configGenerator
        function onConfigChanged() {
            config = configGenerator.config
            console.log(pageId, "Config updated from ConfigGenerator:", JSON.stringify(config))
        }
        function onSchemaChanged() {
            console.log(pageId, "Schema updated:", JSON.stringify(configGenerator.schema.Metering))
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 24
        clip: true
        contentWidth: parent.width

        ColumnLayout {
            id: formLayout
            width: scrollView.width - 48
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
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema["Metering.meterType"]?.label || "Meter Type"
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
                            model: configGenerator.schema?.Metering.meterType?.labels ||configGenerator.schema?.Metering.meterType?.values|| ["Single Phase", "Two Phase", "Three Phase"]

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
                                const schema = configGenerator.schema?.Metering.meterType
                                if (schema?.type === "enum" && schema.labels && schema.values) {
                                    const valueMap = {}
                                    for (let i = 0; i < schema.labels.length; i++) {
                                        valueMap[schema.labels[i]] = schema.values[i]
                                    }
                                    const currentValue = config["Metering.meterType"] || schema.values[0]
                                    const currentLabel = Object.keys(valueMap).find(label => valueMap[label] === currentValue) || schema.labels[0]
                                    currentIndex = schema.labels.indexOf(currentLabel)
                                    if (currentIndex === -1) {
                                        currentIndex = 0
                                        console.warn(pageId, "Invalid initial meterType:", currentValue)
                                    }
                                    console.log(pageId, "meterType initialized to label:", currentLabel, "value:", currentValue, "index:", currentIndex)
                                } else {
                                    currentIndex = 0
                                    console.warn(pageId, "Invalid meterType schema:", JSON.stringify(schema))
                                }
                            }

                            onActivated: function(index) {
                                const schema = configGenerator.schema?.Metering?.meterType
                                if (schema?.type === "enum" && schema.labels && schema.values) {
                                    const selectedLabel = model[index]
                                    const valueMap = {}
                                    for (let i = 0; i < schema.labels.length; i++) {
                                        valueMap[schema.labels[i]] = schema.values[i]
                                    }
                                    const configKey = valueMap[selectedLabel]
                                    if (configKey) {
                                        updateConfig("Metering.meterType", configKey)
                                        console.log(pageId, "Updated meterType to:", configKey, "from label:", selectedLabel)
                                    } else {
                                        console.warn(pageId, "No value mapped for label:", selectedLabel)
                                    }
                                } else {
                                    console.warn(pageId, "Invalid meterType schema on activation:", JSON.stringify(schema))
                                }
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.MTR_REACTIVE?.label || "Reactive Meter"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: reactiveMeterCheck
                            property bool localChecked: config["Metering.MTR_REACTIVE"] !== undefined ? config["Metering.MTR_REACTIVE"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.MTR_REACTIVE", checked)
                                console.log(pageId, "Updating MTR_REACTIVE to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.MTR_REACTIVE"] !== undefined ? config["Metering.MTR_REACTIVE"] : false
                                console.log(pageId, "MTR_REACTIVE initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.meterMeasurement?.label || "Enable Direct Calculations"
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
                            model: configGenerator.schema?.Metering.meterMeasurement?.labels || ["MTR_DIRECT", "MTR_INDIRECT"]

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

                            Component.onCompleted: {
                                const schema = configGenerator.schema?.Metering.meterMeasurement
                                const currentValue = config["Metering.meterMeasurement"] || schema?.default || "MTR_DIRECT"
                                currentIndex = model.indexOf(currentValue)
                                if (currentIndex === -1) {
                                    currentIndex = 0
                                    console.warn(pageId, "Invalid meterMeasurement:", currentValue)
                                }
                                console.log(pageId, "meterMeasurement initialized to:", currentValue, "index:", currentIndex)
                            }

                            onActivated: function(index) {
                                const configKey = model[index]
                                updateConfig("Metering.meterMeasurement", configKey)
                                console.log(pageId, "Updated meterMeasurement to:", configKey)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.MTR_NUM_OF_PHASE?.label || "Number of Phases"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        Label {
                            text: config["Metering.MTR_NUM_OF_PHASE"] !== undefined
                                  ? config["Metering.MTR_NUM_OF_PHASE"].toString()
                                  : "1"
                            font.pixelSize: 14
                            color: "#1A2526"
                            Layout.fillWidth: true
                        }

                        // Ensure the value is saved on load (optional safety)
                        Component.onCompleted: {
                            if (config["Metering.MTR_NUM_OF_PHASE"] === undefined) {
                                updateConfig("Metering.MTR_NUM_OF_PHASE", 1)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.MTR_NUM_OF_CH?.label || "Number of Channels"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        Label {
                            text: config["Metering.MTR_NUM_OF_CH"] !== undefined
                                  ? config["Metering.MTR_NUM_OF_CH"].toString()
                                  : "2"
                            font.pixelSize: 14
                            color: "#1A2526"
                            Layout.fillWidth: true
                        }

                        Component.onCompleted: {
                            if (config["Metering.MTR_NUM_OF_CH"] === undefined) {
                                updateConfig("Metering.MTR_NUM_OF_CH", 2)
                            }
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
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.meteringChips?.label || "Metering Chips"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: meteringChipsCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            model: configGenerator.schema?.Metering.meteringChips?.values || ["ADE7953_ENABLE", "V9203_ENABLE", "V9261F_ENABLE", "V9340_ENABLE", "V9360_ENABLE", "V9381_ENABLE"]

                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: meteringChipsCombo.displayText
                                font: meteringChipsCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: meteringChipsCombo.width - 20
                            }

                            popup: Popup {
                                y: meteringChipsCombo.height
                                width: meteringChipsCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: meteringChipsCombo.popup.visible ? meteringChipsCombo.delegateModel : null
                                    currentIndex: meteringChipsCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }

                            background: Rectangle {
                                color: meteringChipsCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: meteringChipsCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: meteringChipsCombo.focus ? 2 : 1
                                radius: 6
                            }

                            Component.onCompleted: {
                                const schema = configGenerator.schema?.Metering.meteringChips
                                const currentValue = config["Metering.meteringChips"] || schema?.default || "V9381_ENABLE"
                                currentIndex = model.indexOf(currentValue)
                                if (currentIndex === -1) {
                                    currentIndex = 0
                                    console.warn(pageId, "Invalid meteringChips:", currentValue)
                                }
                                console.log(pageId, "meteringChips initialized to:", currentValue, "index:", currentIndex)
                            }

                            onActivated: function(index) {
                                const configKey = model[index]
                                updateConfig("Metering.meteringChips", configKey)
                                console.log(pageId, "Updated meteringChips to:", configKey)
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
                        spacing: 100
                        Layout.fillWidth: true

                        Label {
                            text: configGenerator.schema?.Metering.pulseConstant?.label || "Pulse Constant"
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
                            model: configGenerator.schema?.Metering.pulseConstant?.labels|| configGenerator.schema?.Metering.pulseConstant?.values || ["CONSTANT_1000", "CONSTANT_1600", "CONSTANT_3200", "CONSTANT_10000"]

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
                                const schema = configGenerator.schema?.Metering.pulseConstant
                                const currentValue = config["Metering.pulseConstant"] || schema?.default || "CONSTANT_3200"
                                currentIndex = model.indexOf(currentValue)
                                if (currentIndex === -1) {
                                    currentIndex = 0
                                    console.warn(pageId, "Invalid pulseConstant:", currentValue)
                                }
                                console.log(pageId, "pulseConstant initialized to:", currentValue, "index:", currentIndex)
                            }

                            onActivated: function(index) {
                                const configKey = model[index]
                                updateConfig("Metering.pulseConstant", configKey)
                                console.log(pageId, "Updated pulseConstant to:", configKey)
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
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Metering.MTR_LOAD_PROFILE?.label || "Enable Load Profile"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: loadProfileCheck
                            property bool localChecked: config["Metering.MTR_LOAD_PROFILE"] !== undefined ? config["Metering.MTR_LOAD_PROFILE"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.MTR_LOAD_PROFILE", checked)
                                console.log(pageId, "Updating MTR_LOAD_PROFILE to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.MTR_LOAD_PROFILE"] !== undefined ? config["Metering.MTR_LOAD_PROFILE"] : false
                                console.log(pageId, "MTR_LOAD_PROFILE initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: !!(config["Metering.MTR_LOAD_PROFILE"])

                        Label {
                            text: configGenerator.schema?.Metering.PROFILE_RECORD_NUM?.label || "Profile Record Number"
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
                            text: config["Metering.PROFILE_RECORD_NUM"] !== undefined ? config["Metering.PROFILE_RECORD_NUM"].toString() : "3360"
                            validator: IntValidator { bottom: 0; top: 10000 }
                            onEditingFinished: {
                                var value = parseInt(text) || 3360
                                if (value !== config["Metering.PROFILE_RECORD_NUM"]) {
                                    updateConfig("Metering.PROFILE_RECORD_NUM", value)
                                    console.log(pageId, "Updating PROFILE_RECORD_NUM to", value)
                                }
                            }
                            background: Rectangle {
                                color: profileRecordNumField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: profileRecordNumField.focus ? "#007BFF" : "#CED4DA"
                                border.width: profileRecordNumField.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                console.log(pageId, "PROFILE_RECORD_NUM initialized to", text)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: !!(config["Metering.MTR_LOAD_PROFILE"])

                        Label {
                            text: configGenerator.schema?.Metering.PROFILE_RECORD_TEST_MODE_NUM?.label || "Profile Test Records"
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
                            text: config["Metering.PROFILE_RECORD_TEST_MODE_NUM"] !== undefined ? config["Metering.PROFILE_RECORD_TEST_MODE_NUM"].toString() : "20"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                var value = parseInt(text) || 20
                                if (value !== config["Metering.PROFILE_RECORD_TEST_MODE_NUM"]) {
                                    updateConfig("Metering.PROFILE_RECORD_TEST_MODE_NUM", value)
                                    console.log(pageId, "Updating PROFILE_RECORD_TEST_MODE_NUM to", value)
                                }
                            }
                            background: Rectangle {
                                color: profileTestRecordsField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: profileTestRecordsField.focus ? "#007BFF" : "#CED4DA"
                                border.width: profileTestRecordsField.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                console.log(pageId, "PROFILE_RECORD_TEST_MODE_NUM initialized to", text)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Metering.MTR_RVS_TMPR?.label || "Enable Reverse Tamper"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: reverseTamperCheck
                            property bool localChecked: config["Metering.MTR_RVS_TMPR"] !== undefined ? config["Metering.MTR_RVS_TMPR"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.MTR_RVS_TMPR", checked)
                                console.log(pageId, "Updating MTR_RVS_TMPR to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.MTR_RVS_TMPR"] !== undefined ? config["Metering.MTR_RVS_TMPR"] : false
                                console.log(pageId, "MTR_RVS_TMPR initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Metering.MTR_ERTH_TMPR?.label || "Enable Earth Tamper"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: earthTamperCheck
                            property bool localChecked: config["Metering.MTR_ERTH_TMPR"] !== undefined ? config["Metering.MTR_ERTH_TMPR"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.MTR_ERTH_TMPR", checked)
                                console.log(pageId, "Updating MTR_ERTH_TMPR to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.MTR_ERTH_TMPR"] !== undefined ? config["Metering.MTR_ERTH_TMPR"] : false
                                console.log(pageId, "MTR_ERTH_TMPR initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Metering.MTR_ENABLE_LMT?.label || "Enable Limiter"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: enableLimiterCheck
                            property bool localChecked: config["Metering.MTR_ENABLE_LMT"] !== undefined ? config["Metering.MTR_ENABLE_LMT"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.MTR_ENABLE_LMT", checked)
                                console.log(pageId, "Updating MTR_ENABLE_LMT to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.MTR_ENABLE_LMT"] !== undefined ? config["Metering.MTR_ENABLE_LMT"] : false
                                console.log(pageId, "MTR_ENABLE_LMT initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema["Metering.PULSE_COUNT_ENABLE"].label || "Enable Pulse Count"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: pulseCountCheck
                            property bool localChecked: config.Metering?.PULSE_COUNT_ENABLE !== undefined ? config["Metering.PULSE_COUNT_ENABLE"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.PULSE_COUNT_ENABLE", checked)
                                console.log(pageId, "Updating PULSE_COUNT_ENABLE to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.PULSE_COUNT_ENABLE"] !== undefined ? config["Metering.PULSE_COUNT_ENABLE"] : false
                                console.log(pageId, "PULSE_COUNT_ENABLE initialized to", localChecked)
                            }
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Label {
                            text: configGenerator.schema?.Metering?.BIG_ENDIAN?.label || "Big Endian"
                            font.pixelSize: 16
                            font.family: "Roboto"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        CheckBox {
                            id: bigEndianCheck
                            property bool localChecked: config["Metering.BIG_ENDIAN"] !== undefined ? config["Metering.BIG_ENDIAN"] : false
                            checked: localChecked
                            onCheckedChanged: {
                                localChecked = checked
                                updateConfig("Metering.BIG_ENDIAN", checked)
                                console.log(pageId, "Updating BIG_ENDIAN to", checked)
                            }
                            Component.onCompleted: {
                                localChecked = config["Metering.BIG_ENDIAN"] !== undefined ? config["Metering.BIG_ENDIAN"] : false
                                console.log(pageId, "BIG_ENDIAN initialized to", localChecked)
                            }
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
        if (key === "Metering.meterType") {
            if (value === "MTR_SINGLE_PH") {
                newConfig["Metering.MTR_NUM_OF_PHASE"] = 1
                newConfig["Metering.MTR_NUM_OF_CH"] = 2
            } else if (value === "MTR_TWO_PH") {
                newConfig["Metering.MTR_NUM_OF_PHASE"] = 2
                newConfig["Metering.MTR_NUM_OF_CH"] = 2
            } else if (value === "MTR_THREE_PH") {
                newConfig["Metering.MTR_NUM_OF_PHASE"] = 3
                newConfig["Metering.MTR_NUM_OF_CH"] = 3
            }
            console.log(pageId, "Updated dependent fields for meterType:", JSON.stringify(newConfig))
        }
        console.log(pageId, "Updating config for", key, "with value:", value, "new config:", JSON.stringify(newConfig))
        configUpdated(newConfig)
        config = newConfig
    }
}
