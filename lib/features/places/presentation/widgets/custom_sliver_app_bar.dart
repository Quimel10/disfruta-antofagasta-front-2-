import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String heroTag;
  final VoidCallback? onShare;

  const CustomSliverAppBar({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.heroTag,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 260,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: heroTag,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),

      // ❌ Eliminado el corazón
      actions: [
        if (onShare != null)
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: onShare,
          ),
      ],
    );
  }
}
