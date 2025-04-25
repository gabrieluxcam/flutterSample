import 'package:flutter/material.dart';

class AnimatedCartIcon extends StatefulWidget {
  final int itemCount;
  final VoidCallback? onTap;
  const AnimatedCartIcon({Key? key, required this.itemCount, this.onTap}) : super(key: key);

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  int _prevCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scale = Tween<double>(begin: 1, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _prevCount = widget.itemCount;
  }

  @override
  void didUpdateWidget(covariant AnimatedCartIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > _prevCount) {
      _controller.forward(from: 0);
    }
    _prevCount = widget.itemCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ScaleTransition(
            scale: _scale,
            child: const Icon(Icons.shopping_cart, size: 28),
          ),
          if (widget.itemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text('${widget.itemCount}', style: const TextStyle(fontSize: 10, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
