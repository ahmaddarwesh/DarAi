import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import '../../../data/generate_request_model.dart';
import '../../../data/generated_output_model.dart';
import '../providers/hom_provider.dart';

class HomeController extends GetxController {
  Rx<GenerateInputModel?> inputModel = Rx(null);
  Rx<GeneratedOutputModel?> outputModel = Rx(null);

  RxBool isWorking = RxBool(false);
  Uint8List? _imageBytes;

  @override
  void onInit() {
    super.onInit();
    updateInputModel();
  }

  updateInputModel() {
    inputModel(
      GenerateInputModel(
        prompt: '',
        model: 'dreamlike-diffusion-2.0.safetensors [fdcf65e7]',
        seed: Random().nextInt(1991987),
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> generate({removeTheOld = true}) async {
    inputModel.value!.seed = Random().nextInt(1991991);
    ;
    isWorking(true);
    if (removeTheOld) {
      outputModel(null);
      outputModel.refresh();
    }
    var response = await HomeProvider.generateImage(body: inputModel.value!);

    if (response.statusCode != 200) {
      Get.log(response.statusMessage!);
      Get.log(response.statusCode.toString());
      return;
    }

    Get.log(jsonEncode(response.data));
    var id = response.data["job"];
    Timer(20.seconds, () => getTheImage(id));
  }

  Future<void> getTheImage(String id) async {
    var res = await HomeProvider.getImage(jobId: id);
    if (res.statusCode != 200) {
      Get.log(res.statusCode.toString());
      Get.log(res.statusMessage!);
      return;
    }
    isWorking(false);
    outputModel(GeneratedOutputModel.fromJson(res.data));

    Get.log(res.data.toString());
  }

  Future<void> saveImage() async {
    Get.showSnackbar(GetSnackBar(
      showProgressIndicator: true,
      message: "Downloading...",
      animationDuration: 100.milliseconds,
    ));
    bool isGranted = await handler.Permission.storage.request().isGranted;
    if (!isGranted) {
      snackBar("Please give me permission to save your image!");
      return;
    }
    await _loadImage();
    if (_imageBytes != null) {
      await ImageGallerySaver.saveImage(
        _imageBytes!,
        name: "${DateTime.now().millisecondsSinceEpoch}",
      );
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      snackBar("Image saved successfully!");
    }
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(text), duration: 3.seconds),
    );
  }

  Future<void> _loadImage() async {
    final response = await http.get(Uri.parse(outputModel.value!.imageUrl));
    if (response.statusCode != 200) {
      Get.log(response.statusCode.toString());
      Get.log(response.body);
      return;
    }
    _imageBytes = response.bodyBytes;
  }

  openImage() {
    final imageProvider = Image.network(outputModel.value!.imageUrl).image;
    showImageViewer(
      Get.context!,
      imageProvider,
      onViewerDismissed: () {},
      swipeDismissible: true,
      immersive: false,
      useSafeArea: true,
    );
  }
}
