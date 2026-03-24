import 'package:flutter/material.dart';
import '../../models/shop_model.dart';
import '../../models/product_model.dart';
import '../../services/commerce_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../models/cart_item_model.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Shop shop;

  const ShopDetailsScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shop.name)),
      body: Column(
        children: [
          if (shop.imageUrl.isNotEmpty)
            Image.network(
              shop.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(shop.address),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(shop.rating.toString()),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: CommerceService().getProducts(shop.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const Center(child: Text('No products available.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.shopping_bag, size: 50),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${product.price}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: product.isAvailable
                                        ? () {
                                            context.read<CartBloc>().add(
                                              AddToCart(
                                                CartItem(
                                                  productId: product.id,
                                                  shopId: shop.id,
                                                  name: product.name,
                                                  price: product.price,
                                                  imageUrl: product.imageUrl,
                                                ),
                                              ),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('Added to cart'),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: const Text('Add'),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}
