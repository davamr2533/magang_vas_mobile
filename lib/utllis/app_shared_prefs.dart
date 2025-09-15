import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_reporting/base/base_prefs.dart';

class SharedPref {
  const SharedPref._();

  static const String prefKey = 'RAMAYANA_PREF';
  

  //Set String

  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_name, name);
  }

  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_username, username);
  }
  static Future<void> setGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_gender, gender);
  }

  static Future<void> setDivisi(String divisi) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_divisi, divisi);
  }

  static Future<void> setPosition(String position) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_position, position);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key_token, token);
  }


  // Get String

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_token);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_name);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_username);
  }
  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_gender);
  }

  static Future<String?> getDivisi() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_divisi);
  }

  static Future<String?> getPosition() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key_position);
  }

  static Future<void> clearLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key_token);
  }

}
