import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", value);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("token");
    return data;
  }

  static setIDToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("idToken", value);
  }

  static Future<String?> getIDToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("idToken");
    return data;
  }

  static reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
