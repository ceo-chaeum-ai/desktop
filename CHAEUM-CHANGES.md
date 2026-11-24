# Changes by ChaeumAI Inc.

This repository is a modified version of OpenCloud Desktop (https://github.com/opencloud-eu/desktop),
distributed by ChaeumAI Inc. as Chaeum Drive (채움드라이브) under the GNU General Public License,
version 2 or (at your option) any later version. See COPYING.

Upstream base: 0916ccc0574bfeca7c5211662287d66a55d48b32. Every file below was added (A) or changed (M) by ChaeumAI Inc.;
the dates are the first and last day of our changes. The full history is in the git log.

| | File | Changed | Last change |
|---|---|---|---|
| M | `.craft.ini` | 2026-11-18 to 2026-11-19 | CI: skip msys pacman dev-utils pulled in by craft virtual/base on Windows |
| M | `.craft.shelf` | 2026-11-16 to 2026-11-18 | Craft: 7zip-base 26.06 and snoretoast 0.9.3, the pinned versions were removed from the KDE blueprints |
| A | `.github/workflows/chaeum-windows.yml` | 2026-11-16 to 2026-11-18 | CI: Store MSIX package and test-signed copy for Chaeum Drive |
| M | `CMakeLists.txt` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| A | `chaeum.json` | 2026-11-16 to 2026-11-18 | Chaeum Drive: grey icon tint and dialog buttons without icons |
| M | `cmake/modules/version.rc.in` | 2026-11-16 to 2026-11-21 | Windows version info: show the Korean product name in Task Manager and file properties |
| M | `src/gui/CMakeLists.txt` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/aboutdialog.ui` | 2026-11-21 | About dialog: translate the window title (showed 'About' in Korean UI) |
| M | `src/gui/activitywidget.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/gui/chaeumstyle.cpp` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| A | `src/gui/chaeumstyle.h` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| M | `src/gui/commonstrings.cpp` | 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| M | `src/gui/folderstatusmodel.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/folderstatusmodel.h` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/generalsettings.cpp` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| M | `src/gui/generalsettings.ui` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| M | `src/gui/issueswidget.cpp` | 2026-11-19 | Activity: fit columns to content, keep file name widest, left-align headers, hide account column with a single account |
| M | `src/gui/main.cpp` | 2026-11-16 to 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/models/expandingheaderview.cpp` | 2026-11-19 | Activity: let cut-off columns grow back when the table widens |
| M | `src/gui/models/expandingheaderview.h` | 2026-11-19 | Activity: let cut-off columns grow back when the table widens |
| M | `src/gui/networksettings.cpp` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| M | `src/gui/networksettings.ui` | 2026-11-18 to 2026-11-19 | Settings: clicking a row title toggles its switch again |
| M | `src/gui/newwizard/navigation.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/newwizard/pages/accountconfiguredwizardpage.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/newwizard/pages/serverurlsetupwizardpage.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/newwizard/setupwizardwidget.cpp` | 2026-11-18 to 2026-11-19 | Account wizard: restore Alt mnemonics on Back, Next, Finish and Cancel |
| M | `src/gui/protocolwidget.cpp` | 2026-11-19 | Activity: fit columns to content, keep file name widest, left-align headers, hide account column with a single account |
| M | `src/gui/qml/AccountBar.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/gui/qml/ChaeumButton.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/qml/FolderDelegate.qml` | 2026-11-18 to 2026-11-19 | Space list: fall back to Manage Account when Add Space is disabled |
| M | `src/gui/qml/FolderError.qml` | 2026-11-19 | Space card: reserve room for the Show more button in the error box |
| A | `src/gui/qml/NavButton.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/gui/qml/Style.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/qml/credentials/Credentials.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/qml/credentials/OAuthCredentials.qml` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/settingsdialog.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/gui/settingsdialog.ui` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/libsync/creds/oauth.cpp` | 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| M | `src/libsync/graphapi/space.cpp` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/libsync/graphapi/space.h` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/libsync/theme.cpp` | 2026-11-16 to 2026-11-21 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| A | `src/resources/chaeum/check-off.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/check-on.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/check-partial.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/chevron-down.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/radio-off.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/radio-on.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/switch-off-disabled.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/switch-off.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/switch-on-disabled.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/chaeum/switch-on.svg` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/resources/client.qrc` | 2026-11-18 to 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| M | `src/resources/oauth/oauth.html.in` | 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| A | `src/resources/pretendard/OFL.txt` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/pretendard/Pretendard-Bold.otf` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/pretendard/Pretendard-Bold.subset.woff2` | 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| A | `src/resources/pretendard/Pretendard-Medium.otf` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/pretendard/Pretendard-Regular.otf` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| A | `src/resources/pretendard/Pretendard-Regular.subset.woff2` | 2026-11-19 | Chaeum Drive: light login result page with Pretendard, File Explorer wording and clearer Korean notifications |
| A | `src/resources/pretendard/Pretendard-SemiBold.otf` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `src/resources/theme/colored/1024-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/128-opencloud-icon-sidebar.png` | 2026-11-16 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| M | `src/resources/theme/colored/128-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/150-opencloud-icon-ms.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/16-opencloud-icon-sidebar.png` | 2026-11-16 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| M | `src/resources/theme/colored/16-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/24-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/256-opencloud-icon-sidebar.png` | 2026-11-16 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| M | `src/resources/theme/colored/256-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/310-opencloud-icon-ms.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/32-opencloud-icon-sidebar.png` | 2026-11-16 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| M | `src/resources/theme/colored/32-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/44-opencloud-icon-ms.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/48-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/512-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/colored/64-opencloud-icon-sidebar.png` | 2026-11-16 | Chaeum Drive: app icons with gold D badge, about commit link to fork |
| M | `src/resources/theme/colored/64-opencloud-icon.png` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/dark-systray/ocl-ui_error-flieder-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/dark-systray/ocl-ui_info-flieder-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/dark-systray/ocl-ui_logo-flieder.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/dark-systray/ocl-ui_offline-flieder-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/dark-systray/ocl-ui_pause-flieder-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/dark-systray/ocl-ui_sync-flieder-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_error-petrol-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_info-petrol-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_logo-petrol.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_offline-petrol-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_pause-petrol-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/light-systray/ocl-ui_sync-petrol-colour.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_error-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_info-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_logo-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_offline-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_pause-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/mask-systray/ocl-ui_sync-hex#000.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/universal/opencloud-icon-sidebar.svg` | 2026-11-16 | Chaeum Drive: tray and logo SVGs, no update check, no help link |
| M | `src/resources/theme/universal/opencloud-icon.svg` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/theme/universal/sync-exclude.lst` | 2026-11-24 | Sync: leave the server's search-text folder 서류함/_text out of PC sync |
| M | `src/resources/theme/universal/wizard_logo.svg` | 2026-11-16 | Chaeum Drive: app icons in the new style (large D on gold, small Chaeum AI logo on a cream disc) |
| M | `src/resources/wizard/style.qss` | 2026-11-18 | Chaeum Drive: new light UI for the main window, settings, activity and account wizard |
| M | `translations/desktop_ko.ts` | 2026-11-18 to 2026-11-23 | Korean: Alt mnemonics in the account wizard; app-name particles in the quit dialog and the Explorer share menu |
| A | `CHAEUM-CHANGES.md` | 2026-11-21 | this file |
| A | `admin/chaeum/licenses/` | 2026-11-21 | license texts and third-party notices shipped with the package |
