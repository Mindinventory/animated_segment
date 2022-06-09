library animated_segment;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'util/event_bus.dart';

part 'common/globals.dart';

part 'constants/colors.dart';

part 'constants/dimens.dart';

part 'constants/font_styles.dart';

part 'painter/ripple_effect_painter.dart';

part 'widgets/animated_container.dart';

part 'widgets/background.dart';

part 'widgets/item_ripple.dart';

part 'widgets/segment_items.dart';

class AnimatedSegment extends StatefulWidget {
  const AnimatedSegment(
      {required this.segmentNames,
      required this.onSegmentChanged,
      this.backgroundColor = AppColors.bgColor,
      this.segmentTextColor = AppColors.primary,
      this.selectedSegmentColor = AppColors.white,
      this.rippleEffectColor = AppColors.white,
      this.currentIndex = 0,
      Key? key})
      : super(key: key);

  /// [segmentNames] property takes List<String> as a parameter and segmentNames is useful to display items in segment.
  final List<String> segmentNames;

  /// [onSegmentChanged] Call back called when the user select the new segment and return the selected segment index.
  /// Index for the initial selected segment is [0].
  final ValueChanged<int> onSegmentChanged;

  /// [backgroundColor] property takes Color value as a parameter. You can change the background color of animated segment. default value is `Color(0xff8AADFB)`
  final Color backgroundColor;

  /// [segmentTextColor] property takes Color value as a parameter. You can change the text color of segmented text color. default value is `Color(0xff0217FD)`
  final Color segmentTextColor;

  /// [rippleEffectColor] property takes Color value as a parameter. You can change the ripple color of segment. default value is `Colors.white`
  final Color rippleEffectColor;

  /// [selectedSegmentColor] property takes Color value as a parameter. You can change the selected segment color of animated segment. default value is `Colors.white`
  final Color selectedSegmentColor;

  /// [currentIndex] property is use to set initial index of animated segment.
  final int? currentIndex;

  @override
  _AnimatedSegmentState createState() => _AnimatedSegmentState();
}

class _AnimatedSegmentState extends State<AnimatedSegment> {
  /// [_deviceSize] is use to get device width and height.
  late Size _deviceSize;

  /// [_refreshAnimatedContainer] property will update the animation when value notifier will updates.
  final ValueNotifier<bool> _refreshAnimatedContainer = ValueNotifier(false);

  /// [_showRippleEffect] property shows a ripple effect when on tap performs on segments.
  final ValueNotifier<bool> _showRippleEffect = ValueNotifier(false);

  /// [_animatedContainerWidth] property calculates the width of animation.
  double _animatedContainerWidth = 0;

  /// [_animatedContainerLeftMargin] property calculates the left margin after animation.
  double _animatedContainerLeftMargin = 0;

  /// [_eventBus] property is use to send or listen the events.
  late EventBus _eventBus;

  /// [_updateOnEndComplete] property will check is any update to perform once animation is end.
  bool _updateOnEndComplete = false;

  /// [_lasIndex] property stores last animated segment position.
  int _lasIndex = 0;

  /// [_currentIndex] property stores current animated segment position.
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeEventBus();
    _setInitialSelection();
  }

  /// [_deviceSize] Here we are calculating the device size.
  @override
  void didChangeDependencies() {
    _deviceSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimens.paddingNormal, horizontal: Dimens.paddingNormal),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Stack(
            children: [
              Background(
                width: _deviceSize.width,
                height: Dimens.heightNormal,
                bgColor: widget.backgroundColor,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showRippleEffect,
                builder: (BuildContext context, bool value, Widget? child) {
                  return (value)
                      ? ItemRipple(
                          width: _widgetSize,
                          height: Dimens.heightNormal,
                          rippleEffectColor: widget.rippleEffectColor,
                          leftMargin: _getContainerMargin(),
                          onRippleComplete: () {
                            _showRippleEffect.value = false;
                          },
                        )
                      : SizedBox(
                          width: _widgetSize,
                          height: Dimens.heightNormal,
                        );
                },
              ),
              Positioned(
                top: (Dimens.heightNormal - Dimens.heightSmall) / 2,
                child: ValueListenableBuilder(
                  valueListenable: _refreshAnimatedContainer,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return AnimatedContainerWidget(
                      width: _animatedContainerWidth,
                      height: Dimens.heightSmall,
                      leftMargin: _animatedContainerLeftMargin,
                      color: widget.selectedSegmentColor,
                      onEndComplete: _onEndCallback,
                    );
                  },
                ),
              ),
              SegmentItems(
                widgets: widget.segmentNames,
                width: _deviceSize.width - Dimens.paddingLarge,
                height: Dimens.heightNormal,
                segmentTextColor: widget.segmentTextColor,
                eventBus: _eventBus,
                onEndRenderItems: _animateInitial,
              ),
            ],
          );
        },
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// [_onEndCallback] we get the callback when animated container animation is done.
  /// [_updateOnEndComplete] this member is true then this method will executes.
  /// We are adding the left margin to the animated container.
  /// Then, refresh the screen
  void _onEndCallback() {
    if (_updateOnEndComplete) {
      _updateOnEndComplete = false;
      if (_currentIndex > _lasIndex) {
        _updateContainerMargin();
      }
      _animatedContainerWidth = _widgetSize;
      _updateScreen();
      _lasIndex = _currentIndex;
      widget.onSegmentChanged(_lasIndex);
    }
  }

  /// [_animateInitial] when build is complete then this will calls.
  /// We are setting up the 1st item animation.
  void _animateInitial() {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _animatedContainerWidth = _widgetSize;
      _refreshAnimatedContainer.value = !_refreshAnimatedContainer.value;
    });
  }

  /// [_initializeEventBus] Here we initialize the event bus for the events.
  void _initializeEventBus() {
    _eventBus = EventBusImpl();
    _eventBus.stream.listen(_listenEvent);
  }

  /// [_setInitialSelection] Here we set initial selection of segment.
  void _setInitialSelection() {
    _currentIndex = ((widget.currentIndex != null) && ((widget.currentIndex ?? 0) >= 0)) ? (widget.currentIndex ?? 0) : 0;
    if (_currentIndex < widget.segmentNames.length) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _lasIndex = _currentIndex;
        _updateContainerMargin();
        _showRippleEffect.value = true;
      });
    }
  }

  /// [_listenEvent] On tap of item this method will be execute and performs the animation.
  void _listenEvent(dynamic event) {
    if (event is ItemClickBusEvent) {
      if (!_showRippleEffect.value) _showRippleEffect.value = true;
      _currentIndex = event.index;
      if (_currentIndex == _lasIndex) return;
      _updateOnEndComplete = true;
      _animatedContainerWidth = _getContainerWidth();
      if (_currentIndex < _lasIndex) {
        _updateContainerMargin();
      }
      _updateScreen();
    }
  }

  /// [_updateScreen] here we are refreshing the screen using [ValueNotifier].
  void _updateScreen() {
    _refreshAnimatedContainer.value = !_refreshAnimatedContainer.value;
  }

  /// [_updateContainerMargin] In this method we are changing the margin of AnimatedContainer.
  /// 1st Use Case: This is needed because first we are adding the width by multiply 2 so after animation completes whenever animation is in forward direction, this will execute and removes the width.
  /// Forward direction: 0 tab to 1 tab.
  /// 2nd Use Case: 1st use case but we are doing this before adding the width by multiply by 2.
  void _updateContainerMargin() {
    _animatedContainerLeftMargin = _getContainerMargin();
  }

  /// [_getContainerWidth] we are calculating the container width.
  /// Calculation is based on forward or backward animation
  double _getContainerWidth() {
    if (_currentIndex < _lasIndex) {
      return _widgetSize * ((_currentIndex - (_lasIndex + 1)).abs());
    }
    return _widgetSize * (((_currentIndex + 1) - _lasIndex).abs());
  }

  /// [_getContainerMargin] we are calculating the margin from left side.
  double _getContainerMargin() {
    return (_widgetSize * (_currentIndex + 1)) - _widgetSize;
  }
}
