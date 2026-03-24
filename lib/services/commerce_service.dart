import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CommerceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Shops
  Stream<List<Shop>> getShops() {
    return _firestore.collection('shops').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Shop.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addShop(Shop shop) async {
    await _firestore.collection('shops').doc(shop.id).set(shop.toMap());
  }

  // Products
  Stream<List<Product>> getProducts(String shopId) {
    return _firestore
        .collection('products')
        .where('shopId', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
        });
  }

  Future<void> addProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toMap());
  }

  // Orders
  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toMap());
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => OrderModel.fromSnapshot(doc))
              .toList();
        });
  }
}
