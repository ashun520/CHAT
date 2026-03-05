import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  // 初始化 - 检查登录状态
  Future<void> init() async {
    final token = StorageService.getToken();
    final userInfo = StorageService.getUserInfo();
    
    if (token != null && userInfo != null) {
      try {
        _currentUser = UserModel.fromJson(json.decode(userInfo));
        _isAuthenticated = true;
        notifyListeners();
      } catch (e) {
        await StorageService.clearAuth();
      }
    }
  }

  // 登录
  Future<bool> login(String account, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.post(
        ApiConstants.login,
        data: {
          'account': account,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        
        // 保存 token 和用户信息
        await StorageService.saveToken(data['token']);
        await StorageService.saveUserInfo(data['user']);
        
        // 更新状态
        _currentUser = UserModel.fromJson(data['user']);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('登录错误：$e');
      return false;
    }
  }

  // 注册
  Future<bool> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.post(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 201 && response.data['success']) {
        final data = response.data['data'];
        
        // 自动登录
        await StorageService.saveToken(data['token']);
        await StorageService.saveUserInfo(data['user']);
        
        _currentUser = UserModel.fromJson(data['user']);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('注册错误：$e');
      return false;
    }
  }

  // 登出
  Future<void> logout() async {
    try {
      await ApiService.post(ApiConstants.logout);
    } catch (e) {
      debugPrint('登出请求失败：$e');
    } finally {
      await StorageService.clearAuth();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // 更新用户信息
  Future<bool> updateUserInfo(Map<String, dynamic> updates) async {
    try {
      final response = await ApiService.put(
        ApiConstants.updateUserInfo,
        data: updates,
      );

      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        _currentUser = UserModel.fromJson(data);
        await StorageService.saveUserInfo(data);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('更新用户信息错误：$e');
      return false;
    }
  }
}
