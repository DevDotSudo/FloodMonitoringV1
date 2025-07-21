import 'package:flood_monitoring/controllers/navigation_controller.dart';
import 'package:flood_monitoring/controllers/send_warning_controller.dart';
import 'package:flood_monitoring/controllers/subscriber_controller.dart';
import 'package:flood_monitoring/controllers/water_level_data_controller.dart';
import 'package:flood_monitoring/dao/mysql/mysql_connection.dart';
import 'package:flood_monitoring/firebase_options.dart';
import 'package:flood_monitoring/services/alert_service/notification_alert_service.dart';
import 'package:flood_monitoring/services/firestore_services/water_level_service.dart';
import 'package:flood_monitoring/views/screens/dashboard_screen.dart';
import 'package:flood_monitoring/views/screens/desktop_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

final notificationService = NotificationAlertService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MySQLService.getConnection()
      .then((_) => print('MySQL connected'))
      .catchError((error) => print('MySQL connection error: $error'));
  WaterLevelService().startListening();

  runApp(const FloodMonitoring());

  doWhenWindowReady(() {
    const minSize = Size(1700, 900);
    appWindow.minSize = minSize;
    appWindow.size = minSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class FloodMonitoring extends StatelessWidget {
  const FloodMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => SubscriberController()),
        ChangeNotifierProvider(create: (_) => SendWarningController()),
        ChangeNotifierProvider(
          create: (_) => WaterLevelDataController()..loadWaterLevels(),
          child: DashboardScreen(),
        ),
      ],

      child: MaterialApp(
        title: 'River Safety Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
        home: const DesktopLoginScreen(),
      ),
    );
  }
}
