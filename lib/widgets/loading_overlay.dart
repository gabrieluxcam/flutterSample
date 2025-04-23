// lib/widgets/loading_overlay.dart
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black45,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.white),
          ),
      ],
    );
  }
}
