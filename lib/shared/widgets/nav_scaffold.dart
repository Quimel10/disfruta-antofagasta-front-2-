import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:disfruta_antofagasta/shared/provider/language_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class NavScaffold extends ConsumerWidget {
  const NavScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    const double barHeight = 68;

    // 🎨 Nueva paleta vinotinto
    const Color bg = AppColors.sandLight;
    const Color unselected = AppColors.panelWine; // vinotinto claro
    const Color selected = AppColors.panelWineDark; // vinotinto oscuro

    return Stack(
      children: [
        // Fondo pergamino para TODA la app
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_portada.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Contenido principal de la app
        Scaffold(
          backgroundColor: Colors.transparent,
          body: navigationShell,
          extendBody: true,
          bottomNavigationBar: Container(
            color: bg.withOpacity(0.92),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                height: barHeight,
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,

                // 🔥 Colores de texto: vinotinto oscuro claro y oscuro
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(WidgetState.selected);
                  return TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? selected : unselected,
                  );
                }),

                // 🔥 Íconos vinotinto
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(WidgetState.selected);
                  return IconThemeData(
                    color: isSelected ? selected : unselected,
                    size: isSelected ? 25 : 23,
                  );
                }),
              ),

              child: NavigationBar(
                key: ValueKey('nav-$lang'),
                elevation: 0,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onTap,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: tr('tabs.home'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.qr_code_scanner_outlined),
                    selectedIcon: const Icon(Icons.qr_code_scanner),
                    label: tr('tabs.scan'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.museum_outlined),
                    selectedIcon: const Icon(Icons.museum),
                    label: tr('tabs.pieces'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
