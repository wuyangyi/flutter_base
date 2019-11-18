import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_base/res/index.dart';

class PieProgressIndicator extends StatelessWidget {

  PieProgressIndicator({
    this.strokeWidth = 3.0,
    this.radius = 20.0,
    this.strokeCapRound = false,
    this.backgroundColor = Colors.transparent,
    this.totalAngle = 2 * pi,
    @required this.pieItemBeans,
    this.needHintLabel = false,
    this.isProgress = false,
    this.centerText = "",
  });

  //粗细
  final double strokeWidth;

  //圆的半径
  final double radius;

//  //两端是否为圆角
  final bool strokeCapRound;


  //进度条背景色
  final Color backgroundColor;

  //进度条的总弧度， 2*PI为整圆
  final double totalAngle;

  //颜色组及占比
  final List<PieItemBean> pieItemBeans;

  //是否需要标签
  final bool needHintLabel;

  //是否是进度条 ---进度条的话会进行旋转，让起始点在正上方
  final bool isProgress;

  //中间显示的文字，默认为""
  final String centerText;


  @override
  Widget build(BuildContext context) {
    double _offset = 0.0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound) {
      _offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }
    var _pieItemBeans = pieItemBeans;
    if (_pieItemBeans == null) {
      PieItemBean pieItemBean = PieItemBean(MyColors.main_color, 1.0);
      _pieItemBeans.add(pieItemBean);
    }
    return Transform.rotate(
      angle: isProgress ? -pi / 2.0 - _offset : 0.0,
      child: CustomPaint(
        size: Size.fromRadius(radius),
        painter: PieProgressIndicatorPainter(
          strokeWidth: strokeWidth,
          strokeCapRound: strokeCapRound,
          backgroundColor: backgroundColor,
          totalAngle: totalAngle,
          radius: radius,
          pieItemBeans: _pieItemBeans,
          needHintLabel: needHintLabel,
          isProgress: isProgress,
          centerText: centerText
        ),
      ),
    );
  }
}

//实现画笔
class PieProgressIndicatorPainter extends CustomPainter {
  PieProgressIndicatorPainter({
    this.strokeWidth = 3.0,
    this.radius = 10.0,
    this.strokeCapRound = false,
    this.backgroundColor = Colors.transparent,
    this.totalAngle = 2 * pi,
    @required this.pieItemBeans,
    this.needHintLabel = false,
    this.isProgress = false,
    this.centerText = "",
  });
  //粗细
  final double strokeWidth;

  //圆的半径
  final double radius;

  //两端是否为圆角
  final bool strokeCapRound;

  //进度条背景色
  final Color backgroundColor;

  //进度条的总弧度， 2*PI为整圆
  final double totalAngle;

  //颜色组及占比
  final List<PieItemBean> pieItemBeans;

  //是否需要标签
  final bool needHintLabel;

  //是否是进度条 ---进度条的话会进行旋转，让起始点在正上方
  final bool isProgress;

  //中间显示的文字
  final String centerText;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }
    double _offset = strokeWidth / 2.0;

    double _value = totalAngle;

    double _start = 0.0;

    if (strokeCapRound) {
      _start = asin(strokeWidth / (size.width - strokeWidth));
    }

    Rect rect = Offset(_offset, _offset) & Size(
        size.width - strokeWidth,
        size.height - strokeWidth
    );

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    var paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 0.5;

    //先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, _start, totalAngle, false, paint);
    }
    //再画前景
    if (_value > 0) {
      if (pieItemBeans != null) {
        double _startAngle = _start;
        double _endAngle = 0.0;
        double angle = 0.0; //当前弧度
        double oldAngle = 0.0; //当前弧度
        pieItemBeans.forEach((item){
          _endAngle = _value * item.value;
          print("_startAngle:$_startAngle    _endAngle:$_endAngle");
//          paint.shader = SweepGradient(
//              startAngle: _startAngle,
//              endAngle: _endAngle,
//              colors: item.colors,
//          ).createShader(rect);
          paint.color = item.color;
          canvas.drawArc(rect, _startAngle, _endAngle, false, paint);

          if (needHintLabel) {
            angle = oldAngle + (_value * item.value / 2);
            oldAngle = oldAngle + (_value * item.value);
            print("angle:$angle   oldAngle: $oldAngle");
            paintLine.color = item.color;
            Offset startOffset = getPoint(angle);
            Offset centerOffset = getInflectionPoint(startOffset);
            Offset endOffset = getEndLinePoint(centerOffset);
            canvas.drawLine(startOffset, centerOffset, paintLine);
            canvas.drawLine(centerOffset, endOffset, paintLine);
            String showText = "${item.title} ${(item.value * 100).toStringAsFixed(1)}%";
            TextStyle textStyle = TextStyle(
              color: MyColors.text_normal,
              fontSize: 12.0,
            );
            Offset textOffset = endOffset; 
            //文字是否显示在左边
            bool textAtLeft = (isProgress && angle > pi) || (!isProgress && angle > pi / 2 && angle < pi / 2 * 3);
            if (textAtLeft) {
              textOffset = Offset(endOffset.dx - findAllWidth(showText, textStyle), endOffset.dy);
            }
            TextPainter(
              text: TextSpan(
                text: showText,
                style: textStyle,
              ),
              textDirection: textAtLeft ? TextDirection.rtl : TextDirection.ltr,
            )
            ..layout(minWidth: 20, maxWidth: 100)
            ..paint(canvas, textOffset);
          }
          _startAngle = _startAngle + _value * item.value;
        });
        TextStyle centerTextStyle = TextStyle(
          color: MyColors.title_color,
          fontSize: 15.0,
        );
        TextPainter(
          text: TextSpan(
            text: centerText,
            style: centerTextStyle,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: radius, maxWidth: radius)
          ..paint(canvas, Offset(radius - findAllWidth(centerText, centerTextStyle) / 2 - 10, radius - findHeight(centerText, centerTextStyle) / 2));
      }
    }
  }

  /*
   * 获得切点坐标
   * angle中点的弧度
   */
  Offset getPoint(double angle) {
    double allAngle = 2 * pi;
    if (angle >= allAngle) {
      angle = angle % allAngle;
    }
    double x = 0.0;
    double y = 0.0;
    if (angle <= allAngle / 4) {
      x = radius + radius * sin(angle);
      y = radius + radius * cos(angle);
    } else if (angle <= allAngle / 2) {
      double _a = allAngle / 2 - angle;
      x = radius + radius * sin(_a);
      y = radius - radius * cos(_a);
    } else if (angle <= allAngle / 4 * 3) {
      double _a = allAngle / 4 * 3 - angle;
      x = radius - radius * cos(_a);
      y = radius - radius * sin(_a);
    } else {
      double _a = allAngle - angle;
      x = radius - radius * sin(_a);
      y = radius + radius * cos(_a);
    }
    print("x: $x      y: $y");
    return Offset(y, x);
  }

  /*
   * 获得拐点坐标
   * size 切点坐标
   */
  Offset getInflectionPoint(Offset size) {
    double _lineLenght = 10.0; //拐线的长度
    double a = size.dx * _lineLenght / radius - _lineLenght + size.dx;
    double b = size.dy * _lineLenght / radius - _lineLenght + size.dy;
    return Offset(a, b);
  }

  /*
   * 获得横线的终点坐标
   */
  Offset getEndLinePoint(Offset offset) {
    double _lineLenght = 20.0; //横线线的长度
    Offset offsetNew;
    if (isProgress) {
      offsetNew = Offset(offset.dx, offset.dy < radius ? offset.dy - _lineLenght : offset.dy + _lineLenght);
    } else {
      offsetNew = Offset(offset.dx < radius ? offset.dx - _lineLenght : offset.dx + _lineLenght, offset.dy);
    }
    return offsetNew;
  }

  //获得文字的宽度
  double findAllWidth(String text, TextStyle textStyle) {
    double manWidth = 0;
    text.runes.forEach((rune) {
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      );
      tp.layout();
      manWidth = manWidth + tp.width;
    });
    return manWidth;
  }

  //获得文字的高度
  double findHeight(String text, TextStyle textStyle) {
    double height = 0;
    text.runes.forEach((rune) {
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      );
      tp.layout();
      height = height > tp.height ? height : tp.height;
    });
    return height;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


class PieItemBean {
  IconData icon;
  Color color; //颜色(可实现渐变)
  double value; //占比[0.0-1.0] 所有咱比之和必须为1
  String title; //(类别)
  double money; //金额
  PieItemBean(this.color, this.value, {this.title, this.money, this.icon});
}