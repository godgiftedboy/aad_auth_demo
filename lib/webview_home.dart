import 'dart:developer';

import 'package:aad_auth_demo/home_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePageWeb extends StatefulWidget {
  const MyHomePageWeb({super.key});

  @override
  State<MyHomePageWeb> createState() => _MyHomePageWebState();
}

class _MyHomePageWebState extends State<MyHomePageWeb> {
  late WebViewController webViewController;

  String cliendId = "202e5f68-95ec-4d43-8cc5-cf5b102f790b";
  String responseType = "code";
  String scope =
      "https://swohum.onmicrosoft.com/202e5f68-95ec-4d43-8cc5-cf5b102f790b/Files.Read openid offline_access";
  String policyName = "B2C_1_SignUp_SignIn_Test_Mobile";
  var redirectUri = Uri(
    scheme: "msauth",
    host: "com.example.aad_auth_demo",
    path: "/1%2Bc2k5Kax7x7tA4mqg6C9OOMbE8%3D",
  );

  @override
  void initState() {
    final uri = Uri(
      scheme: "https",
      host: "swohum.b2clogin.com",
      path: "/swohum.onmicrosoft.com/$policyName/oauth2/v2.0/authorize",
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
            if (request.url.contains("?code=")) {
              var authCode = request.url.split("?code=").last;
              Navigator.push(
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
