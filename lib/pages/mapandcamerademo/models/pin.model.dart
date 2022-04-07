import 'package:latlong2/latlong.dart';

abstract class Pin {
  Pin({required this.type, required this.point});

  String type;
  LatLng point;
}
