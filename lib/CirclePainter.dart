import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';
class CirclePainter extends CustomPainter {
  CirclePainter(this.sts, this._animation, {@required this.color,}) : super(repaint: _animation);

  final int sts;
  final Color color;
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (0.8 - (value / 5.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 1.0;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 0.5);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    final Rect rect1 = Rect.fromLTRB(0.0, 0.0, 250.0, 250.0);
    final Rect rect2 = Rect.fromLTRB(300.0, 0.0, 0.0, 0.0);
    if(sts==0)
      circle(canvas, rect1, 2.5);

    for (int wave = 0; wave < 4; wave++) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
