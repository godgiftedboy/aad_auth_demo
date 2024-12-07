// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:aad_auth_demo/auth_data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.authCode,
  }) : super(key: key);

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
      final result = await dio.post(
        "https://swohum.b2clogin.com/swohum.onmicrosoft.com/b2c_1_signup_signin_test_mobile/oauth2/v2.0/token",
        data: {
          "grant_type": "authorization_code",
          "client_id": "202e5f68-95ec-4d43-8cc5-cf5b102f790b",
          "code": widget.authCode,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final response = AuthResponseModel.fromJson(result.data);
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
