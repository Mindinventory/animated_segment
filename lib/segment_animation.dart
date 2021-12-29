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
  const AnimatedSegment({required this.list, this.backgroundColor = AppColors.bgColor, this.textColor = AppColors.primary, this.selectedColor = AppColors.white, this.rippleEffectColor = AppColors.white, Key? key}) : super(key: key);
  final List<String> list;
  final Color backgroundColor;
  final Color textColor;
  final Color rippleEffectColor;
  final Color selectedColor;

  @override
  _AnimatedSegmentState createState() => _AnimatedSegmentState();
}

class _AnimatedSegmentState extends State<AnimatedSegment> {
  late Size _deviceSize;
  final ValueNotifier<bool> _refreshAnimatedContainer = ValueNotifier(false);
  final ValueNotifier<bool> _showRippleEffect = ValueNotifier(false);
  double _animatedContainerWidth = 0;
  double _animatedContainerLeftMargin = 0;
  late EventBus _eventBus;
  bool _updateOnEndComplete = false;
  int _lasIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    _initializeEventBus();
    super.initState();
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
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingNormal, horizontal: Dimens.paddingNormal),
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
                      color: widget.selectedColor,
                      onEndComplete: _onEndCallback,
                    );
                  },
                ),
              ),
              SegmentItems(
                widgets: widget.list,
                width: _deviceSize.width - Dimens.paddingLarge,
                height: Dimens.heightNormal,
                textColor: widget.textColor,
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
  /// 1st Usecase: This is needed because first we are adding the width by multiply 2 so after animation completes whenever animation is in forward direction, this will execute and removes the width.
  /// Forward direction: 0 tab to 1 tab.
  /// 2nd Usecase: 1st usecase but we are doing this before adding the width by multiply by 2.
  void _updateContainerMargin() {
    _animatedContainerLeftMargin = _getContainerMargin();
  }

  double _getContainerWidth() {
    if (_currentIndex < _lasIndex) {
      return _widgetSize * ((_currentIndex - (_lasIndex + 1)).abs());
    }
    return _widgetSize * (((_currentIndex + 1) - _lasIndex).abs());
  }

  double _getContainerMargin() {
    return (_widgetSize * (_currentIndex + 1)) - _widgetSize;
  }
}
