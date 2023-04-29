import 'package:dio/dio.dart' as d;

import '../../../core/const/endpoints_const.dart';
import '../../../core/dio_helper/dio_client.dart';
import '../../../data/generate_request_model.dart';

class HomeProvider {
  HomeProvider._();

  static Future<d.Response> generateImage({
    required GenerateInputModel body,
  }) async {
    return await DioTools.post(
      body: body.toJson(),
      EndpointsConst.ai.generate,
    );
  }

  static Future<d.Response> getImage({
    required String jobId,
  }) async {
    return await DioTools.get("${EndpointsConst.ai.generate}/$jobId");
  }
}
