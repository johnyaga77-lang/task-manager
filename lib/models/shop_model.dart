import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  final String id;
  final String name;
  final String address;
  final GeoPoint location;
  final String imageUrl;
  final double rating;
  final bool isOpen;

  const Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.imageUrl,
    this.rating = 0.0,
    this.isOpen = true,
  });

  factory Shop.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Shop(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      isOpen: data['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
      'isOpen': isOpen,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    location,
    imageUrl,
    rating,
    isOpen,
  ];
}
