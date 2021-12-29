part of animated_segment;

class AnimatedContainerWidget extends StatelessWidget {
  const AnimatedContainerWidget(
      {required this.width,
      required this.height,
      required this.leftMargin,
      required this.onEndComplete,
      required this.color,
      Key? key})
      : super(key: key);
  final double width;
  final double height;
  final double leftMargin;
  final VoidCallback onEndComplete;
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
