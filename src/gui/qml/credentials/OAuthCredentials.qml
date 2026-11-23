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

Credentials {
    readonly property QmlOAuthCredentials credentials: ocContext
    readonly property OCQuickWidget widget: ocQuickWidget

    Label {
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: 380
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: credentials.isValid ? Style.text2 : Style.bad
        text: credentials.isValid ? qsTr("Finish logging in in the browser window. This window continues by itself.") : qsTr("Login failed, please try it again")
    }

    StackLayout {
        id: stackLayout
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 14
        Layout.fillWidth: false
        Layout.fillHeight: false
        currentIndex: credentials.isValid ? 0 : 1
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            ChaeumButton {
                id: openBrowserButton
                Layout.preferredWidth: 260
                Layout.preferredHeight: 40
                property bool browserWasOpened: false
                primary: !browserWasOpened
                enabled: credentials.ready
                visible: credentials.isValid
                glyph: Style.iconExternal
                text: browserWasOpened ? qsTr("Reopen web browser") : qsTr("Open web browser")
                onClicked: {
                    browserWasOpened = true;
                    credentials.openAuthenticationUrlInBrowser();
                }
                Keys.onBacktabPressed: {
                    widget.parentFocusWidget.focusPrevious();
                }
            }

            ChaeumButton {
                id: copyToClipboardButton
                Layout.preferredWidth: 260
                Layout.preferredHeight: 40
                visible: credentials.isValid

                text: qsTr("Copy URL")
                glyph: Style.iconCopy
                onClicked: credentials.copyAuthenticationUrlToClipboard()
                enabled: credentials.ready

                hoverEnabled: true
                ToolTip.text: qsTr("Copy the login address to open it in another browser")
                ToolTip.visible: hovered
                ToolTip.delay: 500

                Keys.onTabPressed: event => {
                    // there is no logout button
                    if (!credentials.isRefresh) {
                        widget.parentFocusWidget.focusNext();
                    } else {
                        event.accepted = false;
                    }
                }
            }

            Loader {
                Layout.preferredWidth: 260
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: logOutButton
            }
        }

        ColumnLayout {
            spacing: 8
            ChaeumButton {
                id: restartButton
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 260
                Layout.preferredHeight: 40
                visible: !credentials.isValid
                primary: true
                glyph: Style.iconSync
                text: qsTr("Restart authentication")
                onClicked: credentials.requestRestart()
            }
            Loader {
                Layout.preferredWidth: 260
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: logOutButton
            }
        }
    }

    Connections {
        target: widget

        function onFocusFirst() {
            stackLayout.nextItemInFocusChain(true).forceActiveFocus(Qt.TabFocusReason);
        }
    }
}
