import 'package:flutter/material.dart';

class BorderedRadiusBoxPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Color backgroundColor;

  BorderedRadiusBoxPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Define the rounded rectangle using the passed BorderRadius
    final RRect rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    // First, fill the box with the background color
    canvas.drawRRect(rect, fillPaint);

    // Then, draw the border around the box
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Update based on your requirements
  }
}
