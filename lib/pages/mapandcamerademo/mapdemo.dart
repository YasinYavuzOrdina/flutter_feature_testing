import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/main.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/models/infopin.model.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/models/pin.model.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/widgets/create_pin_dialog.dart';
import 'package:flutter_feature_testing/widgets/drawer.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapDemoPage extends StatefulWidget {
  static const String route = '/mapdemo';

  const MapDemoPage({Key? key}) : super(key: key);

  @override
  State<MapDemoPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapDemoPage> {
  late final MapController _mapController;
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;

  bool isAddingMarkers = false;

  final LatLng startPosition = LatLng(51.05182, 4.45411);
  List<Marker> markers = [];

  List<Marker> addingMarkers = [];

  List<Pin> newPins = [];

  @override
  void initState() {
    super.initState();

    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rerendered');
    return Scaffold(
      appBar: isAddingMarkers ? _buildEditingAppbar() : _buildDefaultAppbar(),
      drawer: buildDrawer(context, MapDemoPage.route),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
          );
          // Center the location marker on the map and zoom the map to level 18.
          _centerCurrentLocationStreamController.add(18);
        },
        child: const Icon(Icons.my_location_outlined),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              plugins: [
                MarkerClusterPlugin(),
                const LocationMarkerPlugin(),
              ],
              onLongPress: (tapPosition, point) {
                setState(
                  () {
                    isAddingMarkers = true;

                    showDialog(
                        context: context,
                        builder: (ctx) => CreatePinDialog(
                            point: point,
                            addPin: (captures, information) {
                              setState(() {
                                newPins.add(
                                  InfoPin(
                                    type: 'INFO',
                                    point: point,
                                    information: information,
                                    pictures: [...captures],
                                  ),
                                );
                              });
                            })
                        // AlertDialog(
                        //   title: const Text('Create new pin'),
                        //   content: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       TextField(
                        //         controller: _informationController,
                        //         keyboardType: TextInputType.multiline,
                        //         maxLines: null,
                        //         decoration: const InputDecoration(
                        //             hintMaxLines: 5,
                        //             hintText:
                        //                 'Write what the problem is. What is wrong? What is information that should be noted? Extra information?'),
                        //       ),
                        //       const SizedBox(
                        //         height: 16,
                        //       ),
                        //       const Text(
                        //         'Pictures',
                        //       ),
                        //       ElevatedButton(
                        //         onPressed: () {
                        //           showGeneralDialog(
                        //             context: context,
                        //             pageBuilder: (ctx, pa, sa) => Scaffold(
                        //               appBar: AppBar(),
                        //               body: Column(
                        //                 children: [
                        //                   cameras.isNotEmpty
                        //                       ? FutureBuilder<void>(
                        //                           future: _initCameraController,
                        //                           builder: (context, snapshot) {
                        //                             if (snapshot
                        //                                     .connectionState !=
                        //                                 ConnectionState.none) {
                        //                               return Stack(
                        //                                   alignment:
                        //                                       AlignmentDirectional
                        //                                           .bottomCenter,
                        //                                   children: [
                        //                                     CameraPreview(
                        //                                         _cameraController),
                        //                                     Positioned(
                        //                                       bottom: 50,
                        //                                       child:
                        //                                           GestureDetector(
                        //                                         onTap: () async {
                        //                                           await _initCameraController; //To make sure camera is initialized
                        //                                           var xFile =
                        //                                               await _cameraController
                        //                                                   .takePicture();
                        //                                           setState(() {
                        //                                             // captures.add(
                        //                                             //   File(xFile
                        //                                             //       .path),
                        //                                             // );
                        //                                             captures = [
                        //                                               ...captures,
                        //                                               File(xFile
                        //                                                   .path)
                        //                                             ];
                        //                                           });
                        //                                           Navigator.pop(
                        //                                               context);
                        //                                         },
                        //                                         child: Container(
                        //                                           height: 60,
                        //                                           width: 60,
                        //                                           decoration:
                        //                                               const BoxDecoration(
                        //                                             shape: BoxShape
                        //                                                 .circle,
                        //                                             color: Colors
                        //                                                 .white,
                        //                                           ),
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   ]);
                        //                             } else {
                        //                               return const Center(
                        //                                   child:
                        //                                       CircularProgressIndicator());
                        //                             }
                        //                           },
                        //                         )
                        //                       : const Center(
                        //                           child: Text(
                        //                               'No cameras on device'),
                        //                         )
                        //                 ],
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //         child: const Icon(Icons.add),
                        //       ),
                        //       Text(captures.length.toString()),
                        //       SizedBox(
                        //         height: 200,
                        //         width: 200,
                        //         child: ListView(
                        //             scrollDirection: Axis.horizontal,
                        //             shrinkWrap: true,
                        //             children:
                        //                 List.generate(captures.length, (index) {
                        //               print(captures.length);
                        //               return Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Image.file(captures[index]),
                        //               );
                        //             })
                        //             // itemCount: captures.length,
                        //             // itemBuilder: (context, index) {
                        //             //   return Padding(
                        //             //     padding: const EdgeInsets.all(8.0),
                        //             //     child: Image.file(captures[index]),
                        //             //   );
                        //             // },
                        //             ),
                        //       )
                        //     ],
                        //   ),
                        //   actions: [
                        //     TextButton(
                        //       onPressed: () {
                        //         v
                        //         captures.clear();
                        //         _informationController.clear();
                        //         Navigator.pop(context);
                        //       },
                        //       child: const Text(
                        //         'SAVE',
                        //       ),
                        //     )
                        //   ],
                        // ),
                        );
                  },
                );
              },
              center: LatLng(0, 0),
              maxZoom: 18.0,
              zoom: 18.0,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(
                    () =>
                        _centerOnLocationUpdate = CenterOnLocationUpdate.never,
                  );
                }
              },
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ),
              LocationMarkerLayerWidget(
                options: LocationMarkerLayerOptions(),
                plugin: LocationMarkerPlugin(
                    centerCurrentLocationStream:
                        _centerCurrentLocationStreamController.stream,
                    centerOnLocationUpdate: _centerOnLocationUpdate),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 50,
                  size: const Size(40, 40),
                  centerMarkerOnClick: true,
                  showPolygon: false,
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                  markers: isAddingMarkers
                      ? [
                          ...markers,
                          ...pinsToMarkers(newPins),
                        ]
                      : markers,
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _mapController.move(
                        _mapController.center, _mapController.zoom + 0.5);
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mapController.move(
                        _mapController.center, _mapController.zoom - 0.5);
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _informationDialog(
      Marker currentMarker, InfoPin pin, BuildContext ctx) {
    print(pin.pictures.length);
    return AlertDialog(
      title: const Text('Marker information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentMarker.point.toSexagesimal(),
          ),
          Text(pin.information),
          SizedBox(
            height: 200,
            width: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: pin.pictures.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(pin.pictures[index]),
                );
              },
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              markers =
                  markers.where((element) => element != currentMarker).toList();
            });
            Navigator.pop(ctx);
            setState(() {});
          },
          child: const Text('Remove marker'),
        ),
      ],
    );
  }

  AppBar _buildDefaultAppbar() {
    return AppBar(
      title: const Text('Flutter tests'),
    );
  }

  AppBar _buildEditingAppbar() {
    return AppBar(
      title: const Text('Adding markers'),
      backgroundColor: Colors.blue.shade900,
      actions: [
        IconButton(
          onPressed: () {
            setState(
              () {
                markers = [
                  ...markers,
                  ...pinsToMarkers(newPins),
                ];
                newPins.clear();
                isAddingMarkers = false;
              },
            );
          },
          icon: const Icon(Icons.save),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              newPins.clear();
              isAddingMarkers = false;
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  List<Marker> pinsToMarkers(List<Pin> pins) {
    return newPins
        .map(
          (e) => Marker(
            point: e.point,
            builder: (ctx) {
              if (e.type == 'INFO') {
                InfoPin pin = e as InfoPin;
                return SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      if (!isAddingMarkers) {
                        int markerIndex = markers
                            .indexWhere((element) => element.point == e.point);

                        showDialog(
                          context: context,
                          builder: (ctx) {
                            Marker currentMarker = markers[markerIndex];
                            return _informationDialog(currentMarker, pin, ctx);
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 20,
                  height: 20,
                  color: Colors.red,
                );
              }
            },
          ),
        )
        .toList();
  }
}
