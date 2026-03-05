import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box _localBox;
  
  // Token 键
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_info';
  
  // 本地数据库名称
  static const String _localBoxName = 'local_data';

  // 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    _localBox = await Hive.openBox(_localBoxName);
  }

  // ========== SharedPreferences 操作 ==========
  
  // Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  // 用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _prefs.setString(_userKey, userInfo.toString());
  }

  static String? getUserInfo() {
    return _prefs.getString(_userKey);
  }

  static Future<void> removeUserInfo() async {
    await _prefs.remove(_userKey);
  }

  // 通用方法
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  // ========== Hive 本地数据库操作 ==========
  
  static Future<void> putLocalData(String key, dynamic value) async {
    await _localBox.put(key, value);
  }

  static dynamic getLocalData(String key) {
    return _localBox.get(key);
  }

  static Future<void> removeLocalData(String key) async {
    await _localBox.remove(key);
  }

  static Future<void> clearLocalData() async {
    await _localBox.clear();
  }

  // 清除所有登录信息
  static Future<void> clearAuth() async {
    await removeToken();
    await removeUserInfo();
  }
}
