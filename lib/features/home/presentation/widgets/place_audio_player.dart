import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlaceAudioPlayer extends StatefulWidget {
  final String url;

  const PlaceAudioPlayer({super.key, required this.url});

  @override
  State<PlaceAudioPlayer> createState() => _PlaceAudioPlayerState();
}

class _PlaceAudioPlayerState extends State<PlaceAudioPlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    // Empezar a reproducir
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Carga la URL del MP3
      await _player.setUrl(widget.url);
      await _player.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo reproducir el audio';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: _isLoading ? null : _togglePlay,
              iconSize: 32,
              icon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Audio descriptivo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    )
                  else
                    const Text(
                      'Toca el botón para reproducir o pausar.',
                      style: TextStyle(fontSize: 12),
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
