import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order_model.dart';
import '../../services/commerce_service.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const Center(child: Text('Please login to view orders')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<OrderModel>>(
        stream: CommerceService().getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    'Order #${order.id.substring(order.id.length - 6)}',
                  ),
                  subtitle: Text(
                    '${DateFormat('MMM dd, yyyy').format(order.createdAt)} - ${order.status.toString().split('.').last.toUpperCase()}',
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item['name']} x${item['quantity']}'),
                                  Text(
                                    '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Delivery Type: ${order.deliveryType.toString().split('.').last}',
                          ),
                          Text(
                            'Payment: ${order.paymentMethod.toString().split('.').last}',
                          ),
                          if (order.deliveryAddress.isNotEmpty)
                            Text('Address: ${order.deliveryAddress}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.accepted:
        return Colors.orange;
      case OrderStatus.outForDelivery:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
