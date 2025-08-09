import 'package:flutter/material.dart';

class SpectrumLoader extends StatefulWidget {
  const SpectrumLoader({super.key});

  @override
  State<SpectrumLoader> createState() => _SpectrumLoaderState();
}

class _SpectrumLoaderState extends State<SpectrumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Hue goes from 0 to 360 for a rainbow effect
        final color = HSVColor.fromAHSV(
          1.0,
          _controller.value * 360,
          1.0,
          1.0,
        ).toColor();

        return CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        );
      },
    );
  }
}
