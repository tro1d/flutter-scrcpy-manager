class ConstantString {
  // Icon
  static const String fIappIco = "assets/images/tray_icon_original.ico";
  static const String fIappPng = "assets/images/tray_icon_original.png";

  // String
  static const String fApp = "Scrcpy Manager";
  static const String fOnline = "Online";
  static const String fOffline = "Offline";
  static const String fUnauthorized = "Unauthorized";
  static const String fLoading = "Loading...";
  static const String fNotInstalled = "Not Installed";
  static const String fUpdate = "Update";
  static const String fNewversion = "Versi Terbaru";
  static const String fInstalled = "Installed";
  static const String fStatus = "Status: ";
  static const String fDeviceIP = "Device IP: ";
  static const String fDownload = "Mengunduh: ";
  static const String fCheckupdate = "Check update: ";
  static const String fScrcpyVersion = "Scrcpy Version: ";
  static const String fWaitingDevice = "Menunggu perangkat terhubung...";
  static const String fDeviceAttached = "Perangkat terhubung";
  static const String fUSB = "USB";
  static const String fTCPIP = "TCP/IP";
  static const String fNoteLabel = "Catatan";
  static const String fLog = "Log";
  static const String fNote = 'Dalam mode TCP/IP hanya bisa digunakan dalam 1 device. Jika ingin lebih dari 1 device bisa gunakan console.';
  static const String fOpenScrcpyManager = "Buka Scrcpy Manager";
  static const String fThemeMode = "Mode Tema";
  static const String fDark = "Gelap";
  static const String fLight = "Terang";
  static const String fSettings = "Pengaturan";
  static const String fUninstallScrcpy = "Uninstall Scrcpy";
  static const String fUpdateScrcpy = "Perbaharui Scrcpy";
  static const String fAbout = "Tentang";
  static const String fAboutNote = "This is a simple Scrcpy Manager with Command Prompt created in Flutter.";
  static const String fFfouryAPPScrcpyManager = "Scrcpy Manager - FfouryAPP";
  static const String fGenymobilescrcpy = "Scrcpy - Genymobile";
  static const String fCancel = "Batal";
  static const String fExit = "Keluar";
  static const String fExitDisconnect = "Keluar dan Putuskan";
  static const String fExitQ = "Apaka anda yakin ingin keluar ?";
  static const String fExitN = "Jangan lupa untuk memutuskan semuan koneksi ADB.";

  // Url
  static const String fGithubScrcpy = "https://github.com/Genymobile/scrcpy";
  static const String fGithubFApp = "https://github.com/tro1d/flutter-scrcpy-manager";
  static const String fUrlScrcpyLatest = "https://api.github.com/repos/Genymobile/scrcpy/releases/latest";
  static String fReleaseURLDL(String newVersion) {
    return "https://github.com/Genymobile/scrcpy/releases/download/$newVersion/scrcpy-win64-$newVersion.zip";
  }
}
