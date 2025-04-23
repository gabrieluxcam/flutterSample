import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () => context.go('/home/products/${product.id}'),
            child: Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder:
                          (ctx, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                            ),
                          ),
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
