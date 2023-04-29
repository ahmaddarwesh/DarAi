class GeneratedOutputModel {
  final String job;
  final Map<String, dynamic> params;
  final String status;
  final String imageUrl;

  GeneratedOutputModel({
    required this.job,
    required this.params,
    required this.status,
    required this.imageUrl,
  });

  factory GeneratedOutputModel.fromJson(Map<String, dynamic> json) {
    return GeneratedOutputModel(
      job: json['job'],
      params: json['params'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job,
      'params': params,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}