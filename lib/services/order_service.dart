import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> shippingAddress;
  final String? trackingNumber;
  final String paymentMethod;
  final String paymentStatus;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.shippingAddress,
    this.trackingNumber,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'shippingAddress': shippingAddress,
      'trackingNumber': trackingNumber,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      total: (map['total'] ?? 0.0).toDouble(),
      status: map['status'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
      trackingNumber: map['trackingNumber'],
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory OrderItem.fromProduct(Product product, int quantity) {
    return OrderItem(
      productId: product.id,
      productName: product.name,
      price: product.price,
      quantity: quantity,
      imageUrl: product.imageUrl,
    );
  }
}

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _ordersCollection =
      _firestore.collection('orders');

  // Create new order
  static Future<String> createOrder(OrderModel order) async {
    final doc = await _ordersCollection.add(order.toMap());
    await doc.update({'id': doc.id});
    return doc.id;
  }

  // Get user orders
  static Stream<List<OrderModel>> getUserOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get order by ID
  static Future<OrderModel?> getOrderById(String id) async {
    final doc = await _ordersCollection.doc(id).get();
    if (doc.exists) {
      return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update order status
  static Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String? trackingNumber,
  }) async {
    final data = {
      'status': status,
      'updatedAt': Timestamp.now(),
    };

    if (trackingNumber != null) {
      data['trackingNumber'] = trackingNumber;
    }

    await _ordersCollection.doc(orderId).update(data);
  }

  // Update payment status
  static Future<void> updatePaymentStatus(
    String orderId,
    String paymentStatus,
  ) async {
    await _ordersCollection.doc(orderId).update({
      'paymentStatus': paymentStatus,
      'updatedAt': Timestamp.now(),
    });
  }

  // Cancel order
  static Future<void> cancelOrder(String orderId) async {
    await _ordersCollection.doc(orderId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
  }

  // Get recent orders
  static Stream<List<OrderModel>> getRecentOrders(String userId, {int limit = 5}) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
} 