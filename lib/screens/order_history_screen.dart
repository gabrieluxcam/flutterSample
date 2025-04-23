import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    await context.read<OrderProvider>().fetchOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order History')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body:
          orders.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No past orders', style: TextStyle(fontSize: 18)),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadOrders,
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final o = orders[index];
                    return ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text('Order #${o.id}'),
                      subtitle: Text('${o.date.toLocal()}'.split(' ')[0]),
                      trailing: Text('\$${o.total.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
    );
  }
}
