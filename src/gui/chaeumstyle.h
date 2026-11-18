/*
 * Chaeum Drive look: bundled Pretendard font, light palette and a global style sheet.
 * Added by ChaeumAI Inc. on 2026-11-18 for the Chaeum Drive fork of OpenCloud Desktop.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#pragma once

#include "gui/opencloudguilib.h"

#include <QColor>

class QApplication;

namespace OCC::ChaeumStyle {

// colour tokens, shared with qml/Style.qml
namespace Color {
    inline const QColor bg{0xf4, 0xf6, 0xf9};
    inline const QColor side{0xee, 0xf1, 0xf5};
    inline const QColor surface{0xff, 0xff, 0xff};
    inline const QColor line{0xe3, 0xe8, 0xef};
    inline const QColor lineStrong{0xd3, 0xda, 0xe4};
    inline const QColor text{0x1f, 0x29, 0x37};
    inline const QColor text2{0x5b, 0x67, 0x78};
    inline const QColor text3{0x8a, 0x95, 0xa5};
    inline const QColor brand{0x25, 0x63, 0xeb};
    inline const QColor brandStrong{0x1d, 0x4e, 0xd8};
    inline const QColor brandSoft{0xe8, 0xef, 0xfd};
    inline const QColor ok{0x15, 0x80, 0x3d};
    inline const QColor warn{0xb4, 0x53, 0x09};
    inline const QColor bad{0xc2, 0x41, 0x0c};
}

// load the font, force the light scheme, set palette and style sheet
OPENCLOUD_GUI_EXPORT void apply(QApplication *app);

}
