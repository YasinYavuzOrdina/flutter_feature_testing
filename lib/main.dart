import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/pages/camera.dart';
import 'package:flutter_feature_testing/pages/home.dart';
import 'package:flutter_feature_testing/pages/map.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/mapdemo.dart';
import 'package:hive_flutter/hive_flutter.dart';

late final List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();
  await Hive.initFlutter();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Feature Testing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        CameraPage.route: (context) => CameraPage(
              cameras: cameras,
            ),
        MapPage.route: (context) => const MapPage(),
        MapDemoPage.route: (context) => const MapDemoPage(),
      },
    );
  }
}
