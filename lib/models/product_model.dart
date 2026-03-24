import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final String category;

  const Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isAvailable = true,
    this.category = 'General',
  });

  factory Product.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      shopId: data['shopId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      category: data['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [
    id,
    shopId,
    name,
    description,
    price,
    imageUrl,
    isAvailable,
    category,
  ];
}
