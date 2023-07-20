import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/localization_provider.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../utils/colors.dart';

class ListDeviceWidget extends ConsumerWidget {
  const ListDeviceWidget({Key? key, this.color, required this.devices, required this.currentDevice, required this.windowsDNS})
      : super(key: key);

  final Color? color;
  final List<DeviceStatus> devices;
  final DeviceStatus currentDevice;
  final String windowsDNS;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness.name == 'dark';
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localization = ref.watch(localizationProvider);

    final partDNS = windowsDNS.split(".");
    final windowsIp = '${partDNS[0]}.${partDNS[1]}.${partDNS[2]}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: FColor.s200(!isDark)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Badge(
                largeSize: 32.0,
                backgroundColor: FColor.isLightMaterialColor.shade600,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                label: Text(devices.length.toString()),
                child: const Icon(Icons.phone_android_rounded, size: 100.0),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton<DeviceStatus>(
                        onTap: () => ref.read(logStatusProvider.notifier).state = '',
                        padding: EdgeInsets.zero,
                        dropdownColor: FColor.s050(isDark),
                        focusColor: Colors.transparent,
                        value: currentDevice,
                        onChanged: (value) {
                          ref.read(deviceProvider.notifier).state = value!;
                        },
                        items: <DropdownMenuItem<DeviceStatus>>[
                          for (DeviceStatus getDevice in devices)
                            DropdownMenuItem(
                              value: getDevice,
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    if (getDevice.deviceStatus == 'device')
                                      WidgetSpan(child: Icon(Icons.phone_android, size: 18.0, color: FColor.green))
                                    else if (getDevice.deviceStatus == 'offline')
                                      WidgetSpan(child: Icon(Icons.perm_device_info_sharp, size: 18.0, color: FColor.amber))
                                    else
                                      WidgetSpan(child: Icon(Icons.device_unknown_sharp, size: 18.0, color: FColor.red)),
                                    TextSpan(text: getDevice.deviceModel.isEmpty ? getDevice.deviceID : getDevice.deviceModel),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(text: localization.fStatus, style: textTheme.bodyLarge),
                            if (currentDevice.deviceStatus == "device")
                              TextSpan(
                                text: localization.fOnline,
                                style: textTheme.titleSmall!.copyWith(color: FColor.green),
                              ),
                            if (currentDevice.deviceStatus == "offline")
                              TextSpan(
                                text: localization.fOffline,
                                style: textTheme.titleSmall!.copyWith(color: FColor.amber),
                              ),
                            if (currentDevice.deviceStatus == "unauthorized")
                              TextSpan(
                                text: localization.fUnauthorized,
                                style: textTheme.titleSmall!.copyWith(color: FColor.red),
                              ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(text: localization.fDeviceIP, style: textTheme.bodyLarge),
                            TextSpan(
                              text: currentDevice.deviceIP,
                              style: textTheme.titleSmall!.copyWith(color: FColor.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentDevice.deviceIP.startsWith(windowsIp)
                        ? () => showDialog(
                              context: context,
                              builder: (context) => DialogConnect(
                                currentDevice: currentDevice,
                                mode: localization.fTCPIP,
                              ),
                            )
                        : null,
                    icon: const Icon(Icons.wifi_rounded),
                    label: Text(localization.fTCPIP),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DialogConnect(
                        currentDevice: currentDevice,
                        mode: localization.fUSB,
                      ),
                    ),
                    icon: const Icon(Icons.usb_rounded),
                    label: Text(localization.fUSB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialogConnect extends ConsumerWidget {
  const DialogConnect({Key? key, required this.currentDevice, required this.mode}) : super(key: key);

  final DeviceStatus currentDevice;
  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness.name == 'dark';
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localization = ref.watch(localizationProvider);
    final String dialogTitle = '${currentDevice.deviceModel.isNotEmpty ? currentDevice.deviceModel : '???'} [ ${mode.toUpperCase()} ]';
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: FColor.s100(isDark),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(color: FColor.s200(isDark), borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                child: Text(dialogTitle, textAlign: TextAlign.center),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                decoration: BoxDecoration(border: Border.all(color: FColor.s200(isDark))),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      shape: Border(bottom: BorderSide(color: FColor.s300(isDark))),
                      visualDensity: const VisualDensity(vertical: -4),
                      dense: true,
                      title: Text(localization.fAlwaysOnTop, style: textTheme.titleSmall),
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          onChanged: (value) => ref.read(alwaysOnTopProvider.notifier).state = value!,
                          value: ref.watch(alwaysOnTopProvider),
                        ),
                      ),
                    ),
                    ListTile(
                      shape: Border(bottom: BorderSide(color: FColor.s300(isDark))),
                      visualDensity: const VisualDensity(vertical: -4),
                      dense: true,
                      title: Text(localization.fRecordScreen, style: textTheme.titleSmall),
                      subtitle: ref.watch(recordScreenMp4Provider)
                          ? Text('...\\Documents\\FfouryAPP', style: textTheme.bodySmall?.copyWith(fontSize: 10.0))
                          : null,
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          onChanged: (value) => ref.read(recordScreenMp4Provider.notifier).state = value!,
                          value: ref.watch(recordScreenMp4Provider),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(localization.fCancel),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(scrcpyProvider.notifier).runScrcpy(currentDevice, mode);
                      },
                      style: OutlinedButton.styleFrom(backgroundColor: FColor.green.withOpacity(0.8)),
                      child: Text(localization.fConnect),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
