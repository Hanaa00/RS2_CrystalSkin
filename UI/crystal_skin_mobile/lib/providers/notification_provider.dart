import 'package:crystal_skin_mobile/models/notification.dart';
import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super('Notifications');

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }
}