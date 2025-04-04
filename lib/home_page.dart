// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:aad_auth_demo/auth_data_model.dart';
import 'package:aad_auth_demo/pages/user_info_page.dart';
import 'package:aad_auth_demo/user_data_model.dart';
import 'package:aad_auth_demo/webview_home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.authCode,
  });

  final String authCode;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Dio dio;
  AuthResponseModel? authData;
  @override
  void initState() {
    // TODO: implement initState
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
    getAuthToken();
  }

  getAuthToken() async {
    try {
      var redirectUri = Uri(
        scheme: "technology.waterflow.blaze.local",
        host: "oauth2redirect",
      );
      log("here is the auhtcode${widget.authCode}");
      final result = await dio.post(
        "https://testing-keycloak.waterflow.technology/realms/naasa/protocol/openid-connect/token",
        data: {
          "grant_type": "authorization_code",
          "client_id": "krishna-test",
          "code": widget.authCode,
          // "client_secret": "No_secret_key_as_client_auth_is_disabled_in_keycloak",
          "redirect_uri": redirectUri.toString(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final response = AuthResponseModel.fromJson(result.data);
      authData = response;
      log(response.toString());
      log("ID TOKEN: ${response.idToken}");
      return;

      // dio.get()
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserDataModel> fetchUserInfo(String accessToken) async {
    try {
      final response = await dio.get(
        "https://testing-keycloak.waterflow.technology/realms/naasa/protocol/openid-connect/userinfo",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );
      log("response from user datra: $response");
      final userData = UserDataModel.fromJson(response.data);
      return userData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> logout(BuildContext context, String idToken) async {
    const postLogoutRedirectUrl =
        "https://testing-wallet.naasasecurities.com.np/login";
    final postLogoutRedirectUri = Uri.encodeFull(postLogoutRedirectUrl);
    final url =
        "https://testing-keycloak.waterflow.technology/realms/naasa/protocol/openid-connect/logout?post_logout_redirect_uri=$postLogoutRedirectUri&id_token_hint=$idToken";

    try {
      final data = await Dio().get(url);
      if (context.mounted && data.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logout successfull')));
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Logout Failed')));
        }
        return false;
      }
    } on DioException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logout Failed')));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.authCode);
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
            ElevatedButton(
                onPressed: () async {
                  final userData = await fetchUserInfo(
                    authData?.accessToken ?? "",
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
                },
                child: const Text("View user Data")),
            ElevatedButton(
                onPressed: () async {
                  final response = await logout(
                    context,
                    authData?.idToken ?? "",
                  );
                  if (response) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const MyHomePageWeb()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
                child: const Text("Logout"))
          ],
        ));
  }
}
