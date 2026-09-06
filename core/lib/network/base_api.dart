import 'dart:convert';

import 'package:core/network/secure_storage_service.dart';
import 'package:core/network/token_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_alice/alice.dart';
import '../di/find_asset.dart';
import '../di/service_injection.dart';
import '../models/config.dart';
import '../constants/localization_keys.dart';
import '../navigator_key.dart';
import 'api_response.dart';

class BaseApi {
  final Dio _dio;
  String statusCode = "";
  final bool isToParse;
  final SecureStorageService secureStorage = getIt<SecureStorageService>();

  BaseApi({this.isToParse = false})
      : _dio = Dio(BaseOptions(
          baseUrl: Config.baseUrl,
          validateStatus: (status) {
            return status! >= 200 && status < 400;
          },
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            // add other headers as needed
          },
          connectTimeout: const Duration(seconds: Config.timeoutSeconds),
          receiveTimeout: const Duration(seconds: Config.timeoutSeconds),
        )) {
    final alice = Alice(navigatorKey: navigatorKey);
    _dio.interceptors.add(
      TokenInterceptor(
        dio: _dio,
        secureStorage: secureStorage,
      ),
    );
    final FindAsset findAsset = getIt<FindAsset>();
    if (findAsset.isChuckerEnabled == true) {
      // _dio.interceptors.add(ChuckerDioInterceptor());  // Temporarily disabled due to http package compatibility issue
      _dio.interceptors.add(alice.getDioInterceptor());
    }

    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }

  Future<void> changeBaseUrl(String newBaseUrl) async {
    _dio.options.baseUrl = newBaseUrl;
  }

  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters, bool requiresAccessToken = true}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAccessToken': requiresAccessToken},
        ),
      );
      var jsonDecodeString = jsonDecode(response.toString());

      var apiResponse =
          ApiResponse(code: jsonDecodeString['errorCode'], data: jsonDecodeString['data'], message: jsonDecodeString['message']);
      return apiResponse;
    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      if (e.response != null) {
        var errorJson = jsonDecode(e.response.toString());
        return ApiResponse(
          code: e.response?.statusCode?.toString() ?? statusCode,
          message: errorJson['message'] ?? genericError,
        );
      }
    }
    var genericError = LocalizationKeys.genericErrorLabel;
    return ApiResponse(
      code: statusCode,
      message: genericError,
    );
  }

  Future<ApiResponse> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, bool requiresAccessToken = true}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAccessToken': requiresAccessToken},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonDecodeString = jsonDecode(response.toString());
        var apiResponse =
            ApiResponse(code: jsonDecodeString['errorCode'], data: jsonDecodeString['data'], message: jsonDecodeString['message']);
        return apiResponse;
      } else {
        return ApiResponse(code: response.statusCode?.toString(), message: response.statusMessage);
      }
    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      if (e.response != null) {
        String? errorMessage = genericError;
        try {
          var errorJson = jsonDecode(e.response.toString());
          errorMessage = errorJson['error']
              ? errorJson['error'].toString().length < 200
                  ? errorJson['error']?.toString()
                  : genericError
              : genericError;
        } catch (e) {
          debugPrint(
            'Parsing error: ${e.toString()}',
          );
        }
        return ApiResponse(
          code: e.response?.statusCode?.toString() ?? statusCode,
          message: errorMessage ?? genericError,
        );
      }
    }
    var genericError = LocalizationKeys.genericErrorLabel;
    return ApiResponse(
      code: statusCode,
      message: genericError,
    );
  }

  Future<ApiResponse> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, bool requiresAccessToken = true}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          extra: {'requiresAccessToken': requiresAccessToken},
        ),
      );
      var jsonDecodeString = jsonDecode(response.toString());
      return ApiResponse(
        code: jsonDecodeString['errorCode'],
        data: jsonDecodeString['data'],
        message: jsonDecodeString['message'],
      );
    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      if (e.response != null) {
        var errorJson = jsonDecode(e.response.toString());
        return ApiResponse(
          code: e.response?.statusCode?.toString() ?? statusCode,
          message: errorJson['message'] ?? genericError,
        );
      }
      return ApiResponse(code: statusCode, message: genericError);
    }
  }

  Future<ApiResponse> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, queryParameters: queryParameters);
      var jsonDecodeString = jsonDecode(response.toString());
      return ApiResponse(
        code: response.statusCode?.toString() ?? statusCode,
        data: jsonDecodeString,
      );
    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      var errorJson = jsonDecode(e.response.toString());
      return ApiResponse(
        code: e.response?.statusCode?.toString() ?? statusCode,
        message: errorJson['message'] ?? genericError,
      );
    }
  }

  Future<ApiResponse> patch(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, bool requiresAccessToken = true}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        options: Options(
          extra: {'requiresAccessToken': requiresAccessToken},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonDecodeString = jsonDecode(response.toString());
        var apiResponse = ApiResponse(
          code: jsonDecodeString['errorCode'],
          data: jsonDecodeString['data'],
          message: jsonDecodeString['message'],
        );
        return apiResponse;
      } else {
        return ApiResponse(
          code: response.statusCode?.toString(),
          message: response.statusMessage,
        );
      }
    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      if (e.response != null) {
        String? errorMessage = genericError;
        try {
          var errorJson = jsonDecode(e.response.toString());
          errorMessage = errorJson['error']
              ? errorJson['error'].toString().length < 200
                  ? errorJson['error']?.toString()
                  : genericError
              : genericError;
        } catch (e) {
          debugPrint(
            'Parsing error: ${e.toString()}',
          );
        }
        return ApiResponse(
          code: e.response?.statusCode?.toString() ?? statusCode,
          message: errorMessage ?? genericError,
        );
      }
    }
    var genericError = LocalizationKeys.genericErrorLabel;
    return ApiResponse(
      code: statusCode,
      message: genericError,
    );
  }

  Future<ApiResponse> graphql(String path,
      {required String query, Map<String, dynamic>? variables, bool requiresAccessToken = true}) async {
    try {
      final response = await _dio.post(
        path,
        data: {
          'query': query,
          'variables': variables,
        },
        options: Options(
          extra: {'requiresAccessToken': requiresAccessToken},
        ),
      );

      Map<String, dynamic> responseData = jsonDecode(response.toString());

      if (responseData.containsKey('errors') && responseData['errors'] != null) {
        return ApiResponse(
          code: response.statusCode?.toString() ?? 'GRAPHQL_ERROR',
          message: (responseData['errors'] as List).map((error) => error['message']).join('\n'),
          data: responseData['data'],
        );
      }
      
      return ApiResponse(
        code: response.statusCode.toString(),
        data: responseData['data'],
      );

    } on DioException catch (e) {
      var genericError = LocalizationKeys.genericErrorLabel;
      if (e.response != null) {
        try {
          var errorJson = jsonDecode(e.response.toString());
          if (errorJson['errors'] != null) {
            return ApiResponse(
              code: e.response?.statusCode?.toString() ?? statusCode,
              message: (errorJson['errors'] as List).map((error) => error['message']).join('\n'),
            );
          }
          return ApiResponse(
            code: e.response?.statusCode?.toString() ?? statusCode,
            message: errorJson['message'] ?? genericError,
          );
        } catch (_) {
          return ApiResponse(
            code: e.response?.statusCode?.toString() ?? statusCode,
            message: genericError,
          );
        }
      }
      return ApiResponse(
        code: statusCode,
        message: genericError,
      );
    }
  }
}
