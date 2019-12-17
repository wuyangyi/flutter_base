import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_base/bean/weather/weather_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/utils/utils.dart';

class WeatherLineWidget extends StatelessWidget {

  final WeatherBeanEntity weatherData;
  final List<ui.Image> images;

  const WeatherLineWidget({Key key, this.weatherData, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WeatherLinePainter(weatherData, images),
      size: Size(WeatherLinePainter.itemWidth * 16, 330.0),
    );
  }
}


class WeatherLinePainter extends CustomPainter{
  static final double itemWidth = 60; //每个item的宽度

  final double textHeight = 25.0; //文字的高度
  final double textImageHeight = 60.0; //图片的高度
  final double aqiCircleWidth = 3.0; //空气质量圆点你的半径
  final double lineHeight = 120.0; //划线高度

  final WeatherBeanEntity weatherData;
  final List<ui.Image> images;

  List<Offset> topPositionList; //温度最高点的集合
  List<Offset> bottomPositionList; //温度最低点的集合
  double maxWendu; //最大温度
  double minWendu; //最小温度

  WeatherLinePainter(this.weatherData, this.images);

  var paintTop = new Paint()
    ..style = PaintingStyle.fill// 填充;
    ..isAntiAlias = true
    ..color = Colors.green;// 抗锯齿;

  var paintCircle = new Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  //绘制文字
  drawText(Canvas canvas, int i, String text, double height, {double frontSize, ui.Color textColor, double textWidth}) {
    var pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,//居中
      fontSize: frontSize == null ? 14 : frontSize,//大小
    ));
    //添加文字
    pb.addText(text);
    //文字颜色
    pb.pushStyle(ui.TextStyle(color: textColor ?? Colors.white));
    //文本宽度
    var paragraph = pb.build()..layout(ui.ParagraphConstraints(width: textWidth ?? itemWidth));
    //绘制文字
    canvas.drawParagraph(paragraph, Offset(itemWidth*i, height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    topPositionList= [];
    bottomPositionList = [];
    maxWendu = getMaxWenDu();
    minWendu = getMinWenDu();

    //绘制昨天
    drawItem(canvas, -1, Colors.white60);
    for(int i = 0; i < weatherData.data.forecast.length; i++) {
      drawItem(canvas, i, Colors.white);
    }

    //最高温连线
    paintTop.color = Colors.orange;
    paintTop.strokeWidth = 1.0;
    for (int i = 0; i < topPositionList.length - 1; i++) {
      canvas.drawLine(topPositionList[i], topPositionList[i + 1], paintTop);
    }

    //最低温连线
    paintTop.color = Colors.blue;
    paintTop.strokeWidth = 1.0;
    for (int i = 0; i < bottomPositionList.length - 1; i++) {
      canvas.drawLine(bottomPositionList[i], bottomPositionList[i + 1], paintTop);
    }

  }


  void drawItem(Canvas canvas, int i, Color textColor) {
    drawText(canvas, i+1, getWeek(i), 0, textColor: textColor);
    drawText(canvas, i+1, i == -1 ? weatherData.data.yesterday.ymd.substring(5) : weatherData.data.forecast[i].ymd.substring(5), textHeight, textColor: textColor, frontSize: 12.0);
    String aqiText = getAqiString(i == -1 ? weatherData.data.yesterday.aqi : weatherData.data.forecast[i].aqi);
    if(aqiText != "未知") {
      drawText(canvas, i+1, aqiText, textHeight*2, textColor: textColor, frontSize: 13.0, textWidth: itemWidth - aqiCircleWidth * 2 - 8);
      //画空气质量圆点
      paintCircle.color = getAqiColor(i == -1 ? weatherData.data.yesterday.aqi : weatherData.data.forecast[i].aqi);
      canvas.drawCircle(Offset(getLeftWidth(Util.findAllWidth(aqiText, TextStyle(fontSize: 13.0)), i+1), textHeight*2 + Util.getMaxHeight(aqiText, TextStyle(fontSize: 13.0)) / 2), aqiCircleWidth, paintCircle);
    } else {
      drawText(canvas, i+1, aqiText, textHeight*2, textColor: textColor, frontSize: 13.0, textWidth: itemWidth);
    }

    String type = i == -1 ? weatherData.data.yesterday.type : weatherData.data.forecast[i].type;
    ui.Image image = getImage(type);
    canvas.drawImageRect(image,Rect.fromLTWH(0, 0, image.width.toDouble(),  image.height.toDouble()),
        Rect.fromLTWH(itemWidth/4 + itemWidth*(i+1), textHeight * 3 + (textImageHeight - 30) / 2,30,30), paintCircle);

    drawText(canvas, i+1, type, textHeight*3 + textImageHeight, textColor: textColor, frontSize: 14.0,);

    //绘制温度最高的点
    double max = double.parse(i == -1 ? weatherData.data.yesterday.high.substring(3, weatherData.data.yesterday.high.length-1) : weatherData.data.forecast[i].high.substring(3, weatherData.data.forecast[i].high.length-1));
    double min = double.parse(i == -1 ? weatherData.data.yesterday.low.substring(3, weatherData.data.yesterday.low.length-1) : weatherData.data.forecast[i].low.substring(3, weatherData.data.forecast[i].low.length-1));
    double topHeightPoint = textHeight * 4 + textImageHeight + 20 + 80 - 80 * (max - minWendu) / (maxWendu - minWendu);
    Offset topOffset = Offset(itemWidth * (i+1) + itemWidth / 2, topHeightPoint);
    topPositionList.add(topOffset);
    paintTop.color = Colors.orange;
    canvas.drawCircle(topOffset, 4, paintTop);
    //最高温上面显示温度
    drawText(canvas, i+1, "${max.toStringAsFixed(0)}°", topHeightPoint - Util.getMaxHeight("$max°", TextStyle(fontSize: 10)) - 4, frontSize: 10.0, textColor: textColor,);

    paintTop.color = Colors.blue;
    double bottomHeightPoint = textHeight * 4 + textImageHeight + 20 + 80 - 80 * (min - minWendu) / (maxWendu - minWendu);
    Offset bottomOffset = Offset(itemWidth * (i+1) + itemWidth / 2, bottomHeightPoint); //
    bottomPositionList.add(bottomOffset);
    canvas.drawCircle(bottomOffset, 4, paintTop);
    drawText(canvas, i+1, "${min.toStringAsFixed(0)}°", bottomHeightPoint + 8, frontSize: 10.0, textColor: textColor,);

    drawText(canvas, i+1, "${i == -1 ? weatherData.data.yesterday.fx : weatherData.data.forecast[i].fx}", textHeight * 4 + textImageHeight + lineHeight, frontSize: 12.0, textColor: textColor,);
    drawText(canvas, i+1, "${i == -1 ? weatherData.data.yesterday.fl : weatherData.data.forecast[i].fl}", textHeight * 5 + textImageHeight + lineHeight, frontSize: 12.0, textColor: textColor,);
  }


  //获得最高温度的最大值
  double getMaxWenDu() {
    double max = double.parse(weatherData.data.yesterday.high.substring(3, weatherData.data.yesterday.high.length-1));
    weatherData.data.forecast.forEach((item){
      double high = double.parse(item.high.substring(3, item.high.length-1));
      if (high > max) {
        max = high;
      }
    });
    return max;
  }

  //获得最低温度最小值
  double getMinWenDu() {
    double min = double.parse(weatherData.data.yesterday.low.substring(3, weatherData.data.yesterday.low.length-1));
    weatherData.data.forecast.forEach((item){
      double low = double.parse(item.low.substring(3, item.low.length-1));
      if (low < min) {
        min = low;
      }
    });
    return min;
  }


  double getLeftWidth(double textWidth, int i) {
    return i*itemWidth + (itemWidth - aqiCircleWidth * 2 - 8 - textWidth) / 2 + textWidth + 8;
  }


  String getWeek(int i) {
    String week = "";
    if (i == -1) { //昨天
      week = "昨天";
    } else if (i == 0){
      week = "今天";
    } else {
      week = weatherData.data.forecast[i].week;
    }
    return week;

  }

  //根据aqi获取空气质量
  String getAqiString(int aqi) {
    if (aqi == null) {
      return "未知";
    }
    String type = "";
    if (aqi <= 50) {
      type = "优";
    } else if (aqi <= 100) {
      type = "良";
    } else if (aqi <= 150) {
      type = "轻度";
    } else if (aqi <= 200) {
      type = "中等";
    } else if (aqi <= 300) {
      type = "重度";
    } else {
      type = "严重";
    }
    return type;
  }

  //根据aqi获取空气质量
  Color getAqiColor(int aqi) {
    if (aqi == null) {
      return Colors.transparent;
    }
    Color type;
    if (aqi <= 50) {
      type = Colors.green;
    } else if (aqi <= 100) {
      type = Colors.yellow;
    } else if (aqi <= 150) {
      type = Colors.orange;
    } else if (aqi <= 200) {
      type = Colors.red;
    } else if (aqi <= 300) {
      type = Colors.purple;
    } else {
      type = Colors.brown;
    }
    return type;
  }

  ui.Image getImage(String type) {
    print("天气：$type");
    ui.Image image;
    if (type == "晴") {
      image = images[0];
    } else if (type == "多云") {
      image = images[1];
    } else if (type == "阴") {
      image = images[2];
    } else if (type == "小雨") {
      image = images[3];
    } else if (type == "中雨") {
      image = images[4];
    } else if (type == "大雨") {
      image = images[5];
    } else if (type == "小雪") {
      image = images[6];
    } else if (type == "中雪") {
      image = images[7];
    } else if (type == "大雪") {
      image = images[8];
    } else {
      image = images[0];
    }
    return image;
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}