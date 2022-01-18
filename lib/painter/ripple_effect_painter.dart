part of animated_segment;

/// [RippleEffectPainter] class create a ripple effect on tap of segment.
/// This class uses a [CustomPainter] to draw a ripple effect.
class RippleEffectPainter extends CustomPainter {
  RippleEffectPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  final Color color;
  final Animation<double> animation;

  /// [circle] drawing circle for the ripple effect.
  void circle(Canvas canvas, Rect rect, double value) {
    final Color _color = color.withOpacity(_calculateOpacity(value));
    // Here, we are calculating size by dividing width/2.
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave > 2; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// [_calculateOpacity] method calculates a opacity of ripple effect.
  double _calculateOpacity(double value) =>
      (1.0 - (value / 4.0)).clamp(0.0, 1.0);
}
