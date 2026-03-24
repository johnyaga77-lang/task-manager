import 'package:flutter/material.dart';
import '../../models/shop_model.dart';
import '../../services/commerce_service.dart';
import 'shop_details_screen.dart';
import 'shop_search_delegate.dart';
import 'cart_screen.dart';

class HomeCommerceScreen extends StatelessWidget {
  const HomeCommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ShopSearchDelegate());
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Shop>>(
        stream: CommerceService().getShops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final shops = snapshot.data ?? [];
          if (shops.isEmpty) {
            return const Center(child: Text('No shops found nearby.'));
          }
          return ListView.builder(
            itemCount: shops.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final shop = shops[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: shop.imageUrl.isNotEmpty
                      ? Image.network(
                          shop.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.store, size: 60),
                  title: Text(
                    shop.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' ${shop.rating}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetailsScreen(shop: shop),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
