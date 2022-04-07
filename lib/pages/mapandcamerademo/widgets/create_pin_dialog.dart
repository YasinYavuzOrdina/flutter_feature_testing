import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/main.dart';
import 'package:latlong2/latlong.dart';

class CreatePinDialog extends StatefulWidget {
  final LatLng point;

  final Function addPin;

  const CreatePinDialog({
    Key? key,
    required this.point,
    required this.addPin,
  }) : super(key: key);

  @override
  State<CreatePinDialog> createState() => _CreatePinDialogState();
}

class _CreatePinDialogState extends State<CreatePinDialog> {
  late CameraController _cameraController;
  final TextEditingController _informationController = TextEditingController();
  late Future<void> _initCameraController;

  List<File> captures = [];
  int selectedCamera = 0;

  _initCamera(int cameraIndex) async {
    _cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.max,
    );

    _initCameraController = _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();

    if (cameras.isNotEmpty) {
      _initCamera(selectedCamera);
    }
  }

  @override
  void dispose() {
    _informationController.dispose();

    if (cameras.isNotEmpty) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new pin'),
      content: SizedBox(
        height: 300,
        width: 300,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: _informationController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintMaxLines: 5,
                  hintText:
                      'Write what the problem is. What is wrong? What is information that should be noted? Extra information?'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Pictures',
            ),
            ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (ctx, pa, sa) => Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [
                        cameras.isNotEmpty
                            ? FutureBuilder<void>(
                                future: _initCameraController,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.none) {
                                    return Stack(
                                        alignment:
                                            AlignmentDirectional.bottomCenter,
                                        children: [
                                          CameraPreview(_cameraController),
                                          Positioned(
                                            bottom: 50,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await _initCameraController; //To make sure camera is initialized
                                                var xFile =
                                                    await _cameraController
                                                        .takePicture();
                                                setState(() {
                                                  // captures.add(
                                                  //   File(xFile
                                                  //       .path),
                                                  // );
                                                  captures = [
                                                    ...captures,
                                                    File(xFile.path)
                                                  ];
                                                });
                                                Navigator.pop(context);
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
                                        ]);
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              )
                            : const Center(
                                child: Text('No cameras on device'),
                              )
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            Text(captures.length.toString()),
            SizedBox(
              height: 200,
              width: 200,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(captures.length, (index) {
                    print(captures.length);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(captures[index]),
                    );
                  })
                  // itemCount: captures.length,
                  // itemBuilder: (context, index) {
                  //   return Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Image.file(captures[index]),
                  //   );
                  // },
                  ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.addPin(captures, _informationController.text);
            captures.clear();
            _informationController.clear();
            Navigator.pop(context);
          },
          child: const Text(
            'SAVE',
          ),
        )
      ],
    );
  }
}
