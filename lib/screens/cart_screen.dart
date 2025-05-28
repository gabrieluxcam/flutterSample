import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../services/adyen_payment_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body:
          items.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                              maxWidth: 56,
                              maxHeight: 56,
                            ),
                            child: Image.network(
                              item.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(item.product.title),
                          subtitle: Text(
                            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed:
                                      () => context
                                          .read<CartProvider>()
                                          .updateQuantity(
                                            item.product.id,
                                            item.quantity - 1,
                                          ),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed:
                                      () => context
                                          .read<CartProvider>()
                                          .updateQuantity(
                                            item.product.id,
                                            item.quantity + 1,
                                          ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed:
                                      () => context
                                          .read<CartProvider>()
                                          .removeItem(item.product.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('\$${cart.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tax'),
                            Text('\$${cart.tax.toStringAsFixed(2)}'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/home/cart/checkout'),
                            child: const Text('Checkout'),
                          ),
                        ),
                        const SizedBox(height: 8), // Spacing between buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Convert total to cents as required by Adyen
                              final amountInCents =
                                  (cart.total * 100).round().toString();
                              AdyenPaymentService.startPayment(
                                context,
                                amountInCents,
                              );
                            },
                            child: const Text('Adyen Payment'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
