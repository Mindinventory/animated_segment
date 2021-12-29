import 'package:animated_segment/segment_animation.dart';
import 'package:example/constants/strings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppColors.white,
        child: const AnimatedSegment(
          list: [Strings.tab_1, Strings.tab_2, Strings.tab_3],
          backgroundColor: AppColors.bgColor,
          textColor: AppColors.white,
          rippleEffectColor: AppColors.primary,
          selectedColor: AppColors.primary,
        ),
      ),
    );
  }
}