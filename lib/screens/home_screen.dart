import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../services/firebase_service.dart';
import 'cart_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      final user = await FirebaseService.getCurrentUser();
      print('Firebase connection check - User: ${user?.email ?? 'Not signed in'}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Firebase connection error: $e');
      setState(() {
        _error = 'Error connecting to Firebase: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'RoomScape',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E1E1E)),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFF1E1E1E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(showAppBar: true),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : const ProductsGrid(),
    );
  }
}

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({super.key});

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  String _selectedCategory = 'all';
  final List<String> _categories = ['all', 'wall', 'floors'];
  bool _isDeleting = false;

  Stream<List<Product>> _getFilteredProducts() {
    if (_selectedCategory == 'all') {
      return ProductService.getProducts();
    }
    return ProductService.getProductsByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Categories
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ChoiceChip(
                  label: Text(
                    _categories[index].toUpperCase(),
                    style: TextStyle(
                      color: _selectedCategory == _categories[index]
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ),
                  selected: _selectedCategory == _categories[index],
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = _categories[index];
                    });
                  },
                  selectedColor: const Color(0xFF1E1E1E),
                  backgroundColor: Colors.grey[200],
                ),
              );
            },
          ),
        ),
        
        // Products Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<List<Product>>(
              stream: _getFilteredProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data ?? [];
                
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products found. Add some products to get started!'),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
} 