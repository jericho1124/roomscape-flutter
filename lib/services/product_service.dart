import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _productsCollection = _firestore.collection('products');

  // Get all products
  static Stream<List<Product>> getProducts() {
    return _productsCollection
        .orderBy('__name__')  // Order by document ID instead of createdAt
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                print('Product ID: ${doc.id}');
                print('Raw product data from Firebase: $data');
                print('Raw price value: ${data['price']} (${data['price'].runtimeType})');
                
                // Add default values for timestamp fields if they don't exist
                if (!data.containsKey('createdAt')) {
                  data['createdAt'] = Timestamp.now();
                }
                if (!data.containsKey('updatedAt')) {
                  data['updatedAt'] = Timestamp.now();
                }
                
                final product = Product.fromMap({...data, 'id': doc.id});
                print('Parsed product: Name=${product.name}, Price=${product.price} (${product.price.runtimeType})');
                return product;
              })
              .toList();
        });
  }

  // Get products by category
  static Stream<List<Product>> getProductsByCategory(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .orderBy('__name__')  // Order by document ID
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                print('Category product ID: ${doc.id}');
                print('Raw category product data: $data');
                print('Raw category price value: ${data['price']} (${data['price'].runtimeType})');
                
                if (!data.containsKey('createdAt')) {
                  data['createdAt'] = Timestamp.now();
                }
                if (!data.containsKey('updatedAt')) {
                  data['updatedAt'] = Timestamp.now();
                }
                
                final product = Product.fromMap({...data, 'id': doc.id});
                print('Parsed category product: Name=${product.name}, Price=${product.price} (${product.price.runtimeType})');
                return product;
              })
              .toList();
        });
  }

  // Get product by ID
  static Future<Product?> getProductById(String id) async {
    final doc = await _productsCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      // Add default values for timestamp fields if they don't exist
      if (!data.containsKey('createdAt')) {
        data['createdAt'] = Timestamp.now();
      }
      if (!data.containsKey('updatedAt')) {
        data['updatedAt'] = Timestamp.now();
      }
      return Product.fromMap({...data, 'id': doc.id});
    }
    return null;
  }

  // Add new product
  static Future<String> addProduct(Product product) async {
    try {
      final docRef = _productsCollection.doc();
      final now = Timestamp.now();
      final productData = {
        ...product.toMap(),
        'id': docRef.id,
        'createdAt': now,
        'updatedAt': now,
      };
      await docRef.set(productData);
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  // Update product
  static Future<void> updateProduct(Product product) async {
    await _productsCollection.doc(product.id).update({
      ...product.toMap(),
      'updatedAt': Timestamp.now(),
    });
  }

  // Delete product
  static Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }

  // Search products
  static Stream<List<Product>> searchProducts(String query) {
    query = query.toLowerCase();
    return _productsCollection
        .orderBy('__name__')  // Order by document ID
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                // Add default values for timestamp fields if they don't exist
                if (!data.containsKey('createdAt')) {
                  data['createdAt'] = Timestamp.now();
                }
                if (!data.containsKey('updatedAt')) {
                  data['updatedAt'] = Timestamp.now();
                }
                return Product.fromMap({...data, 'id': doc.id});
              })
              .where((product) =>
                  product.name.toLowerCase().contains(query) ||
                  product.description.toLowerCase().contains(query) ||
                  product.tags.any((tag) => tag.toLowerCase().contains(query)))
              .toList();
        });
  }

  // Get featured products
  static Stream<List<Product>> getFeaturedProducts() {
    return _productsCollection
        .where('isFeatured', isEqualTo: true)
        .orderBy('__name__')  // Order by document ID
        .limit(10)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                // Add default values for timestamp fields if they don't exist
                if (!data.containsKey('createdAt')) {
                  data['createdAt'] = Timestamp.now();
                }
                if (!data.containsKey('updatedAt')) {
                  data['updatedAt'] = Timestamp.now();
                }
                return Product.fromMap({...data, 'id': doc.id});
              })
              .toList();
        });
  }

  // Get products with AR models
  static Stream<List<Product>> getARProducts() {
    return _productsCollection
        .where('hasARModel', isEqualTo: true)
        .orderBy('__name__')  // Order by document ID
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                // Add default values for timestamp fields if they don't exist
                if (!data.containsKey('createdAt')) {
                  data['createdAt'] = Timestamp.now();
                }
                if (!data.containsKey('updatedAt')) {
                  data['updatedAt'] = Timestamp.now();
                }
                return Product.fromMap({...data, 'id': doc.id});
              })
              .toList();
        });
  }

  // Update product rating
  static Future<void> updateProductRating(
    String productId,
    double newRating,
    int reviewCount,
  ) async {
    await _productsCollection.doc(productId).update({
      'rating': newRating,
      'reviewCount': reviewCount,
      'updatedAt': Timestamp.now(),
    });
  }

  // Update product stock
  static Future<void> updateProductStock(
    String productId,
    int newStock,
  ) async {
    await _productsCollection.doc(productId).update({
      'stockCount': newStock,
      'isAvailable': newStock > 0,
      'updatedAt': Timestamp.now(),
    });
  }
} 