part of animated_segment;

/// [AnimatedContainerWidget] class is [StatelessWidget] class.
/// So, it create a animation when segment will change.
class AnimatedContainerWidget extends StatelessWidget {
  const AnimatedContainerWidget(
      {required this.width,
      required this.height,
      required this.leftMargin,
      required this.onEndComplete,
      required this.color,
      Key? key})
      : super(key: key);

  /// [width] is use to animate current selection with animation.
  final double width;

  /// [height] property will set the height of container.
  final double height;

  /// [leftMargin] property will set the left margin of container.
  final double leftMargin;

  /// [onEndComplete] property is callback when AnimatedContainer animation is end.
  final VoidCallback onEndComplete;

  /// [color] property will set the background color of container.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: onEndComplete,
      margin: EdgeInsets.only(left: leftMargin),
      duration: const Duration(milliseconds: Dimens.animationDurationNormal),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: (BorderRadius.circular(Dimens.radiusLarge)),
      ),
    );
  }
}
