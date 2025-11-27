import 'package:flutter/material.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // tarjeta clara sobre el pergamino
        color: AppColors.sandLight.withOpacity(0.9),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1),
      ),
      child: Padding(
        padding: padding,
        // NO cambiamos DefaultTextStyle para no romper formularios
        child: child,
      ),
    );
  }
}
