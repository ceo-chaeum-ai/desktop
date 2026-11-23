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
#pragma once

#include <QHash>
#include <QHeaderView>
#include <QSet>

namespace OCC {

class ExpandingHeaderView : public QHeaderView
{
    Q_OBJECT
public:
    ExpandingHeaderView(const QString &objectName, QWidget *parent = nullptr);
    ~ExpandingHeaderView();

    int expandingColumn() const;
    void setExpandingColumn(int newExpandingColumn);

    void resizeColumns(bool reset = false);
    void addResetActionToMenu(QMenu *menu);

    bool resizeToContent() const;
    void setResizeToContent(bool newResizeToContent);

    void setModel(QAbstractItemModel *model) override;

    // columns that never grow past the default size when fitted to content (long paths)
    void setNarrowColumns(const QSet<int> &columns);

protected:
    void resizeEvent(QResizeEvent *event) override;

    // the width the content of a column needs, measured once rows are there
    int contentWidth(int section);

private:
    bool _requiresReset = false;
    bool _resizeToContent = false;
    int _expandingColumn = 0;
    QSet<int> _narrowColumns;
    QHash<int, int> _contentWidths;
    // the widths the last layout gave, a column changed since then was sized by hand
    QHash<int, int> _laidOutWidths;
};

}
