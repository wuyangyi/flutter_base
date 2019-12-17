import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/config/data_config.dart';

import 'RainFlake.dart';

class RainView extends StatefulWidget {
  final int type; //雨的类别（0-小雨  1-中雨 2-大雨）

  const RainView({Key key, this.type = 0}) : super(key: key);
  @override
  _RainViewState createState() => _RainViewState(type);
}

class _RainViewState extends State<RainView> with SingleTickerProviderStateMixin  {

  static int NUM_RAINFLAKES = 200; // 雨滴数量
  List<RainFlake> mRainFlakes; // 雨滴
  Animation<double> animation;
  AnimationController controller;
//  TimerUtil timerUtil;

  final int type;

  _RainViewState(this.type);


  void initRain(double width, double height) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill// 填充;
      ..isAntiAlias = true// 抗锯齿
      ..color = Colors.white70; // 白色雨滴
    mRainFlakes = [];
    for (int i = 0; i < NUM_RAINFLAKES; ++i) {
      mRainFlakes.add(RainFlake.create(width, height, paint));
    }
  }

  @override
  void initState() {
    super.initState();
    if (type == 0) {
      NUM_RAINFLAKES = 200;
      RainFlake.FLAKE_SIZE_UPPER = 1;
      RainFlake.FLAKE_SIZE_LOWER = 0.5;
      RainFlake.INCREMENT_UPPER = 5;
      RainFlake.INCREMENT_LOWER = 3;
    } else if (type == 1) {
      NUM_RAINFLAKES = 250;
      RainFlake.FLAKE_SIZE_UPPER = 2;
      RainFlake.FLAKE_SIZE_LOWER = 1.5;
      RainFlake.INCREMENT_UPPER = 6;
      RainFlake.INCREMENT_LOWER = 4;
    } else if (type == 2) {
      NUM_RAINFLAKES = 300;
      RainFlake.FLAKE_SIZE_UPPER = 3;
      RainFlake.FLAKE_SIZE_LOWER = 2.5;
      RainFlake.INCREMENT_UPPER = 7;
      RainFlake.INCREMENT_LOWER = 5;
    }
    initRain(DataConfig.appSize.width, DataConfig.appSize.height);
    controller = new AnimationController(
        duration: const Duration(seconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
        });
      });
    controller.repeat();
//    _startTimer();
  }

//  void _startTimer() {
//    if (timerUtil == null) {
//      timerUtil = TimerUtil();
//      timerUtil.setInterval(1); //设置时间间隔
//      timerUtil.setOnTimerTickCallback((time){ //回调
//        setState(() {
//        });
//      });
//    }
//    timerUtil.startTimer();
//  }
//
//  void _cancelTimer() {
//    if (timerUtil != null && timerUtil.isActive()) { //timerUtil不为空且timerUtil是启动状态
//      timerUtil.cancel();
//    }
//
//  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
//    _cancelTimer();
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
        painter: RainViewPainter(mRainFlakes),
      ),
    );
  }
}



class RainViewPainter extends CustomPainter {

  List<RainFlake> mSnowFlakes; // 雨滴

  RainViewPainter(this.mSnowFlakes);

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
