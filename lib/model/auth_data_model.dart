// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final authResponseModel = authResponseModelFromJson(jsonString);

class AuthResponseModel {
  String accessToken;
  String idToken;
  String tokenType;
  int notBefore;
  int idTokenExpiresIn;
  String sessionState;
  String scope;
  String refreshToken;
  int refreshTokenExpiresIn;

  AuthResponseModel({
    required this.accessToken,
    required this.idToken,
    required this.tokenType,
    required this.notBefore,
    required this.idTokenExpiresIn,
    required this.sessionState,
    required this.scope,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        accessToken: json["access_token"],
        idToken: json["id_token"],
        tokenType: json["token_type"],
        notBefore: json["not-before-policy"],
        idTokenExpiresIn: json["expires_in"],
        sessionState: json["session_state"],
        scope: json["scope"],
        refreshToken: json["refresh_token"],
        refreshTokenExpiresIn: json["refresh_expires_in"],
      );

  @override
  String toString() {
    return 'AuthResponseModel(\naccessToken: $accessToken,\n idToken: $idToken,\n tokenType: $tokenType,\n notBefore: $notBefore,\n idTokenExpiresIn: $idTokenExpiresIn,\n sessionState: $sessionState,\n scope: $scope,\n refreshToken: $refreshToken,\n refreshTokenExpiresIn: $refreshTokenExpiresIn\n)\n';
  }
}
