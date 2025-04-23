import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  final String orderId;
  const CheckoutSuccessScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Success')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              Text('Thank you for your order!', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Order #${orderId}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.go('/home/products');
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
