import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthorizationInterceptor extends QueuedInterceptorsWrapper {
  @override
  onRequest(options, handler) async {
    Get.log("Requested: ${options.path} || ${options.method}");
    //
    // var isAuth = Store.read(SKeys.isAuth, def: false);
    // if (isAuth) {
    //   var token = Store.read(SKeys.token, def: "");
    //   options.headers.addAll(
    //     <String, String>{'Authorization': "Bearer $token"},
    //   );
    // }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    Get.log("${response.statusMessage} | ${response.statusCode}");
    Get.log(response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    Get.log(err.message!);
    // if (err.response != null) {
    //   if (err.response.statusCode == 401) {
    //     final RequestOptions requestOptions = err.response.requestOptions;
    //     await RefreshTokenProvider.refreshToken();
    //     final token = LocalSessions.profileRef.currentProfile.token;
    //     requestOptions.headers['Authorization'] = 'Bearer $token';
    //     final response = await DioInstance.dio.fetch(requestOptions);
    //     return handler.resolve(response);
    //   }
    // }
    return handler.next(err);
  }
}

// class RefreshTokenInterceptor extends QueuedInterceptorsWrapper {
//   @override
//   onRequest(options, handler) async {
//     // var token = LocalSessions.profileRef.currentProfile.token;
//     // options.headers.addAll(<String, String>{'Authorization': "Bearer $token"});
//     return handler.next(options);
//   }
//
//   @override
//   onResponse(response, handler) async {
//     // var token = response.data["Result"] as String;
//     // LocalSessions.profileRef.currentProfile.token = token;
//     // var getLastChar = token.substring(token.length - 5, token.length);
//     // l(info: "refreshed: $getLastChar");
//
//     return handler.next(response);
//   }
//
//   @override
//   onError(DioError err, handler) {
//     Log.error(err.message);
//     // printDioError(error);
//     // if (error.response != null) {
//     //   if (error.response.statusCode == 401) {
//     //     LocalSessions.profileRef.logoutCurrentAccount();
//     //   }
//     // }
//     handler.next(err);
//   }
// }
