import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: rootPage
    property var config: configGenerator.config || {
        "Dlms.IR_ENABLE": false,
        "Dlms.Dlms_mIrCom": 13,
        "Dlms.Dlms_mIrDefaultBaudrate": "Dlms_eBaud300",
        "Dlms.Dlms_mIrCommunicationMode": "Dlms_eModeIec",
        "Dlms.Dlms_mIrNormalBaudrate": "Dlms_eBaud9600",
        "Dlms.DLMS_mIrItb": 20,
        "Dlms._IP_": false,
        "Dlms.Dlms_IpWrap_mInactivityTime": 55,
        "Dlms.DLMS_IpWarp_mPort": 4059,
        "Dlms.Dlms_IpWrap_mDefaultCommProfile": "Dlms_eIpTcp",
        "Dlms.Dlms_IpWrap_mItf": 1,
        "Dlms.DLMS_mRsCom": 1,
        "Dlms.Dlms_mRsBaudrate": "Dlms_eBaud9600",
        "Dlms.Dlms_mRsDatabits": "Dlms_m8DataBits",
        "Dlms.Dlms_mRsParity": "Dlms_NoParity",
        "Dlms.Dlms_mRsItf": 2
    }
    signal configUpdated(var newConfig)
    property string pageId: "DlmsPage_" + Math.random().toString(36).substr(2, 9)

    Component.onCompleted: {
        console.log(pageId, "Initialized with config:", JSON.stringify(config))
        const schema = configGenerator.schema["Dlms"] || {}
        for (let key in schema) {
            const fullKey = "Dlms." + key
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
                    text: "DLMS Configuration"
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "Arial, sans-serif"
                    color: "#1A2526"
                    anchors.centerIn: parent
                }
            }

            GroupBox {
                title: "IR Settings"
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
                        id: irEnableCheck
                        text: configGenerator.schema.Dlms?.IR_ENABLE?.label || "Enable IR Settings"
                        checked: config["Dlms.IR_ENABLE"] || false
                        visible: configGenerator.schema.Dlms?.IR_ENABLE !== undefined
                        onClicked: updateConfig("Dlms.IR_ENABLE", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Dlms?.IR_ENABLE?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_mIrCom !== undefined
                        enabled: irEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mIrCom?.label || "IR Com Port"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: irComField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.Dlms_mIrCom"] !== undefined ? config["Dlms.Dlms_mIrCom"].toString() : "13"
                            validator: IntValidator { bottom: 0; top: 20 }
                            onEditingFinished: {
                                const value = parseInt(text) || 13
                                if (value !== config["Dlms.Dlms_mIrCom"]) {
                                    updateConfig("Dlms.Dlms_mIrCom", value)
                                }
                            }
                            background: Rectangle {
                                color: irComField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irComField.focus ? "#007BFF" : "#CED4DA"
                                border.width: irComField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.Dlms_mIrCom?.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_mIrDefaultBaudrate !== undefined
                        enabled: irEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mIrDefaultBaudrate?.label || "IR Default Baud Rate"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: irDefaultBaudrateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mIrDefaultBaudrate || {}
                            model: schema.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: irDefaultBaudrateCombo.displayText
                                font: irDefaultBaudrateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: irDefaultBaudrateCombo.width - 20
                            }
                            popup: Popup {
                                y: irDefaultBaudrateCombo.height
                                width: irDefaultBaudrateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: irDefaultBaudrateCombo.popup.visible ? irDefaultBaudrateCombo.delegateModel : null
                                    currentIndex: irDefaultBaudrateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: irDefaultBaudrateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irDefaultBaudrateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: irDefaultBaudrateCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mIrDefaultBaudrate"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "IRDefaultBaudrateCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mIrDefaultBaudrate", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_mIrCommunicationMode !== undefined
                        enabled: irEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mIrCommunicationMode?.label || "IR Communication Mode"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: irCommunicationModeCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mIrCommunicationMode || {}
                            model: schema.values || ["Dlms_eModeIec", "Dlms_eModeDlmsUA"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: irCommunicationModeCombo.displayText
                                font: irCommunicationModeCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: irCommunicationModeCombo.width - 20
                            }
                            popup: Popup {
                                y: irCommunicationModeCombo.height
                                width: irCommunicationModeCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: irCommunicationModeCombo.popup.visible ? irCommunicationModeCombo.delegateModel : null
                                    currentIndex: irCommunicationModeCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: irCommunicationModeCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irCommunicationModeCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: irCommunicationModeCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mIrCommunicationMode"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "IRCommunicationModeCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mIrCommunicationMode", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_mIrNormalBaudrate !== undefined
                        enabled: irEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mIrNormalBaudrate?.label || "IR Normal Baud Rate"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: irNormalBaudrateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mIrNormalBaudrate || {}
                            model: schema.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: irNormalBaudrateCombo.displayText
                                font: irNormalBaudrateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: irNormalBaudrateCombo.width - 20
                            }
                            popup: Popup {
                                y: irNormalBaudrateCombo.height
                                width: irNormalBaudrateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: irNormalBaudrateCombo.popup.visible ? irNormalBaudrateCombo.delegateModel : null
                                    currentIndex: irNormalBaudrateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: irNormalBaudrateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irNormalBaudrateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: irNormalBaudrateCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mIrNormalBaudrate"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "IRNormalBaudrateCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mIrNormalBaudrate", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: irEnableCheck.checked && configGenerator.schema.Dlms?.DLMS_mIrItb !== undefined
                        enabled: irEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.DLMS_mIrItb?.label || "IR Frame Timeout (10ms)"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: irItbField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.DLMS_mIrItb"] !== undefined ? config["Dlms.DLMS_mIrItb"].toString() : "20"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                const value = parseInt(text) || 20
                                if (value !== config["Dlms.DLMS_mIrItb"]) {
                                    updateConfig("Dlms.DLMS_mIrItb", value)
                                }
                            }
                            background: Rectangle {
                                color: irItbField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: irItbField.focus ? "#007BFF" : "#CED4DA"
                                border.width: irItbField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.DLMS_mIrItb?.description || ""
                        }
                    }
                }
            }

            GroupBox {
                title: "IP Settings"
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
                        id: ipEnableCheck
                        text: configGenerator.schema.Dlms?._IP_?.label || "Enable IP Settings"
                        checked: config["Dlms._IP_"] || false
                        visible: configGenerator.schema.Dlms?._IP_ !== undefined
                        onClicked: updateConfig("Dlms._IP_", checked)
                        ToolTip.visible: hovered
                        ToolTip.text: configGenerator.schema.Dlms?._IP_?.description || ""
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_IpWrap_mInactivityTime !== undefined
                        enabled: ipEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_IpWrap_mInactivityTime?.label || "IP Inactivity Time (sec)"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: ipInactivityTimeField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.Dlms_IpWrap_mInactivityTime"] !== undefined ? config["Dlms.Dlms_IpWrap_mInactivityTime"].toString() : "55"
                            validator: IntValidator { bottom: 0; top: 100 }
                            onEditingFinished: {
                                const value = parseInt(text) || 55
                                if (value !== config["Dlms.Dlms_IpWrap_mInactivityTime"]) {
                                    updateConfig("Dlms.Dlms_IpWrap_mInactivityTime", value)
                                }
                            }
                            background: Rectangle {
                                color: ipInactivityTimeField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipInactivityTimeField.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipInactivityTimeField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.Dlms_IpWrap_mInactivityTime?.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked && configGenerator.schema.Dlms?.DLMS_IpWarp_mPort !== undefined
                        enabled: ipEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.DLMS_IpWarp_mPort?.label || "IP Port"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: ipPortField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.DLMS_IpWarp_mPort"] !== undefined ? config["Dlms.DLMS_IpWarp_mPort"].toString() : "4059"
                            validator: IntValidator { bottom: 0; top: 65535 }
                            onEditingFinished: {
                                const value = parseInt(text) || 4059
                                if (value !== config["Dlms.DLMS_IpWarp_mPort"]) {
                                    updateConfig("Dlms.DLMS_IpWarp_mPort", value)
                                }
                            }
                            background: Rectangle {
                                color: ipPortField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipPortField.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipPortField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.DLMS_IpWarp_mPort?.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_IpWrap_mDefaultCommProfile !== undefined
                        enabled: ipEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_IpWrap_mDefaultCommProfile?.label || "IP Communication Profile"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: ipCommProfileCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_IpWrap_mDefaultCommProfile || {}
                            model: schema.values || ["Dlms_eIpTcp", "Dlms_eIpUdp"]
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
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_IpWrap_mDefaultCommProfile"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "IPCommProfileCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_IpWrap_mDefaultCommProfile", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: ipEnableCheck.checked && configGenerator.schema.Dlms?.Dlms_IpWrap_mItf !== undefined
                        enabled: ipEnableCheck.checked
                        opacity: enabled ? 1.0 : 0.6

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_IpWrap_mItf?.label || "IP Interface"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: ipItfField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.Dlms_IpWrap_mItf"] !== undefined ? config["Dlms.Dlms_IpWrap_mItf"].toString() : "1"
                            validator: IntValidator { bottom: 0; top: 10 }
                            onEditingFinished: {
                                const value = parseInt(text) || 1
                                if (value !== config["Dlms.Dlms_IpWrap_mItf"]) {
                                    updateConfig("Dlms.Dlms_IpWrap_mItf", value)
                                }
                            }
                            background: Rectangle {
                                color: ipItfField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: ipItfField.focus ? "#007BFF" : "#CED4DA"
                                border.width: ipItfField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.Dlms_IpWrap_mItf?.description || ""
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
                    spacing: 15
                    width: parent.width

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: configGenerator.schema.Dlms?.DLMS_mRsCom !== undefined

                        Label {
                            text: configGenerator.schema.Dlms?.DLMS_mRsCom?.label || "RS485 Com Port"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rsComField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.DLMS_mRsCom"] !== undefined ? config["Dlms.DLMS_mRsCom"].toString() : "1"
                            validator: IntValidator { bottom: 0; top: 10 }
                            onEditingFinished: {
                                const value = parseInt(text) || 1
                                if (value !== config["Dlms.DLMS_mRsCom"]) {
                                    updateConfig("Dlms.DLMS_mRsCom", value)
                                }
                            }
                            background: Rectangle {
                                color: rsComField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rsComField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rsComField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.DLMS_mRsCom?.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: configGenerator.schema.Dlms?.Dlms_mRsBaudrate !== undefined

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mRsBaudrate?.label || "RS485 Baud Rate"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rsBaudrateCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mRsBaudrate || {}
                            model: schema.values || ["Dlms_eBaud300", "Dlms_eBaud600", "Dlms_eBaud1200", "Dlms_eBaud2400", "Dlms_eBaud4800", "Dlms_eBaud9600", "Dlms_eBaud19200", "Dlms_eBaud38400", "Dlms_eBaud57600", "Dlms_eBaud115200"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rsBaudrateCombo.displayText
                                font: rsBaudrateCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rsBaudrateCombo.width - 20
                            }
                            popup: Popup {
                                y: rsBaudrateCombo.height
                                width: rsBaudrateCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rsBaudrateCombo.popup.visible ? rsBaudrateCombo.delegateModel : null
                                    currentIndex: rsBaudrateCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rsBaudrateCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rsBaudrateCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rsBaudrateCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mRsBaudrate"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "RSBaudrateCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mRsBaudrate", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: configGenerator.schema.Dlms?.Dlms_mRsDatabits !== undefined

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mRsDatabits?.label || "RS485 Data Bits"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rsDatabitsCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mRsDatabits || {}
                            model: schema.values || ["Dlms_m7DataBits", "Dlms_m8DataBits"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rsDatabitsCombo.displayText
                                font: rsDatabitsCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rsDatabitsCombo.width - 20
                            }
                            popup: Popup {
                                y: rsDatabitsCombo.height
                                width: rsDatabitsCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rsDatabitsCombo.popup.visible ? rsDatabitsCombo.delegateModel : null
                                    currentIndex: rsDatabitsCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rsDatabitsCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rsDatabitsCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rsDatabitsCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mRsDatabits"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "RSDatabitsCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mRsDatabits", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: configGenerator.schema.Dlms?.Dlms_mRsParity !== undefined

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mRsParity?.label || "RS485 Parity"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        ComboBox {
                            id: rsParityCombo
                            Layout.fillWidth: true
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            property var schema: configGenerator.schema.Dlms?.Dlms_mRsParity || {}
                            model: schema.values || ["Dlms_NoParity", "Dlms_EvenParity"]
                            contentItem: Text {
                                leftPadding: 10
                                rightPadding: 10
                                text: rsParityCombo.displayText
                                font: rsParityCombo.font
                                color: "#1A2526"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: rsParityCombo.width - 20
                            }
                            popup: Popup {
                                y: rsParityCombo.height
                                width: rsParityCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 2
                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: rsParityCombo.popup.visible ? rsParityCombo.delegateModel : null
                                    currentIndex: rsParityCombo.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }
                            }
                            background: Rectangle {
                                color: rsParityCombo.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rsParityCombo.focus ? "#007BFF" : "#CED4DA"
                                border.width: rsParityCombo.focus ? 2 : 1
                                radius: 6
                            }
                            Component.onCompleted: {
                                if (schema.values) {
                                    const current = config["Dlms.Dlms_mRsParity"] || schema.default || schema.values[0]
                                    currentIndex = schema.values.indexOf(current)
                                    console.log(pageId, "RSParityCombo initialized with index:", currentIndex, "value:", current)
                                }
                            }
                            onActivated: {
                                if (schema.values && index >= 0 && index < schema.values.length) {
                                    updateConfig("Dlms.Dlms_mRsParity", schema.values[index])
                                }
                            }
                            ToolTip.visible: hovered && schema.description
                            ToolTip.text: schema.description || ""
                        }
                    }

                    RowLayout {
                        spacing: 100
                        Layout.fillWidth: true
                        visible: configGenerator.schema.Dlms?.Dlms_mRsItf !== undefined

                        Label {
                            text: configGenerator.schema.Dlms?.Dlms_mRsItf?.label || "RS485 Interface Timeout"
                            font.pixelSize: 16
                            font.family: "Arial, sans-serif"
                            color: "#1A2526"
                            Layout.preferredWidth: 160
                            verticalAlignment: Label.AlignVCenter
                        }

                        TextField {
                            id: rsItfField
                            Layout.minimumWidth: 280
                            Layout.maximumWidth: 480
                            font.pixelSize: 14
                            padding: 8
                            text: config["Dlms.Dlms_mRsItf"] !== undefined ? config["Dlms.Dlms_mRsItf"].toString() : "2"
                            validator: IntValidator { bottom: 0; top: 10 }
                            onEditingFinished: {
                                const value = parseInt(text) || 2
                                if (value !== config["Dlms.Dlms_mRsItf"]) {
                                    updateConfig("Dlms.Dlms_mRsItf", value)
                                }
                            }
                            background: Rectangle {
                                color: rsItfField.hovered ? "#F8FAFC" : "#FFFFFF"
                                border.color: rsItfField.focus ? "#007BFF" : "#CED4DA"
                                border.width: rsItfField.focus ? 2 : 1
                                radius: 6
                            }
                            ToolTip.visible: hovered
                            ToolTip.text: configGenerator.schema.Dlms?.Dlms_mRsItf?.description || ""
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
        const newConfig = JSON.parse(JSON.stringify(config || {}))
        newConfig[key] = value
        if (key === "Dlms.IR_ENABLE" && !value) {
            newConfig["Dlms.Dlms_mIrCom"] = configGenerator.schema.Dlms?.Dlms_mIrCom?.default || 13
            newConfig["Dlms.Dlms_mIrDefaultBaudrate"] = configGenerator.schema.Dlms?.Dlms_mIrDefaultBaudrate?.default || "Dlms_eBaud300"
            newConfig["Dlms.Dlms_mIrCommunicationMode"] = configGenerator.schema.Dlms?.Dlms_mIrCommunicationMode?.default || "Dlms_eModeIec"
            newConfig["Dlms.Dlms_mIrNormalBaudrate"] = configGenerator.schema.Dlms?.Dlms_mIrNormalBaudrate?.default || "Dlms_eBaud9600"
            newConfig["Dlms.DLMS_mIrItb"] = configGenerator.schema.Dlms?.DLMS_mIrItb?.default || 20
        }
        if (key === "Dlms._IP_" && !value) {
            newConfig["Dlms.Dlms_IpWrap_mInactivityTime"] = configGenerator.schema.Dlms?.Dlms_IpWrap_mInactivityTime?.default || 55
            newConfig["Dlms.DLMS_IpWarp_mPort"] = configGenerator.schema.Dlms?.DLMS_IpWarp_mPort?.default || 4059
            newConfig["Dlms.Dlms_IpWrap_mDefaultCommProfile"] = configGenerator.schema.Dlms?.Dlms_IpWrap_mDefaultCommProfile?.default || "Dlms_eIpTcp"
            newConfig["Dlms.Dlms_IpWrap_mItf"] = configGenerator.schema.Dlms?.Dlms_IpWrap_mItf?.default || 1
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
