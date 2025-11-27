// SplashGate.dart
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:disfruta_antofagasta/features/auth/presentation/state/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashGate extends ConsumerWidget {
  const SplashGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Forzamos a evaluar authProvider (checkAuthStatus)
    ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.sandLight, // 👈 MISMO fondo del Home
      body: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.black, // 👈 Loader visible sobre fondo claro
        ),
      ),
    );
  }
}
