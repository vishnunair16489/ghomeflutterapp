

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AnimatedCardWidget extends StatefulWidget {


  @override
  _AnimatedCardWidgetState createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with TickerProviderStateMixin {
  AnimationController? controller;
  SequenceAnimation? sequenceAnimation;

  @override
  void initState() {
    super.initState();
    const multiplier = 3;
    WidgetsBinding.instance?.addPostFrameCallback((_) => {
      controller?.repeat(reverse: true),
        });
    controller = AnimationController(
      duration: const Duration(milliseconds: 10 * multiplier),
      vsync: this,
    );

    sequenceAnimation = SequenceAnimationBuilder()

        .addAnimatable(
      animatable: Tween<double>(begin: 1.0, end: 0.75),
      from: const Duration(milliseconds: 100 * multiplier),
      to: const Duration(milliseconds: 300 * multiplier),
      curve: Curves.fastOutSlowIn,
      tag: 'bouncing',
    )
        .animate(controller!);
  }
  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(

    child: ScaleTransition(
      scale: sequenceAnimation!['bouncing'] as Animation<double>,
      child: buildCard(onClicked: handleAnimation),


    ),
  );

  void handleAnimation() {

    controller?.repeat(reverse: true);

  }

  Widget buildCard({required VoidCallback onClicked}) => GestureDetector(
    child: Transform(
      transform: Matrix4.identity()..rotateZ(0 / 2),
      alignment: Alignment.center,
      child: Image.asset('assets/images/switchfront.jpg', fit: BoxFit.fill),
    ),
    onTap: onClicked,
  );
}
