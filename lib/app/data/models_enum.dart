import 'package:DarAi/generated/assets.dart';

enum Model {
  dreamlikeDiffusion,
  openJourny,
  styleJourny,
  realistic,
  deliberate,
  counterfeit,
}

extension ModelExten on Model {
  String get name {
    switch (this) {
      case Model.openJourny:
        return "OpenJourny";
      case Model.styleJourny:
        return "StyleJourny";
      case Model.realistic:
        return "Realistic";
      case Model.dreamlikeDiffusion:
        return "Dreamlike";
      case Model.deliberate:
        return "Deliberate";
      case Model.counterfeit:
        return "Counterfeit";
    }
  }

  String get image {
    switch (this) {
      case Model.openJourny:
        return Assets.imagesOpenjourneyV4;
      case Model.styleJourny:
        return Assets.imagesStylejourney;
      case Model.realistic:
        return Assets.imagesRealisticVision;
      case Model.dreamlikeDiffusion:
        return Assets.imagesDreamlikeDiffusion;
      case Model.deliberate:
        return Assets.imagesDeliberate;
      case Model.counterfeit:
        return Assets.imagesCounterfeitV25;
    }
  }

  String get key {
    switch (this) {
      case Model.openJourny:
        return "openjourney_V4.ckpt [ca2f377f]";
      case Model.styleJourny:
        return "analog-diffusion-1.0.ckpt [9ca13f02]";
      case Model.realistic:
        return "v1-5-pruned-emaonly.ckpt [81761151]";
      case Model.dreamlikeDiffusion:
        return "dreamlike-diffusion-2.0.safetensors [fdcf65e7]";
      case Model.deliberate:
        return "deliberate_v2.safetensors [10ec4b29]";
      case Model.counterfeit:
        return "sdv1_4.ckpt [7460a6fa]";
    }
  }
}
