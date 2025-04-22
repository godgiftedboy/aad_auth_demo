import 'dart:developer';

import 'package:aad_auth_demo/constants/constants.dart';
import 'package:aad_auth_demo/home_page.dart';
import 'package:aad_auth_demo/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///This page has handles logout functionality in keycloak
class LogoutPage extends StatefulWidget {
  final String logoutUrl;
  const LogoutPage({super.key, required this.logoutUrl});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    super.initState();
    webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.logoutUrl))
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
            final url = request.url.toString();

            final condition =
                (url == (KeyCloakConst.redirectUriLogout).toString());
            //in login page we used the condition to check for authorization code.
            //here we check if the url is equal to the redirect uri.
            //if it is equal then we know that the user has logged out successfully.
            //and we can navigate back to the login page.

            if (condition == true) {
              await LocalStorage.reset();
              // Possibly notify parent or navigate back
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                    const SnackBar(content: Text("Logout successful")));
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const HomePage()));
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: webViewController);
  }
}
