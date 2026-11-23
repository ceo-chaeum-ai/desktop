/*
 * Chaeum Drive look: bundled Pretendard font, light palette and a global style sheet.
 * Added by ChaeumAI Inc. on 2026-11-18 for the Chaeum Drive fork of OpenCloud Desktop.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#include "gui/chaeumstyle.h"

#include <QApplication>
#include <QCheckBox>
#include <QFontDatabase>
#include <QLabel>
#include <QLoggingCategory>
#include <QMouseEvent>
#include <QPalette>
#include <QQuickStyle>
#include <QStyleFactory>
#include <QStyleHints>

Q_LOGGING_CATEGORY(lcChaeumStyle, "gui.chaeumstyle", QtInfoMsg)

using namespace Qt::Literals::StringLiterals;

namespace {

QString hex(const QColor &c)
{
    return c.name(QColor::HexRgb);
}

QString styleSheet()
{
    using namespace OCC::ChaeumStyle;
    QString qss = uR"(
QMainWindow, QDialog { background: @bg; }
QToolTip { background: @surface; color: @text; border: 1px solid @lineStrong; border-radius: 6px; padding: 5px 8px; }

QPushButton {
    background: @surface; color: @text; border: 1px solid @lineStrong; border-radius: 7px;
    padding: 0 14px; min-height: 30px; font-weight: 600;
}
QPushButton:hover { background: #f5f7fa; border-color: #c3ccd8; }
QPushButton:pressed { background: #eef1f5; }
QPushButton:focus { border-color: @brand; }
QPushButton:disabled { color: #a3adba; background: #f7f9fb; border-color: @line; }
QPushButton:default, QPushButton[chaeumRole="primary"] { background: @brand; color: #ffffff; border-color: @brand; }
QPushButton:default:hover, QPushButton[chaeumRole="primary"]:hover { background: @brandStrong; border-color: @brandStrong; }
QPushButton:default:disabled, QPushButton[chaeumRole="primary"]:disabled { background: #b9c9f5; border-color: #b9c9f5; color: #ffffff; }
QPushButton[chaeumRole="soft"] { background: @brandSoft; color: #1e4fc4; border-color: @brandSoft; }
QPushButton[chaeumRole="ghost"] { background: transparent; border-color: transparent; color: @text2; }
QPushButton[chaeumRole="ghost"]:hover { background: #eef1f5; }
QToolButton { border: 0; border-radius: 6px; padding: 4px; }
QToolButton:hover { background: #eef1f5; }

QLineEdit, QSpinBox, QComboBox, QPlainTextEdit, QTextEdit {
    background: @surface; color: @text; border: 1px solid @lineStrong; border-radius: 7px;
    selection-background-color: @brandSoft; selection-color: @text;
}
QLineEdit, QSpinBox, QComboBox { min-height: 30px; padding: 0 10px; }
QLineEdit:focus, QSpinBox:focus, QComboBox:focus, QPlainTextEdit:focus, QTextEdit:focus { border-color: @brand; }
QLineEdit:disabled, QSpinBox:disabled, QComboBox:disabled { color: #a3adba; background: #f7f9fb; border-color: @line; }
QComboBox::drop-down { border: 0; width: 26px; }
QComboBox QAbstractItemView { background: @surface; border: 1px solid @line; border-radius: 8px; padding: 4px; outline: 0;
    selection-background-color: #f0f3f7; selection-color: @text; }

QCheckBox, QRadioButton { spacing: 8px; color: @text; }
QCheckBox::indicator, QRadioButton::indicator, QTreeView::indicator, QListView::indicator { width: 18px; height: 18px; }
QCheckBox::indicator:unchecked, QTreeView::indicator:unchecked, QListView::indicator:unchecked { image: url(:/client/chaeum/check-off.svg); }
QCheckBox::indicator:checked, QTreeView::indicator:checked, QListView::indicator:checked { image: url(:/client/chaeum/check-on.svg); }
QCheckBox::indicator:indeterminate, QTreeView::indicator:indeterminate { image: url(:/client/chaeum/check-partial.svg); }
QRadioButton::indicator:unchecked { image: url(:/client/chaeum/radio-off.svg); }
QRadioButton::indicator:checked { image: url(:/client/chaeum/radio-on.svg); }
QCheckBox[chaeumRole="switch"] { spacing: 0; }
QCheckBox[chaeumRole="switch"]::indicator { width: 40px; height: 22px; }
QCheckBox[chaeumRole="switch"]::indicator:unchecked { image: url(:/client/chaeum/switch-off.svg); }
QCheckBox[chaeumRole="switch"]::indicator:checked { image: url(:/client/chaeum/switch-on.svg); }
QCheckBox[chaeumRole="switch"]::indicator:unchecked:disabled { image: url(:/client/chaeum/switch-off-disabled.svg); }
QCheckBox[chaeumRole="switch"]::indicator:checked:disabled { image: url(:/client/chaeum/switch-on-disabled.svg); }
QRadioButton[chaeumRole="step"] { spacing: 0; padding: 6px 14px; border-radius: 15px; color: @text3; font-weight: 600; background: transparent; }
QRadioButton[chaeumRole="step"]::indicator { width: 0; height: 0; image: none; }
QRadioButton[chaeumRole="step"]:enabled { color: @text2; }
QRadioButton[chaeumRole="step"]:enabled:hover { background: #e9edf2; }
QRadioButton[chaeumRole="step"]:checked { background: @brandSoft; color: #1e4fc4; }
QComboBox::down-arrow { image: url(:/client/chaeum/chevron-down.svg); width: 14px; height: 14px; }
QSpinBox { padding-right: 10px; min-width: 70px; }
QSpinBox::up-button, QSpinBox::down-button { width: 0; border: 0; }

QGroupBox { background: @surface; border: 1px solid @line; border-radius: 10px; margin-top: 30px; padding: 12px 14px; }
QGroupBox::title { subcontrol-origin: margin; subcontrol-position: top left; left: 2px; top: 4px; padding: 0; color: @text2; font-weight: 700; }
QGroupBox[flat="true"] { background: transparent; border: 0; margin-top: 0; padding: 0; }

QTabWidget::pane { border: 0; top: 8px; }
QTabBar { qproperty-drawBase: 0; }
QTabBar::tab { background: #e9edf2; color: @text2; font-weight: 600; padding: 6px 16px; margin: 0; border: 0; min-height: 22px; }
QTabBar::tab:first { border-top-left-radius: 9px; border-bottom-left-radius: 9px; padding-left: 18px; }
QTabBar::tab:last { border-top-right-radius: 9px; border-bottom-right-radius: 9px; padding-right: 18px; }
QTabBar::tab:selected { background: @surface; color: @text; border: 3px solid #e9edf2; border-radius: 9px; }

QTreeView, QListView, QTableView {
    background: @surface; color: @text; border: 1px solid @line; border-radius: 10px;
    alternate-background-color: #f9fafc; selection-background-color: @brandSoft; selection-color: @text; outline: 0;
}
QTreeView::item, QListView::item, QTableView::item { min-height: 32px; padding: 0 4px; border: 0; }
QTreeView::item:hover, QListView::item:hover { background: #f5f7fa; }
QTreeView::item:selected, QListView::item:selected, QTableView::item:selected { background: @brandSoft; color: @text; }
QHeaderView { background: transparent; border: 0; }
QHeaderView::section { background: #fafbfd; color: @text3; font-weight: 600; border: 0; border-bottom: 1px solid @line; padding: 7px 10px; }

QScrollBar:vertical { background: transparent; width: 10px; margin: 2px; }
QScrollBar::handle:vertical { background: #cdd5df; border-radius: 3px; min-height: 30px; margin: 0 2px; }
QScrollBar::handle:vertical:hover { background: #b5bfcc; }
QScrollBar:horizontal { background: transparent; height: 10px; margin: 2px; }
QScrollBar::handle:horizontal { background: #cdd5df; border-radius: 3px; min-width: 30px; margin: 2px 0; }
QScrollBar::add-line, QScrollBar::sub-line { width: 0; height: 0; }
QScrollBar::add-page, QScrollBar::sub-page { background: transparent; }

QProgressBar { background: #edf0f4; border: 0; border-radius: 3px; max-height: 6px; text-align: center; color: transparent; }
QProgressBar::chunk { background: @brand; border-radius: 3px; }

QMenu { background: @surface; border: 1px solid @line; border-radius: 10px; padding: 5px; }
QMenu::item { color: @text; padding: 7px 28px 7px 12px; border-radius: 6px; }
QMenu::item:selected { background: #f0f3f7; }
QMenu::item:disabled { color: #a3adba; }
QMenu::separator { height: 1px; background: @line; margin: 5px 6px; }

QMessageBox QLabel { color: @text; }
QDialogButtonBox { dialogbuttonbox-buttons-have-icons: 0; }
QLabel[chaeumRole="title"] { font-size: 20px; font-weight: 700; color: @text; margin-bottom: 4px; }
QLabel[chaeumRole="section"] { font-weight: 700; color: @text2; }
QLabel[chaeumRole="muted"] { color: @text3; }
QFrame[chaeumRole="card"] { background: @surface; border: 1px solid @line; border-radius: 10px; }
QWidget[chaeumRole="row"] { background: transparent; border: 0; border-bottom: 1px solid @line; }
QWidget[chaeumRole="row"] QLabel, QWidget[chaeumRole="rowLast"] QLabel { background: transparent; border: 0; }
QWidget[chaeumRole="row"] QLabel[chaeumRole="muted"], QWidget[chaeumRole="rowLast"] QLabel[chaeumRole="muted"] { color: @text3; }
QWidget[chaeumRole="page"], QScrollArea { background: @bg; }
QLabel[chaeumRole="section"] { margin-top: 14px; }
)"_s;
    const std::pair<QString, QColor> tokens[] = {
        {u"@bg"_s, Color::bg},
        {u"@surface"_s, Color::surface},
        {u"@lineStrong"_s, Color::lineStrong},
        {u"@line"_s, Color::line},
        {u"@text2"_s, Color::text2},
        {u"@text3"_s, Color::text3},
        {u"@text"_s, Color::text},
        {u"@brandStrong"_s, Color::brandStrong},
        {u"@brandSoft"_s, Color::brandSoft},
        {u"@brand"_s, Color::brand},
    };
    for (const auto &[key, color] : tokens) {
        qss.replace(key, hex(color));
    }
    return qss;
}

class BuddyClickFilter : public QObject
{
public:
    using QObject::QObject;

protected:
    bool eventFilter(QObject *watched, QEvent *event) override
    {
        if (event->type() != QEvent::MouseButtonPress && event->type() != QEvent::MouseButtonRelease) {
            return false;
        }
        auto *label = qobject_cast<QLabel *>(watched);
        auto *mouseEvent = static_cast<QMouseEvent *>(event);
        auto *box = label ? qobject_cast<QCheckBox *>(label->buddy()) : nullptr;
        if (!box || !box->isEnabled() || mouseEvent->button() != Qt::LeftButton) {
            return false;
        }
        // take the press so the release comes back to the label
        if (event->type() == QEvent::MouseButtonRelease && label->rect().contains(mouseEvent->position().toPoint())) {
            box->setFocus(Qt::MouseFocusReason);
            box->click();
        }
        return true;
    }
};

QPalette palette()
{
    using namespace OCC::ChaeumStyle;
    QPalette p;
    p.setColor(QPalette::Window, Color::bg);
    p.setColor(QPalette::WindowText, Color::text);
    p.setColor(QPalette::Base, Color::surface);
    p.setColor(QPalette::AlternateBase, QColor(0xf7, 0xf9, 0xfb));
    p.setColor(QPalette::Text, Color::text);
    p.setColor(QPalette::Button, Color::surface);
    p.setColor(QPalette::ButtonText, Color::text);
    p.setColor(QPalette::BrightText, Qt::white);
    p.setColor(QPalette::Highlight, Color::brand);
    p.setColor(QPalette::HighlightedText, Qt::white);
    p.setColor(QPalette::Accent, Color::brand);
    p.setColor(QPalette::Link, Color::brand);
    p.setColor(QPalette::LinkVisited, Color::brandStrong);
    p.setColor(QPalette::PlaceholderText, Color::text3);
    p.setColor(QPalette::ToolTipBase, Color::surface);
    p.setColor(QPalette::ToolTipText, Color::text);
    p.setColor(QPalette::Light, Qt::white);
    p.setColor(QPalette::Midlight, QColor(0xe9, 0xed, 0xf2));
    p.setColor(QPalette::Mid, Color::lineStrong);
    p.setColor(QPalette::Dark, QColor(0xb5, 0xbf, 0xcc));
    p.setColor(QPalette::Shadow, QColor(0x8a, 0x95, 0xa5));
    const QColor disabledText(0xa3, 0xad, 0xba);
    p.setColor(QPalette::Disabled, QPalette::WindowText, disabledText);
    p.setColor(QPalette::Disabled, QPalette::Text, disabledText);
    p.setColor(QPalette::Disabled, QPalette::ButtonText, disabledText);
    p.setColor(QPalette::Disabled, QPalette::Highlight, QColor(0xb9, 0xc9, 0xf5));
    return p;
}

}

void OCC::ChaeumStyle::apply(QApplication *app)
{
    const auto weights = {u"Regular"_s, u"Medium"_s, u"SemiBold"_s, u"Bold"_s};
    for (const auto &w : weights) {
        if (QFontDatabase::addApplicationFont(u":/client/pretendard/Pretendard-%1.otf"_s.arg(w)) == -1) {
            qCWarning(lcChaeumStyle) << u"Could not load Pretendard" << w;
        }
    }
    QFont font(u"Pretendard"_s);
    font.setPointSizeF(10);
    font.setHintingPreference(QFont::PreferNoHinting);
    app->setFont(font);

    // the design is light only; keep it when Windows is in dark mode
    app->styleHints()->setColorScheme(Qt::ColorScheme::Light);
    app->setStyle(QStyleFactory::create(u"Fusion"_s));
    QQuickStyle::setStyle(u"Fusion"_s);
    app->setPalette(palette());
    app->setStyleSheet(styleSheet());
}

void OCC::ChaeumStyle::makeBuddyLabelsClickable(QWidget *root)
{
    auto *filter = new BuddyClickFilter(root);
    for (auto *label : root->findChildren<QLabel *>()) {
        // nested settings widgets call this too; install once per label or a click toggles twice
        if (qobject_cast<QCheckBox *>(label->buddy()) && !label->property("chaeumBuddyClick").toBool()) {
            label->setProperty("chaeumBuddyClick", true);
            label->installEventFilter(filter);
            label->setCursor(Qt::PointingHandCursor);
        }
    }
}
