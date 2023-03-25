import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xstask/db/db_helper.dart';
import 'package:xstask/services/notification_service.dart';
import 'package:xstask/services/theme_service.dart';
import 'package:xstask/Screens/Home/home_screen.dart';
import 'package:xstask/services/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  await NotificationService().requestIOSPermissions();
  await DBHelper.initDb();
  await GetStorage.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      title: 'X Task',
      home: HomePage(),
    );
  }
}
