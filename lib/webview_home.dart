import 'dart:developer';

import 'package:aad_auth_demo/auth_data_model.dart';
import 'package:aad_auth_demo/home_page.dart';
import 'package:aad_auth_demo/services/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

///This page has the login page from keycloak in a webview
class MyHomePageWeb extends StatefulWidget {
  const MyHomePageWeb({super.key});

  @override
  State<MyHomePageWeb> createState() => _MyHomePageWebState();
}

class _MyHomePageWebState extends State<MyHomePageWeb> {
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
          onNavigationRequest: (request) async {
            log(request.url);
            final uri = Uri.parse(request.url.toString());
            final authCode = uri.queryParameters['code'];
            if (authCode != null && authCode.isNotEmpty) {
              final authData = await getAuthToken(authCode);
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

  Future<AuthResponseModel> getAuthToken(String authCode) async {
    try {
      var redirectUri = Uri(
        scheme: "technology.waterflow.blaze.local",
        host: "oauth2redirect",
      );
      final result = await dio.post(
        "https://testing-keycloak.waterflow.technology/realms/naasa/protocol/openid-connect/token",
        data: {
          "grant_type": "authorization_code",
          "client_id": "krishna-test",
          "code": authCode,
          // "client_secret": "No_secret_key_as_client_auth_is_disabled_in_keycloak",
          "redirect_uri": redirectUri.toString(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final response = AuthResponseModel.fromJson(result.data);

      log(response.toString());
      log("ID TOKEN: ${response.idToken}");
      return response;

      // dio.get()
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
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
