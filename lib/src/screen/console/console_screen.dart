import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/console_provider.dart';
import '../../utils/colors.dart';

final runConsoleProvider = AsyncNotifierProvider<RunConsoleNotifier, void>(RunConsoleNotifier.new);

class ConsoleScreen extends ConsumerWidget {
  const ConsoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness.name == 'dark';
    final TextEditingController outputController = ref.watch(outputControllerProvider);

    void runCmd(TextEditingController inputController) async {
      final output = ref.watch(outputListProvider);
      final String command = inputController.text;
      inputController.clear();

      final result = await ref.read(runConsoleProvider.notifier).runCommand(command);
      output.add(result);
      outputController.text = ref.watch(outputListProvider).join();
    }

    final List<String> adbCommands = [
      'adb devices',
      'adb devices -l',
      'adb kill-server',
      'adb start-server ',
      'adb reboot',
      'adb reboot recovery ',
      'adb reboot-bootloader',
      'adb shell',
      'adb shell getprop',
      'adb usb',
      "adb connect ",
      'adb tcpip',
      'adb -s',
      "adb logcat",
      "adb logcat -c ",
      "adb shell input keyevent ",
      "adb shell ls ",
      "adb shell ls -s ",
      "adb shell ls -R ",
      "adb bugreport",
      "adb backup",
      "adb restore",
      "adb sideload",
      'clear',
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: FColor.s050(isDark).withOpacity(isDark ? 0.8 : 1),
              border: Border.all(color: FColor.s200(!isDark)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              textAlign: TextAlign.start,
              controller: outputController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12.0),
              readOnly: true,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: RawAutocomplete<String>(
            optionsBuilder: (textEditingController) {
              List<String> matches = <String>[];
              matches.addAll(adbCommands);
              matches.retainWhere((s) => s.toLowerCase().startsWith(textEditingController.text.toLowerCase()));
              return matches;
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                maxLines: null,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) => runCmd(textEditingController),
                decoration: InputDecoration(
                  labelText: 'CMD',
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  suffixIconColor: FColor.s600(isDark),
                  suffixIcon: IconButton(
                    onPressed: () => runCmd(textEditingController),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Transform.translate(
                offset: const Offset(0, -45),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    type: MaterialType.transparency,
                    elevation: 4.0,
                    child: SizedBox(
                      height: 36.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return Text(
                            option,
                            maxLines: null,
                            style: TextStyle(
                              color: FColor.s600(isDark).withOpacity(0.6),
                              fontSize: 16.0,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
