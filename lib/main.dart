import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/pages/camera.dart';
import 'package:flutter_feature_testing/pages/home.dart';
import 'package:flutter_feature_testing/pages/map.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/mapdemo.dart';
import 'package:flutter_feature_testing/pages/pkceflow/auth_redirect.dart';
import 'package:flutter_feature_testing/pages/pkceflow/login.dart';
import 'package:flutter_feature_testing/pages/pkceflow/login2.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:hive_flutter/hive_flutter.dart';

late final List<CameraDescription> cameras;
Future<void> main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  if (!kIsWeb) {
    cameras = await availableCameras();
  }
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Feature Testing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name!.contains(AuthRedirectPage.routeName)) {
          return MaterialPageRoute(
            builder: (context) {
              return const AuthRedirectPage();
            },
          );
        }
        return null;
      },
      routes: <String, WidgetBuilder>{
        CameraPage.route: (context) => CameraPage(
              cameras: cameras,
            ),
        MapPage.route: (context) => const MapPage(),
        MapDemoPage.route: (context) => const MapDemoPage(),
        LoginPage.route: (context) => const LoginPage(),
        Login2Page.route: (context) => const Login2Page(),

        //test
        AuthRedirectPage.routeName: (context) => const AuthRedirectPage(),
      },
    );
  }
}
