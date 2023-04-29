import 'package:DarAi/app/core/dio_helper/dio_client.dart';
import 'package:DarAi/app/data/models_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (s) {
        Get.focusScope!.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Generate Ai Image", style: TextStyle(fontSize: 30)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your prompt..',
                    ),
                    minLines: 1,
                    autofocus: false,
                    maxLines: 5,
                    onChanged: (s) {
                      controller.inputModel.value!.prompt = s;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Style ❤️',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: Model.values.map((e) {
                          return modelItem(e);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                generateButton,
                const SizedBox(height: 10),
                const Text(
                  'Result 🖼️',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Center(child: showTheImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get generateButton {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                controller.isWorking.isTrue
                    ? Colors.blueAccent.withOpacity(0.4)
                    : Colors.blueAccent[400]!,
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            onPressed: () {
              if (controller.isWorking.isFalse) {
                controller.generate();
              }
            },
            child: Obx(() {
              return Text(
                'Generate 🍀',
                style: TextStyle(
                  color:
                      controller.isWorking.isTrue ? Colors.grey : Colors.white,
                ),
              );
            }),
          ),
        ),
        resetButton,
      ],
    );
  }

  Obx get resetButton {
    return Obx(() {
      return Visibility(
        visible: controller.isWorking.isTrue,
        child: Row(
          children: [
            const SizedBox(width: 10),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.grey[200]!,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              onPressed: () {
                controller.isWorking(false);
                DioInstance.cancelAllRequests();
              },
              child: const Text(
                'Stop ✋',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget get showTheImage {
    return Obx(() {
      bool isWorking = controller.isWorking.value;
      var output = controller.outputModel.value;

      if (output != null) {
        if (isWorking) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.1,
                child: networkImage,
              ),
              const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            InkWell(
              onTap: () {
                controller.openImage();
              },
              child: networkImage,
            ),
            actionBar,
          ],
        );
      }

      if (isWorking) {
        return const Center(
          child: CupertinoActivityIndicator(radius: 20),
        );
      }

      return const SizedBox.shrink();
    });
  }

  SizedBox get actionBar {
    return SizedBox(
      width: Get.width * .8,
      height: 50,
      child: ColoredBox(
        color: Colors.grey[200]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            actionButton(
              text: "Regenerate",
              icon: Icons.refresh,
              onAction: () {
                controller.generate(removeTheOld: false);
              },
            ),
            actionButton(
              text: "Download",
              icon: Icons.download_rounded,
              onAction: () {
                controller.saveImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  SizedBox get networkImage {
    return SizedBox(
      height: Get.width * .8,
      width: Get.width * .8,
      child: Image.network(controller.outputModel.value!.imageUrl),
    );
  }

  Widget actionButton({
    required String text,
    required IconData icon,
    required Function() onAction,
  }) {
    return InkWell(
      onTap: () {
        onAction();
      },
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 5),
          Icon(icon),
        ],
      ),
    );
  }

  Widget modelItem(Model model) {
    return Obx(() {
      var isSelected = model.key == controller.inputModel.value!.model;
      return SizedBox(
        height: 120,
        width: 110,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                controller.inputModel.value!.model = model.key;
                controller.inputModel.refresh();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: isSelected
                      ? Border.all(color: Colors.indigoAccent, width: 4)
                      : null,
                ),
                height: 90,
                width: 100,
                child: Image.asset(model.image, fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              model.name,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              softWrap: true,
            )
          ],
        ),
      );
    });
  }
}
