import 'package:flutter/material.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';

class PlaceDetailsSkeleton extends StatelessWidget {
  const PlaceDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // 🔹 Fondo pergamino
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_portada.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Contenido cargando
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Imagen grande esqueleto
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: AppColors.panelWine.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const SizedBox(height: 16),

                // Panel principal esqueleto (mismo color que place_card)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.panelWine,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.panelWineDark,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(),
                      const SizedBox(height: 12),
                      _line(width: 180),
                      const SizedBox(height: 16),
                      _line(width: 140),
                      const SizedBox(height: 8),
                      _line(),
                      const SizedBox(height: 8),
                      _line(),
                      const SizedBox(height: 8),
                      _line(width: 200),
                      const SizedBox(height: 16),

                      // Mini galería esqueleto
                      Row(
                        children: [
                          _square(),
                          const SizedBox(width: 10),
                          _square(),
                          const SizedBox(width: 10),
                          _square(),
                          const SizedBox(width: 10),
                          _square(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Línea esqueleto
  Widget _line({double width = double.infinity}) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  // Cuadrado esqueleto
  Widget _square() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
