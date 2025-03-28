import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsRepoProvider =
    Provider<SharedPrefsRepo>((ref) => SharedPrefsRepo());

class SharedPrefsRepo {
  final String _tokenKey = "COOKIE_TOKEN";
  final String _currentUserKey = "CURRENT_USER";

  Future<String?> getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString(_tokenKey);
    return cookie;
  }

  Future<UserData?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);
    final user = data != null ? UserData.fromJson(jsonDecode(data)) : null;
    return user;
  }

  Future<void> setCurrentUser(UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  Future<void> setCookie(String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, cookie);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
