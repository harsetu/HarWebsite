import 'dart:convert';
import 'dart:io';

import 'package:core/network/secure_storage_service.dart';
import 'package:dio/dio.dart';

import '../constants/network_constants.dart';
import '../utils/Logger.dart';
import '../utils/utility.dart';

const String networkKey = 'Network ';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService secureStorage;
  String? _accessToken;
  int accessToken401Count = 0;

  TokenInterceptor({
    required this.dio,
    required this.secureStorage,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only reset the counter for genuine, top-level requests (repository
    // calls triggered by user interaction) - not for the internal
    // refresh/retry requests this interceptor issues on its own `dio`
    // instance during 401 handling, which are marked with `isTokenRetry`.
    if (options.extra['isTokenRetry'] != true) {
      accessToken401Count = 0;
    }

    if (options.extra.containsKey('requiresAccessToken') && options.extra['requiresAccessToken']) {
      _accessToken = await secureStorage.get(NetworkConstants.accessTokenKey);
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Log the error first
    Logger.error("On Error : ${err.response.toString()}");

    if (err.response?.statusCode == 401) {
      Logger.info("Error code is 401");
      if (accessToken401Count <= 2) {
        Logger.info("Access token count is <=2, access token has expired");
        accessToken401Count++;
        // Access token has expired
        final refreshToken = await secureStorage.get(NetworkConstants.refreshTokenKey);
        //TODO api endpoint check
        if (refreshToken != null /*&& !err.requestOptions.path.contains(ApiEndpoint.verifyOtp.path)*/) {
          try {
            var params = {'refreshToken': refreshToken};
            //TODO get refresh token api from app
            final refreshApiResponse = await dio.post('/api/auth/refresh',
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                }, extra: {
                  'isTokenRetry': true,
                }),
                data: jsonEncode(params));
            if (refreshApiResponse.statusCode == 401 || refreshApiResponse.statusCode == 404) {
              accessToken401Count = 0;
              await secureStorage.deleteAll();
              Utility.logoutUser();
              handler.next(err);
              return;
            }

            final newAccessToken = refreshApiResponse.data['data'][NetworkConstants.accessTokenKey] as String;
            final newRefreshToken = refreshApiResponse.data['data'][NetworkConstants.refreshTokenKey] as String;
            await secureStorage.store(NetworkConstants.accessTokenKey, newAccessToken);
            await secureStorage.store(NetworkConstants.refreshTokenKey, newRefreshToken);

            // Update the authorization header with the new token
            err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final options = Options(
              headers: err.requestOptions.headers,
              method: err.requestOptions.method,
              extra: {...err.requestOptions.extra, 'isTokenRetry': true},
            );

            final response = await dio.request(err.requestOptions.path,
                options: options,
                cancelToken: err.requestOptions.cancelToken,
                onReceiveProgress: err.requestOptions.onReceiveProgress,
                data: err.requestOptions.data,
                queryParameters: err.requestOptions.queryParameters);

            handler.resolve(response);
            if (response.statusCode != 401) {
              accessToken401Count = 0;
            }
            return;
          } catch (refreshError) {
            // If refresh fails, logout user
            Logger.info("Refresh failed! Logging out the user");
            await secureStorage.deleteAll();
            Utility.logoutUser();
            handler.next(err);
            return;
          }
        } else {
          Logger.info("Failed to execute something!");
          await secureStorage.deleteAll();
          Utility.logoutUser();
          return;
        }
      } else {
        Logger.info("Failed to execute something!");
        await secureStorage.deleteAll();
        handler.next(err);
        return;
      }
    } else {
      Logger.info("Failed to execute something!");
      handler.next(err);
      return;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    accessToken401Count = 0;
    super.onResponse(response, handler);
  }
}
