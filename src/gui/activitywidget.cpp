// Modified by ChaeumAI Inc. (2026-11-18) for Chaeum Drive. See CHAEUM-CHANGES.md.
/*
 * Copyright (C) by Klaas Freitag <freitag@owncloud.com>
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

#include "activitywidget.h"


#include "issueswidget.h"
#include "protocolwidget.h"
#include "resources/fonticon.h"
#include "theme.h"

#include <QtGui>
#include <QtWidgets>


using namespace std::chrono;
using namespace std::chrono_literals;


namespace OCC {

ActivitySettings::ActivitySettings(QWidget *parent)
    : QWidget(parent)
{
    // Chaeum Drive (2026-11-18): page title and the same margins as the settings page
    auto *vbox = new QVBoxLayout(this);
    vbox->setContentsMargins(32, 24, 32, 24);
    vbox->setSpacing(14);
    auto *title = new QLabel(tr("Activity"), this);
    title->setProperty("chaeumRole", QStringLiteral("title"));
    vbox->addWidget(title);

    // create a tab widget for the activity views
    _tab = new QTabWidget(this);
    _tab->setDocumentMode(true);
    vbox->addWidget(_tab);

    _protocolWidget = new ProtocolWidget(this);
    _tab->addTab(_protocolWidget, tr("Local Activity"));

    _issuesWidget = new IssuesWidget(this);
    const int issueTabId = _tab->addTab(_issuesWidget, tr("Not Synced"));
    connect(_issuesWidget, &IssuesWidget::issueCountUpdated, this, [issueTabId, this](int issueCount) {
        QString cntText = tr("Not Synced");
        if (issueCount) {
            //: %1 is the number of not synced files.
            cntText = tr("Not Synced (%1)").arg(issueCount);
        }
        _tab->setTabText(issueTabId, cntText);
    });
}

void ActivitySettings::slotShowIssuesTab()
{
    _tab->setCurrentWidget(_issuesWidget);
}

ActivitySettings::~ActivitySettings()
{
}
}
