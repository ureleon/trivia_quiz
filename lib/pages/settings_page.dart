import 'dart:async';
import 'dart:collection';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';
import 'package:trivia_questions/config/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return const PreferencesState();
  }
}

class PreferencesState extends StatefulWidget {
  const PreferencesState({super.key});

  @override
  State<PreferencesState> createState() => _PreferencesStateState();
}

class _PreferencesStateState extends State<PreferencesState> {
  final Future<SharedPreferencesWithCache> _prefs =
  SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'settings', 'timer','results','quizBLocks'},
    ),
  );
  late Future<int> _theme;
  final Completer<void> _preferencesReady = Completer<void>();

  Future<void> _migratePreferences() async {
    // #docregion migrate
    const SharedPreferencesOptions sharedPreferencesOptions =
    SharedPreferencesOptions();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: prefs,
      sharedPreferencesAsyncOptions: sharedPreferencesOptions,
      migrationCompletedKey: 'migrationCompleted',
    );
    // #enddocregion migrate
  }

  @override
  void initState() {
    super.initState();
    _migratePreferences().then((_) {
      _theme = _prefs.then((final SharedPreferencesWithCache prefs) {
        return prefs.getInt('settings') ?? 0;
      });

      _preferencesReady.complete();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd:(DragEndDetails details){
          final double velocity = details.velocity.pixelsPerSecond.dx;
          if (velocity > 350) {
            context.go('/');
          }
        },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Settings page'),
      ),
      body: Center(child: Column(
        children: <Widget>[
          _WaitForInitialization(
            initialized: _preferencesReady.future,
            builder: (final BuildContext context) => FutureBuilder<int>(
              future: _theme,
              builder:
                  (
                  final BuildContext context,
                  final AsyncSnapshot<int> snapshot,
                  ) {
                didChangeDependencies();
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    throw Exception('Settings is not here for now');
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator(
                      color: Colors.redAccent,
                    );
                  case ConnectionState.active:
                    throw Exception('settings is loading');
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('snapshot has error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 10,),
                          DropdownMenu<_ModeLabel>(
                            enableSearch: false,
                            requestFocusOnTap: false,
                            leadingIcon: const Icon(
                              Icons.accessibility_new_rounded,
                            ),
                            label: const Text('Theme'),
                            onSelected: (final _ModeLabel? number) =>
                                ThemeController.of(
                                  context,
                                ).updateTheme(number!.number),
                            dropdownMenuEntries: _ModeLabel.entries,
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    ),
    )
    );
  }
}

class _WaitForInitialization extends StatelessWidget {
  const _WaitForInitialization({
    required this.initialized,
    required this.builder,
  });

  final Future<void> initialized;
  final WidgetBuilder builder;

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<void>(
      future: initialized,
      builder:
          (final BuildContext context, final AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const CircularProgressIndicator();
        }
        return builder(context);
      },
    );
  }
}

typedef _ModeEntry = DropdownMenuEntry<_ModeLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
enum _ModeLabel {
  system('System Theme', 1),
  light('Light Theme', 2),
  dark('Dark Theme', 3);

  const _ModeLabel(this.label, this.number);
  final String label;
  final int number;

  static final List<_ModeEntry> entries = UnmodifiableListView<_ModeEntry>(
    values.map<_ModeEntry>(
          (final _ModeLabel number) => _ModeEntry(value: number, label: number.label),
    ),
  );
}
