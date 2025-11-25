import 'package:flutter/material.dart';

class WavesBackground extends StatelessWidget {
  const WavesBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_portada.png'),
          fit: BoxFit.cover, // Se adapta a toda la pantalla
        ),
      ),
    );
  }
}
