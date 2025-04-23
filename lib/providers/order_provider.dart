import 'package:flutter/foundation.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _orders = [
      Order(id: '1001', date: DateTime.now().subtract(const Duration(days: 1)), total: 49.99),
      Order(id: '1002', date: DateTime.now().subtract(const Duration(days: 5)), total: 120.00),
    ];
    notifyListeners();
  }
}
