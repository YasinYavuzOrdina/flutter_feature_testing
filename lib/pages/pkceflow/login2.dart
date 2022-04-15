import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feature_testing/utils/constants.dart';

import 'package:flutter_feature_testing/widgets/drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Login2Page extends StatefulWidget {
  static const String route = '/login2';
  const Login2Page({Key? key}) : super(key: key);

  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2Page> {
  final storage = const FlutterSecureStorage();

  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String _createCodeVerifier() {
    return List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openAuthorizationServerLogin(Uri authUri) async {
    var authUriString = authUri.toString();
    if (await canLaunch(authUriString)) {
      await launch(authUriString, webOnlyWindowName: '_self');
    } else {
      throw 'Could not launch $authUri';
    }
  }

  void authenticate() async {
    var _codeVerifier = _createCodeVerifier();
    await storage.write(key: 'code', value: _codeVerifier);

    final grant = oauth2.AuthorizationCodeGrant(
      kIdentifier,
      kAuthorizationEndpoint,
      kTokenEndpoint,
      httpClient: http.Client(),
      codeVerifier: _codeVerifier,
    );

    var authUrl = grant.getAuthorizationUrl(Uri.parse(kRedirectUrl));

    _openAuthorizationServerLogin(authUrl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web Auth example'),
        ),
        drawer: buildDrawer(context, Login2Page.route),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80),
              ElevatedButton(
                child: const Text('Authenticate'),
                onPressed: () {
                  authenticate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
