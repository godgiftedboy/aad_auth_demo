class KeyCloakConst {
  KeyCloakConst._();

  static const String clientId = "krishna-test";
  static const String scope = "openid";
  static const String responseType = "code";
  static Uri redirectUriLogin = Uri(
    scheme: "technology.waterflow.blaze.local",
    host: "oauth2redirect",
  );
  static const String commonUrl =
      "https://testing-keycloak.waterflow.technology/realms/naasa/protocol/openid-connect";

  static Uri authorizationUri = Uri(
    scheme: "https",
    host: "testing-keycloak.waterflow.technology",
    path: "/realms/naasa/protocol/openid-connect/auth",
    queryParameters: {
      "client_id": clientId,
      "response_type": responseType,
      "redirect_uri": redirectUriLogin.toString(),
      "scope": scope,
    },
  );

  static String redirectUriLogout =
      "https://testing-wallet.naasasecurities.com.np/login";
  static const String middleWareUrl =
      "https://api-dev-blaze.waterflowtechnology.net/api";
}
