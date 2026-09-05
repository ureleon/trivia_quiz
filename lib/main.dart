import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_questions/config/go_router.dart';
import 'package:trivia_questions/config/theme_controller.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const Map<int, ThemeMode> themeMap = <int, ThemeMode>{
  1: ThemeMode.system,
  2: ThemeMode.light,
  3: ThemeMode.dark,
};

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((String task, Map<String, dynamic>? inputData) async{
    // Настройка уведомлений для Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings,);

    // Параметры самого уведомления
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '69',
      'trivia quiz',
      icon: '@mipmap/ic_launcher', // Имя канала
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Показываем уведомление
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'trivia quiz!',
      body: 'what about quiz?',
      notificationDetails: platformChannelSpecifics,
    );

    return Future<bool>.value(true);
  });
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    '96',
    'trivia quiz',
    icon: '@mipmap/ic_launcher',
    importance: Importance.max,
    priority: Priority.high,

  );

  const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id: 1,
    title: 'trivia quiz?',
    body: 'quiz is waiting for you',
    notificationDetails:  platformDetails,
  );
}

late ThemeMode globalThemeMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ThemeMode themeModeFromCache = themeMap[prefs.getInt('settings') ?? 1]!;

  unawaited(Workmanager().initialize(callbackDispatcher));

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  unawaited(flutterLocalNotificationsPlugin.initialize(settings: initializationSettings));

  unawaited(Workmanager().registerPeriodicTask(
    'periodicPush',
    'push-notification',
    frequency: const Duration(hours: 12),
    constraints: Constraints(networkType: NetworkType.notRequired),
  ));

  runApp(MyApp(themeMode: themeModeFromCache));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.themeMode});

  final ThemeMode themeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late final GoRouter _router = GoRouter(
    routes: $appRoutes,
    initialLocation: '/',
  );

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ThemeMode themeMode =
    themeMap[prefs.getInt('settings') ?? 1]!;
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _updateThemeMode(final int mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('settings', mode);
    setState(() => _themeMode = themeMap[mode]!);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      updateTheme: _updateThemeMode,
      child: MaterialApp.router(
        title: 'Trivia',
        themeMode: _themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        routerConfig: _router,
      ),
    );
  }
}
