part of animated_segment;

class SegmentItems extends StatelessWidget {
  const SegmentItems({
    required this.widgets,
    required this.width,
    required this.height,
    required this.textColor,
    required this.eventBus,
    required this.onEndRenderItems,
    Key? key,
  }) : super(key: key);
  final double width;
  final double height;
  final Color textColor;
  final List<String> widgets;
  final EventBus eventBus;
  final VoidCallback onEndRenderItems;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: _generateWidgets(),
      ),
    );
  }

  List<Widget> _generateWidgets() {
    _widgetSize = (width / widgets.length);
    var list = <Widget>[];
    widgets.asMap().forEach((index, element) {
      list.add(
        InkWell(
          onTap: () => _onTapPressed(index),
          child: Container(
            alignment: Alignment.center,
            width: _widgetSize,
            height: height,
            child: Text(
              element,
              style: AppFontStyles.textNormal.copyWith(
                color: textColor,
              ),
            ),
          ),
        ),
      );
    });
    onEndRenderItems();
    return list;
  }

  void _onTapPressed(int index) {
    eventBus.sendEvent(ItemClickBusEvent(index: index));
  }
}
