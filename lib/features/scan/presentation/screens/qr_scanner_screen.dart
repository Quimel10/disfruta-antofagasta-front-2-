import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isProcessing = false;

  bool _esSoloNumeros(String valor) => RegExp(r'^\d+$').hasMatch(valor);

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing) return;

      final rawOriginal = scanData.code;
      if (rawOriginal == null) return;

      final raw = rawOriginal.trim();
      _isProcessing = true;

      await _controller?.pauseCamera();

      if (_esSoloNumeros(raw)) {
        if (!mounted) return;

        await context.push('/place/$raw');

        if (!mounted) return;
        _isProcessing = false;
        await _controller?.resumeCamera();
        return;
      }

      final urlMatch = RegExp(r'(https?:\/\/[^\s]+)').firstMatch(raw);

      if (urlMatch != null) {
        final uri = Uri.parse(urlMatch.group(0)!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _isProcessing = false;
          await _controller?.resumeCamera();
        }
      } else {
        _isProcessing = false;
        await _controller?.resumeCamera();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 Fondo igual al Home
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_portada.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 45),

            // 🔥 Título
            const Text(
              "Escanear QR",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 QR VIEW dentro de un cuadro
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange, width: 4),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 Texto corto
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Escanea el código QR",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
