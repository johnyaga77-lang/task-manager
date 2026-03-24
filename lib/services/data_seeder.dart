import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class DataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<void> seedData() async {
    final WriteBatch batch = _firestore.batch();

    // 1. Create Shops
    final shops = [
      Shop(
        id: _uuid.v4(),
        name: 'Fresh Mart',
        address: '123 Green St, Springfield',
        location: const GeoPoint(37.7749, -122.4194), // San Francisco
        imageUrl:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=500&q=60',
        rating: 4.5,
      ),
      Shop(
        id: _uuid.v4(),
        name: 'Tech Haven',
        address: '456 Silicon Ave, Tech Valley',
        location: const GeoPoint(37.7849, -122.4094),
        imageUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=500&q=60',
        rating: 4.8,
      ),
      Shop(
        id: _uuid.v4(),
        name: 'Bakery Delights',
        address: '789 Sweet Rd, Candyland',
        location: const GeoPoint(37.7649, -122.4294),
        imageUrl:
            'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=500&q=60',
        rating: 4.7,
      ),
    ];

    for (var shop in shops) {
      batch.set(_firestore.collection('shops').doc(shop.id), shop.toMap());
    }

    // 2. Create Products for each shop
    final products = [
      // Fresh Mart
      Product(
        id: _uuid.v4(),
        shopId: shops[0].id,
        name: 'Organic Apples',
        description: 'Fresh organic red apples from local farms.',
        price: 3.99,
        imageUrl:
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=500&q=60',
        category: 'Groceries',
      ),
      Product(
        id: _uuid.v4(),
        shopId: shops[0].id,
        name: 'Whole Milk',
        description: '1 Gallon of fresh whole milk.',
        price: 4.50,
        imageUrl:
            'https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=500&q=60',
        category: 'Dairy',
      ),
      // Tech Haven
      Product(
        id: _uuid.v4(),
        shopId: shops[1].id,
        name: 'Wireless Headphones',
        description: 'Noise cancelling over-ear headphones.',
        price: 199.99,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=60',
        category: 'Electronics',
      ),
      Product(
        id: _uuid.v4(),
        shopId: shops[1].id,
        name: 'Smart Watch',
        description: 'Fitness tracker and smartwatch.',
        price: 149.50,
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=60',
        category: 'Electronics',
      ),
      // Bakery Delights
      Product(
        id: _uuid.v4(),
        shopId: shops[2].id,
        name: 'Croissant',
        description: 'Buttery flaky croissant.',
        price: 2.50,
        imageUrl:
            'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=500&q=60',
        category: 'Bakery',
      ),
      Product(
        id: _uuid.v4(),
        shopId: shops[2].id,
        name: 'Chocolate Cake',
        description: 'Rich chocolate layer cake.',
        price: 25.00,
        imageUrl:
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=500&q=60',
        category: 'Bakery',
      ),
    ];

    for (var product in products) {
      batch.set(
        _firestore.collection('products').doc(product.id),
        product.toMap(),
      );
    }

    await batch.commit();
  }
}
