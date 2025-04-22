// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

class UserDataModel {
  String sub;
  bool emailVerified;
  String email;
  List<String> defaultRole;
  String name;
  String preferredUsername;

  UserDataModel({
    required this.sub,
    required this.emailVerified,
    required this.email,
    required this.defaultRole,
    required this.name,
    required this.preferredUsername,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        sub: json["sub"],
        emailVerified: json["email_verified"],
        email: json["email"],
        defaultRole: List<String>.from(json["Default Role"].map((x) => x)),
        name: json["name"],
        preferredUsername: json["preferred_username"],
      );
}
