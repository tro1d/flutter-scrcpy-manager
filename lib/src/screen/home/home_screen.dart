import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/localization_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../providers/tray_manager_provider.dart';
import '../../utils/colors.dart';
import '../../utils/constant_string.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../console/console_screen.dart';
import '../scrcpy/scrcpy_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness.name == 'dark';
    final localization = ref.watch(localizationProvider);

    final List<DeviceStatus> devices = ref.watch(devicesListProvider);
    final DeviceStatus currentDevice = ref.watch(deviceProvider);

    final scrcpyStatus = ref.watch(scrcpyProvider).when(
          error: (error, stackTrace) => {'status': '$error', "version": '-'},
          loading: () => {'status': localization.fLoading, "version": '-'},
          data: (data) => data,
        );

    final adbStatus = ref.watch(adbDevicesProvider).when(
          error: (error, stackTrace) => 'Error: $error',
          loading: () => localization.fWaitingDevice,
          data: (data) {
            if (data == ProcessADBStatus.waitingDevice) {
              return localization.fWaitingDevice;
            } else if (data == ProcessADBStatus.deviceAttached) {
              return localization.fDeviceAttached;
            } else {
              return localization.fWaitingDevice;
            }
          },
        );

    final String logCmd = ref.watch(logStatusProvider);

    ref.listen(isAboutppProvider, (previous, next) {
      if (next) dialogAbout(context, ref);
    });

    return Scaffold(
      backgroundColor: FColor.s100(isDark).withOpacity(0.85),
      appBar: CustomAppBar(
        title: localization.fApp,
        backgroundColor: FColor.s050(isDark),
        brightness: isDark ? Brightness.dark : Brightness.light,
        iconApp: Image.asset(ConstantString.fIappPng, scale: 6.0),
        onpressedIconApp: () => ref.read(trayManagerProvider.notifier).onTapIconApp(),
        onpressedExitApp: () => ref.read(trayManagerProvider.notifier).onExit(),
        onpressedExitAppDisconect: () => ref.read(trayManagerProvider.notifier).onExitAndDisconnect(),
      ),
      body: PageView(
        controller: ref.watch(pageControllerProvider),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ScrcpyScreen(
            devices: devices,
            currentDevice: currentDevice,
            scrcpyStatus: scrcpyStatus,
            adbStatus: adbStatus,
            logCmd: logCmd,
          ),
          const ConsoleScreen(),
        ],
      ),
    );
  }

  Future<Dialog?> dialogAbout(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    return showDialog(
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(localization.fAbout),
          contentTextStyle: Theme.of(context).textTheme.bodyLarge,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(localization.fAboutNote),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => ref.read(scrcpyProvider.notifier).onTapURLAbout(ConstantString.fGithubScrcpy),
                  child: Text(
                    localization.fGenymobilescrcpy,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => ref.read(scrcpyProvider.notifier).onTapURLAbout(ConstantString.fGithubFApp),
                  child: Text(
                    localization.fFfouryAPPScrcpyManager,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              child: Text(localization.fCancel),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(isAboutppProvider.notifier).state = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
