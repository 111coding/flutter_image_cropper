import 'package:flutter/material.dart';

class CropPainter extends CustomPainter {
  CropPainter({
    required Color color,
    required this.radius,
    required this.center,
  }) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }

  late final Paint _paint;
  final double radius;
  Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    double halfRadius = radius / 2;

    final pathTop = Path()
      ..lineTo(0, center.dy)
      ..lineTo(center.dx - halfRadius, center.dy)
      ..arcToPoint(
        Offset(center.dx + halfRadius, center.dy),
        radius: Radius.circular(halfRadius), //가중치
        clockwise: true,
      )
      ..lineTo(size.width, center.dy)
      ..lineTo(size.width, 0);

    final pathBottom = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, center.dy)
      ..lineTo(center.dx - halfRadius, center.dy)
      ..arcToPoint(
        Offset(center.dx + halfRadius, center.dy),
        radius: Radius.circular(halfRadius), //가중치
        clockwise: false,
      )
      ..lineTo(size.width, center.dy)
      ..lineTo(size.width, size.height);

    canvas.drawPath(pathTop, _paint);
    canvas.drawPath(pathBottom, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
