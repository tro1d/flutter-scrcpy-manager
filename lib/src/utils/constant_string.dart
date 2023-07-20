class ConstantString {
  // Icon
  static const String fIappIco = "assets/images/tray_icon_original.ico";
  static const String fIappPng = "assets/images/tray_icon_original.png";

  // Url
  static const String fGithubScrcpy = "https://github.com/Genymobile/scrcpy";
  static const String fGithubFApp = "https://github.com/tro1d/flutter-scrcpy-manager";
  static const String fUrlScrcpyLatest = "https://api.github.com/repos/Genymobile/scrcpy/releases/latest";
  static String fReleaseURLDL(String newVersion) {
    return "https://github.com/Genymobile/scrcpy/releases/download/$newVersion/scrcpy-win64-$newVersion.zip";
  }
}
