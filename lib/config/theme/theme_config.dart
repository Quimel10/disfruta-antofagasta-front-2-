import 'package:flutter/material.dart';

class AppColors {
  // === PALETA ORIGINAL ===
  // principales
  static const Color bluePrimaryDark = Color(0xFF21527D);
  static const Color bluePrimaryLight = Color(0xFF1C9FE2);
  static const Color orangePrimary = Color(0xFFF3771D);

  // degradados
  static const Color blue = Color(0xFF0E4E78);
  static const Color blueDeep = Color(0xFF0B3C5A);
  static const Color cream = Color(0xFFF7F3EA);
  static const Color coral = Color(0xFFFF6F59);

  // Extras para “agua”
  static const Color aqua = Color(0xFF0D7AA3);
  static const Color cyanSoft = Color(0xFF78C9E2);

  // Textos neutros
  static const Color neutral900 = Color(0xFF2A2A2A);
  static const Color neutral800 = Color(0xFF464646);
  static const Color neutral700 = Color(0xFF828582);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral50 = Color(0xFFFFFFFF);

  // Complementarios (accesorios / fondos)
  static const Color aquaLight = Color(0xFFC9ECF5);
  static const Color pink = Color(0xFFE7A7A0);
  static const Color pinkLight = Color(0xFFF8E1DE);
  static const Color sandLight = Color(0xFFF3EFE2);
  static const Color desertAmber = Color(0xFFCE9100);

  // Estados
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  // === PALETA MUSEO / NUEVOS ===

  /// Fondo tipo pergamino general
  static const Color parchment = Color(0xFFF4E4C4);

  /// Paneles / botones en naranja (por compatibilidad con código viejo)
  static const Color panel = orangePrimary;
  static const Color panelDark = Color(0xFFB15A12);

  /// Vinotinto para botones y tarjetas (color del logo) - **ACLARADO**
  static const Color panelWine = Color(0xFFB75B43); // vinotinto claro
  static const Color panelWineDark = Color(0xFF8C3A28); // borde / hover

  /// Texto genérico principal (fuera de paneles)
  static const Color textPrimary = Colors.black;

  /// Texto sobre botones/paneles oscuros
  static const Color textOnPanel = Colors.white;
}

class AppRadius {
  static const double xl = 16;
  static const double lg = 12;
  static const double md = 10;
  static const double sm = 8;
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}
