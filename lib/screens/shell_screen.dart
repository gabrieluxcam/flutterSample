import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({Key? key, required this.child}) : super(key: key);

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home/cart')) return 1;
    if (location.startsWith('/home/profile')) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/products');
        break;
      case 1:
        context.go('/home/cart');
        break;
      case 2:
        context.go('/home/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;
    final selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
