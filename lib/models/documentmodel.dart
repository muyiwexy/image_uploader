class UserFields {
  static const String url = "url";
}

class DocModel {
  String? url;

  DocModel({
    required this.url,
  });

  DocModel.fromJson(Map<String, dynamic> json) {
    url = json[UserFields.url];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserFields.url] = url;
    return data;
  }
}