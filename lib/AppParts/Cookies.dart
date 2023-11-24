import 'package:shared_preferences/shared_preferences.dart';

class Cookies{
  static late SharedPreferences prefs;

  Cookies(){
    init();
  }

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static SetCookie(key, value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static ReadCookie(key)
  async {
    prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  static SetListCookie(key, value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static ReadListCookie(key)
  async {
    prefs = await SharedPreferences.getInstance();
    var value = prefs.getStringList(key);
    return value;
  }

}