import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {
    id: page
    
    // Bindings to the KConfig schema variables established in main.xml
    property alias cfg_customFontSize: fontSizeSpin.value
    property alias cfg_showDegreeSymbol: degreeCheck.checked
    property alias cfg_separatorText: separatorCombo.currentText
    
    // New Advanced Settings Bindings
    property alias cfg_pollInterval: pollIntervalSpin.value
    property alias cfg_tempWarning: tempWarningSpin.value
    property alias cfg_tempCritical: tempCriticalSpin.value
    property alias cfg_boldFont: boldCheck.checked
    property alias cfg_maxCoreOnly: maxCoreCheck.checked

    Controls.SpinBox {
        id: fontSizeSpin
        Kirigami.FormData.label: i18n("Text Size (px):")
        from: 6
        to: 36
    }
    
    Controls.CheckBox {
        id: degreeCheck
        Kirigami.FormData.label: i18n("Show Degree Symbol (°):")
    }

    Controls.ComboBox {
        id: separatorCombo
        Kirigami.FormData.label: i18n("Separator:")
        model: ["|", "-", ",", " "]
    }
    
    Kirigami.Separator {
        Layout.fillWidth: true
    }

    Controls.SpinBox {
        id: pollIntervalSpin
        Kirigami.FormData.label: i18n("Update Interval (ms):")
        from: 1000
        to: 10000
        stepSize: 1000
    }

    Controls.SpinBox {
        id: tempWarningSpin
        Kirigami.FormData.label: i18n("Warning Color Threshold (°C):")
        from: 40
        to: 100
    }

    Controls.SpinBox {
        id: tempCriticalSpin
        Kirigami.FormData.label: i18n("Critical Color Threshold (°C):")
        from: 60
        to: 120
    }

    Controls.CheckBox {
        id: boldCheck
        Kirigami.FormData.label: i18n("Use Bold Font:")
    }

    Controls.CheckBox {
        id: maxCoreCheck
        Kirigami.FormData.label: i18n("Only Show Hottest Core (Max Temp):")
    }
}
