import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Stream<List<Product>> _productsStream;
  String _selectedCategory = 'all';
  final List<String> _categories = ['all', 'wall', 'floors'];

  @override
  void initState() {
    super.initState();
    _productsStream = ProductService.getProducts();
  }

  void _updateSearch(String query) {
    setState(() {
      _productsStream = query.isEmpty
          ? ProductService.getProducts()
          : ProductService.searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: _updateSearch,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Color(0xFF1E1E1E)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
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
                stream: _productsStream,
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
                      child: Text('No products found'),
                    );
                  }

                  // Filter products by category if not 'all'
                  final filteredProducts = _selectedCategory == 'all'
                      ? products
                      : products.where((product) => 
                          product.category == _selectedCategory
                        ).toList();

                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text('No products found in this category'),
                    );
                  }

                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredProducts[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 