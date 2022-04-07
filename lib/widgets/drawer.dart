import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/pages/camera.dart';
import 'package:flutter_feature_testing/pages/home.dart';
import 'package:flutter_feature_testing/pages/map.dart';
import 'package:flutter_feature_testing/pages/mapandcamerademo/mapdemo.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          child: Text('Flutter Tests'),
        ),
        _buildMenuItem(
            context, const Text('Home'), HomePage.route, currentRoute),
        _buildMenuItem(
            context, const Text('Camera'), CameraPage.route, currentRoute),
        _buildMenuItem(context, const Text('Map'), MapPage.route, currentRoute),
        _buildMenuItem(context, const Text('Map Camera Demo'),
            MapDemoPage.route, currentRoute),
      ],
    ),
  );
}
