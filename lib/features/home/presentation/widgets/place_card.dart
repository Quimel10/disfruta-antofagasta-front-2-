import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/place.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;

  /// si es favorito o no
  final bool onFavorite;

  /// cuando se toca el corazón
  final VoidCallback? onFavoriteTap;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final wineLight = AppColors.panelWine.withOpacity(0.85);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: wineLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.panelWineDark, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                place.imagen,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.white12,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // TEXTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO + FAVORITO
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          place.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (onFavoriteTap != null)
                        IconButton(
                          onPressed: onFavoriteTap,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            onFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // CATEGORÍA (Vitrina / Pedestal, etc.)
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.tipoNombreView,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // DESCRIPCIÓN (excerpt / descCorta)
                  Text(
                    place.extractoView,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensión para campos del backend
extension PlaceViewFields on PlaceEntity {
  /// descripción corta que viene del backend
  String get extractoView => descCorta;

  /// nombre de la categoría / tipo (Vitrina, Pedestal, etc.)
  String get tipoNombreView => tipo;
}
