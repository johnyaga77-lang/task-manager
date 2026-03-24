import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../models/order_model.dart';
import '../../services/commerce_service.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Direct auth check

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  DeliveryType _deliveryType = DeliveryType.sameDay;
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      leading: Image.network(
                        item.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text(item.name),
                      subtitle: Text('\$${item.price} x ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('\$${item.total.toStringAsFixed(2)}'),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                RemoveFromCart(item.productId),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: \$${state.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Address',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DeliveryType>(
                      value: _deliveryType,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Type',
                      ),
                      items: DeliveryType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type.toString().split('.').last.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _deliveryType = val!),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<PaymentMethod>(
                      value: _paymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Payment Method',
                      ),
                      items: PaymentMethod.values.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(
                            method.toString().split('.').last.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_addressController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter delivery address'),
                            ),
                          );
                          return;
                        }

                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please login to place order'),
                            ),
                          );
                          return;
                        }

                        // Create Order
                        // Group by shop? For now assuming single shop or multiple orders. Only one order per checkout for simplicity?
                        // Actually, let's create one order for now. If mixed shops, might need split orders.
                        // Simplification: Assume all items from same shop or create one mixed order (but ShopId is required in OrderModel?)
                        // Let's use the shopId of the first item.

                        final shopId = state.items.first.shopId;

                        final order = OrderModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: user.uid,
                          shopId: shopId,
                          items: state.items.map((e) => e.toMap()).toList(),
                          totalAmount: state.totalAmount,
                          status: OrderStatus.placed,
                          paymentMethod: _paymentMethod,
                          deliveryType: _deliveryType,
                          createdAt: DateTime.now(),
                          deliveryAddress: _addressController.text,
                        );

                        await CommerceService().placeOrder(order);
                        if (context.mounted) {
                          context.read<CartBloc>().add(ClearCart());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order Placed Successfully!'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
