import 'package:crystal_skin_admin/helpers/json_helper.dart';
import 'package:crystal_skin_admin/models/order_item.dart';

class Order {
  int id;
  int patientId;
  String? transactionId;
  String? fullName;
  String? address;
  String? phoneNumber;
  String? paymentMethod;
  String? deliveryMethod;
  String? note;
  double totalAmount;
  int? status;
  DateTime? date;
  List<OrderItemModel> items;

  Order({
    required this.id,
    required this.patientId,
    this.transactionId,
    this.fullName,
    this.address,
    this.phoneNumber,
    this.paymentMethod,
    this.deliveryMethod,
    this.note,
    required this.totalAmount,
    this.status,
    this.date,
    List<OrderItemModel>? items,
  })  : items = items ?? [];

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      patientId: json['patientId'],
      transactionId: json['transactionId'],
      fullName: json['fullName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      paymentMethod: json['paymentMethod'],
      deliveryMethod: json['deliveryMethod'],
      note: json['note'],
      totalAmount:  JsonHelper.toDouble(json['totalAmount']),
      status: json['status'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    var obj = {
      'id': id,
      'patientId': patientId,
      'transactionId': transactionId,
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
      'deliveryMethod': deliveryMethod,
      'note': note,
      'totalAmount': totalAmount,
      'date': date?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };

    if (status != null){
      obj['status'] = status;
    }

    if (note != null){
      obj['note'] = note;
    }

    return obj;
  }
}
