import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<String?> getUsernameMb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username_mb');
  }

  static Future<void> setUsernameMb(String usernameMb) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username_mb', usernameMb);
  }
}
