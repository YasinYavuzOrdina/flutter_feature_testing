import 'dart:io';

import 'package:flutter_feature_testing/pages/mapandcamerademo/models/pin.model.dart';
import 'package:latlong2/latlong.dart';

class InfoPin extends Pin {
  InfoPin({
    required String type,
    required LatLng point,
    required this.information,
    required this.pictures,
  }) : super(type: type, point: point);

  String information;
  List<File> pictures;
}
