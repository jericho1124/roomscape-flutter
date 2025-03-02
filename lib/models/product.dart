import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final Map<String, String> specifications;
  final List<String> additionalImages;
  final String category;
  final bool isAvailable;
  final int stockCount;
  final double rating;
  final int reviewCount;
  final String? arModelUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.tags,
    required this.specifications,
    this.additionalImages = const [],
    required this.category,
    this.isAvailable = true,
    this.stockCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.arModelUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'tags': tags,
      'specifications': specifications,
      'additionalImages': additionalImages,
      'category': category,
      'isAvailable': isAvailable,
      'stockCount': stockCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'arModelUrl': arModelUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // Handle timestamps that might be null or already DateTime
    DateTime getDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      specifications: Map<String, String>.from(map['specifications'] ?? {}),
      additionalImages: List<String>.from(map['additionalImages'] ?? []),
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      stockCount: map['stockCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      arModelUrl: map['arModelUrl'],
      createdAt: getDateTime(map['createdAt']),
      updatedAt: getDateTime(map['updatedAt']),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? tags,
    Map<String, String>? specifications,
    List<String>? additionalImages,
    String? category,
    bool? isAvailable,
    int? stockCount,
    double? rating,
    int? reviewCount,
    String? arModelUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      additionalImages: additionalImages ?? this.additionalImages,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      stockCount: stockCount ?? this.stockCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      arModelUrl: arModelUrl ?? this.arModelUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 