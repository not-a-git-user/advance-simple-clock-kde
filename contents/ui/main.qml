import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    property date currentTime: new Date()
    readonly property bool panelIsVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property int layoutMode: plasmoid.configuration.layoutMode
    readonly property bool useVerticalClock: layoutMode === 1 ? true : (layoutMode === 2 ? false : panelIsVertical)
    readonly property bool useCustomPartStyles: plasmoid.configuration.useCustomPartStyles
    readonly property bool autoScaleWithPanel: plasmoid.configuration.autoScaleWithPanel
    readonly property bool showMeridiem: !plasmoid.configuration.use24h && plasmoid.configuration.showMeridiem
    readonly property int separatorMode: plasmoid.configuration.separatorMode

    function twoDigits(number) {
        return number < 10 ? "0" + number : "" + number
    }

    function displayHour(dateObject) {
        var hour = dateObject.getHours()
        if (!plasmoid.configuration.use24h) {
            hour = hour % 12
            if (hour === 0) {
                hour = 12
            }
        }
        return twoDigits(hour)
    }

    function period(dateObject) {
        if (plasmoid.configuration.use24h) {
            return ""
        }
        return dateObject.getHours() >= 12 ? "PM" : "AM"
    }

    function separatorText() {
        if (separatorMode === 1) {
            return ""
        }
        if (separatorMode === 2) {
            return "/"
        }
        return ":"
    }

    function scaledBaseFontSize() {
        var panelThickness = panelIsVertical ? root.width : root.height
        if (panelThickness <= 0) {
            return plasmoid.configuration.fontPixelSize
        }

        var scaled = Math.round(panelThickness * 0.62)
        return Math.max(8, Math.min(120, scaled))
    }

    function baseFontSize() {
        if (autoScaleWithPanel) {
            return root.scaledBaseFontSize()
        }

        return plasmoid.configuration.fontPixelSize
    }

    function partFontSize(partName) {
        if (!useCustomPartStyles) {
            return root.baseFontSize()
        }

        if (partName === "hour") {
            return plasmoid.configuration.hourFontPixelSize
        }
        if (partName === "minute") {
            return plasmoid.configuration.minuteFontPixelSize
        }
        if (partName === "second") {
            return plasmoid.configuration.secondFontPixelSize
        }
        if (partName === "meridiem") {
            return plasmoid.configuration.meridiemFontPixelSize
        }

        return plasmoid.configuration.fontPixelSize
    }

    function partBold(partName) {
        if (!useCustomPartStyles) {
            return partName === "hour" || partName === "minute"
        }

        if (partName === "hour") {
            return plasmoid.configuration.hourBold
        }
        if (partName === "minute") {
            return plasmoid.configuration.minuteBold
        }
        if (partName === "second") {
            return plasmoid.configuration.secondBold
        }
        if (partName === "meridiem") {
            return plasmoid.configuration.meridiemBold
        }

        return false
    }

    function nextTickInterval() {
        if (plasmoid.configuration.showSeconds) {
            return 1000
        }

        var now = new Date()
        var remainingMs = (60 - now.getSeconds()) * 1000 - now.getMilliseconds()
        return Math.max(50, remainingMs)
    }

    function refreshClock() {
        root.currentTime = new Date()
        clockTimer.interval = root.nextTickInterval()
        clockTimer.start()
    }

    Timer {
        id: clockTimer
        repeat: false
        onTriggered: root.refreshClock()
    }

    Connections {
        target: plasmoid.configuration

        function onShowSecondsChanged() {
            root.refreshClock()
        }
    }

    Component {
        id: clockComponent

        Item {
            id: representation

            readonly property int horizontalPad: plasmoid.configuration.horizontalPadding
            readonly property int verticalPad: plasmoid.configuration.verticalPadding
            readonly property int activeHorizontalPad: root.useVerticalClock ? 0 : horizontalPad
            readonly property int activeVerticalPad: root.useVerticalClock ? verticalPad : 0

            implicitWidth: contentItem.implicitWidth + activeHorizontalPad * 2
            implicitHeight: contentItem.implicitHeight + activeVerticalPad * 2

            // Match panel orientation: constrain the panel's main axis to content size.
            Layout.minimumWidth: root.panelIsVertical ? 0 : implicitWidth
            Layout.preferredWidth: implicitWidth
            Layout.maximumWidth: root.panelIsVertical ? Infinity : implicitWidth

            Layout.minimumHeight: root.panelIsVertical ? implicitHeight : 0
            Layout.preferredHeight: implicitHeight
            Layout.maximumHeight: root.panelIsVertical ? implicitHeight : Infinity

            Loader {
                id: contentItem
                anchors.centerIn: parent
                sourceComponent: root.useVerticalClock ? verticalClock : horizontalClock
            }
        }
    }

    Component {
        id: verticalClock

        Column {
            spacing: plasmoid.configuration.lineSpacing

            PlasmaComponents3.Label {
                text: root.displayHour(root.currentTime)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: root.partFontSize("hour")
                font.bold: root.partBold("hour")
            }

            PlasmaComponents3.Label {
                text: root.twoDigits(root.currentTime.getMinutes())
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: root.partFontSize("minute")
                font.bold: root.partBold("minute")
            }

            PlasmaComponents3.Label {
                visible: plasmoid.configuration.showSeconds
                text: root.twoDigits(root.currentTime.getSeconds())
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: root.partFontSize("second")
                font.bold: root.partBold("second")
            }

            PlasmaComponents3.Label {
                visible: root.showMeridiem
                text: root.period(root.currentTime)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: root.partFontSize("meridiem")
                font.bold: root.partBold("meridiem")
            }
        }
    }

    Component {
        id: horizontalClock

        RowLayout {
            property string separator: root.separatorText()
            readonly property int numberGap: Math.max(2, Math.round(root.partFontSize("minute") * 0.2))
            spacing: Math.max(0, plasmoid.configuration.lineSpacing)

            PlasmaComponents3.Label {
                text: root.displayHour(root.currentTime)
                font.pixelSize: root.partFontSize("hour")
                font.bold: root.partBold("hour")
                Layout.alignment: Qt.AlignVCenter
            }

            PlasmaComponents3.Label {
                visible: parent.separator !== ""
                text: parent.separator
                font.pixelSize: root.partFontSize("hour")
                font.bold: root.partBold("hour")
                Layout.alignment: Qt.AlignVCenter
            }

            PlasmaComponents3.Label {
                text: root.twoDigits(root.currentTime.getMinutes())
                font.pixelSize: root.partFontSize("minute")
                font.bold: root.partBold("minute")
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: parent.separator === "" ? parent.numberGap : 0
            }

            PlasmaComponents3.Label {
                visible: plasmoid.configuration.showSeconds && parent.separator !== ""
                text: parent.separator
                font.pixelSize: root.partFontSize("minute")
                font.bold: root.partBold("minute")
                Layout.alignment: Qt.AlignVCenter
            }

            PlasmaComponents3.Label {
                visible: plasmoid.configuration.showSeconds
                text: root.twoDigits(root.currentTime.getSeconds())
                font.pixelSize: root.partFontSize("second")
                font.bold: root.partBold("second")
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: parent.separator === "" ? parent.numberGap : 0
            }

            PlasmaComponents3.Label {
                visible: root.showMeridiem
                text: root.period(root.currentTime)
                font.pixelSize: root.partFontSize("meridiem")
                font.bold: root.partBold("meridiem")
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: parent.separator === "" && root.showMeridiem ? parent.numberGap : 0
            }
        }
    }

    Component.onCompleted: root.refreshClock()

    compactRepresentation: clockComponent
    fullRepresentation: clockComponent
}
