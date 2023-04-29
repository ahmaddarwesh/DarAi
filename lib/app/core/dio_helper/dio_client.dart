import 'package:dio/dio.dart';

import '../const/remote_const.dart';
import 'interceptor.dart';

class DioInstance {
  static CancelToken _cancelToken = CancelToken();
  static Dio dio = Dio();

  static Future dioInit() async {
    dio.interceptors.clear();

    dio.interceptors.add(AuthorizationInterceptor());
  }

  static void cancelAllRequests() {
    _cancelToken.cancel("All requests cancelled");
    _cancelToken = CancelToken();
    dio = Dio();
  }
}

class DioTools {
  static Dio get client {
    var options = BaseOptions(
      baseUrl: RemoteConst.url,
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
        "Accept-Language": "en",
        "X-Prodia-Key": RemoteConst.appKey
      },
    );

    DioInstance.dio.options = options;

    return DioInstance.dio;
  }

  static Future<Response<dynamic>> post(
    String path, {
    required body,
    Map<String, String>? queryParameters,
  }) async {
    return await client.post(path,
        data: body, queryParameters: queryParameters);
  }

  static Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? customHeaders,
  }) async {
    return await client.get(path, queryParameters: queryParameters);
  }
}
