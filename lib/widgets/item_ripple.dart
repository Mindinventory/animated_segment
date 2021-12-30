part of animated_segment;

/// [ItemRipple] class is [StatefulWidget] class.
/// Because we are using ticker provider.
/// We are showing ripple effect with animation.
class ItemRipple extends StatefulWidget {
  const ItemRipple({
    required this.width,
    required this.height,
    required this.rippleEffectColor,
    required this.leftMargin,
    required this.onRippleComplete,
    Key? key,
  }) : super(key: key);

  /// [width] property set the width of segment ripple effect.
  final double width;

  /// [height] property set the height of segment ripple effect.
  final double height;

  /// [rippleEffectColor] property set the ripple effect color.
  final Color rippleEffectColor;

  /// [leftMargin] property set the margin from left side.
  final double leftMargin;

  /// [onRippleComplete] property is callback of ripple completion.
  final VoidCallback onRippleComplete;

  @override
  State<ItemRipple> createState() => _ItemRippleState();
}

class _ItemRippleState extends State<ItemRipple> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Dimens.animationDurationSmall),
    );
    _animationController.forward();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        widget.onRippleComplete();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.leftMargin),
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: RippleEffectPainter(
          animation: _animationController,
          color: widget.rippleEffectColor,
        ),
      ),
    );
  }
}
