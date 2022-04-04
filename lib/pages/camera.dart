import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/widgets/drawer.dart';

class CameraPage extends StatefulWidget {
  static const String route = '/camera';
  final List<CameraDescription> cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late Future<void> _initCameraController;

  List<File> captures = [];
  int selectedCamera = 0;

  _initCamera(int cameraIndex) async {
    _cameraController = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.max,
    );

    _initCameraController = _cameraController.initialize();
  }

  @override
  void initState() {
    _initCamera(selectedCamera);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      drawer: buildDrawer(context, CameraPage.route),
      body: FutureBuilder<void>(
        future: _initCameraController,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none) {
            return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        if (captures.isEmpty) return; //Return if no image
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => GalleryScreen(
                        //             images: capturedImages.reversed.toList())));
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          image: captures.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(captures.last),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black, BlendMode.hue),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: Center(
                            child: Text(
                          captures.length.toString(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: GestureDetector(
                      onTap: () async {
                        await _initCameraController; //To make sure camera is initialized
                        var xFile = await _cameraController.takePicture();
                        setState(() {
                          captures.add(File(xFile.path));
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: IconButton(
                      onPressed: () {
                        if (widget.cameras.length > 1) {
                          setState(
                            () {
                              selectedCamera =
                                  selectedCamera == 0 ? 1 : 0; //Switch camera
                              _initCamera(selectedCamera);
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No secondary camera found'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.switch_camera_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
