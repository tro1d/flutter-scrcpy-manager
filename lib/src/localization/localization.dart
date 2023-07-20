import 'dart:ui';

import 'en.dart' as en;
import 'id.dart' as id;

const List<Map<String, String>> localeApp = [
  {"code": "en", "language": "English"},
  {"code": "id", "language": "Bahasa Indonesia"},
];

class Localization {
  String flanguageCode;
  String flanguage;
  String fApp;
  String fOnline;
  String fOffline;
  String fUnauthorized;
  String fLoading;
  String fNotInstalled;
  String fUpdate;
  String fNewversion;
  String fInstalled;
  String fStatus;
  String fDeviceIP;
  String fDownload;
  String fCheckupdate;
  String fScrcpyVersion;
  String fWaitingDevice;
  String fDeviceAttached;
  String fUSB;
  String fTCPIP;
  String fNoteLabel;
  String fLog;
  String fNote;
  String fOpenScrcpyManager;
  String fOpenConsole;
  String fThemeMode;
  String fDark;
  String fLight;
  String fSettings;
  String fUninstallScrcpy;
  String fUpdateScrcpy;
  String fAbout;
  String fAboutNote;
  String fFfouryAPPScrcpyManager;
  String fGenymobilescrcpy;
  String fAlwaysOnTop;
  String fRecordScreen;
  String fConnect;
  String fCancel;
  String fExit;
  String fExitDisconnect;
  String fExitQ;
  String fExitN;

  Localization({
    required this.flanguageCode,
    required this.flanguage,
    required this.fApp,
    required this.fOnline,
    required this.fOffline,
    required this.fUnauthorized,
    required this.fLoading,
    required this.fNotInstalled,
    required this.fUpdate,
    required this.fNewversion,
    required this.fInstalled,
    required this.fStatus,
    required this.fDeviceIP,
    required this.fDownload,
    required this.fCheckupdate,
    required this.fScrcpyVersion,
    required this.fWaitingDevice,
    required this.fDeviceAttached,
    required this.fUSB,
    required this.fTCPIP,
    required this.fNoteLabel,
    required this.fLog,
    required this.fNote,
    required this.fOpenScrcpyManager,
    required this.fOpenConsole,
    required this.fThemeMode,
    required this.fDark,
    required this.fLight,
    required this.fSettings,
    required this.fUninstallScrcpy,
    required this.fUpdateScrcpy,
    required this.fAbout,
    required this.fAboutNote,
    required this.fFfouryAPPScrcpyManager,
    required this.fGenymobilescrcpy,
    required this.fAlwaysOnTop,
    required this.fRecordScreen,
    required this.fConnect,
    required this.fCancel,
    required this.fExit,
    required this.fExitDisconnect,
    required this.fExitQ,
    required this.fExitN,
  });

  static Localization of(Locale locale) {
    switch (locale.languageCode) {
      case 'id':
        return id.of(locale);
      default:
        return en.of(locale);
    }
  }
}
