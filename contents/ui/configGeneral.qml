import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

Kirigami.FormLayout {
    property alias cfg_layoutMode: layoutMode.currentIndex
    property alias cfg_use24h: use24h.checked
    property alias cfg_showMeridiem: showMeridiem.checked
    property alias cfg_showSeconds: showSeconds.checked
    property alias cfg_separatorMode: separatorMode.currentIndex
    property alias cfg_autoScaleWithPanel: autoScaleWithPanel.checked
    property alias cfg_fontPixelSize: fontPixelSize.value
    property alias cfg_useCustomPartStyles: useCustomPartStyles.checked
    property alias cfg_hourFontPixelSize: hourFontPixelSize.value
    property alias cfg_minuteFontPixelSize: minuteFontPixelSize.value
    property alias cfg_secondFontPixelSize: secondFontPixelSize.value
    property alias cfg_meridiemFontPixelSize: meridiemFontPixelSize.value
    property alias cfg_hourBold: hourBold.checked
    property alias cfg_minuteBold: minuteBold.checked
    property alias cfg_secondBold: secondBold.checked
    property alias cfg_meridiemBold: meridiemBold.checked
    property alias cfg_lineSpacing: lineSpacing.value
    property alias cfg_horizontalPadding: horizontalPadding.value
    property alias cfg_verticalPadding: verticalPadding.value
    readonly property bool panelIsVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool useVerticalLayout: layoutMode.currentIndex === 1 || (layoutMode.currentIndex === 0 && panelIsVertical)
    readonly property bool useHorizontalLayout: !useVerticalLayout
    readonly property bool customPartStylesEnabled: useCustomPartStyles.checked
    readonly property string verticalPaddingHint: i18n("Vertical padding is inactive in Horizontal layout. Adjust this directly in KDE taskbar settings.")
    readonly property string horizontalPaddingHint: i18n("Horizontal padding is inactive in Vertical layout. Adjust this directly in KDE taskbar settings.")

    QQC2.ComboBox {
        id: layoutMode
        model: [
            i18n("Auto"),
            i18n("Vertical"),
            i18n("Horizontal")
        ]
        Kirigami.FormData.label: i18n("Clock layout:")
    }

    QQC2.CheckBox {
        id: use24h
        text: i18n("Use 24-hour time")
        Kirigami.FormData.label: i18n("Format:")
    }

    QQC2.CheckBox {
        id: showMeridiem
        text: i18n("Show AM/PM in 12-hour mode")
        enabled: !use24h.checked
    }

    QQC2.CheckBox {
        id: showSeconds
        text: i18n("Show seconds")
    }

    QQC2.ComboBox {
        id: separatorMode
        model: [
            i18n("Colon (:)") ,
            i18n("None"),
            i18n("Slash (/)")
        ]
        Kirigami.FormData.label: i18n("Horizontal separator:")
    }

    QQC2.CheckBox {
        id: autoScaleWithPanel
        text: i18n("Scale with taskbar size")
        Kirigami.FormData.label: i18n("Sizing:")
    }

    QQC2.SpinBox {
        id: fontPixelSize
        from: 10
        to: 72
        editable: true
        enabled: !autoScaleWithPanel.checked && !customPartStylesEnabled
        Kirigami.FormData.label: i18n("Font size:")
    }

    QQC2.CheckBox {
        id: useCustomPartStyles
        text: i18n("Customize each clock part")
        Kirigami.FormData.label: i18n("Part styles:")
    }

    RowLayout {
        enabled: customPartStylesEnabled
        Kirigami.FormData.label: i18n("Hours:")

        QQC2.SpinBox {
            id: hourFontPixelSize
            from: 8
            to: 72
            editable: true
        }

        QQC2.CheckBox {
            id: hourBold
            text: i18n("Bold")
        }
    }

    RowLayout {
        enabled: customPartStylesEnabled
        Kirigami.FormData.label: i18n("Minutes:")

        QQC2.SpinBox {
            id: minuteFontPixelSize
            from: 8
            to: 72
            editable: true
        }

        QQC2.CheckBox {
            id: minuteBold
            text: i18n("Bold")
        }
    }

    RowLayout {
        enabled: customPartStylesEnabled
        Kirigami.FormData.label: i18n("Seconds:")

        QQC2.SpinBox {
            id: secondFontPixelSize
            from: 8
            to: 72
            editable: true
        }

        QQC2.CheckBox {
            id: secondBold
            text: i18n("Bold")
        }
    }

    RowLayout {
        enabled: customPartStylesEnabled
        Kirigami.FormData.label: i18n("AM/PM:")

        QQC2.SpinBox {
            id: meridiemFontPixelSize
            from: 8
            to: 72
            editable: true
        }

        QQC2.CheckBox {
            id: meridiemBold
            text: i18n("Bold")
        }
    }

    QQC2.SpinBox {
        id: lineSpacing
        from: 0
        to: 24
        editable: true
        Kirigami.FormData.label: i18n("Line spacing:")
    }

    QQC2.SpinBox {
        id: horizontalPadding
        from: 0
        to: 32
        editable: true
        enabled: useHorizontalLayout
        Kirigami.FormData.label: i18n("Left/right padding (width):")

        MouseArea {
            anchors.fill: parent
            enabled: !parent.enabled
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            QQC2.ToolTip.delay: 300
            QQC2.ToolTip.visible: containsMouse
            QQC2.ToolTip.text: horizontalPaddingHint
        }
    }

    QQC2.SpinBox {
        id: verticalPadding
        from: 0
        to: 32
        editable: true
        enabled: useVerticalLayout
        Kirigami.FormData.label: i18n("Top/bottom padding (height):")

        MouseArea {
            anchors.fill: parent
            enabled: !parent.enabled
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            QQC2.ToolTip.delay: 300
            QQC2.ToolTip.visible: containsMouse
            QQC2.ToolTip.text: verticalPaddingHint
        }
    }
}
