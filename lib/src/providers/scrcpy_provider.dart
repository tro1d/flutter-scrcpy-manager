import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/process_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:process_run/cmd_run.dart';

import '../utils/constant_string.dart';

final adbDevicesProvider = AsyncNotifierProvider<ProcessADBNotifier, ProcessADBStatus>(ProcessADBNotifier.new);
final scrcpyProvider = AsyncNotifierProvider<ScrcpyNotifier, Map<String, String>>(ScrcpyNotifier.new);

final devicesListProvider = StateProvider<List<DeviceStatus>>((ref) => []);
final deviceProvider = StateProvider<DeviceStatus>((ref) => DeviceStatus());
final windowsDNSProvider = StateProvider<String>((ref) => '');
final logStatusProvider = StateProvider<String>((ref) => '');

enum ProcessADBStatus { waitingDevice, deviceAttached, error }

class DeviceStatus {
  String deviceID;
  String deviceStatus;
  String deviceModel;
  String deviceIP;
  DeviceStatus({this.deviceID = '', this.deviceStatus = '', this.deviceModel = '', this.deviceIP = ''});
}

class ScrcpyNotifier extends AsyncNotifier<Map<String, String>> {
  @override
  Future<Map<String, String>> build() async {
    log('ScrcpyNotifier initialized');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? version = prefs.getString('version');
    if (version != null) {
      try {
        final dio = Dio();
        final Response response = await dio.get(ConstantString.fUrlScrcpyLatest);
        final Map<String, dynamic> data = response.data;
        final String newVersion = data["tag_name"];
        if (version == newVersion) {
          return {"status": ConstantString.fInstalled, "version": version};
        } else {
          return {"status": "${ConstantString.fUpdate} (${ConstantString.fNewversion} $newVersion)", "version": version};
        }
      } on DioException catch (e) {
        if (e.response != null) {
          return {"status": "${ConstantString.fInstalled} (${ConstantString.fCheckupdate}${e.response?.data})", "version": version};
        } else {
          return {"status": "${ConstantString.fInstalled} (${ConstantString.fCheckupdate}$e)", "version": version};
        }
      }
    } else {
      return {"status": ConstantString.fNotInstalled, "version": '-'};
    }
  }

  Future<void> downloadScrcpy() async {
    log('Check Version Scrcpy initialized');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Directory appDocumentsDir = await getApplicationSupportDirectory();
    try {
      final dio = Dio();
      final Response response = await dio.get(ConstantString.fUrlScrcpyLatest);
      final Map<String, dynamic> data = response.data;
      final String newVersion = data["tag_name"];

      final String? oldVersion = prefs.getString('version');
      if (oldVersion == null || oldVersion != newVersion) {
        final String releaseURLDL = ConstantString.fReleaseURLDL(newVersion);
        final String pathDL = '${appDocumentsDir.path}/scrcpy-win64-$newVersion.zip';
        await dio.download(
          releaseURLDL,
          pathDL,
          onReceiveProgress: (count, total) async {
            state = AsyncValue.data({
              "status": "${ConstantString.fDownload}${formatBytes(count)} / ${formatBytes(total)}",
              "version": '-',
            });
            if (count == total) {
              await prefs.setString('version', newVersion);
              final inputStream = InputFileStream(pathDL);
              final archive = ZipDecoder().decodeBuffer(inputStream);
              extractArchiveToDisk(archive, '${appDocumentsDir.path}/');
              inputStream.close();

              if (await File(pathDL).exists()) {
                final File file = File(pathDL);
                await file.delete(recursive: true);
              }

              final String oldVersionPath = '${appDocumentsDir.path}/scrcpy-win64-$oldVersion';
              if (await Directory(oldVersionPath).exists()) {
                final Directory dir = Directory(oldVersionPath);
                await dir.delete(recursive: true);
              }
              state = AsyncValue.data({"status": ConstantString.fInstalled, "version": newVersion});
              ref.read(adbDevicesProvider.notifier).initialized();
            }
          },
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Error: ${e.response?.data}');
      } else {
        log('Error: ${e.message}');
      }
    }
  }

  Future<void> onTapURLAbout(String url) async => await runCmd(ProcessCmd('start', [url]));

  Future<void> runScrcpy(DeviceStatus device, String mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scrcpyVersion = prefs.getString('version');
    final Directory appDocumentsDir = await getApplicationSupportDirectory();
    String adbPath = '${appDocumentsDir.path}/scrcpy-win64-$scrcpyVersion';
    switch (mode) {
      case ConstantString.fUSB:
        ref.read(logStatusProvider.notifier).state = "USB Running ${device.deviceModel}";
        ProcessCmd cmdScrcpy = ProcessCmd(workingDirectory: adbPath, 'scrcpy', ['-s', device.deviceID, '--always-on-top']);
        final cmdScrcpyLog = await runCmd(cmdScrcpy);
        if (cmdScrcpyLog.stderr.isNotEmpty) {
          ref.read(logStatusProvider.notifier).state = cmdScrcpyLog.errText;
        }
      case ConstantString.fTCPIP:
        String splitIp = device.deviceIP.trim().split('.').last;
        int port = 5556 + int.parse(splitIp);
        ref.read(logStatusProvider.notifier).state = "TCP/IP Running ${device.deviceModel} [${device.deviceIP}:$port]";
        ProcessCmd cmdDisconnectFirst = ProcessCmd(workingDirectory: adbPath, 'adb', ['disconnect']);
        ProcessCmd cmdConnectPort = ProcessCmd(workingDirectory: adbPath, 'adb', ['tcpip', '$port']);
        ProcessCmd cmdConnectDevice = ProcessCmd(workingDirectory: adbPath, 'adb', ['connect', '${device.deviceIP}:$port']);
        ProcessCmd cmdScrcpy = ProcessCmd(
          workingDirectory: adbPath,
          'scrcpy',
          ['--tcpip=${device.deviceIP}:$port', '--window-title=${device.deviceModel} [Port $port]', '--always-on-top'],
        );
        final cmdDisconnectFirstLog = await runCmd(cmdDisconnectFirst);
        if (cmdDisconnectFirstLog.stderr.isNotEmpty) {
          ref.read(logStatusProvider.notifier).state = cmdDisconnectFirstLog.errText;
        }
        final cmdConnectPortLog = await runCmd(cmdConnectPort);
        if (cmdConnectPortLog.stderr.isNotEmpty) {
          ref.read(logStatusProvider.notifier).state = cmdConnectPortLog.errText;
        }
        final cmdConnectDeviceLog = await runCmd(cmdConnectDevice);
        if (cmdConnectDeviceLog.stderr.isNotEmpty) {
          ref.read(logStatusProvider.notifier).state = cmdConnectDeviceLog.errText;
        }
        final cmdScrcpyLog = await runCmd(cmdScrcpy);
        if (cmdScrcpyLog.stderr.isNotEmpty) {
          ref.read(logStatusProvider.notifier).state = cmdScrcpyLog.errText;
        }
      default:
        null;
    }
  }

  String formatBytes(int bytes) {
    const int kiloBytes = 1024;
    const int megaBytes = kiloBytes * 1024;
    const int gigaBytes = megaBytes * 1024;

    if (bytes >= gigaBytes) {
      double result = bytes / gigaBytes;
      return '${result.toStringAsFixed(2)} Gb';
    } else if (bytes >= megaBytes) {
      double result = bytes / megaBytes;
      return '${result.toStringAsFixed(2)} Mb';
    } else if (bytes >= kiloBytes) {
      double result = bytes / kiloBytes;
      return '${result.toStringAsFixed(2)} Kb';
    } else {
      return '$bytes bytes';
    }
  }
}

class ProcessADBNotifier extends AsyncNotifier<ProcessADBStatus> {
  @override
  FutureOr<ProcessADBStatus> build() => ProcessADBStatus.waitingDevice;

  Future<void> initialized() async {
    log('ProcessRunADB initialized');
    late bool deviceFound = false;

    ProcessCmd cmdIpconfig = ProcessCmd('nslookup', ['%']);
    final ipconfig = await runCmd(cmdIpconfig);
    if (ipconfig.stdout.contains('Address')) {
      RegExp ipRegex = RegExp(r'Address:\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})');
      RegExpMatch? windowsDNS = ipRegex.firstMatch(ipconfig.stdout);
      ref.read(windowsDNSProvider.notifier).state = '${windowsDNS?.group(1)?.trim()}';
    } else {
      ref.invalidate(windowsDNSProvider);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scrcpyVersion = prefs.getString('version');
    final Directory appDocumentsDir = await getApplicationSupportDirectory();
    String adbPath = '${appDocumentsDir.path}/scrcpy-win64-$scrcpyVersion';

    while (!deviceFound && scrcpyVersion != null) {
      try {
        ProcessCmd cmd = ProcessCmd('adb', ['devices'], workingDirectory: adbPath);
        final result = await runCmd(cmd);
        final adbresult = await _parseDevices(result.stdout);

        if (adbresult.isNotEmpty) {
          ref.read(devicesListProvider.notifier).state = adbresult;
          deviceFound = true;
          state = const AsyncData(ProcessADBStatus.deviceAttached);
          ref.read(deviceProvider.notifier).state = adbresult.first;
        } else {
          state = const AsyncData(ProcessADBStatus.waitingDevice);
          await Future.delayed(const Duration(seconds: 3));
        }
      } catch (e) {
        log('Error: $e');
        state = const AsyncData(ProcessADBStatus.error);
      }
    }
  }

  Future<List<DeviceStatus>> _parseDevices(String stdout) async {
    List<DeviceStatus> deviceList = [];

    try {
      const String attached = 'List of devices attached';
      if (stdout.contains(attached)) {
        List<String> stdoutLines = stdout.replaceFirst('\r\n\r\n', '').split('\r\n');
        for (String line in stdoutLines) {
          if (!line.contains(attached)) {
            final List<String> device = line.split('\t');
            if (device.last == 'device') {
              final deviceModel = await runAdbCommand(device.first, 'shell getprop ro.product.model');
              final ifconfigOutput = await runAdbCommand(device.first, "shell ifconfig wlan0");
              RegExp ipRegex = RegExp(r'inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})');
              RegExpMatch? deviceIP = ipRegex.firstMatch(ifconfigOutput.stdout);
              if (!device.first.contains(":")) {
                deviceList.add(
                  DeviceStatus(
                    deviceID: device.first,
                    deviceStatus: device.last,
                    deviceModel: deviceModel.stdout.trim(),
                    deviceIP: '${deviceIP?.group(1)}',
                  ),
                );
              }
            } else {
              deviceList.add(
                DeviceStatus(
                  deviceID: device.first,
                  deviceStatus: device.last,
                ),
              );
            }
          }
        }
      } else {
        log('Error: Invalid Stdout');
      }
    } catch (e) {
      log('Error: $e');
    }
    return deviceList;
  }

  Future<ProcessResult> runAdbCommand(String deviceSerial, String command) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scrcpyVersion = prefs.getString('version');
    final Directory appDocumentsDir = await getApplicationSupportDirectory();
    String adbPath = '${appDocumentsDir.path}/scrcpy-win64-$scrcpyVersion';
    ProcessCmd cmd = ProcessCmd('adb', workingDirectory: adbPath, ['-s', deviceSerial, ...command.split(' ')]);
    return await runCmd(cmd);
  }
}
