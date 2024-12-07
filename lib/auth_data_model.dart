// To parse this JSON data, do
//
//     final authResponseModel = authResponseModelFromJson(jsonString);

import 'dart:convert';

AuthResponseModel authResponseModelFromJson(String str) =>
    AuthResponseModel.fromJson(json.decode(str));

String authResponseModelToJson(AuthResponseModel data) =>
    json.encode(data.toJson());

class AuthResponseModel {
  String idToken;
  String tokenType;
  int notBefore;
  int idTokenExpiresIn;
  String profileInfo;
  String scope;
  String refreshToken;
  int refreshTokenExpiresIn;

  AuthResponseModel({
    required this.idToken,
    required this.tokenType,
    required this.notBefore,
    required this.idTokenExpiresIn,
    required this.profileInfo,
    required this.scope,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        idToken: json["id_token"],
        tokenType: json["token_type"],
        notBefore: json["not_before"],
        idTokenExpiresIn: json["id_token_expires_in"],
        profileInfo: json["profile_info"],
        scope: json["scope"],
        refreshToken: json["refresh_token"],
        refreshTokenExpiresIn: json["refresh_token_expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "id_token": idToken,
        "token_type": tokenType,
        "not_before": notBefore,
        "id_token_expires_in": idTokenExpiresIn,
        "profile_info": profileInfo,
        "scope": scope,
        "refresh_token": refreshToken,
        "refresh_token_expires_in": refreshTokenExpiresIn,
      };
}
