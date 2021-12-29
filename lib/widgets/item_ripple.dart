part of animated_segment;

class ItemRipple extends StatefulWidget {
  const ItemRipple({
    required this.width,
    required this.height,
    required this.rippleEffectColor,
    required this.leftMargin,
    required this.onRippleComplete,
    Key? key,
  }) : super(key: key);
  final double width;
  final double height;
  final Color rippleEffectColor;
  final double leftMargin;
  final VoidCallback onRippleComplete;

  @override
  State<ItemRipple> createState() => _ItemRippleState();
}

class _ItemRippleState extends State<ItemRipple>
    with TickerProviderStateMixin {
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
