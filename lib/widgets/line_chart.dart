import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';

class LineChart extends StatefulWidget {
  LineChart({
    this.lineColor = MyColors.main_color,
    this.list,
    this.xStart = 0,
    this.xEnd = 0,
    this.xUnit = "",
    this.yUnit = "",
  });

  //折线的颜色
  final Color lineColor;

  //所有点的集合
  final List<LineChartBean> list;

  //原点 横坐标的起始值
  final int xStart;

  // 横坐标的终点值
  final int xEnd;

  //横坐标单位
  final String xUnit;

  //纵坐标单位
  final String yUnit;

  @override
  State<StatefulWidget> createState() {
    return LineChartState();
  }
}


class LineChartState extends State<LineChart> {



  //原点 纵坐标最小值
  double yMin = 0;

  //纵坐标最大值
  double yMax = 0;  //取整


  bool showDetail = false; //是否显示了详情

  int showDetailOffset; //显示详情的位置


  double startAndEndWidth = 30.0; //横坐标开通和结尾流出的空间

  double itemWidth = 0.0; //横坐标间隔为1的距离

  double maxWidth; //控件宽度

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;

    if (widget.list == null || widget.list.isEmpty) {
      yMax = 0;
    } else {
      yMax = yMax.abs();
      widget.list.forEach((item){
        if (item.money > yMax) {
          yMax = item.money;
        }
      });

      String max = yMax.toString();
      if (yMax == 0) {
        yMax = yMax.abs();
      } else if (yMax < 100) {
        if (yMax % 20 > 0) {
          yMax = double.parse("${((yMax ~/ 20 + 1) * 20).toStringAsFixed(0)}");
        }
      } else {
        if (yMax % 200 > 0) {
          yMax = double.parse("${((yMax ~/ 200 + 1) * 200).toStringAsFixed(0)}");
        }
      }
    }

    startAndEndWidth = Util.findAllWidth("${yMax.toStringAsFixed(0)}${widget.yUnit}", LineChartPainter.yTextStyle) + 5;
    itemWidth = (maxWidth - startAndEndWidth * 2) / (widget.xEnd - widget.xStart);

    return Listener(
      onPointerDown: (PointerDownEvent event){ //手指按下
        setState(() {
          showDetail = true;
          showDetailOffset = getPosition(event.position);
        });
      },
      onPointerMove: (PointerMoveEvent event) { //手指移动
        setState(() {
          showDetailOffset = getPosition(event.position);
        });
      },
      onPointerUp: (PointerUpEvent event) { //手指抬起
        setState(() {
          showDetail = false;
          showDetailOffset = null;
        });
      },
      child: CustomPaint(
        size: Size(maxWidth, double.infinity),
        painter: LineChartPainter(
          lineColor: widget.lineColor,
          list: widget.list,
          xStart: widget.xStart,
          xEnd: widget.xEnd,
          yMax: yMax,
          yMin: yMin,
          xUnit: widget.xUnit,
          yUnit: widget.yUnit,
          showDetail: showDetail,
          showDetailOffset: showDetailOffset,
          itemWidth: itemWidth,
          startAndEndWidth: startAndEndWidth,
        ),
      ),
    );
  }

  int getPosition(Offset offset) {
    int position = 0;
    if (offset.dx <= startAndEndWidth) {
      position = 0;
    } else if (offset.dx >= maxWidth - startAndEndWidth) {
      position = widget.xEnd - widget.xStart;
    } else {
      position = (offset.dx - startAndEndWidth) ~/ itemWidth;
      if ((offset.dx - startAndEndWidth) % itemWidth > itemWidth / 2) {
        position++;
      }
    }
    print("position: $position");
    return position;
  }
}


//画笔
class LineChartPainter extends CustomPainter {
  LineChartPainter({
    this.lineColor = MyColors.main_color,
    this.list,
    this.xStart = 0,
    this.xEnd = 0,
    this.yMin = 0,
    this.yMax = 0,
    this.xUnit = "",
    this.yUnit = "",
    this.showDetailOffset,
    this.showDetail = false,
    this.itemWidth,
    this.startAndEndWidth,
  });

  //折线的颜色
  final Color lineColor;

  //所有点的集合
  final List<LineChartBean> list;

  //原点 横坐标的起始值
  final int xStart; //这里通过list计算

  // 横坐标的终点值
  final int xEnd;

  //原点 纵坐标最小值
  final double yMin;

  //纵坐标最大值
  final double yMax;

  //横坐标单位
  final String xUnit;

  //纵坐标单位
  final String yUnit;

  final double itemHeight = 60.0; //三条虚线的间隔
  final double imaginaryLineWidth = 4.0; //虚线的长

  int xItemNumber = 5; //横坐标的间隔数目
  final double itemWidth; //横坐标间隔为1的距离
  int itemNumber = 0; //横坐标间的差(最后一个除外)

  final double startAndEndWidth; //横坐标开通和结尾流出的空间

  final int showDetailOffset; //需要显示详情的位置
  final bool showDetail; //是否显示了详情(为false时不显示)


  var paintLine = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 0.5;

  var paintDetails = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 0.5;

  var paintTop = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Color(0xFF333333);

  //纵坐标文字样式
  static TextStyle yTextStyle = TextStyle(
    color: MyColors.lineColor,
    fontSize: 10.0,
  );

  //横坐标文字样式
  TextStyle xTextStyle = TextStyle(
    color: MyColors.text_normal,
    fontSize: 10.0,
  );

  //顶部详情文字样式
  TextStyle topDetailTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 10.0,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (xEnd - xStart < 5) {
      xItemNumber = xEnd - xStart;
    }
//    startAndEndWidth = findAllWidth("${yMax.toStringAsFixed(0)}$yUnit", yTextStyle) + 5;
//    itemWidth = (size.width - startAndEndWidth * 2) / (xEnd - xStart);
    itemNumber = (xEnd - xStart) ~/ xItemNumber;


    //首先绘制三条虚线
    paintLine.color = MyColors.lineColor; //虚线的颜色
    drawImaginaryLine(canvas, size.height / 2, size.width);
    drawImaginaryLine(canvas, size.height / 2 - itemHeight, size.width);
    drawImaginaryLine(canvas, size.height / 2 + itemHeight, size.width);

    //max文字
    TextPainter(
      text: TextSpan(
        text: "${yMax?.toStringAsFixed(0)}$yUnit",
        style: yTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: double.infinity, maxWidth: double.infinity)
      ..paint(canvas, Offset(5.0, size.height / 2 - itemHeight - 15));

    //center文字
    TextPainter(
      text: TextSpan(
        text: "${(yMax / 2)?.toStringAsFixed(0)}$yUnit",
        style: yTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: double.infinity, maxWidth: double.infinity)
      ..paint(canvas, Offset(5.0, size.height / 2 - 15));

    //bottom文字
    TextPainter(
      text: TextSpan(
        text: "${yMin.toStringAsFixed(0)}$yUnit",
        style: yTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: double.infinity, maxWidth: double.infinity)
      ..paint(canvas, Offset(5.0, size.height / 2 + itemHeight - 15));

    //横坐标
    for (int i = 0; i < xItemNumber + 1; i++) {
      String text = "${(xStart + (xEnd - xStart) / xItemNumber * i).toStringAsFixed(0)}$xUnit";
      double x = startAndEndWidth + i * itemNumber * itemWidth - Util.findAllWidth(text, xTextStyle) / 2;
      if (i == xItemNumber) {
        text = "$xEnd$xUnit";
        x = size.width - startAndEndWidth - Util.findAllWidth(text, xTextStyle) / 2;
      }
      dratXText(canvas, text, x, size.height / 2 + itemHeight + 5);
    }
    paintLine.color = lineColor;
    paintDetails.color = MyColors.lineColor;
    //绘制折线
    for(int i = xStart; i < xEnd; i++) {
      double startValue = getValueByTime(i);
      double endValue = getValueByTime(i+1);
      print("startValue:$startValue    endValue:$endValue");
      Offset offsetStart = Offset(startAndEndWidth + (i - xStart) * itemWidth, size.height / 2 + itemHeight - (2 * itemHeight) / yMax * startValue);
      Offset offsetEnd = Offset(startAndEndWidth + (i + 1 - xStart) * itemWidth, size.height / 2 + itemHeight - (2 * itemHeight) / yMax * endValue);
      canvas.drawLine(offsetStart, offsetEnd, paintLine);
    }

    //显示详情
    if (showDetail) {
      //画竖着的线
      paintLine.color = MyColors.lineColor;
      canvas.drawLine(Offset(startAndEndWidth + showDetailOffset * itemWidth, size.height / 2 - itemHeight), Offset(startAndEndWidth + showDetailOffset * itemWidth, size.height / 2 + itemHeight), paintLine);

      //画圆
      paintLine.color = lineColor;
      canvas.drawCircle(Offset(startAndEndWidth + showDetailOffset * itemWidth, size.height / 2 + itemHeight - (2 * itemHeight) / yMax * getValueByTime(xStart + showDetailOffset)), 2.0, paintLine);

      //绘制三角形
      double b = 5.0; //直角三角形的侧边长
      Path path = new Path();
      path.moveTo(startAndEndWidth + showDetailOffset * itemWidth, size.height / 2 - itemHeight);
      path.lineTo(startAndEndWidth + showDetailOffset * itemWidth - b, size.height / 2 - itemHeight - b);
      path.lineTo(startAndEndWidth + showDetailOffset * itemWidth + b, size.height / 2 - itemHeight - b);
      canvas.drawPath(path, paintTop);

      //绘制上面的显示信息
      String showValueText = "金额：${getValueByTime(xStart + showDetailOffset)}";
      String timeText = "${xStart + showDetailOffset}$xUnit";
      double reWidth = Util.findAllWidth(showValueText, topDetailTextStyle);
      double reHeight = Util.getMaxHeight(timeText, topDetailTextStyle) + Util.getMaxHeight(showValueText, topDetailTextStyle);
      RRect rRect = RRect.fromLTRBR(
          startAndEndWidth + showDetailOffset * itemWidth - (reWidth + 6) / 2,
          size.height / 2 - itemHeight - reHeight - 6 - b + 1,
          startAndEndWidth + showDetailOffset * itemWidth + (reWidth + 6) / 2,
          size.height / 2 - itemHeight - b + 1, Radius.circular(4.0));
      canvas.drawRRect(rRect, paintTop);

      //详情文字--时间
      TextPainter(
        text: TextSpan(
          text: "$timeText",
          style: topDetailTextStyle,
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: double.infinity, maxWidth: double.infinity)
        ..paint(canvas, Offset(startAndEndWidth + showDetailOffset * itemWidth - reWidth / 2, size.height / 2 - itemHeight - b + 1 - reHeight - 3));

      //详情文字--值
      TextPainter(
        text: TextSpan(
          text: "$showValueText",
          style: topDetailTextStyle,
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: double.infinity, maxWidth: double.infinity)
        ..paint(canvas, Offset(startAndEndWidth + showDetailOffset * itemWidth - reWidth / 2, size.height / 2 - itemHeight - b + 1 - Util.getMaxHeight(showValueText, topDetailTextStyle) - 3));

    }

  }

  //获取横坐标所对应纵坐标的值
  double getValueByTime(int time) {
    double money = 0.0;
    list.forEach((item){
      if (time == item.time) {
        money = item.money;
      }
    });
    return money;
  }

  /*
   * 绘制三条虚线
   * canvas 画布
   * height 当前的纵坐标
   * maxWidth 虚线的总长
   */
  void drawImaginaryLine(Canvas canvas, double height, maxWidth) {
    //画多少根线
    int maxLine = maxWidth ~/ (2 * imaginaryLineWidth) + 1;
    double dxStart = 0;
    double dxEnd = 0;
    for(int i = 0; i < maxLine; i++) {
      dxEnd = dxStart + imaginaryLineWidth;
      canvas.drawLine(Offset(dxStart, height), Offset(dxEnd, height), paintLine);
      dxStart = dxStart + 2 * imaginaryLineWidth;
    }
  }

  //绘制横坐标的底部文字
  void dratXText(Canvas canvas, String text, double x, double y){
    TextPainter(
      text: TextSpan(
        text: text,
        style: xTextStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: double.infinity, maxWidth: double.infinity)
      ..paint(canvas, Offset(x, y));
  }







  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.list != this.list || oldDelegate.showDetail != this.showDetail ||
        oldDelegate.showDetailOffset != this.showDetailOffset || oldDelegate.lineColor != this.lineColor;
  }

}


class LineChartBean {
  double money; //金额
  int time; //时间
  LineChartBean(this.money, this.time,);
}