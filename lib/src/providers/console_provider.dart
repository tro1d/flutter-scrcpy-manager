import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd_run.dart';
import 'package:shared_preferences/shared_preferences.dart';

final outputListProvider = StateProvider<List<String>>((ref) => []);
final outputControllerProvider = Provider<TextEditingController>((ref) => TextEditingController());

class RunConsoleNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<String> runCommand(String command) async {
    if (command.startsWith("clear")) {
      ref.read(outputListProvider.notifier).state = [];
      return "clear";
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? scrcpyVersion = prefs.getString('version');
      final Directory appDocumentsDir = await getApplicationSupportDirectory();
      String adbPath = '${appDocumentsDir.path}/scrcpy-win64-$scrcpyVersion';
      ProcessCmd cmdDisconnect = ProcessCmd(workingDirectory: adbPath, command, []);
      final res = await runCmd(cmdDisconnect);
      return "${res.stdout}\n${res.stderr}";
    }
  }
}
