import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'Product 1',
      description: 'This is the description for Product 1.',
      price: 19.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+1',
    ),
    Product(
      id: '2',
      title: 'Product 2',
      description: 'This is the description for Product 2.',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+2',
    ),
    Product(
      id: '3',
      title: 'Product 3',
      description: 'This is the description for Product 3.',
      price: 39.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+3',
    ),
    Product(
      id: '4',
      title: 'Product 4',
      description: 'This is the description for Product 4.',
      price: 49.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+4',
    ),
    Product(
      id: '5',
      title: 'Product 5',
      description: 'This is the description for Product 5.',
      price: 59.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+5',
    ),
    Product(
      id: '6',
      title: 'Product 6',
      description: 'This is the description for Product 6.',
      price: 69.99,
      imageUrl: 'https://via.placeholder.com/150?text=Product+6',
    ),
  ];

  late List<Product> _filteredProducts;

  ProductProvider() {
    _filteredProducts = List.from(_products);
  }

  List<Product> get products => _filteredProducts;

  Future<void> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  void filterBy(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Product getById(String id) => _products.firstWhere((p) => p.id == id);
}
