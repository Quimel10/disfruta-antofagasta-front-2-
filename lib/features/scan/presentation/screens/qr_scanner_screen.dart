import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final MobileScannerController _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  bool _esSoloNumeros(String valor) => RegExp(r'^\d+$').hasMatch(valor);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleCapture(
    BuildContext context,
    BarcodeCapture capture,
  ) async {
    if (_isProcessing) return;
    if (capture.barcodes.isEmpty) return;

    final rawOriginal = capture.barcodes.first.rawValue;
    if (rawOriginal == null) return;

    final raw = rawOriginal.trim();
    _isProcessing = true;

    // Detenemos la cámara al primer scan
    await _controller.stop();

    // 1) Si es numérico -> navegar a la pieza
    if (_esSoloNumeros(raw)) {
      if (!mounted) return;

      await context.push('/place/$raw');

      // Al volver atrás, reactivamos cámara para nuevo scan
      if (!mounted) return;
      _isProcessing = false;
      await _controller.start();
      return;
    }

    // 2) Intentar abrir URL si hay una
    final urlMatch = RegExp(r'(https?:\/\/[^\s]+)').firstMatch(raw);

    if (urlMatch != null) {
      final uri = Uri.parse(urlMatch.group(0)!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Si se va al navegador, dejamos la cámara parada (es otro flujo)
      } else {
        // Si falla abrir, permitimos reintentar
        _isProcessing = false;
        await _controller.start();
      }
    } else {
      // Contenido no soportado, reactivamos para permitir otro scan
      _isProcessing = false;
      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Igual que HomeScreen
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Escanear QR",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, // flecha atrás negra
        ),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) => _handleCapture(context, capture),
      ),
    );
  }
}
