import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_feature_testing/widgets/drawer.dart';

import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final authorizationEndpoint =
      Uri.parse('http://oauth2.prims-dev.the-sniffers.com/authorize');
  final tokenEndpoint = Uri.parse(
      'http://oauth2.prims-dev.the-sniffers.com/authorize/auth/token');

  final redirectUrl = 'http://127.0.0.1:14200/#/auth-redirect';
  final identifier = 'prims-mobile';

  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String _createCodeVerifier() {
    return List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  final codeVerifier = _createCodeVerifier();

  login() async {
    final AuthorizationTokenResponse? result =
        await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        '<client_id>',
        '<redirect_url>',
        serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint.toString(),
            tokenEndpoint: tokenEndpoint.toString()),
      ),
    );
  }

  Future<void> _openAuthorizationServerLogin(String authUri) async {
    if (await canLaunch(authUri)) {
      await launch(authUri, webOnlyWindowName: '_self');
    } else {
      throw 'Could not launch $authUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter tests'),
      ),
      drawer: buildDrawer(context, LoginPage.route),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            login();
          },
          child: const Text('LOGIN'),
        ),
      ),
    );
  }
}
