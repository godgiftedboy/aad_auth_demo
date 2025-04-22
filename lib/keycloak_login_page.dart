import 'dart:developer';

import 'package:aad_auth_demo/home_page.dart';
import 'package:aad_auth_demo/services/keyclock_services.dart';
import 'package:aad_auth_demo/services/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

///This page has the login page from keycloak in a webview
class KeyCloakLoginPage extends StatefulWidget {
  const KeyCloakLoginPage({super.key});

  @override
  State<KeyCloakLoginPage> createState() => _KeyCloakLoginPageState();
}

class _KeyCloakLoginPageState extends State<KeyCloakLoginPage> {
  late WebViewController webViewController;

  String cliendId = "krishna-test";
  String responseType = "code";
  String scope = "openid";
  var redirectUri = Uri(
    scheme: "technology.waterflow.blaze.local",
    host: "oauth2redirect",
  );
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    //constructing the uri for the keycloak login page/ authorization page
    final uri = Uri(
      scheme: "https",
      host: "testing-keycloak.waterflow.technology",
      path: "/realms/naasa/protocol/openid-connect/auth",
      queryParameters: {
        "client_id": cliendId,
        "response_type": responseType,
        "redirect_uri": redirectUri.toString(),
        "scope": scope
      },
    );
    log(uri.toString());
    super.initState();
    webViewController = WebViewController()
      ..loadRequest(uri)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          //listens to the url changes on the webview
          //and checks if the url has the auth code
          //if yes, it calls the getAuthToken method to get the access token
          //and id token
          //and saves them in the local storage
          //and navigates to the home page
          //if no, it does nothing
          onNavigationRequest: (request) async {
            log(request.url);
            final uri = Uri.parse(request.url.toString());
            final authCode = uri.queryParameters['code'];
            if (authCode != null && authCode.isNotEmpty) {
              //call the function to exchange authcode with access token
              //and id token
              //and save them in the local storage
              final authData = await KeyCloakServices().getAuthToken(authCode);
              await LocalStorage.setIDToken(authData.idToken);
              await LocalStorage.setToken(authData.accessToken);
              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const HomePage()));
              }

              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    //Fetch the token from the local storage
    //and check if it is null or not
    //if it is null, show the webview
    //if it is not null, show the home page
    return FutureBuilder(
      future: LocalStorage.getToken(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Material(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.connectionState == ConnectionState.done) {
          return snap.hasData
              ? snap.requireData != null
                  ? const HomePage()
                  : WebViewWidget(controller: webViewController)
              : WebViewWidget(controller: webViewController);
        } else {
          return const Material(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
