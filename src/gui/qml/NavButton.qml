// Sidebar entry of the Chaeum Drive main window (ChaeumAI Inc., 2026-11-18).
// Selected: white pill with a brand bar on the left; the bar keeps its place when not selected.
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import eu.OpenCloud.gui 1.0

AbstractButton {
    id: control

    // remixicon glyph, or empty when `leading` is used
    property string glyph: ""
    property string subtitle: ""
    property Component leading: null
    property Component trailing: null

    implicitHeight: subtitle !== "" ? 52 : 40
    implicitWidth: 200
    hoverEnabled: true
    focusPolicy: Qt.TabFocus

    background: Rectangle {
        radius: 8
        color: control.checked ? Style.surface : (control.hovered ? "#e6eaf0" : "transparent")
        border.width: control.visualFocus ? 2 : (control.checked ? 1 : 0)
        border.color: control.visualFocus ? Style.brand : Style.line

        Rectangle {
            x: 4
            width: 3
            height: parent.height - 22
            anchors.verticalCenter: parent.verticalCenter
            radius: 2
            color: control.checked ? Style.brand : "transparent"
        }
    }

    contentItem: RowLayout {
        spacing: 10
        opacity: control.enabled ? 1 : 0.5

        Item {
            Layout.leftMargin: 6
            Layout.preferredWidth: control.leading ? 28 : 18
            Layout.preferredHeight: control.leading ? 28 : 18

            Image {
                anchors.fill: parent
                visible: !control.leading
                source: control.glyph !== "" ? OCUtils.resourcePath("remixicons", control.glyph, true, 0, control.checked ? Style.brand : Style.text2) : ""
                sourceSize.width: 36
                sourceSize.height: 36
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
            Loader {
                anchors.fill: parent
                sourceComponent: control.leading
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Label {
                Layout.fillWidth: true
                text: control.text
                color: Style.text
                font.weight: control.subtitle !== "" || control.checked ? Font.DemiBold : Font.Normal
                elide: Text.ElideRight
            }
            Label {
                Layout.fillWidth: true
                visible: control.subtitle !== ""
                text: control.subtitle
                color: Style.text3
                font.pointSize: 8.5
                elide: Text.ElideRight
            }
        }

        Loader {
            Layout.rightMargin: 4
            sourceComponent: control.trailing
        }
    }
}
