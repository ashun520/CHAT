import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../services/storage_service.dart';

class ApiService {
  static late Dio _dio;
  static const int _connectTimeout = 30000;
  static const int _receiveTimeout = 30000;

  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: _connectTimeout),
      receiveTimeout: const Duration(milliseconds: _receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加认证 token
        final token = StorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        // 处理错误
        if (error.response != null) {
          switch (error.response!.statusCode) {
            case 401:
              // Token 过期或无效，清除登录信息
              await StorageService.clearAuth();
              // TODO: 跳转到登录页
              break;
            case 403:
              // 无权限
              break;
            case 404:
              // 资源不存在
              break;
            case 500:
              // 服务器错误
              break;
          }
        }
        return handler.next(error);
      },
    ));
  }

  // GET 请求
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // POST 请求
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // PUT 请求
  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // DELETE 请求
  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // 文件上传
  static Future<Response> uploadFile(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap(data ?? {});
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(filePath),
      ));

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // 错误处理
  static void _handleError(DioException error) {
    String message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
        break;
      case DioExceptionType.badResponse:
        message = '请求失败';
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      default:
        message = '网络错误';
    }
    // TODO: 显示错误提示
    debugPrint('API 错误：$message');
  }
}
