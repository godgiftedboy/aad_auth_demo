import 'dart:developer';

import 'package:aad_auth_demo/constants/constants.dart';
import 'package:aad_auth_demo/model/auth_data_model.dart';
import 'package:aad_auth_demo/model/user_data_model.dart';
import 'package:aad_auth_demo/pages/logout_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

///This class has all the function used for interaction with keycloack apis.
class KeyCloakServices {
  KeyCloakServices() {
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
  }
  final Dio dio = Dio();

  ///This function is used to get the auth token from the keycloak server
  ///It takes the auth code as a parameter and returns the auth response model
  Future<AuthResponseModel> getAuthToken(String authCode) async {
    try {
      final redirectUri = KeyCloakConst.redirectUriLogin;
      const clientId = KeyCloakConst.clientId;
      final result = await dio.post(
        "${KeyCloakConst.commonUrl}/token",
        data: {
          "grant_type": "authorization_code",
          "client_id": clientId,
          "code": authCode,
          "redirect_uri": redirectUri.toString(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final response = AuthResponseModel.fromJson(result.data);

      log("ID TOKEN: ${response.idToken}");
      return response;

      // dio.get()
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  ///This function is used to fetch the user info from the keycloak server
  ///It takes the access token as a parameter and returns the user data model
  ///It throws an error if the request fails
  Future<UserDataModel> fetchUserInfo(String accessToken) async {
    try {
      final response = await dio.get(
        "${KeyCloakConst.commonUrl}/userinfo",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );
      final userData = UserDataModel.fromJson(response.data);
      return userData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  ///This function is used to logout the user from the keycloak server
  ///It takes the id token as a parameter and returns true if the logout is successful
  ///It returns false if the logout fails
  Future<bool> logout(BuildContext context, String idToken) async {
    final postLogoutRedirectUri = KeyCloakConst.redirectUriLogout;
    final url =
        "${KeyCloakConst.commonUrl}/logout?post_logout_redirect_uri=$postLogoutRedirectUri&id_token_hint=$idToken";

    try {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (ctx) => LogoutPage(
                    logoutUrl: url,
                  )));
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logout Failed')));
      }
      return false;
    }
  }
}
