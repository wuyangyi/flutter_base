
import 'package:flutter/material.dart';
/*
 * 垂直排列汉字，从上到下
 */
class VerticalTextWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final TextStyle textStyle;
  final bool mainAlignmentRight;//是否从右边开始排列

  VerticalTextWidget({this.text, this.width, this.height, this.textStyle, this.mainAlignmentRight = true});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalText(text, width, height, textStyle, mainAlignmentRight,),
    );
  }
}



class VerticalText extends CustomPainter {
  final String text;
  final double width;
  final double height;
  final TextStyle textStyle;
  bool mainAlignmentRight = true; //是否从右边开始排列

  VerticalText(
      this.text,
      this.width,
      this.height,
      this.textStyle,
      this.mainAlignmentRight,
      );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = textStyle.color;
    double offsetX = mainAlignmentRight ? width : 0;
    double offSetY = 0;
    bool newLine = true;
    double maxWidth = 0;
    maxWidth = findMaxWidth(text, textStyle);

    text.runes.forEach((rune){
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
      );
      tp.layout();
      if (offsetX + tp.height > height) {
        newLine = true;
        offSetY = 0;
      }
      if (newLine) {
        if (mainAlignmentRight) {
          offsetX -= maxWidth;
        } else {
          offsetX += maxWidth;
        }
        newLine = false;
      }
      if (mainAlignmentRight && offsetX < -maxWidth) {
        return;
      }
      if (!mainAlignmentRight && offsetX - width < -maxWidth) {
        return;
      }

      tp.paint(canvas, new Offset(offsetX, offSetY));
      offSetY += tp.height;
    });
  }

  @override
  bool shouldRepaint(VerticalText oldDelegate) {
    return oldDelegate.text != text ||
      oldDelegate.textStyle != textStyle ||
      oldDelegate.width != width ||
      oldDelegate.height != height;
  }

  double findMaxWidth(String text, TextStyle textStyle) {
    double maxWidth = 0;
    text.runes.forEach((rune) {
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
      );
      tp.layout();
      maxWidth = max(maxWidth, tp.width);
    });
    return maxWidth;
  }

  double findAllHeight(String text, TextStyle textStyle) {
    double maxHeight = 0;
    text.runes.forEach((rune) {
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      );
      tp.layout();
      maxHeight = maxHeight + tp.height;
    });
    return maxHeight;
  }

  double max(double a, double b) {
    if (a > b) {
      return a;
    } else {
      return b;
    }
  }

}


/*
 * 一列居中
 */
class VerticalCenterTextWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final TextStyle textStyle;

  VerticalCenterTextWidget({this.text, this.width, this.height, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalCenterText(text, width, height, textStyle,),
    );
  }
}



class VerticalCenterText extends CustomPainter {
  final String text;
  final double width;
  double height;
  final TextStyle textStyle;

  VerticalCenterText(
      this.text,
      this.width,
      this.height,
      this.textStyle,
      );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = textStyle.color;
    double offsetX = width;
    double offSetY = 0;
    offSetY = (height - findAllHeight(text, textStyle)) / 2;

    text.runes.forEach((rune){
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      );
      tp.layout();
      tp.paint(canvas, new Offset(offsetX, offSetY));
      offSetY += tp.height;
    });
  }

  @override
  bool shouldRepaint(VerticalCenterText oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }

  double findAllHeight(String text, TextStyle textStyle) {
    double maxHeight = 0;
    text.runes.forEach((rune) {
      String str = new String.fromCharCode(rune);
      TextSpan span = new TextSpan(style: textStyle, text: str);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr
      );
      tp.layout();
      maxHeight = maxHeight + tp.height;
    });
    return maxHeight;
  }

}

