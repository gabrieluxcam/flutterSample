import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.length;

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(id: product.id, product: product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
