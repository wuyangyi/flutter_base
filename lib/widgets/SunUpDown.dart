import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/utils/utils.dart';
import 'dart:ui' as ui;

//日出日落
class SunUpDown extends StatefulWidget {

  final String startTime;
  final String endTime;

  const SunUpDown({Key key, this.startTime, this.endTime}) : super(key: key);

  @override
  _SunUpDownState createState() => _SunUpDownState(startTime, endTime);
}

class _SunUpDownState extends State<SunUpDown> with SingleTickerProviderStateMixin {

  double value;
  final String startTime;
  final String endTime;

  double realValue;

  Animation<double> animation;
  AnimationController controller;

  _SunUpDownState(this.startTime, this.endTime);

  @override
  void initState() {
    super.initState();
    initTimeValue();
    controller = new AnimationController(
        duration: Duration(milliseconds: (3000 * realValue).toInt()), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          value = realValue * controller.value;
        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  void initTimeValue() {
    int startH = int.parse(startTime.substring(0, startTime.indexOf(":")));
    int startM = int.parse(startTime.substring(startTime.lastIndexOf(":")+1));
    int endH = int.parse(endTime.substring(0, endTime.indexOf(":")));
    int endM = int.parse(endTime.substring(endTime.lastIndexOf(":")+1));
    DateTime nowTime = DateTime.now();
    int maxM = (endH - startH) * 60 + (endM - startM);
    int nowM = (nowTime.hour - startH) * 60 + (nowTime.minute - startM);
    realValue = nowM / maxM;
    if (realValue > 1) {
      realValue = 1;
    }
    value = realValue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SunUpDownPainter(value, startTime, endTime),
      size: Size(MediaQuery.of(context).size.width - 60, (MediaQuery.of(context).size.width - 60 - SunUpDownPainter.LINE_MORE_CIRCLE * 2) / 2 + 40),
    );
  }
}


class SunUpDownPainter extends CustomPainter{
  static final double LINE_MORE_CIRCLE = 30.0; //圆弧外左右两边的距离

  final double value;
  final String startTime;
  final String endTime;

  SunUpDownPainter(this.value, this.startTime, this.endTime);

  var paintLine = Paint()
    ..strokeWidth = 1
    ..color = Colors.white
    ..isAntiAlias = true;

  var textStyle = TextStyle(
    color: Colors.white,
    fontSize: 10.0,
  );

  @override
  void paint(Canvas canvas, Size size) {
    drawText(canvas, 0.0, startTime, size.height - 20);
    drawText(canvas, size.width - LINE_MORE_CIRCLE * 2, endTime, size.height - 20);
    canvas.drawLine(Offset(0, size.height - 25), Offset(size.width, size.height - 25), paintLine);

    paintLine.color = Colors.white60;
    paintLine.strokeWidth = 0.5;
    paintLine.style = PaintingStyle.stroke;
    double r = (size.width - LINE_MORE_CIRCLE * 2) / 2; //绘制轨迹的半径
    Offset offsetBigCenter = Offset(size.width / 2, size.height - 25); //绘制轨迹的圆心
    canvas.drawArc(Rect.fromCircle(center: offsetBigCenter, radius: r), pi, pi, false, paintLine);

    paintLine.color = Colors.orangeAccent;
    canvas.drawArc(Rect.fromCircle(center: offsetBigCenter, radius: r), pi, pi * value, false, paintLine);

    if (value == 1) { //为1时表示已经下山
      return;
    }
    //绘制太阳
    paintLine.style = PaintingStyle.fill;
    Offset offsetCircle = Offset(getSunX(offsetBigCenter, r), getSunY(offsetBigCenter, r)); //太阳在轨迹上的圆心点
    canvas.drawCircle(offsetCircle, 10.0, paintLine);
    //绘制太阳的光线
    paintLine.strokeWidth = 1.0;
    drawSunLine(canvas, size, r, 10.0, offsetCircle);
  }

  void drawSunLine(Canvas canvas, Size size, double r, double mR, Offset offset) {
    double lineLong = 4.0; //光线的长度
    double distance = 2.0; //距离
    double minR = mR + distance;
    double maxR = mR + distance + lineLong;
    // 正下上
    canvas.drawLine(Offset(offset.dx + minR * cos(value * pi), offset.dy + minR * sin(value * pi)), Offset(offset.dx + maxR * cos(value * pi), offset.dy + maxR * sin(value * pi)), paintLine);
    canvas.drawLine(Offset(offset.dx - minR * cos(value * pi), offset.dy - minR * sin(value * pi)), Offset(offset.dx - maxR * cos(value * pi), offset.dy - maxR * sin(value * pi)), paintLine);
    //正左右
    canvas.drawLine(Offset(offset.dx - minR * sin(value * pi), offset.dy + minR * cos(value * pi)), Offset(offset.dx - maxR * sin(value * pi), offset.dy + maxR * cos(value * pi)), paintLine);
    canvas.drawLine(Offset(offset.dx + minR * sin(value * pi), offset.dy - minR * cos(value * pi)), Offset(offset.dx + maxR * sin(value * pi), offset.dy - maxR * cos(value * pi)), paintLine);
    //斜左 上下
    canvas.drawLine(Offset(offset.dx - minR * cos((value - 0.25) * pi), offset.dy - minR * sin((value - 0.25) * pi)), Offset(offset.dx - maxR * cos((value - 0.25) * pi), offset.dy - maxR * sin((value - 0.25) * pi)), paintLine);
    canvas.drawLine(Offset(offset.dx + minR * cos((value - 0.25) * pi), offset.dy + minR * sin((value - 0.25) * pi)), Offset(offset.dx + maxR * cos((value - 0.25) * pi), offset.dy + maxR * sin((value - 0.25) * pi)), paintLine);
    //斜右 上下
    canvas.drawLine(Offset(offset.dx - minR * cos((value + 0.25) * pi), offset.dy - minR * sin((value + 0.25) * pi)), Offset(offset.dx - maxR * cos((value + 0.25) * pi), offset.dy - maxR * sin((value + 0.25) * pi)), paintLine);
    canvas.drawLine(Offset(offset.dx + minR * cos((value + 0.25) * pi), offset.dy + minR * sin((value + 0.25) * pi)), Offset(offset.dx + maxR * cos((value + 0.25) * pi), offset.dy + maxR * sin((value + 0.25) * pi)), paintLine);
  }

  double getSunX(Offset center, double r) {
    double x = LINE_MORE_CIRCLE;
    x = center.dx - cos(value * pi) * r;
    print("坐标x:$x");
    return x;
  }

  double getSunY(Offset center, double r) {
    double y;
    y = center.dy - r * sin(value * pi);
    print("坐标y:$y");
    return y;
  }

  //绘制文字
  drawText(Canvas canvas, double x, String text, double height) {
    var pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,//居中
      fontSize: 10,//大小
    ));
    //添加文字
    pb.addText(text);
    //文字颜色//文字颜色
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    //文本宽度
    var paragraph = pb.build()..layout(ui.ParagraphConstraints(width: LINE_MORE_CIRCLE * 2));
    //绘制文字
    canvas.drawParagraph(paragraph, Offset(x, height));
  }

  @override
  bool shouldRepaint(SunUpDownPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.startTime != startTime || oldDelegate.endTime != endTime;
  }

}