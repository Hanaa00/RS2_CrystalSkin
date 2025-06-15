import 'package:crystal_skin_admin/models/base.dart';

class AppConfig extends BaseModel {
  late double monthlyFee;

  AppConfig();

  AppConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    monthlyFee = json['monthlyFee'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['monthlyFee'] = monthlyFee;
    data['createdAt'] = createdAt;
    return data;
  }
}