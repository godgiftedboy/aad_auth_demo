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
          "client_id": "naasa-wallet",
          "code": widget.authCode,
          "client_secret": "client_secret_removal",
          //Add your own client secret here
          //We can also create a client that doesnt require authentication
          //like krishna-test was created for demo by madhav dai
          "redirect_uri": redirectUri.toString(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final response = AuthResponseModel.fromJson(result.data);
      log(response.toString());
      log(response.idToken);

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
      body: Center(child: Text(widget.authCode)),
    );
  }
}
