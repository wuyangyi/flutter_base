import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/utils/utils.dart';

class FlWidget extends StatefulWidget {
  @override
  _FlWidgetState createState() => _FlWidgetState();
}

class _FlWidgetState extends State<FlWidget> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  double angle = 0;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(seconds: 3), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          angle = pi * 2 * controller.value;
//          print("旋转值：$angle");
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width / 5,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomLeft,
        children: <Widget>[

          Positioned(
            left: -29.5,
            bottom: 14,
            child: Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: angle,
                child: Image.asset(
                  Util.getImgPath("ico_windmill_blade"),
                  width: 80.0,
                  gaplessPlayback: true, //避免图片闪烁
                ),
              ),
            ),
          ),

          Positioned(
            left: 10.0,
            child: Container(
              height: 70.0,
              alignment: Alignment.topCenter,
              child: Image.asset(Util.getImgPath("ico_windmill"), height: 70.0,),
            ),
          ),


          Positioned(
            left: 14.5,
            bottom: -2.0,
            child: Container(
              height: 60,
              width: 60.0,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: angle,
                child: Image.asset(
                  Util.getImgPath("ico_windmill_blade"),
                  width: 40.0,
                  gaplessPlayback: true, //避免图片闪烁
                ),
              ),
            ),
          ),

          Positioned(
            left: 40.0,
            child: Container(
              height: 30.0,
              alignment: Alignment.topCenter,
              child: Image.asset(Util.getImgPath("ico_windmill"), height: 30.0,),
            ),
          ),
        ],
      ),
    );
  }
}
