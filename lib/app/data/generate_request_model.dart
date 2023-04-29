class GenerateInputModel {
  String prompt;
  String model;
  int seed;

  GenerateInputModel({
    required this.prompt,
    required this.model,
    required this.seed,
  });

  factory GenerateInputModel.fromJson(Map<String, dynamic> json) {
    return GenerateInputModel(
      prompt: json['prompt'],
      model: json['model'],
      seed: json['seed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'model': model,
      'seed': seed,
    };
  }
}
