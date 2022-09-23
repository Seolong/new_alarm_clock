
import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    this.color = Colors.white,
  });

  final IconData icon;
  final double size;
  final Gradient gradient;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}