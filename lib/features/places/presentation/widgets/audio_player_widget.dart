import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _player;
  bool _isLoading = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // Escuchamos cambios de estado para actualizar el icono
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      final processing = state.processingState;
      setState(() {
        _isPlaying = state.playing && processing == ProcessingState.ready;
        _isLoading =
            processing == ProcessingState.loading ||
            processing == ProcessingState.buffering;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.url.isEmpty) return;

    // Si ya está reproduciendo, pausamos
    if (_player.playing) {
      await _player.pause();
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await _player.setUrl(widget.url);
      await _player.play();
    } catch (e) {
      debugPrint('Error reproduciendo audio: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo reproducir el audio')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 32,
            onPressed: _isLoading ? null : _togglePlay,
            icon: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Reproducir audio',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
