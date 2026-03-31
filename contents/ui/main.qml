import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as Plasma5Support
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    // We want the widget to sit on the taskbar natively as a Row, without a popup.
    preferredRepresentation: fullRepresentation
    
    // Tooltips removed for Plasma 6 compatibility

    property var coreTemps: []
    property var coreStrings: []
    
    Plasma5Support.DataSource {
        id: executableSource
        engine: "executable"
        connectedSources: []
        
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            
            var stdout = data["stdout"];
            if (stdout) {
                try {
                    var json = JSON.parse(stdout);
                    var newTemps = [];
                    var newStrings = [];
                    
                    // Iterate through the adapters (e.g., coretemp-isa-0000, k10temp, etc.)
                    for (var key in json) {
                        // Check if it's likely a CPU sensor block
                        if (key.indexOf("coretemp") !== -1 || key.indexOf("k10temp") !== -1 || key.indexOf("zenpower") !== -1 || key.indexOf("cpu") !== -1) {
                            var cpuObj = json[key];
                            
                            // Iterate through the Cores (e.g., Core 0, Core 1...)
                            for (var coreKey in cpuObj) {
                                if (coreKey.startsWith("Core ")) {
                                    var coreData = cpuObj[coreKey];
                                    
                                    // Iterate to find the thermal inputs
                                    for (var tempKey in coreData) {
                                        if (tempKey.endsWith("_input")) {
                                            var t = Math.round(coreData[tempKey]);
                                            newTemps.push(t);
                                            newStrings.push(coreKey + ": " + t + "°C");
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if (newTemps.length > 0) {
                        if (Plasmoid.configuration.maxCoreOnly) {
                            var maxT = Math.max.apply(null, newTemps);
                            coreTemps = [maxT];
                            coreStrings = ["Hottest Core: " + maxT + "°C"];
                        } else {
                            coreTemps = newTemps;
                            coreStrings = newStrings;
                        }
                    }
                } catch (e) {
                    console.log("Error parsing sensors JSON output:", e);
                }
            }
        }
    }

    Timer {
        id: pollTimer
        interval: Plasmoid.configuration.pollInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            executableSource.connectSource("sensors -j");
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: myRow.implicitWidth + Kirigami.Units.smallSpacing * 2
        Layout.minimumHeight: Kirigami.Units.gridUnit
        
        RowLayout {
            id: myRow
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing
            
            Repeater {
                model: root.coreTemps
                delegate: PlasmaComponents.Label {
                    text: {
                        var val = modelData.toString();
                        if (Plasmoid.configuration.showDegreeSymbol) {
                            val += "°";
                        }
                        
                        // Add separator text ONLY if it's not the last core
                        if (index < root.coreTemps.length - 1) {
                            var sep = Plasmoid.configuration.separatorText;
                            if (sep !== "") {
                                val += " " + sep;
                            }
                        }
                        return val;
                    }
                    
                    // Controlled exclusively through widget configuration setting
                    font.pixelSize: Plasmoid.configuration.customFontSize
                    font.bold: Plasmoid.configuration.boldFont
                    
                    color: {
                        if (modelData >= Plasmoid.configuration.tempCritical) {
                            return Kirigami.Theme.negativeTextColor; // Red
                        } else if (modelData >= Plasmoid.configuration.tempWarning) {
                            return Kirigami.Theme.neutralTextColor; // Yellow/Orange
                        } else {
                            return Kirigami.Theme.textColor; // Default White/Black theme color
                        }
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
