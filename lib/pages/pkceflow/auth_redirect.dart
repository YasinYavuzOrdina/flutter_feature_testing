import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_feature_testing/pages/pkceflow/save_service.dart';
import 'package:flutter_feature_testing/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;

class AuthRedirectPage extends StatefulWidget {
  static String routeName = '/auth-redirect';

  const AuthRedirectPage({Key? key}) : super(key: key);

  @override
  State<AuthRedirectPage> createState() => _AuthRedirectPageState();
}

class _AuthRedirectPageState extends State<AuthRedirectPage> {
  final storage = const FlutterSecureStorage();
  late Future<void> codeGetter;
  String? _codeVerifier;

  Future<void> getCode() async {
    _codeVerifier = await storage.read(key: 'code');
  }

  Future<void> handleOAuth() async {
    final grant = oauth2.AuthorizationCodeGrant(
        kIdentifier, kAuthorizationEndpoint, kTokenEndpoint,
        httpClient: http.Client(), codeVerifier: _codeVerifier);
    grant.getAuthorizationUrl(Uri.parse(kRedirectUrl));
    print(Uri.base.queryParameters);
    try {
      final client =
          await grant.handleAuthorizationResponse(Uri.base.queryParameters);

      String jwtBearer = client.credentials.accessToken;
      print(jwtBearer);
      String refreshToken = client.credentials.refreshToken!;
      print(refreshToken);
      await storage.write(key: 'jwt', value: jwtBearer);
      await storage.write(key: 'refresh', value: refreshToken);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  @override
  void initState() {
    codeGetter = getCode();

    super.initState();
  }

  final SaveService saveService = SaveService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: storage.read(key: 'code'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: FutureBuilder(
                    future: handleOAuth(),
                    builder: (context, snapshot) {
                      return Text('Logged in');
                    }),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
