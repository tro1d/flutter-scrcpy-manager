import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/localization_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../utils/colors.dart';
import 'widget/list_device_widget.dart';

class ScrcpyScreen extends ConsumerWidget {
  const ScrcpyScreen({
    Key? key,
    required this.devices,
    required this.currentDevice,
    required this.scrcpyStatus,
    required this.adbStatus,
    required this.logCmd,
  }) : super(key: key);

  final List<DeviceStatus> devices;
  final DeviceStatus currentDevice;
  final Map<String, String> scrcpyStatus;
  final String adbStatus;
  final String logCmd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness.name == 'dark';
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color bgColor = FColor.s050(isDark).withOpacity(isDark ? 0.8 : 1);
    final localization = ref.watch(localizationProvider);

    final TextEditingController noteEC = TextEditingController(text: logCmd.isEmpty ? localization.fNote : logCmd);
    final String note = logCmd.isEmpty ? localization.fNoteLabel : localization.fLog;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: FColor.s200(!isDark)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: const Icon(Icons.android_rounded),
              title: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: localization.fScrcpyVersion, style: textTheme.bodyLarge),
                    TextSpan(text: '${scrcpyStatus['version']}', style: textTheme.titleMedium),
                  ],
                ),
              ),
              subtitle: Text(
                scrcpyStatus['status']!,
                style: textTheme.titleSmall?.copyWith(
                  color:
                      scrcpyStatus['status']!.contains(localization.fInstalled) || scrcpyStatus['status']!.contains(localization.fDownload)
                          ? FColor.green
                          : FColor.red,
                ),
              ),
              trailing: IconButton(
                onPressed:
                    scrcpyStatus['status'] == localization.fInstalled ? null : () => ref.read(scrcpyProvider.notifier).downloadScrcpy(),
                icon: const Icon(Icons.download_rounded),
              ),
            ),
          ),
          if (scrcpyStatus['version'] != "-")
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: FColor.s200(!isDark)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(localization.fStatus, style: textTheme.bodyLarge),
                leading: Icon(adbStatus.contains(localization.fWaitingDevice) ? Icons.device_unknown_rounded : Icons.devices),
                subtitle: Text(
                  adbStatus,
                  style: textTheme.titleSmall?.copyWith(
                    color: scrcpyStatus['status'] != localization.fWaitingDevice ? FColor.green : FColor.red,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => ref.read(adbDevicesProvider.notifier).initialized(),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ),
          if (scrcpyStatus['version'] != "-" && devices.isNotEmpty)
            ListDeviceWidget(
              color: bgColor,
              devices: devices,
              currentDevice: currentDevice,
              windowsDNS: ref.watch(windowsDNSProvider),
            ),
          if (scrcpyStatus['version'] != "-" && devices.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: FColor.s200(!isDark)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: noteEC,
                maxLines: 3,
                style: textTheme.bodyLarge!.copyWith(fontSize: 12.0),
                readOnly: true,
                decoration: InputDecoration(labelText: note, labelStyle: textTheme.titleMedium),
              ),
            ),
          Text.rich(
            style: textTheme.bodyLarge!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, height: 2.2),
            textAlign: TextAlign.end,
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: "Code with "),
                WidgetSpan(child: Icon(Icons.favorite_rounded, color: FColor.red, size: 16)),
                const TextSpan(text: " in Flutter"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
