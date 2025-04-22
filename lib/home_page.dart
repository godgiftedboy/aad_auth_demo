// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aad_auth_demo/keycloak_login_page.dart';
import 'package:aad_auth_demo/pages/user_info_page.dart';
import 'package:aad_auth_demo/services/keyclock_services.dart';
import 'package:aad_auth_demo/services/local_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

///This page is the Dashboard page of the app
///It is shown after the user has logged in successfully
class _HomePageState extends State<HomePage> {
  bool isFetching = false;
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Logged in",
                ),
              ],
            ),
            isFetching
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isFetching = true;
                      });
                      final token = await LocalStorage.getToken();
                      final userData = await KeyCloakServices().fetchUserInfo(
                        token ?? "",
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoPage(
                              userDataModel: userData,
                            ),
                          ),
                        );
                      }
                      Future.delayed(
                        const Duration(milliseconds: 300),
                      );
                      setState(() {
                        isFetching = false;
                      });
                    },
                    child: const Text("View user Data")),
            isLoggingOut
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoggingOut = true;
                      });
                      final idToken = await LocalStorage.getIDToken();
                      final response = await KeyCloakServices().logout(
                        context,
                        idToken ?? "",
                      );

                      if (response) {
                        LocalStorage.reset();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const KeyCloakLoginPage()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                      setState(() {
                        isLoggingOut = false;
                      });
                    },
                    child: const Text("Logout")),
            ElevatedButton(
                onPressed: () async {
                  await LocalStorage.reset();
                },
                child: const Text("Clear local storage")),
          ],
        ));
  }
}
