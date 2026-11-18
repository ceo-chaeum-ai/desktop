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
import QtQuick.Effects
import QtQuick.Layouts
import eu.OpenCloud.gui 1.0
import eu.OpenCloud.libsync 1.0
import eu.OpenCloud.resources 1.0

// Chaeum Drive account page (ChaeumAI Inc., 2026-11-18).
// Head row [title, count ... connection badge, Manage Account, Add Space], then one card per synced space.
// Each card keeps three fixed rows on the right (state, bar, detail) so progress never moves the layout.
Pane {
    id: folderSyncPanel
    readonly property AccountSettings accountSettings: ocContext
    readonly property OCQuickWidget widget: ocQuickWidget
    readonly property bool connected: accountSettings.accountState.state === AccountState.Connected

    spacing: 8
    leftPadding: 28
    rightPadding: 28
    topPadding: 20
    bottomPadding: 16

    background: Rectangle {
        color: Style.bg
    }

    Accessible.role: Accessible.List
    Accessible.name: qsTr("Folder Sync")

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Connections {
        target: widget

        function onFocusFirst() {
            manageAccountButton.forceActiveFocus(Qt.TabFocusReason);
        }

        function onFocusLast() {
            if (listView.currentItem) {
                listView.currentItem.forceActiveFocus(Qt.TabFocusReason);
            } else {
                addSyncButton.forceActiveFocus(Qt.TabFocusReason);
            }
        }
    }

    // For some reason layout mirroring doesn't propagate down to a Menu's children, so we have to force it for every MenuItem
    component OCMenuItem: MenuItem {
        id: menuItem
        property string glyph: ""
        property bool danger: false
        LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
        implicitHeight: visible ? 34 : 0
        leftPadding: 10
        rightPadding: 16
        contentItem: RowLayout {
            spacing: 10
            Image {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                source: menuItem.glyph !== "" ? OCUtils.resourcePath("remixicons", menuItem.glyph, menuItem.enabled, 0, menuItem.danger ? Style.bad : Style.text2) : ""
                sourceSize.width: 32
                sourceSize.height: 32
            }
            Label {
                Layout.fillWidth: true
                text: menuItem.text
                color: !menuItem.enabled ? "#a3adba" : (menuItem.danger ? Style.bad : Style.text)
                elide: Text.ElideRight
            }
        }
        background: Rectangle {
            radius: 6
            color: menuItem.highlighted ? Style.hover : "transparent"
        }
    }

    component OCMenu: Menu {
        padding: 5
        background: Rectangle {
            implicitWidth: 230
            radius: 10
            color: Style.surface
            border.color: Style.line
        }
    }

    component OCMenuSeparator: MenuSeparator {
        topPadding: 4
        bottomPadding: 4
        contentItem: Rectangle {
            implicitHeight: 1
            color: Style.line
        }
    }

    // soft brand button, outline button
    component OCButton: ChaeumButton {}

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.minimumHeight: 36
            spacing: 12

            Label {
                text: qsTr("Spaces")
                color: Style.text
                font.pointSize: 15
                font.weight: Font.Bold
            }
            Label {
                // empty while not connected: the counts are not known then
                text: folderSyncPanel.connected ? qsTr("%1 of %2 synced").arg(accountSettings.syncedSpaces).arg(accountSettings.syncedSpaces + accountSettings.unsyncedSpaces) : ""
                color: Style.text3
                font.pointSize: 9.5
            }
            Item {
                Layout.fillWidth: true
            }

            // connection state: state colour, not clickable
            Rectangle {
                id: badge
                readonly property bool good: folderSyncPanel.connected
                readonly property bool busy: accountSettings.accountState.state === AccountState.Connecting
                implicitHeight: 24
                implicitWidth: badgeRow.implicitWidth + 20
                radius: 12
                color: good ? Style.okSoft : (busy ? Style.warnSoft : Style.badSoft)
                RowLayout {
                    id: badgeRow
                    anchors.centerIn: parent
                    spacing: 6
                    Rectangle {
                        implicitWidth: 7
                        implicitHeight: 7
                        radius: 4
                        color: badge.good ? Style.ok : (badge.busy ? Style.warn : Style.bad)
                    }
                    Label {
                        text: accountSettings.connectionLabel
                        color: badge.good ? Style.ok : (badge.busy ? Style.warn : Style.bad)
                        font.pointSize: 9
                        font.weight: Font.DemiBold
                    }
                }
            }

            OCButton {
                id: manageAccountButton
                text: qsTr("Manage Account")
                trailingChevron: true

                OCMenu {
                    id: accountMenu
                    y: manageAccountButton.height + 4
                    property bool shiftPressed: false

                    onAboutToShow: {
                        shiftPressed = OCUtils.hasKeyboardModifiers(Qt.ShiftModifier);
                    }

                    OCMenuItem {
                        glyph: accountSettings.accountState.state === AccountState.SignedOut ? Style.iconLogin : Style.iconLogout
                        text: accountSettings.accountState.state === AccountState.SignedOut ? qsTr("Log in") : qsTr("Log out")
                        onTriggered: accountSettings.slotToggleSignInState()
                    }
                    OCMenuItem {
                        glyph: Style.iconSync
                        text: qsTr("Reconnect")
                        enabled: accountSettings.accountState.state !== AccountState.SignedOut && accountSettings.accountState.state !== AccountState.Connected
                        onTriggered: accountSettings.accountState.checkConnectivity(true)
                    }
                    OCMenuItem {
                        glyph: Style.iconExternal
                        text: CommonStrings.showInWebBrowser()
                        onTriggered: Qt.openUrlExternally(accountSettings.accountState.account.url)
                    }
                    OCMenuItem {
                        glyph: Style.iconCopy
                        text: CommonStrings.copyUrlToClipBoard()
                        onTriggered: OCUtils.setClipBoard(accountSettings.accountState.account.url)
                        visible: accountMenu.shiftPressed
                        enabled: visible
                    }
                    OCMenuSeparator {}
                    OCMenuItem {
                        glyph: Style.iconDelete
                        danger: true
                        text: qsTr("Remove")
                        onTriggered: accountSettings.slotDeleteAccount()
                    }
                }

                onClicked: {
                    accountMenu.open();
                    Accessible.announce(qsTr("Account options Menu"));
                }

                Keys.onBacktabPressed: {
                    widget.parentFocusWidget.focusPrevious();
                }
            }

            OCButton {
                id: addSyncButton
                soft: true
                glyph: Style.iconAdd
                text: qsTr("Add Space")

                onClicked: {
                    accountSettings.slotAddFolder();
                }
                enabled: folderSyncPanel.connected && accountSettings.unsyncedSpaces

                Keys.onTabPressed: {
                    if (listView.currentItem) {
                        listView.currentItem.forceActiveFocus(Qt.TabFocusReason);
                    } else {
                        widget.parentFocusWidget.focusNext();
                    }
                }
            }
        }

        ScrollView {
            id: scrollView
            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            contentWidth: availableWidth

            clip: true

            ListView {
                id: listView
                focus: true
                boundsBehavior: Flickable.StopAtBounds

                model: accountSettings.model
                spacing: folderSyncPanel.spacing

                onCurrentItemChanged: {
                    if (currentItem) {
                        currentItem.forceActiveFocus(Qt.TabFocusReason);
                    }
                }

                delegate: FocusScope {
                    id: folderDelegate

                    implicitHeight: card.implicitHeight
                    width: scrollView.availableWidth - (scrollView.ScrollBar.vertical.visible ? 12 : 0)

                    required property string displayName
                    required property var errorMsg
                    required property Folder folder
                    required property string itemText
                    required property string overallText
                    required property double progress
                    required property string quota
                    required property string accessibleDescription
                    required property string statusIcon
                    required property string subtitle
                    required property string statusKind
                    required property string statusText
                    required property string localPath
                    required property double quotaFraction
                    // model index
                    required property int index

                    readonly property bool running: statusKind === "sync"
                    readonly property color stateColor: statusKind === "ok" ? Style.ok : (statusKind === "sync" ? Style.brand : (statusKind === "error" || statusKind === "problem" || statusKind === "offline" ? Style.bad : (statusKind === "paused" ? Style.warn : Style.text3)))
                    readonly property string stateGlyph: statusKind === "ok" ? Style.iconOk : (statusKind === "sync" ? Style.iconSync : (statusKind === "paused" ? Style.iconPause : (statusKind === "offline" ? Style.iconOffline : (statusKind === "waiting" ? Style.iconSync : Style.iconError))))

                    Pane {
                        id: card
                        anchors.left: parent.left
                        anchors.right: parent.right
                        implicitHeight: 76 + (folderDelegate.errorMsg.length ? errorBox.implicitHeight + 10 : 0)
                        padding: 0

                        Accessible.name: folderDelegate.accessibleDescription
                        Accessible.role: Accessible.ListItem

                        activeFocusOnTab: true
                        focus: true

                        background: Rectangle {
                            radius: Style.radius
                            color: Style.surface
                            border.width: card.visualFocus ? 2 : 1
                            border.color: card.visualFocus ? Style.brand : Style.line
                        }

                        Keys.onBacktabPressed: {
                            addSyncButton.forceActiveFocus(Qt.TabFocusReason);
                        }
                        Keys.onTabPressed: {
                            widget.parentFocusWidget.focusNext();
                        }
                        Keys.onSpacePressed: {
                            contextMenu.popup();
                        }

                        MouseArea {
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            anchors.fill: parent

                            onClicked: mouse => {
                                if (mouse.button === Qt.RightButton) {
                                    contextMenu.popup();
                                } else {
                                    folderDelegate.ListView.view.currentIndex = folderDelegate.index;
                                    folderDelegate.forceActiveFocus(Qt.TabFocusReason);
                                }
                            }
                            onDoubleClicked: OCUtils.showInFileManager(folderDelegate.folder.path)
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 8
                            spacing: 0

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 76
                                spacing: 14

                                // thumbnail: the space image, or our icon on a tinted square
                                Item {
                                    Layout.preferredWidth: 44
                                    Layout.preferredHeight: 44
                                    readonly property var spaceImage: folderDelegate.folder.space ? folderDelegate.folder.space.image : null
                                    readonly property bool custom: spaceImage !== null && spaceImage.isCustom
                                    readonly property string kind: spaceImage ? spaceImage.kind : "personal"

                                    Rectangle {
                                        id: thumbBg
                                        anchors.fill: parent
                                        radius: 10
                                        color: parent.kind === "shares" ? "#eaf3f0" : (parent.kind === "personal" ? Style.brandSoft : "#f3eedf")
                                    }
                                    Image {
                                        anchors.centerIn: parent
                                        width: 22
                                        height: 22
                                        visible: !parent.custom
                                        source: OCUtils.resourcePath("remixicons", parent.kind === "shares" ? Style.iconShared : Style.iconFolder, true, 0, parent.kind === "shares" ? "#2f7a63" : (parent.kind === "personal" ? Style.brand : "#8a6a1c"))
                                        sourceSize.width: 44
                                        sourceSize.height: 44
                                    }
                                    Image {
                                        id: thumbImage
                                        anchors.fill: parent
                                        visible: false
                                        fillMode: Image.PreserveAspectCrop
                                        source: parent.custom ? parent.spaceImage.qmlImageUrl : ""
                                        sourceSize.width: 88
                                        sourceSize.height: 88
                                    }
                                    Rectangle {
                                        id: thumbMask
                                        anchors.fill: parent
                                        radius: 10
                                        visible: false
                                        layer.enabled: true
                                    }
                                    MultiEffect {
                                        anchors.fill: parent
                                        visible: parent.custom
                                        source: thumbImage
                                        maskEnabled: true
                                        maskSource: thumbMask
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Label {
                                        Layout.fillWidth: true
                                        text: folderDelegate.displayName
                                        color: Style.text
                                        font.pointSize: 10.5
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        text: folderDelegate.localPath
                                        color: Style.text3
                                        font.pointSize: 9
                                        elide: Text.ElideMiddle
                                    }
                                }

                                // state column: three fixed rows
                                ColumnLayout {
                                    Layout.preferredWidth: 250
                                    Layout.maximumWidth: 250
                                    spacing: 5

                                    ToolTip.visible: stateHover.hovered && folderDelegate.itemText !== ""
                                    ToolTip.text: folderDelegate.itemText
                                    ToolTip.delay: 400
                                    HoverHandler {
                                        id: stateHover
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 18
                                        spacing: 6
                                        Image {
                                            Layout.preferredWidth: 15
                                            Layout.preferredHeight: 15
                                            source: OCUtils.resourcePath("remixicons", folderDelegate.stateGlyph, true, 0, folderDelegate.stateColor)
                                            sourceSize.width: 30
                                            sourceSize.height: 30
                                        }
                                        Label {
                                            Layout.fillWidth: true
                                            text: folderDelegate.statusText
                                            color: folderDelegate.statusKind === "ok" || folderDelegate.statusKind === "sync" || folderDelegate.statusKind === "waiting" ? Style.text2 : folderDelegate.stateColor
                                            font.pointSize: 9
                                            font.weight: folderDelegate.statusKind === "ok" || folderDelegate.statusKind === "waiting" ? Font.Normal : Font.DemiBold
                                            elide: Text.ElideRight
                                        }
                                        Label {
                                            text: folderDelegate.running ? Math.round(folderDelegate.progress * 100) + "%" : ""
                                            color: Style.text3
                                            font.pointSize: 9
                                        }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        implicitHeight: 6
                                        radius: 3
                                        color: Style.track
                                        Rectangle {
                                            readonly property double fraction: folderDelegate.running ? folderDelegate.progress : Math.max(0, folderDelegate.quotaFraction)
                                            width: parent.width * Math.min(1, fraction)
                                            height: parent.height
                                            radius: 3
                                            color: folderDelegate.running ? Style.brand : (folderDelegate.quotaFraction > 0.9 ? Style.warn : "#b9c4d3")
                                        }
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 16
                                        text: folderDelegate.running ? folderDelegate.overallText : folderDelegate.quota
                                        color: Style.text3
                                        font.pointSize: 8.5
                                        elide: Text.ElideRight
                                    }
                                }

                                ToolButton {
                                    id: moreButton
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    Accessible.name: qsTr("Sync options menu")
                                    focusPolicy: Qt.NoFocus
                                    background: Rectangle {
                                        radius: Style.radiusSmall
                                        color: moreButton.hovered || contextMenu.visible ? "#eef1f5" : "transparent"
                                    }
                                    contentItem: Image {
                                        source: OCUtils.resourcePath("remixicons", Style.iconMore, true, 0, Style.text2)
                                        sourceSize.width: 36
                                        sourceSize.height: 36
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    onClicked: contextMenu.popup(moreButton, moreButton.width - 230, moreButton.height + 4)
                                }
                            }

                            FolderError {
                                id: errorBox
                                Accessible.ignored: true
                                Layout.fillWidth: true
                                Layout.rightMargin: 6
                                Layout.bottomMargin: 10
                                visible: folderDelegate.errorMsg.length > 0
                                errorMessages: folderDelegate.errorMsg
                            }
                        }

                        OCMenu {
                            id: contextMenu
                            property bool shiftPressed: false

                            onAboutToShow: {
                                shiftPressed = OCUtils.hasKeyboardModifiers(Qt.ShiftModifier);
                            }

                            OCMenuItem {
                                glyph: Style.iconFolderOpen
                                text: CommonStrings.showInFileBrowser()
                                onTriggered: OCUtils.showInFileManager(folderDelegate.folder.path)
                            }

                            OCMenuItem {
                                glyph: Style.iconCopy
                                text: CommonStrings.copyFilePathToClipBoard()
                                onTriggered: OCUtils.setClipBoardFromFilePath(folderDelegate.folder.path)
                                visible: contextMenu.shiftPressed
                                enabled: visible
                            }

                            OCMenuItem {
                                glyph: Style.iconExternal
                                text: CommonStrings.showInWebBrowser()
                                onTriggered: Qt.openUrlExternally(folderDelegate.folder.webUrl)
                                enabled: folderDelegate.folder.webUrl
                            }

                            OCMenuItem {
                                glyph: Style.iconCopy
                                text: CommonStrings.copyUrlToClipBoard()
                                onTriggered: OCUtils.setClipBoard(folderDelegate.folder.webUrl)
                                visible: contextMenu.shiftPressed
                                enabled: folderDelegate.folder.webUrl && visible
                            }

                            OCMenuSeparator {}

                            OCMenuItem {
                                glyph: Style.iconSync
                                text: folderDelegate.folder.isSyncRunning ? qsTr("Restart sync") : qsTr("Force sync now")
                                enabled: accountSettings.accountState.state === AccountState.Connected && !folderDelegate.folder.isSyncPaused && visible
                                onTriggered: accountSettings.slotForceSyncCurrentFolder(folderDelegate.folder)
                                visible: folderDelegate.folder.isReady
                            }

                            OCMenuItem {
                                glyph: folderDelegate.folder.isSyncPaused ? Style.iconSync : Style.iconPause
                                text: folderDelegate.folder.isSyncPaused ? qsTr("Resume sync") : qsTr("Pause sync")
                                enabled: accountSettings.accountState.state === AccountState.Connected && visible
                                onTriggered: accountSettings.slotEnableCurrentFolder(folderDelegate.folder, true)
                                visible: folderDelegate.folder.isReady
                            }

                            OCMenuItem {
                                glyph: Style.iconChoose
                                text: qsTr("Choose what to sync")
                                onTriggered: accountSettings.showSelectiveSyncDialog(folderDelegate.folder)
                                visible: folderDelegate.folder.isReady && folderDelegate.folder.vfsMode !== 1
                                enabled: visible
                            }

                            OCMenuSeparator {
                                visible: removeItem.visible
                            }

                            OCMenuItem {
                                id: removeItem
                                glyph: Style.iconUnlink
                                danger: true
                                text: qsTr("Remove Space")
                                onTriggered: accountSettings.slotRemoveCurrentFolder(folderDelegate.folder)
                                visible: !folderDelegate.isDeployed
                                enabled: visible
                            }

                            onOpened: {
                                Accessible.announce(qsTr("Sync options menu"));
                            }
                        }
                    }
                }
            }
        }
    }
}
