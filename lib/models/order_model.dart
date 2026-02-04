import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final String address;
  final String paymentMethod;
  final String orderStatus;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    required this.orderStatus,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      userId: map['userId'] as String,
      items: List<Map<String, dynamic>>.from(map['items'] as List),
      totalPrice: map['totalPrice'] as double,
      address: map['address'] as String,
      paymentMethod: map['paymentMethod'] as String,
      orderStatus: map['orderStatus'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalprice': totalPrice,
      'address': address,
      'paymentMethod': paymentMethod,
      'status': orderStatus,
      'createdAt': createdAt,
    };
  }
}
