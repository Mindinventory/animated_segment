part of animated_segment;

class Background extends StatelessWidget {
  const Background({required this.width, required this.height, required this.bgColor, Key? key}) : super(key: key);
  final double width;
  final double height;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusLarge),
        ),
        color: bgColor,
      ),
    );
  }
}
