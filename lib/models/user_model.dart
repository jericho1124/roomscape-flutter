import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String photoUrl;
  final DateTime? createdAt;
  final List<String> favorites;
  final List<String> recentlyViewed;
  final String? phoneNumber;
  final String? address;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl = '',
    this.createdAt,
    this.favorites = const [],
    this.recentlyViewed = const [],
    this.phoneNumber,
    this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      favorites: List<String>.from(map['favorites'] ?? []),
      recentlyViewed: List<String>.from(map['recentlyViewed'] ?? []),
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'favorites': favorites,
      'recentlyViewed': recentlyViewed,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    List<String>? favorites,
    List<String>? recentlyViewed,
    String? phoneNumber,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      favorites: favorites ?? this.favorites,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
} 