// Modified by ChaeumAI Inc. (2026-11-19) for Chaeum Drive. See CHAEUM-CHANGES.md.
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
#include "expandingheaderview.h"
#include "models.h"

#include "configfile.h"

#include <QAbstractItemView>
#include <QApplication>

#include <algorithm>
#include <QMenu>

using namespace OCC;

ExpandingHeaderView::ExpandingHeaderView(const QString &objectName, QWidget *parent)
    : QHeaderView(Qt::Horizontal, parent)
{
    setSectionsClickable(true);
    setHighlightSections(true);
    setDefaultAlignment(Qt::AlignLeft | Qt::AlignVCenter);
    setResizeToContent(true);

    connect(this, &QHeaderView::sectionCountChanged, this, [this] { resizeColumns(false); });

    setObjectName(objectName);
    ConfigFile cfg;
    if (!cfg.restoreGeometryHeader(this)) {
        _requiresReset = true;
    }
}

ExpandingHeaderView::~ExpandingHeaderView()
{
    ConfigFile cfg;
    cfg.saveGeometryHeader(this);
}

int ExpandingHeaderView::expandingColumn() const
{
    return _expandingColumn;
}

void ExpandingHeaderView::setExpandingColumn(int newExpandingColumn)
{
    _expandingColumn = newExpandingColumn;
}

void ExpandingHeaderView::resizeEvent(QResizeEvent *event)
{
    QHeaderView::resizeEvent(event);
    resizeColumns();
}

bool ExpandingHeaderView::resizeToContent() const
{
    return _resizeToContent;
}

void ExpandingHeaderView::setResizeToContent(bool newResizeToContent)
{
    _resizeToContent = newResizeToContent;
}

void ExpandingHeaderView::setNarrowColumns(const QSet<int> &columns)
{
    _narrowColumns = columns;
}

void ExpandingHeaderView::setModel(QAbstractItemModel *newModel)
{
    QHeaderView::setModel(newModel);
    if (newModel) {
        // fit the columns once the first rows arrive
        connect(newModel, &QAbstractItemModel::rowsInserted, this, [this] {
            // new rows can be wider, measure again on the next layout
            _contentWidths.clear();
            if (_requiresReset) {
                resizeColumns(false);
            }
        });
    }
}

int ExpandingHeaderView::contentWidth(int section)
{
    auto it = _contentWidths.constFind(section);
    if (it != _contentWidths.cend()) {
        return *it;
    }
    if (!model() || model()->rowCount() == 0) {
        return 0;
    }
    // the same measure QHeaderView::ResizeToContents uses
    int width = sectionSizeHint(section);
    if (auto view = qobject_cast<QAbstractItemView *>(parentWidget())) {
        width = std::max(width, view->sizeHintForColumn(section));
    }
    _contentWidths.insert(section, width);
    return width;
}

void ExpandingHeaderView::resizeColumns(bool reset)
{
    int availableWidth = width();
    const auto defaultSize = defaultSectionSize();
    if (_requiresReset && _resizeToContent) {
        // wee need some rows to adjust to the content
        if (model() && model()->rowCount() > 0) {
            reset = true;
        }
    }
    if (reset) {
        _requiresReset = false;
        _contentWidths.clear();
        _laidOutWidths.clear();
        if (_resizeToContent) {
            resizeSections(QHeaderView::ResizeToContents);
            for (int i = 0; i < count(); ++i) {
                _contentWidths.insert(i, sectionSize(i));
            }
        }
    }
    for (int i = 0; i < count(); ++i) {
        if (i == _expandingColumn || isSectionHidden(i)) {
            continue;
        }
        // fit the content, but keep the expanding column (file name) the widest
        const int maxSize = _narrowColumns.contains(i) ? defaultSize : std::max(defaultSize, width() / 4);
        const bool laidOut = _laidOutWidths.value(i, sectionSize(i)) == sectionSize(i);
        if (reset) {
            resizeSection(i, _resizeToContent ? std::clamp(sectionSize(i), defaultSize / 2, maxSize) : defaultSize);
        } else if (_resizeToContent && laidOut) {
            // a column cut off while the view was small grows back to its content once there is room
            const int wanted = std::min(contentWidth(i), maxSize);
            if (wanted > sectionSize(i)) {
                resizeSection(i, wanted);
            }
        }
        if (reset || laidOut) {
            _laidOutWidths.insert(i, sectionSize(i));
        }
        availableWidth -= sectionSize(i);
    }
    resizeSection(_expandingColumn, availableWidth);
}

void ExpandingHeaderView::addResetActionToMenu(QMenu *menu)
{
    menu->addAction(tr("Reset column sizes"), this, [this] {
        resizeColumns(true);
    });
}
