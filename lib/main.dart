import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/pages/camera.dart';
import 'package:flutter_feature_testing/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
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
      },
    );
  }
}
