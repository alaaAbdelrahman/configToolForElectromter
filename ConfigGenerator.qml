// ConfigGenerator.qml
import QtQuick 2.15

QtObject {
    id: root
    property var config
    property var onConfigUpdated
    function generateConfig() {
        let content = `// Auto-generated configuration file
// Created by Meter Configuration Tool

#ifndef CONFIGURABLE_METER_OPTIONS_H
#define CONFIGURABLE_METER_OPTIONS_H

// =====================================================
// 1. Microcontroller Target
// =====================================================
#define MicroController ${root.config.microcontroller}

// =====================================================
// 2. Meter Type Configuration
// =====================================================
${generateMeterTypeConfig()}

// Continue with other sections...

#endif // CONFIGURABLE_METER_OPTIONS_H
`

        // Show save dialog and save file
        // (In a real app, you'd use FileDialog and File IO)
        console.log(content)
    }

    function generateMeterTypeConfig() {
        if (root.config.meterType === "singlePhase") {
            return `#define MTR_SINGLE_PH
#define MTR_DIRECT
#define MTR_NUM_OF_PHASE 1
#define MTR_NUM_OF_CH 2`
        } else {
            return `#define MTR_THREE_PH
#define MTR_DIRECT
#define MTR_NUM_OF_PHASE 3
#define MTR_NUM_OF_CH 3`
        }
    }
}
