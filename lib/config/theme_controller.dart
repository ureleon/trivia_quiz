import 'package:flutter/material.dart';

class ThemeController extends InheritedWidget {
  const ThemeController({
    super.key,
    required this.updateTheme,
    required super.child,
  });

  final void Function(int) updateTheme;

  static ThemeController of(final BuildContext context) {
    final ThemeController? result = context
        .dependOnInheritedWidgetOfExactType<ThemeController>();
    assert(result != null, 'No ThemeController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(final ThemeController oldWidget) =>
      updateTheme != oldWidget.updateTheme;
}
