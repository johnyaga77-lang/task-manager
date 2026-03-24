import 'package:flutter/material.dart';
import '../../models/shop_model.dart';
import '../../services/commerce_service.dart';
import 'shop_details_screen.dart';

class ShopSearchDelegate extends SearchDelegate {
  final CommerceService _commerceService = CommerceService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Shop>>(
      stream: _commerceService
          .getShops(), // Ideally, this should be a search query
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final shops = snapshot.data ?? [];
        final results = shops
            .where(
              (shop) => shop.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        if (results.isEmpty) {
          return const Center(child: Text('No shops found.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final shop = results[index];
            return ListTile(
              title: Text(shop.name),
              subtitle: Text(shop.address),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopDetailsScreen(shop: shop),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Shop>>(
      stream: _commerceService.getShops(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final shops = snapshot.data ?? [];
        final suggestions = shops
            .where(
              (shop) => shop.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final shop = suggestions[index];
            return ListTile(
              title: Text(shop.name),
              onTap: () {
                query = shop.name;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
