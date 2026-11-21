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

#include "theme.h"
#include "common/depreaction.h"
#include "common/utility.h"
#include "common/version.h"
#include "configfile.h"
#include "resources/jsontheme.h"
#include "vfs/vfs.h"

#include "resources/qmlresources.h"
#include "resources/resources.h"

#include <QSslSocket>
#include <QStyle>
#include <QtCore>
#include <QtGui>

#include "themewatcher.h"


using namespace Qt::Literals::StringLiterals;

namespace OCC {

Theme *Theme::_instance = nullptr;

Theme *Theme::instance()
{
    if (!_instance) {
        _instance = new Theme();
        auto *watcher = new Resources::ThemeWatcher(_instance);
        connect(watcher, &Resources::ThemeWatcher::themeChanged, _instance, &Theme::themeChanged);
    }
    return _instance;
}

Theme::~Theme()
{
}

Theme::Theme()
    : QObject(nullptr)
{
}

QUrl Theme::helpUrl() const
{
    // Modified by ChaeumAI Inc. on 2026-11-16: no help link (the tray menu hides "Help" when this is empty).
    return {};
}

QUrl Theme::updateCheckUrl() const
{
#ifdef APPLICATION_UPDATE_URL
    return QUrl(QStringLiteral(APPLICATION_UPDATE_URL));
#else
    return {};
#endif
}

bool Theme::wizardSkipAdvancedPage() const
{
    return false;
}

QString Theme::gitSHA1(VersionFormat format) const
{
    const QString gitShahSort = Version::gitSha().left(6);
    if (!aboutShowCopyright()) {
        return gitShahSort;
    }
    // Modified by ChaeumAI Inc. on 2026-11-16: commit link points to the Chaeum Drive source.
    const auto gitUrl = QStringLiteral("https://github.com/ceo-chaeum-ai/desktop/commit/%1").arg(Version::gitSha());
    switch (format) {
    case Theme::VersionFormat::OneLiner:
        Q_FALLTHROUGH();
    case Theme::VersionFormat::Plain:
        return gitShahSort;
    case Theme::VersionFormat::Url:
        return gitUrl;
    case Theme::VersionFormat::RichText:
        return QStringLiteral("<a href=\"%1\">%3</a>").arg(gitUrl, gitShahSort);
    }
    return QString();
}

QString Theme::aboutVersions(Theme::VersionFormat format) const
{
    const QString br = [&format] {
        switch (format) {
        case Theme::VersionFormat::RichText:
            return QStringLiteral("<br>");
        case Theme::VersionFormat::Url:
            Q_FALLTHROUGH();
        case Theme::VersionFormat::Plain:
            return QStringLiteral("\n");
        case Theme::VersionFormat::OneLiner:
            return QStringLiteral(" ");
        }
        Q_UNREACHABLE();
    }();
    const QString qtVersion = QString::fromUtf8(qVersion());
    const QString qtVersionString = (QLatin1String(QT_VERSION_STR) == qtVersion
            ? qtVersion
            : QCoreApplication::translate("OpenCloudTheme::qtVer", "%1 (Built against Qt %2)").arg(qtVersion, QStringLiteral(QT_VERSION_STR)));
    QString _version = Version::displayString();
    QString gitUrl;
    if (!Version::gitSha().isEmpty()) {
        if (format != Theme::VersionFormat::Url) {
            _version = QCoreApplication::translate("OpenCloudTheme::versionWithSha", "%1 %2").arg(_version, gitSHA1(format));
        } else {
            gitUrl = gitSHA1(format) + br;
        }
    }
    QStringList sysInfo = {QStringLiteral("OS: %1-%2 (kernel: %3, build arch: %4, CPU arch: %5)")
            .arg(QSysInfo::productType(), QSysInfo::productVersion(), QSysInfo::kernelVersion(), QSysInfo::buildCpuArchitecture(), Utility::currentCpuArch())};
    // may be called by both GUI and CLI, but we can display QPA only for the former
    if (auto guiApp = qobject_cast<QGuiApplication *>(qApp)) {
        sysInfo << QStringLiteral("QPA: %1").arg(guiApp->platformName());
    }

    return QCoreApplication::translate("OpenCloudTheme::aboutVersions()",
        "%1 %2%7"
        "%8"
        "Libraries Qt %3, %4%7"
        "Using virtual files plugin: %5%7"
        "%6")
        .arg(Resources::JsonTheme::instance().applicationName(), _version, qtVersionString, QSslSocket::sslLibraryVersionString(),
            Utility::enumToString(VfsPluginManager::instance().bestAvailableVfsMode()), sysInfo.join(br), br, gitUrl);
}


QString Theme::about() const
{
    // Modified by ChaeumAI Inc. on 2026-11-16: distributor and source location of Chaeum Drive.
    // Modified by ChaeumAI Inc. on 2026-11-21: GPL notices (license files, written source offer).
    return tr("<p>Version %1. Based on OpenCloud Desktop.</p>"
              "<p>Copyright ChaeumAI Inc. (modifications)<br/>"
              "Copyright OpenCloud GmbH<br/>"
              "Copyright ownCloud GmbH</p>"
              "<p>Distributed by ChaeumAI Inc. under the GNU General Public License (GPL) version 2 or later, without any warranty. "
              "The license texts and third-party notices are in the licenses folder of the installation.</p>"
              "<p>Source code of this version: <a href=\"https://github.com/ceo-chaeum-ai/desktop/releases\">GitHub</a>. "
              "For three years after distribution we will also send the complete source code to anyone who asks (support@chaeumai.com).</p>"
              "<p><small>%2</small></p>")
        .arg(Utility::escape(Version::displayString()), aboutVersions(Theme::VersionFormat::RichText));
}

bool Theme::aboutShowCopyright() const
{
    return true;
}

QString Theme::oauthClientId() const
{
    return QStringLiteral("OpenCloudDesktop");
}

QString Theme::oauthClientSecret() const
{
    return QString();
}

QPair<QString, QString> Theme::oauthOverrideAuthUrl() const
{
    return {};
}

QVector<quint16> Theme::oauthPorts() const
{
    // zero means a random port
    return {0};
}

bool Theme::oidcEnableDynamicRegistration() const
{
    return true;
}

QString Theme::versionSwitchOutput() const
{
    return aboutVersions(Theme::VersionFormat::Url);
}

bool Theme::connectionValidatorClearCookies() const
{
    return false;
}

bool Theme::enableSocketApiIconSupport() const
{
    return true;
}


bool Theme::allowDuplicatedFolderSyncPair() const
{
    return true;
}

bool Theme::enableMoveToTrash() const
{
    return true;
}

bool Theme::withCrashReporter() const
{
    return false;
}

} // end namespace client
