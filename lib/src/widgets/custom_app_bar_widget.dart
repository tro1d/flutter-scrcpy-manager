import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/theme_provider.dart';
import '../providers/tray_manager_provider.dart';
import '../utils/constant_string.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String title;
  final Brightness brightness;
  final Color backgroundColor;
  final Widget? iconApp;
  final VoidCallback? onpressedIconApp;
  final VoidCallback? onpressedExitApp;
  final VoidCallback? onpressedExitAppDisconect;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.brightness,
    required this.backgroundColor,
    this.iconApp,
    this.onpressedIconApp,
    this.onpressedExitApp,
    this.onpressedExitAppDisconect,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(32);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isExitAppProvider, (previous, next) => next ? onCloseDialog() : null);
    return SizedBox(
      height: 32,
      width: 400.0,
      child: Container(
        color: widget.backgroundColor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) => windowManager.startDragging(),
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: <Widget>[
                      InkWell(onTap: widget.onpressedIconApp, child: widget.iconApp ?? const SizedBox()),
                      Text(widget.title, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                final page = ref.read(pageControllerProvider);
                if (ref.watch(pageControllerProvider).page == 0) {
                  page.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                } else {
                  page.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                }
              },
              icon: Icon(
                Icons.developer_mode_outlined,
                color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                size: 18,
              ),
            ),
            IconButton(
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              icon: Icon(
                widget.brightness.name == 'dark' ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                size: 18,
              ),
            ),
            WindowCaptionButton.minimize(
              brightness: widget.brightness,
              onPressed: () => windowManager.minimize(),
            ),
            WindowCaptionButton.unmaximize(
              brightness: widget.brightness,
              onPressed: () {},
            ),
            WindowCaptionButton.close(
              brightness: widget.brightness,
              onPressed: () => onCloseDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Dialog?> onCloseDialog() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text(ConstantString.fExitQ),
            titleTextStyle: textTheme.titleSmall,
            content: const Text(ConstantString.fExitN),
            contentTextStyle: Theme.of(context).textTheme.bodyLarge,
            actions: <Widget>[
              OutlinedButton(
                child: const Text(ConstantString.fCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(isExitAppProvider.notifier).state = false;
                },
              ),
              OutlinedButton(
                onPressed: widget.onpressedExitApp,
                child: const Text(ConstantString.fExit),
              ),
              OutlinedButton(
                onPressed: widget.onpressedExitAppDisconect,
                child: const Text(ConstantString.fExitDisconnect),
              ),
            ],
          ),
        );
      },
    );
  }
}
