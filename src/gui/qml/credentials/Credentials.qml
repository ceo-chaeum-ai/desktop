// Modified by ChaeumAI Inc. (2026-11-18) for Chaeum Drive. See CHAEUM-CHANGES.md.
/*
 * Copyright (C) by Hannah von Reth <hannah.vonreth@owncloud.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 */

import QtQuick

// specifically use the basic style, as we modify the palette
import QtQuick.Controls.Basic
import QtQuick.Layouts

import eu.OpenCloud.resources 1.0
import eu.OpenCloud.gui 1.0
import eu.OpenCloud.libsync 1.0

Pane {
    id: credentialsView

    //TODO
    //required property QmlCredentials credentials
    readonly property OCQuickWidget widget: ocQuickWidget

    default property alias content: contentLayout.data
    property alias logOutButton: logutButtonComponent

    // Chaeum Drive (2026-11-18): light page that matches the main window
    background: Rectangle {
        color: Style.bg
    }
    palette.windowText: Style.text
    font.family: "Pretendard"

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Component {
        id: logutButtonComponent

        ChaeumButton {
            id: logOutButton
            // this button is hidden when used in the wizard
            visible: credentials.isRefresh
            text: qsTr("Stay logged out")
            onClicked: credentials.logOutRequested()

            Keys.onTabPressed: event => {
                if (!visible) {
                    event.accepted = false;
                } else {
                    widget.parentFocusWidget.focusNext();
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        Item {
            Layout.fillHeight: true
        }

        Image {
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: OCUtils.resourcePath("jsontheme", "wizardLogo", true)
            sourceSize.height: 72
            sourceSize.width: 72
        }

        Item {
            Layout.preferredHeight: 18
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("Log in with your web browser")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 22
            font.weight: Font.Bold
            color: Style.text
        }

        Label {
            Layout.fillWidth: true
            Layout.topMargin: 6
            text: credentials.isRefresh ? qsTr("%1 on %2").arg(credentials.displayName).arg(credentials.host) : credentials.host
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            color: Style.text3
        }

        Item {
            Layout.preferredHeight: 22
        }

        ColumnLayout {
            id: contentLayout
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Connections {
        target: widget

        function onFocusLast() {
            if (logOutButton.visible) {
                logOutButton.forceActiveFocus(Qt.TabFocusReason);
            } else {
                logOutButton.nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocusReason);
            }
        }
    }
}
