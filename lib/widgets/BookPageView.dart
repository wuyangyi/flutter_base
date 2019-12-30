import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_base/bean/read_book/read_book_content_info_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'dart:math' as math;

import 'package:flutter_base/utils/utils.dart';

class BookPageView extends StatefulWidget {

  final ReadBookContentInfoBeanEntity data;

  const BookPageView(this.data);

  @override
  _BookPageViewState createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> with SingleTickerProviderStateMixin {
  String style = BookPageViewPainter.STYLE_BOTTOM_RIGHT;

  Offset a,f,g,e,h,c,j,b,k,d,i, temp;
  Size size = Size(DataConfig.appSize.width, DataConfig.appSize.height);

  Animation<double> animation;
  AnimationController controller;

  double value = 1.0;

  bool nextBook = true;

  Offset nextOffset;

  List<String> texts = [];
  int nowIndex = 0;

  double textSize = 18.0; //文字大小
  double lineSpring = 1.5; //行距

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          value = animation.value;
          startCancelAnimate();
          if (animation.value == 1.0) {
            setState(() {
              if (nextBook) {
                nowIndex++;
                if (nowIndex == texts.length) {
                  nowIndex = 0;
                }
              }
              a = null;
              style = null;
            });
          }
        });
      });
    initText();
  }

  void initText() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: textSize,
      height: lineSpring,
    );
    int lastIndex = 0;
    double maxHeight = Util.getMaxHeight("测", textStyle);
    int maxLine = (size.height - 30) ~/ maxHeight;
    print("maxLine:$maxLine");
    while(lastIndex < widget.data.chapter.cpContent.length) {
      lastIndex = getLastIndex(textStyle, lastIndex, widget.data.chapter.cpContent, maxLine);
    }
  }

  int getLastIndex(TextStyle textStyle, int startIndex, String text, int maxLine) {
    double maxWidth = size.width - 30.0;
    double nowWidth = 0.0;
    int nowLine = 1;
    int nowIndex = startIndex;
    for (int i = startIndex; i < text.length; i++) {
      if (i+2 <= text.length && text.substring(i, i+2) == '&&') {
        nowLine++;
        nowWidth = 0;
        print("一行1：${text.substring(nowIndex, i)}");
        i = i+1;
        nowIndex = i + 1;
        if (nowLine > maxLine) {
          i = i+1;
        }
      } else {
        double width = Util.findAllWidth(text.substring(nowIndex, i+1), textStyle);
        if (width > maxWidth) {
          nowLine++;
          print("一行：${text.substring(nowIndex, i)}");
          nowIndex = i;
          i--;
        } else {
          nowWidth = width;
        }
      }
      if (nowLine > maxLine) {
//        print("字符:${text.substring(startIndex, (startIndex+i)~/2)}");
//        print("字符:${text.substring((startIndex+i)~/2, i)}");
        texts.add(text.substring(startIndex, i).replaceAll("&&", "        "));
        print("-------一节结束了-------");
        return i;
      }
    }

    print("字符:${text.substring(startIndex, text.length)}");
    print("-------一节结束了-------");
    texts.add(text.substring(startIndex,text.length));
    return text.length;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e){
        if (!controller.isCompleted) {
          controller.stop();
        }
        nextBook = true;
//        print("onTapDown e：${e.localPosition.toString()}");
        if (e.localPosition.dx > DataConfig.appSize.width / 3 * 2) {
          if (e.localPosition.dy < DataConfig.appSize.height / 3) {
            style = BookPageViewPainter.STYLE_TOP_RIGHT;
          } else if (e.localPosition.dy < DataConfig.appSize.height / 3 * 2) {
            style = BookPageViewPainter.STYLE_CENTER_RIGHT;
          } else {
            style = BookPageViewPainter.STYLE_BOTTOM_RIGHT;
          }
        } else if (e.localPosition.dx < DataConfig.appSize.width / 3) {
          style = BookPageViewPainter.STYLE_LEFT;
          nowIndex--;
          if (nowIndex < 0) {
            nowIndex = texts.length - 1;
          }
          nextBook = false;
        }
        nextOffset = e.localPosition;
      },
      onPointerMove: (e){
        setState(() {
          if (style == BookPageViewPainter.STYLE_CENTER_RIGHT || style == BookPageViewPainter.STYLE_LEFT) {
            a = Offset(e.localPosition.dx, size.height - 1);
            initPoint(size);
          } else {
            a = e.localPosition;
            initPoint(size);
            if (calcPointCX(e.localPosition, f) < 0) {
              calcPointAByTouchPoint();
              initPoint(size);
            }
          }
          if ((e.localPosition.dx - nextOffset.dx).abs() > 10.0 || (e.localPosition.dy - nextOffset.dy).abs() > 10.0) {
            if (e.localPosition.dx <= nextOffset.dx) {
              nextBook = true;
            } else {
              nextBook = false;
            }
            nextOffset = e.localPosition;
          }

        });
      },
      onPointerUp: (e){
        temp = a;
        controller.forward(from: 0.0);
      },
      child: CustomPaint(
        size: size,
        painter: BookPageViewPainter(a, f, g, e, h, c, j, b, k, d, i, style, texts[nowIndex], texts[nowIndex + 1 == texts.length ? 0 : nowIndex + 1], textSize, lineSpring),
      ),
    );
  }

  void startCancelAnimate() {
    if (value != 1.0 && temp != null) {
      if (nextBook) {
        if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
          a = Offset(temp.dx - size.width * value, temp.dy * (1 - value) - 1);
        } else {
          a = Offset(temp.dx - size.width * value, temp.dy + value * (size.height - temp.dy) - 1);
        }
      } else {
        if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
          a = Offset(temp.dx + (size.width - temp.dx) * value - 1, temp.dy * (1 - value) - 1);
        } else {
          a = Offset(temp.dx + (size.width - temp.dx) * value - 1, temp.dy + value * (size.height - temp.dy) - 1);
        }
      }
      initPoint(size);
    }
  }

  /*
   * 计算C点的X值
   * @param a
   * @param f
   * @return
   */
  double calcPointCX(Offset a, Offset f){
    if (a == null || f == null) {
      return 0;
    }
    Offset g,e;
    g = new Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);
    e = new Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);
    return e.dx - (f.dx - e.dx) / 2;
  }

  /*
   * 如果c点x坐标小于0,根据触摸点重新测量a点坐标
   */
  void calcPointAByTouchPoint(){
    double w0 = DataConfig.appSize.width - c.dx;

    double w1 = (f.dx - a.dx).abs();
    double w2 = DataConfig.appSize.width * w1 / w0;
    double dx = (f.dx - w2).abs();

    double h1 = (f.dy - a.dy).abs();
    double h2 = w2 * h1 / w1;
    double dy = (f.dy - h2).abs();
    a = Offset(dx, dy);
  }

  //初始化点
  void initPoint(Size size) {
    if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
      f = Offset(size.width, 0);
    } else if(style == BookPageViewPainter.STYLE_BOTTOM_RIGHT) {
      f = Offset(size.width, size.height);
    } else if(style == BookPageViewPainter.STYLE_CENTER_RIGHT) {
      f = Offset(size.width, size.height);
    } else if (style == BookPageViewPainter.STYLE_LEFT) {
      f = Offset(size.width, size.height);
    }
    g = Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);
    e = Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);
    h = Offset(f.dx, g.dy - (f.dx - g.dx) * (f.dx - g.dx) / (f.dy - g.dy));
    c = Offset(e.dx - (f.dx - e.dx) / 2, f.dy);
    j = Offset(f.dx, h.dy - (f.dy - h.dy) / 2);
    b = getIntersectionPoint(a,e,c,j);
    k = getIntersectionPoint(a,h,c,j);
    d = Offset((c.dx + e.dx * 2 + b.dx) / 4, (2 * e.dy + c.dy + b.dy) / 4);
    i = Offset((j.dx + 2 * h.dx + k.dx) / 4, (2 * h.dy + j.dy + k.dy) / 4);
  }

  /*
   * 获得交叉点的坐标
   */
  Offset getIntersectionPoint(Offset lineOnePointOne, Offset lineOnePointTwo, Offset lineTwoPointOne, Offset lineTwoPointTwo) {
    double x1,y1,x2,y2,x3,y3,x4,y4;
    x1 = lineOnePointOne.dx;
    y1 = lineOnePointOne.dy;
    x2 = lineOnePointTwo.dx;
    y2 = lineOnePointTwo.dy;
    x3 = lineTwoPointOne.dx;
    y3 = lineTwoPointOne.dy;
    x4 = lineTwoPointTwo.dx;
    y4 = lineTwoPointTwo.dy;
    double pointX =((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1))
        / ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));
    double pointY =((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4))
        / ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));

    return  new Offset(pointX,pointY);
  }
}

//绘制
class BookPageViewPainter extends CustomPainter {
  static const String STYLE_LEFT = "STYLE_LEFT"; //点击左边区域
  static const String STYLE_CENTER = "STYLE_CENTER"; //点击中间区域
  static const String STYLE_TOP_RIGHT = "STYLE_TOP_RIGHT"; //右上角开始翻书
  static const String STYLE_CENTER_RIGHT = "STYLE_CENTER_RIGHT"; //中间开始翻书
  static const String STYLE_BOTTOM_RIGHT = "STYLE_BOTTOM_RIGHT"; //右下角开始翻书

  Offset a,f,g,e,h,c,j,b,k,d,i;
  final String style;
  double textSize; //文字大小
  double lineSpring; //行距

  String nowText;
  String nextText;

  BookPageViewPainter(this.a, this.f, this.g, this.e, this.h, this.c, this.j, this.b, this.k, this.d, this.i, this.style, this.nowText, this.nextText, this.textSize, this.lineSpring);

  var paints = Paint()
//    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.transparent;

  var paintA = Paint()
//    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Color(0xFFC2B28F); //0xFFD9B98F

  var paintC = Paint()
//    ..style = PaintingStyle.fill
//    ..blendMode = BlendMode.dstOver //折叠部分处理
    ..isAntiAlias = true
    ..color = Color(0xFFD7C7A9);

  var paintB = Paint()
//    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOver //折叠部分处理
    ..isAntiAlias = true
    ..color = Color(0xFFC2B28F);

  @override
  void paint(Canvas canvas, Size size) {
    if (a == null || style == null || f == null || g == null || e == null || h == null) {
      canvas.drawPath(getPathDefault(size), paintA);
      drawText(canvas, nowText, Offset(15.0, 30.0));
      return;
    }
    drawText(canvas, nextText, Offset(15.0, 30.0));
    canvas.drawPath(getPathDefault(size), paints);

    //绘制A区域
    canvas.drawPath(pathA(size), paintA);

    var combinec = Path.combine(PathOperation.intersect, pathC(size), pathA(size));
    var combineC = Path.combine(PathOperation.difference, pathC(size), combinec);
    var pathc;
    if (style == STYLE_CENTER_RIGHT || style == STYLE_LEFT) {
      paintC.blendMode = BlendMode.srcOver;
      pathc = pathC(size);
    } else {
      paintC = Paint()
        ..isAntiAlias = true
        ..color = Color(0xFFD7C7A9);
      pathc = combineC;
    }

    //绘制C区域
    canvas.drawPath(pathc, paintC);

    //绘制B区域
    canvas.drawPath(pathB(size), paintB);



    var combine = Path.combine(PathOperation.intersect, getPathDefault(size), pathA(size));
    canvas.clipPath(combine);
    drawText(canvas, nowText, Offset(15.0, 30.0));


  }

  //默认的path
  Path getPathDefault(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  Path pathA(Size size) {
    Path pathA;
    if (style == STYLE_TOP_RIGHT) {
      pathA = pathAFromRightTop(size);
    } else if (style == STYLE_BOTTOM_RIGHT) {
      pathA = pathAFromRightBottom(size);
    } else if (style == STYLE_CENTER_RIGHT || style == STYLE_LEFT) {
      pathA = pathAFromRightBottom(size);
    }
    return pathA;
  }

  //区域A的路径
  Path pathAFromRightBottom(Size size) {
    Path pathA = new Path();
    pathA.lineTo(0, size.height);
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //c - b的贝塞尔曲线
    pathA.lineTo(a.dx, a.dy); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //画k-j的贝塞尔曲线
    pathA.lineTo(size.width, 0); //移动到右上角
    pathA.close(); //闭合区域
    return pathA;
  }

  //区域A的路径
  Path pathAFromRightTop(Size size) {
    Path pathA = new Path();
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //c - b的贝塞尔曲线
    pathA.lineTo(a.dx, a.dy); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //画k-j的贝塞尔曲线
    pathA.lineTo(size.width, size.height); //移动到右下角
    pathA.lineTo(0, size.height);

    pathA.close(); //闭合区域
    return pathA;
  }

  //区域C的路径
  Path pathC(Size size) {
    Path pathC = new Path();
    pathC.moveTo(i.dx, i.dy);
    pathC.lineTo(d.dx, d.dy);
    pathC.lineTo(b.dx, b.dy);
    pathC.lineTo(a.dx, a.dy);
    pathC.lineTo(k.dx, k.dy);
    pathC.close();
    return pathC;
  }

  //区域B的路径
  Path pathB(Size size) {
    Path pathB = new Path();
    pathB.lineTo(0, size.height);
    pathB.lineTo(size.width, size.height);
    pathB.lineTo(size.width, 0);
    pathB.close();
    return pathB;
  }


  //绘制横坐标的底部文字
  void drawText(Canvas canvas, String text, Offset offset){
    TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
          height: lineSpring,
        ),
      ),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0.0, maxWidth: DataConfig.appSize.width - 30)
      ..paint(canvas, offset);
  }

  @override
  bool shouldRepaint(BookPageViewPainter oldDelegate) {
    return a != oldDelegate.a;
  }

}