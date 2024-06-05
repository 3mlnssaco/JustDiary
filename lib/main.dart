import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'theme_notifier.dart';
import 'home_screen.dart';
import 'settings_screen.dart'; // 설정 화면 추가

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) =>
          ThemeNotifier(ThemeData.light()), // Set initial theme to light
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      theme: themeNotifier.getTheme(),
      home: const HomeScreen(),
      routes: {
        '/settings': (context) => const SettingScreen(),
      },
    );
  }
}

void scheduleAlarm(DateTime scheduledTime) async {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'App usage notification',
    '지금 일기를 쓰지 않으면, 우리는 춤을 출거에요 ',
    tz.TZDateTime.from(scheduledTime, tz.local), // 시간대 변환
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
