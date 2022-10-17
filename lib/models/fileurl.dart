class UserFields {
  static const String id = "\$id";
  static const String name = "name";
  static const String bucketId = "bucketId";
}

class UploadedFiles {
  String? id;
  String? name;
  String? bucketId;

  UploadedFiles({
    required this.id,
    required this.bucketId,
    required this.name,
  });

  UploadedFiles.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    name = json[UserFields.name];
    bucketId = json[UserFields.bucketId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.id] = id;
    data[UserFields.bucketId] = bucketId;
    return data;
  }
}