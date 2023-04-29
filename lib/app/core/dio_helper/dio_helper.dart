import 'package:dio/dio.dart';

class DioHelper {
  DioHelper._();

  static String errorHandler(DioError e) {
    String message;
    if (e.response != null) {
      message = e.response!.data["message"];
    } else {
      message = e.message!;
    }

    return message;
  }
}
