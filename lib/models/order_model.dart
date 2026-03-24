import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus { placed, accepted, outForDelivery, delivered, cancelled }

enum PaymentMethod { cod, upi }

enum DeliveryType { sameDay, pickup }

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String shopId;
  final List<Map<String, dynamic>> items; // {productId, quantity, name, price}
  final double totalAmount;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DeliveryType deliveryType;
  final DateTime createdAt;
  final String deliveryAddress;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryType,
    required this.createdAt,
    required this.deliveryAddress,
  });

  factory OrderModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      shopId: data['shopId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => OrderStatus.placed,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == data['paymentMethod'],
        orElse: () => PaymentMethod.cod,
      ),
      deliveryType: DeliveryType.values.firstWhere(
        (e) => e.toString() == data['deliveryType'],
        orElse: () => DeliveryType.sameDay,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deliveryAddress: data['deliveryAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shopId': shopId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status.toString(),
      'paymentMethod': paymentMethod.toString(),
      'deliveryType': deliveryType.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    shopId,
    items,
    totalAmount,
    status,
    paymentMethod,
    deliveryType,
    createdAt,
    deliveryAddress,
  ];
}
