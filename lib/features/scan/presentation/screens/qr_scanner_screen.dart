import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  // helper para saber si el texto es solo números (id de pieza)
  bool _esSoloNumeros(String valor) {
    return RegExp(r'^\d+$').hasMatch(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR")),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
        ),
        onDetect: (BarcodeCapture capture) async {
          if (capture.barcodes.isEmpty) return;

          final barcode = capture.barcodes.first;
          final String? rawOriginal = barcode.rawValue;
          if (rawOriginal == null) return;

          // limpiamos espacios basura
          final raw = rawOriginal.trim();

          debugPrint("QR detectado (raw): $raw");

          // 1) Si es numérico -> ir directo a la pieza en la app
          if (_esSoloNumeros(raw)) {
            context.push('/place/$raw');
            return;
          }

          // 2) Buscar una URL http/https dentro del texto
          final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
          final match = urlRegExp.firstMatch(raw);

          if (match != null) {
            final String urlStr = match.group(0)!;
            debugPrint('URL detectada en QR: $urlStr');

            final uri = Uri.parse(urlStr);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              debugPrint('No se pudo abrir la URL: $uri');
            }
          } else {
            debugPrint('Contenido de QR no soportado (sin http/https): $raw');
          }
        },
      ),
    );
  }
}
