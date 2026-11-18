/*
 * Chaeum Drive button (2026-11-18): white outline by default, soft blue with `soft`, solid blue with `primary`.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import eu.OpenCloud.gui 1.0

Button {
    id: btn
    property bool soft: false
    property bool primary: false
    property string glyph: ""
    property bool trailingChevron: false

    readonly property color fg: primary ? "#ffffff" : (soft ? Style.brandSoftText : Style.text)

    implicitHeight: 32
    leftPadding: 14
    rightPadding: 14
    font.weight: Font.DemiBold

    contentItem: RowLayout {
        spacing: 6
        opacity: btn.enabled ? 1 : 0.55
        Item {
            Layout.fillWidth: true
        }
        Image {
            visible: btn.glyph !== ""
            Layout.preferredWidth: 15
            Layout.preferredHeight: 15
            source: btn.glyph !== "" ? OCUtils.resourcePath("remixicons", btn.glyph, true, 0, btn.fg) : ""
            sourceSize.width: 30
            sourceSize.height: 30
        }
        Label {
            text: btn.text
            font: btn.font
            color: btn.fg
        }
        Image {
            visible: btn.trailingChevron
            Layout.preferredWidth: 14
            Layout.preferredHeight: 14
            source: OCUtils.resourcePath("remixicons", Style.iconDown, true, 0, btn.primary ? "#ffffff" : Style.text3)
            sourceSize.width: 28
            sourceSize.height: 28
        }
        Item {
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        radius: Style.radiusSmall
        color: btn.primary ? (btn.down || btn.hovered ? Style.brandStrong : Style.brand)
             : btn.soft ? (btn.down ? "#d9e5fc" : (btn.hovered ? "#dfe8fd" : Style.brandSoft))
             : (btn.down ? "#eef1f5" : (btn.hovered ? "#f5f7fa" : Style.surface))
        border.width: btn.visualFocus ? 2 : ((btn.soft || btn.primary) ? 0 : 1)
        border.color: btn.visualFocus ? (btn.primary ? Style.brandStrong : Style.brand) : Style.lineStrong
    }
}
