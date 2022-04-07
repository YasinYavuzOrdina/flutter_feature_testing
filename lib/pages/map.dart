import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/widgets/drawer.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  static const String route = '/map';

  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _mapController;

  final LatLng startPosition = LatLng(51.05182, 4.45411);
  List<Marker> markers = [
    Marker(
      width: 50.0,
      height: 50.0,
      point: LatLng(51.05182, 4.45411),
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://yt3.ggpht.com/ytc/AKedOLRB62Zq_HPbCPACN3dLfbByLHG2LCbcN3yk7aIJVw=s900-c-k-c0x00ffffff-no-rj',
            ),
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter tests'),
      ),
      drawer: buildDrawer(context, MapPage.route),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onLongPress: (tapPosition, point) {
                setState(() {
                  markers.add(
                    Marker(
                      point: point,
                      builder: (ctx) => SizedBox(
                        child: GestureDetector(
                          onTap: () {
                            int markerIndex = markers.indexWhere(
                                (element) => element.point == point);

                            showDialog(
                              context: context,
                              builder: (ctx) {
                                Marker currentMarker = markers[markerIndex];
                                return AlertDialog(
                                  title: const Text('Marker information'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(currentMarker.point.toSexagesimal())
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          markers.removeAt(markerIndex);
                                        });
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Remove marker'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 10,
                            height: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
              center: startPosition,
              maxZoom: 18.0,
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: markers,
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
          Container(
              color: Colors.white,
              child: const Text('On long press: new marker on that position')),
        ],
      ),
    );
  }
}
