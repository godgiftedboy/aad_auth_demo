// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:aad_auth_demo/auth_data_model.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthToken();
  }

  getAuthToken() async {
    final dio = Dio();
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
      log(response.toString());
      log("ID TOKEN: ${response.idToken}");
      return;

      // dio.get()
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.authCode);
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("Logged in"),
        ));
  }
}
