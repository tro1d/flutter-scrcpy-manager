import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/scrcpy_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant_string.dart';

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
                            TextSpan(text: ConstantString.fStatus, style: textTheme.bodyLarge),
                            if (currentDevice.deviceStatus == "device")
                              TextSpan(
                                text: ConstantString.fOnline,
                                style: textTheme.titleSmall!.copyWith(color: FColor.green),
                              ),
                            if (currentDevice.deviceStatus == "offline")
                              TextSpan(
                                text: ConstantString.fOffline,
                                style: textTheme.titleSmall!.copyWith(color: FColor.amber),
                              ),
                            if (currentDevice.deviceStatus == "unauthorized")
                              TextSpan(
                                text: ConstantString.fUnauthorized,
                                style: textTheme.titleSmall!.copyWith(color: FColor.red),
                              ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(text: ConstantString.fDeviceIP, style: textTheme.bodyLarge),
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
                        ? () => ref.read(scrcpyProvider.notifier).runScrcpy(currentDevice, ConstantString.fTCPIP)
                        : null,
                    icon: const Icon(Icons.wifi_rounded),
                    label: const Text(ConstantString.fTCPIP),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => ref.read(scrcpyProvider.notifier).runScrcpy(currentDevice, ConstantString.fUSB),
                    icon: const Icon(Icons.usb_rounded),
                    label: const Text(ConstantString.fUSB),
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
