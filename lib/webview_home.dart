import 'dart:developer';

import 'package:aad_auth_demo/home_page.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
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
          onNavigationRequest: (request) {
            log(request.url);
            final uri = Uri.parse(request.url.toString());
            final authCode = uri.queryParameters['code'];
            if (authCode != null && authCode.isNotEmpty) {
              log("here is the auth code $authCode");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => HomePage(authCode: authCode)));
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
    return Scaffold(
      body: WebViewWidget(controller: webViewController),
    );
  }
}
