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
import QtQuick.Controls
import QtQuick.Layouts
import eu.OpenCloud.gui 1.0
import eu.OpenCloud.libsync 1.0
import eu.OpenCloud.resources 1.0

// Chaeum Drive: the navigation is a sidebar on the left (ChaeumAI Inc., 2026-11-18).
// Same entries as the original top bar: accounts, add account, activity, settings, theme url buttons, quit.
Pane {
    id: bar
    readonly property SettingsDialog settingsDialog: ocContext
    readonly property OCQuickWidget widget: ocQuickWidget

    Accessible.name: qsTr("Navigation bar")

    LayoutMirroring.enabled: Qt.application.layoutDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding: 10
    topPadding: 8
    background: Rectangle {
        color: Style.side
    }

    Component.onCompleted: {
        if (OCUtils.compareQVersion(6, 8, 3) >= 0) {
            ToolTip.toolTip.popupType = Popup.Native;
        }
    }

    Connections {
        target: widget

        function onFocusFirst() {
            if (accountButtons.count === 0) {
                addAccountButton.forceActiveFocus(Qt.TabFocusReason);
            } else {
                accountButtons.itemAt(0).forceActiveFocus(Qt.TabFocusReason);
            }
        }

        function onFocusLast() {
            quitButton.forceActiveFocus(Qt.TabFocusReason);
        }
    }

    component SectionLabel: Label {
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.topMargin: 10
        Layout.bottomMargin: 4
        color: Style.text3
        font.pointSize: 8.5
        font.weight: Font.DemiBold
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 2

        // don't modify the enabled state directly as it messes with the palette in Qt 6.7.2
        opacity: widget.enabled ? 1.0 : 0.5

        SectionLabel {
            text: qsTr("Accounts")
        }

        Repeater {
            id: accountButtons

            model: AccountManager.accounts

            delegate: NavButton {
                id: accountButton
                property AccountState accountState: modelData
                readonly property bool hasAvatar: accountState.account.hasAvatar

                Layout.fillWidth: true
                Accessible.role: Accessible.PageTab
                checked: settingsDialog.currentAccount === accountState.account
                text: accountState.account.davDisplayName !== "" ? accountState.account.davDisplayName : accountState.account.hostName
                subtitle: accountState.account.hostName

                leading: Component {
                    Item {
                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: Style.brandSoft
                            visible: !accountButton.hasAvatar
                            Label {
                                anchors.centerIn: parent
                                text: accountButton.accountState.account.initials
                                color: Style.brandSoftText
                                font.pointSize: 8
                                font.weight: Font.Bold
                            }
                        }
                        Image {
                            id: avatarImage
                            anchors.fill: parent
                            visible: accountButton.hasAvatar
                            cache: false
                            source: accountButton.hasAvatar ? OCUtils.avatarPath(accountButton.accountState.account.uid, true) : ""
                            sourceSize.width: 56
                            sourceSize.height: 56
                            Connections {
                                target: accountButton.accountState.account
                                function onAvatarChanged() {
                                    avatarImage.source = "";
                                    if (accountButton.accountState.account.hasAvatar) {
                                        avatarImage.source = OCUtils.avatarPath(accountButton.accountState.account.uid, true);
                                    }
                                }
                            }
                        }
                    }
                }
                trailing: Component {
                    Rectangle {
                        implicitWidth: 8
                        implicitHeight: 8
                        radius: 4
                        color: accountButton.accountState.state === AccountState.Connected ? Style.okDot : "#c0c8d3"
                    }
                }

                ToolTip.visible: hovered
                ToolTip.text: accountState.account.davDisplayName + "\n" + accountState.account.url
                ToolTip.delay: 500

                Accessible.name: accountState.account.displayNameWithHost
                Accessible.onPressAction: {
                    clicked();
                }

                Keys.onBacktabPressed: event => {
                    if (index === 0) {
                        // We're the first button, handle the back-tab
                        widget.parentFocusWidget.focusPrevious();
                    } else {
                        event.accepted = false;
                    }
                }
                onClicked: {
                    settingsDialog.currentAccount = accountState.account;
                }
            }
        }
        NavButton {
            id: addAccountButton

            Layout.fillWidth: true
            glyph: Style.iconAdd
            text: qsTr("Add Account")
            visible: JsonTheme.multiAccount || AccountManager.accounts.length === 0

            Keys.onBacktabPressed: event => {
                // If there are no account buttons, we're the first button, so handle the back-tab
                if (accountButtons.count === 0) {
                    widget.parentFocusWidget.focusPrevious();
                } else {
                    event.accepted = false;
                }
            }
            onClicked: {
                settingsDialog.addAccount();
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            implicitHeight: 1
            color: Style.lineStrong
        }

        NavButton {
            id: logButton

            Layout.fillWidth: true
            Accessible.role: Accessible.PageTab
            Accessible.onPressAction: {
                clicked();
            }
            checked: settingsDialog.currentPage === SettingsDialog.Activity
            glyph: Style.iconActivity
            text: qsTr("Activity")

            onClicked: {
                settingsDialog.currentPage = SettingsDialog.Activity;
            }
        }
        NavButton {
            id: settingsButton

            Layout.fillWidth: true
            Accessible.role: Accessible.PageTab
            Accessible.onPressAction: {
                clicked();
            }
            checked: settingsDialog.currentPage === SettingsDialog.Settings
            glyph: Style.iconSettings
            text: qsTr("Settings")

            onClicked: {
                settingsDialog.currentPage = SettingsDialog.Settings;
            }
        }
        Repeater {
            // branded buttons with a URL
            model: JsonTheme.urlButtons

            delegate: NavButton {
                required property int index
                required property urlButton modelData

                Layout.fillWidth: true
                leading: Component {
                    Image {
                        source: OCUtils.resourcePath("urlbutton", index, true)
                        sourceSize.width: 36
                        sourceSize.height: 36
                        fillMode: Image.PreserveAspectFit
                    }
                }
                text: modelData.text

                onClicked: {
                    Qt.openUrlExternally(modelData.url);
                }
            }
        }
        Item {
            // spacer
            Layout.fillHeight: true
        }
        NavButton {
            id: quitButton

            Layout.fillWidth: true
            glyph: Style.iconPower
            text: qsTr("Quit")

            Keys.onTabPressed: {
                widget.parentFocusWidget.focusNext();
            }
            onClicked: {
                Qt.quit();
            }
        }
    }
}
