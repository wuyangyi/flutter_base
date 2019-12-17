import 'package:flutter/material.dart';
import 'package:flutter_base/config/data_config.dart';

import 'SnowFlake.dart';

class SnowView extends StatefulWidget {
  final int type;

  const SnowView({Key key, this.type = 0}) : super(key: key);
  @override
  _SnowViewState createState() => _SnowViewState(type);
}

class _SnowViewState extends State<SnowView> with SingleTickerProviderStateMixin {

  static int NUM_SNOWFLAKES = 120; // 雪花数量
  List<SnowFlake> mSnowFlakes; // 雪花
  Animation<double> animation;
  AnimationController controller;
  final int type;

  _SnowViewState(this.type);

  void initSnow(double width, double height) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill// 填充;
      ..isAntiAlias = true// 抗锯齿
      ..color = Colors.white70; // 白色雪花
    mSnowFlakes = [];
    for (int i = 0; i < NUM_SNOWFLAKES; ++i) {
      mSnowFlakes.add(SnowFlake.create(width, height, paint));
    }
  }

  @override
  void initState() {
    super.initState();
    if (type == 0) {
      NUM_SNOWFLAKES = 120;
      SnowFlake.INCREMENT_LOWER = 1;
      SnowFlake.INCREMENT_UPPER = 3;
      SnowFlake.FLAKE_SIZE_LOWER = 1;
      SnowFlake.FLAKE_SIZE_UPPER = 3;
    } else if (type == 1) {
      NUM_SNOWFLAKES = 150;
      SnowFlake.INCREMENT_LOWER = 1.5;
      SnowFlake.INCREMENT_UPPER = 3.5;
      SnowFlake.FLAKE_SIZE_LOWER = 2;
      SnowFlake.FLAKE_SIZE_UPPER = 4;
    } else if (type == 2) {
      NUM_SNOWFLAKES = 200;
      SnowFlake.INCREMENT_LOWER = 2.0;
      SnowFlake.INCREMENT_UPPER = 4;
      SnowFlake.FLAKE_SIZE_LOWER = 3;
      SnowFlake.FLAKE_SIZE_UPPER = 5;
    }
    initSnow(DataConfig.appSize.width, DataConfig.appSize.height);
    controller = new AnimationController(
        duration: const Duration(seconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
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
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF415A64), Color(0xCC415A64), Color(0x77C415A64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: SnowViewPainter(mSnowFlakes),
      ),
    );
  }
}



class SnowViewPainter extends CustomPainter {

  List<SnowFlake> mSnowFlakes; // 雪花

  SnowViewPainter(this.mSnowFlakes);

  @override
  void paint(Canvas canvas, Size size) {
    mSnowFlakes.forEach((item){
      item.draw(canvas, size);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
