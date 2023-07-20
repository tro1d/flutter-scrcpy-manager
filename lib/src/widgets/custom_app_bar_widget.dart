import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../localization/localization.dart';
import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/tray_manager_provider.dart';
import '../utils/colors.dart';

final onHoverCustomPopupMenuLabel = StateProvider<String>((ref) => '');
final onHoverCustomIconButton = StateProvider<IconData?>((ref) => null);

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
    final localization = ref.watch(localizationProvider);
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
                      widget.iconApp ?? const SizedBox(),
                      const SizedBox(width: 8.0),
                      Text(widget.title, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
            CustomIconButton(
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
              iconData: Icons.developer_mode_outlined,
            ),
            MouseRegion(
              onEnter: (_) => ref.read(onHoverCustomIconButton.notifier).state = Icons.menu,
              onExit: (_) => ref.read(onHoverCustomIconButton.notifier).state = null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: ref.watch(onHoverCustomIconButton) == Icons.menu ? FColor.s200(widget.brightness.name == 'dark') : null,
                child: PopupMenuButton<Widget>(
                  tooltip: '',
                  icon: Icon(
                    Icons.menu,
                    color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                    size: 18,
                  ),
                  itemBuilder: (context) => <PopupMenuItem<Widget>>[
                    PopupMenuItem(
                      height: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: PopupMenuButton<Widget>(
                        tooltip: '',
                        offset: const Offset(-112, 0),
                        position: PopupMenuPosition.over,
                        constraints: const BoxConstraints(maxWidth: 120.0),
                        child: CustomPopupMenuLabel(
                          label: localization.flanguage,
                          leading: Icon(
                            Icons.language_rounded,
                            color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                            size: 18,
                          ),
                          suffix: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                            size: 12,
                          ),
                        ),
                        itemBuilder: (BuildContext context) => List.generate(
                          localeApp.length,
                          (i) => PopupMenuItem(
                            onTap: () {
                              Navigator.of(context).pop();
                              ref.read(localeProvider.notifier).setLocale(Locale(localeApp[i]['code']!));
                            },
                            height: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CustomPopupMenuLabel(
                              label: localeApp[i]['language']!,
                              leading: Icon(
                                Icons.check,
                                color: ref.watch(localeProvider).languageCode == localeApp[i]['code']
                                    ? widget.brightness.name == 'dark'
                                        ? const Color(0xBDFFFFFF)
                                        : Colors.black
                                    : FColor.transparent,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      height: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: PopupMenuButton(
                        tooltip: '',
                        offset: const Offset(-112, 0),
                        position: PopupMenuPosition.over,
                        constraints: const BoxConstraints(maxWidth: 120.0),
                        child: CustomPopupMenuLabel(
                          label: localization.fThemeMode,
                          leading: Icon(
                            widget.brightness.name == 'dark' ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                            size: 18,
                          ),
                          suffix: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : Colors.black,
                            size: 12,
                          ),
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuItem<CustomPopupMenuLabel>>[
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context).pop();
                              ref.read(themeProvider.notifier).isLight();
                            },
                            height: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CustomPopupMenuLabel(
                              label: localization.fLight,
                              suffix: Icon(
                                Icons.light_mode_outlined,
                                color: FColor.amber,
                                size: 18,
                              ),
                              leading: Icon(
                                Icons.check,
                                color: widget.brightness.name == 'dark' ? FColor.transparent : Colors.black,
                                size: 18,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context).pop();
                              ref.read(themeProvider.notifier).isDark();
                            },
                            height: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CustomPopupMenuLabel(
                              label: localization.fDark,
                              suffix: Icon(
                                Icons.dark_mode_rounded,
                                color: FColor.isLightMaterialColor.shade600,
                                size: 18,
                              ),
                              leading: Icon(
                                Icons.check,
                                color: widget.brightness.name == 'dark' ? const Color(0xBDFFFFFF) : FColor.transparent,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomIconButton(
              onPressed: () => windowManager.minimize(),
              iconData: Icons.remove,
            ),
            CustomIconButton(
              onPressed: () => onCloseDialog(),
              iconData: Icons.close,
              hoverColor: FColor.red.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Future<Dialog?> onCloseDialog() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localization = ref.watch(localizationProvider);

    return showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(localization.fExitQ, style: textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Text(localization.fExitN, style: textTheme.bodyLarge?.copyWith(fontSize: 14.0)),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(isExitAppProvider.notifier).state = false;
                          },
                          child: Text(localization.fCancel),
                        ),
                        OutlinedButton(
                          onPressed: widget.onpressedExitAppDisconect,
                          child: Text(localization.fExitDisconnect),
                        ),
                        OutlinedButton(
                          onPressed: widget.onpressedExitApp,
                          child: Text(localization.fExit),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomPopupMenuLabel extends ConsumerWidget {
  const CustomPopupMenuLabel({Key? key, required this.label, this.leading, this.suffix}) : super(key: key);

  final String label;
  final Widget? leading;
  final Widget? suffix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = Theme.of(context).brightness.name == 'dark';
    return MouseRegion(
      onExit: (_) => ref.read(onHoverCustomPopupMenuLabel.notifier).state = '',
      onEnter: (_) => ref.read(onHoverCustomPopupMenuLabel.notifier).state = label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        width: double.infinity,
        color: ref.watch(onHoverCustomPopupMenuLabel) == label ? FColor.s200(isDark) : null,
        child: Row(
          children: <Widget>[
            if (leading != null) Padding(padding: const EdgeInsets.only(right: 4.0), child: leading),
            Expanded(child: Text(label)),
            if (suffix != null) Padding(padding: const EdgeInsets.only(left: 4.0), child: suffix),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends ConsumerWidget {
  const CustomIconButton({Key? key, this.onPressed, required this.iconData, this.hoverColor}) : super(key: key);

  final VoidCallback? onPressed;
  final IconData iconData;
  final Color? hoverColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = Theme.of(context).brightness.name == 'dark';
    Color? containerColor;

    if (hoverColor == null) {
      containerColor = ref.watch(onHoverCustomIconButton) == iconData ? FColor.s200(isDark) : null;
    } else {
      containerColor = ref.watch(onHoverCustomIconButton) == iconData ? hoverColor : null;
    }

    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      onEnter: (_) => ref.read(onHoverCustomIconButton.notifier).state = iconData,
      onExit: (_) => ref.read(onHoverCustomIconButton.notifier).state = null,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          color: containerColor,
          child: Icon(
            iconData,
            color: isDark ? const Color(0xBDFFFFFF) : Colors.black,
            size: 18,
          ),
        ),
      ),
    );
  }
}
