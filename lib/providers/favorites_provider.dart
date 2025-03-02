import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};
  final Map<String, Product> _favoriteProducts = {};

  bool isFavorite(String productId) => _favoriteIds.contains(productId);
  
  int get count => _favoriteIds.length;

  List<Product> get favorites => _favoriteProducts.values.toList();

  void toggleFavorite(Product product) {
    final productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      _favoriteProducts.remove(productId);
    } else {
      _favoriteIds.add(productId);
      _favoriteProducts[productId] = product;
    }
    notifyListeners();
  }

  void removeFromFavorites(String productId) {
    _favoriteIds.remove(productId);
    _favoriteProducts.remove(productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    _favoriteProducts.clear();
    notifyListeners();
  }
} 