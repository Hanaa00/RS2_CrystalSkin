import 'package:crystal_skin_mobile/models/user_model.dart';

class NotificationModel {
  final int id;
  final int userId;
  UserModel? user;
  final String message;
  bool read;

  NotificationModel({
    required this.id,
    required this.userId,
    this.user,
    required this.message,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      message: json['message'],
      read: json['read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'read': read,
    };
  }
}