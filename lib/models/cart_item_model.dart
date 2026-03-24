import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String shopId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  });

  CartItem copyWith({
    String? productId,
    String? shopId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'shopId': shopId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
    productId,
    shopId,
    name,
    price,
    quantity,
    imageUrl,
  ];
}
