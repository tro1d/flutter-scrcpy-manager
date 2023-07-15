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

    final TextEditingController inputController = TextEditingController();
    final TextEditingController outputController = ref.watch(outputControllerProvider);

    void runCommand() async {
      final output = ref.watch(outputListProvider);
      final String command = inputController.text;
      inputController.clear();

      final result = await ref.read(runConsoleProvider.notifier).runCommand(command);
      output.add(result);
      outputController.text = ref.watch(outputListProvider).join();
    }

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
          child: Column(
            children: <Widget>[
              TextField(
                controller: inputController,
                maxLines: null,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => runCommand(),
                decoration: InputDecoration(
                  labelText: 'CMD',
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  suffixIcon: IconButton(
                    onPressed: () => runCommand(),
                    icon: const Icon(Icons.send_rounded),
                  ),
                  suffixIconColor: FColor.s600(isDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
