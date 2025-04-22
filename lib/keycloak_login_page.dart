import 'dart:developer';

import 'package:aad_auth_demo/constants/constants.dart';
import 'package:aad_auth_demo/home_page.dart';
import 'package:aad_auth_demo/services/keyclock_services.dart';
import 'package:aad_auth_demo/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///This page has the login page from keycloak in a webview
class KeyCloakLoginPage extends StatefulWidget {
  const KeyCloakLoginPage({super.key});

  @override
  State<KeyCloakLoginPage> createState() => _KeyCloakLoginPageState();
}

class _KeyCloakLoginPageState extends State<KeyCloakLoginPage> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    super.initState();
    webViewController = WebViewController()
      ..loadRequest(KeyCloakConst.authorizationUri)
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
