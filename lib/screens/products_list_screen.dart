import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'price';
  Set<String> _selectedCategories = {};

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            // Mock categories for demo
            final categories = ['Electronics', 'Books', 'Clothing', 'Home'];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'price',
                        groupValue: _sortBy,
                        onChanged: (v) {
                          setModalState(() => _sortBy = v!);
                          setState(() => _sortBy = v!);
                        },
                      ),
                      const Text('Price'),
                      Radio<String>(
                        value: 'rating',
                        groupValue: _sortBy,
                        onChanged: (v) {
                          setModalState(() => _sortBy = v!);
                          setState(() => _sortBy = v!);
                        },
                      ),
                      const Text('Rating'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...categories.map((cat) => CheckboxListTile(
                        title: Text(cat),
                        value: _selectedCategories.contains(cat),
                        onChanged: (val) {
                          setModalState(() {
                            if (val == true) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                          setState(() {
                            if (val == true) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                        },
                      )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<ProductProvider>().filterBy('');
                  _searchController.clear();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
            ),
            controller: _searchController,
            onChanged: (q) => context.read<ProductProvider>().filterBy(q),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Filter & Sort',
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductProvider>().fetchProducts(),
        child: Column(
          children: [

            Expanded(
              child:
                  products.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No products found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap:
                                () =>
                                    context.go('/home/products/${product.id}'),
                            child: Card(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: 'product-image-${product.id}',
                                    child: AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (ctx, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                  ),
                                                ),
                                        loadingBuilder: (ctx, child, progress) {
                                          if (progress == null) return child;
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Consumer<CartProvider>(
                                      builder:
                                          (ctx, cart, _) => CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart,
                                              ),
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              tooltip: 'Add to Cart',
                                              onPressed: () {
                                                cart.addItem(product);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Added to cart',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    ),
                                  ),
                                  // Rest of the card content below image
                                  Positioned.fill(
                                    top: null,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            product.title,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(color: Colors.green),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Consumer<WishlistProvider>(
                                            builder: (ctx, wishlist, _) {
                                              final isFav = wishlist.isIn(
                                                product.id,
                                              );
                                              return IconButton(
                                                icon: Icon(
                                                  isFav
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color:
                                                      isFav
                                                          ? Theme.of(
                                                            ctx,
                                                          ).colorScheme.primary
                                                          : Colors.grey,
                                                ),
                                                onPressed:
                                                    () => wishlist.toggle(
                                                      product.id,
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
