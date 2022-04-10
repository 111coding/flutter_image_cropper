import 'package:flutter/material.dart';

class EdgePainter extends CustomPainter {
  double strokeWidth = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double height = 9;
    final edge = Path()
      ..moveTo(0, 0)
      ..lineTo(height, 0)
      ..moveTo(0, 0)
      ..lineTo(0, height)
      ..moveTo(0, size.height)
      ..lineTo(height, size.height)
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - height)
      ..moveTo(size.width, 0)
      ..lineTo(size.width - height, 0)
      ..moveTo(size.width, 0)
      ..lineTo(size.width, height)
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height - height)
      ..moveTo(size.width, size.height)
      ..lineTo(size.width - height, size.height);

    double gap = strokeWidth / 2;

    edge
      ..moveTo(0, 0)
      ..lineTo(-gap, 0)
      ..moveTo(0, size.height)
      ..lineTo(0, size.height + gap)
      ..moveTo(size.width, 0)
      ..lineTo(size.width, -gap)
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height + gap);

    canvas.drawPath(edge, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
