import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/shimmer_placeholder.dart';
import '../widgets/animated_cart_icon.dart';
import '../models/product.dart'; // Assumes Product has a `category` and `rating` field

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'price';
  final Set<String> _selectedCategories = {};
  int _currentIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final categories = ['Electronics', 'Books', 'Clothing', 'Home'];
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...categories.map(
                    (cat) => CheckboxListTile(
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
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

  void _onNavIndex(int idx) {
    setState(() => _currentIndex = idx);
    switch (idx) {
      case 0:
        context.go('/home/products');
        break;
      case 1:
        context.go('/home/cart');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawProducts = context.watch<ProductProvider>().products;
    // Make a local copy to apply sorting & category filtering
    List<Product> products = List.from(rawProducts);

    // Apply category filters
    if (_selectedCategories.isNotEmpty) {
      products =
          products
              .where((p) => _selectedCategories.contains(p.category))
              .toList();
    }

    // Apply sorting
    products.sort((a, b) {
      if (_sortBy == 'price') {
        return a.price.compareTo(b.price);
      } else {
        // descending by rating
        return b.rating.compareTo(a.rating);
      }
    });

    // Prepare a stable key for AnimatedSwitcher
    final sortedCats = _selectedCategories.toList()..sort();
    final switcherKey = ValueKey(
      '${products.length}|$_sortBy|${sortedCats.join(',')}',
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductProvider>().filterBy('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.2),
            ),
            onChanged: (q) => context.read<ProductProvider>().filterBy(q),
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder:
                (ctx, cart, _) => AnimatedCartIcon(
                  itemCount: cart.itemCount,
                  onTap: () {
                    context.go('/home/cart');
                  },
                ),
          ),
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
            if (_selectedCategories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Wrap(
                  spacing: 6,
                  children:
                      _selectedCategories
                          .map(
                            (cat) => InputChip(
                              label: Text(cat),
                              onDeleted:
                                  () => setState(
                                    () => _selectedCategories.remove(cat),
                                  ),
                            ),
                          )
                          .toList(),
                ),
              ),
            Expanded(
              child:
                  products.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'No products found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                      : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: GridView.builder(
                          key: switcherKey,
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
                                  () => context.go(
                                    '/home/products/${product.id}',
                                  ),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                tween: Tween(begin: 2.0, end: 8.0),
                                builder:
                                    (context, elevation, child) => Material(
                                      elevation: elevation,
                                      borderRadius: BorderRadius.circular(14),
                                      clipBehavior: Clip.antiAlias,
                                      child: child,
                                    ),
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
                                                  Image.asset(
                                                    'assets/placeholder.png',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                          loadingBuilder: (
                                            ctx,
                                            child,
                                            progress,
                                          ) {
                                            if (progress == null) return child;
                                            return ShimmerPlaceholder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall?.copyWith(
                                                color: Colors.green,
                                              ),
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
                                                            ? Theme.of(ctx)
                                                                .colorScheme
                                                                .primary
                                                            : Colors.grey,
                                                  ),
                                                  tooltip:
                                                      isFav
                                                          ? 'Remove from wishlist'
                                                          : 'Add to wishlist',
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
            ),
          ],
        ),
      ),
    );
  }
}
