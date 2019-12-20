import 'package:flutter/material.dart';
import 'package:flutter_base/utils/utils.dart';

//棋盘
class ChineseChessCheckerboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = Size(MediaQuery.of(context).size.width - 40, (MediaQuery.of(context).size.width - 40.0 - ChineseChessCheckerboardPainter.outLineDistance * 2 - ChineseChessCheckerboardPainter.outLineDistance * 2) / 8 * 9 + ChineseChessCheckerboardPainter.outLineDistance * 2 + ChineseChessCheckerboardPainter.outLineDistance * 2);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Util.getImgPath("ico_checkerboard_bg")),
          fit: BoxFit.fill,
        ),
        border: Border.all(width: 0.5, color: Colors.black45),
      ),
      child: CustomPaint(
        size: size,
        painter: ChineseChessCheckerboardPainter(),
      ),
    );
  }
}

//绘制棋盘
class ChineseChessCheckerboardPainter extends CustomPainter {
  static final double outDistance = 15.0; //最外面的距离
  static final double outLineDistance = 5.0; //棋盘线距离边框线的距离

  static final double flowerLength = 8.0; //梅花的长
  static final double flowerToLineDistance = 4.0; //梅花距离线的距离

  double itemDistance; //方格的长宽

  var paintLine = Paint()
    ..strokeWidth = 1
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    itemDistance = (size.width - outDistance * 2 - outLineDistance * 2) / 8;
    //绘制最外面的边框线
    drawOut(canvas, size);

    //画外线
    drawOutLine(canvas, size);

    paintLine.strokeWidth = 1.0;
    //画横线里面8条
    for (int i = 1; i < 9; i++) {
      if (i == 4 || i == 5) {
        paintLine.strokeWidth = 2.0;
      } else {
        paintLine.strokeWidth = 1.0;
      }
      canvas.drawLine(Offset(outDistance + outLineDistance, outDistance + outLineDistance + i * itemDistance), Offset(size.width - outDistance - outLineDistance, outDistance + outLineDistance + i * itemDistance), paintLine);
    }
    //画竖线里面6条
    for (int i = 1; i < 8; i++) {
      paintLine.strokeWidth = 1.0;
      canvas.drawLine(Offset(outDistance + outLineDistance + i * itemDistance, outDistance + outLineDistance), Offset(outDistance + outLineDistance + i * itemDistance, outLineDistance + outDistance + 4 * itemDistance), paintLine);
      canvas.drawLine(Offset(outDistance + outLineDistance + i * itemDistance, outLineDistance + outDistance + 5 * itemDistance), Offset(outDistance + outLineDistance + i * itemDistance, size.height - outDistance - outLineDistance), paintLine);
    }

    paintLine.strokeWidth = 1.5;
    //绘制兵的梅花
    for (int i = 0; i < 5; i++) {
      for (int j = 1; j < 3; j++) {
        double x = outLineDistance + outDistance + i * itemDistance * 2; //点上的x坐标
        double y = outDistance + outLineDistance + itemDistance * 3 * j;
        if (i != 0) {
          Path path = Path();
          path.moveTo(x - flowerToLineDistance, y - flowerToLineDistance - flowerLength);
          path.lineTo(x - flowerToLineDistance, y - flowerToLineDistance);
          path.lineTo(x - flowerToLineDistance - flowerLength, y - flowerToLineDistance);
          canvas.drawPath(path, paintLine);

          Path path2 = Path();
          path2.moveTo(x - flowerToLineDistance, y + flowerToLineDistance + flowerLength);
          path2.lineTo(x - flowerToLineDistance, y + flowerToLineDistance);
          path2.lineTo(x - flowerToLineDistance - flowerLength, y + flowerToLineDistance);
          canvas.drawPath(path2, paintLine);
        }

        if (i != 4) {
          Path path3 = Path();
          path3.moveTo(x + flowerToLineDistance, y - flowerToLineDistance - flowerLength);
          path3.lineTo(x + flowerToLineDistance, y - flowerToLineDistance);
          path3.lineTo(x + flowerToLineDistance + flowerLength, y - flowerToLineDistance);
          canvas.drawPath(path3, paintLine);

          Path path4 = Path();
          path4.moveTo(x + flowerToLineDistance, y + flowerToLineDistance + flowerLength);
          path4.lineTo(x + flowerToLineDistance, y + flowerToLineDistance);
          path4.lineTo(x + flowerToLineDistance + flowerLength, y + flowerToLineDistance);
          canvas.drawPath(path4, paintLine);
        }

      }
    }

    //绘制炮的梅花
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        double x = outLineDistance + outDistance + itemDistance + i * itemDistance * 6; //点上的x坐标
        double y = outDistance + outLineDistance + itemDistance * 2 + itemDistance * 5 * j;
        Path path = Path();
        path.moveTo(x - flowerToLineDistance, y - flowerToLineDistance - flowerLength);
        path.lineTo(x - flowerToLineDistance, y - flowerToLineDistance);
        path.lineTo(x - flowerToLineDistance - flowerLength, y - flowerToLineDistance);
        canvas.drawPath(path, paintLine);

        Path path2 = Path();
        path2.moveTo(x - flowerToLineDistance, y + flowerToLineDistance + flowerLength);
        path2.lineTo(x - flowerToLineDistance, y + flowerToLineDistance);
        path2.lineTo(x - flowerToLineDistance - flowerLength, y + flowerToLineDistance);
        canvas.drawPath(path2, paintLine);

        Path path3 = Path();
        path3.moveTo(x + flowerToLineDistance, y - flowerToLineDistance - flowerLength);
        path3.lineTo(x + flowerToLineDistance, y - flowerToLineDistance);
        path3.lineTo(x + flowerToLineDistance + flowerLength, y - flowerToLineDistance);
        canvas.drawPath(path3, paintLine);

        Path path4 = Path();
        path4.moveTo(x + flowerToLineDistance, y + flowerToLineDistance + flowerLength);
        path4.lineTo(x + flowerToLineDistance, y + flowerToLineDistance);
        path4.lineTo(x + flowerToLineDistance + flowerLength, y + flowerToLineDistance);
        canvas.drawPath(path4, paintLine);

      }
    }

    //绘制将的行走范围
    paintLine.strokeWidth = 1.0;
    //上
    canvas.drawLine(Offset(outLineDistance + outDistance + itemDistance * 3, outLineDistance + outDistance), Offset(outLineDistance + outDistance + itemDistance * 5, outLineDistance + outDistance + itemDistance * 2), paintLine);
    canvas.drawLine(Offset(outLineDistance + outDistance + itemDistance * 3, outLineDistance + outDistance + itemDistance * 2), Offset(outLineDistance + outDistance + itemDistance * 5, outLineDistance + outDistance), paintLine);
    //下
    canvas.drawLine(Offset(outLineDistance + outDistance + itemDistance * 3, size.height - outLineDistance - outDistance - 1), Offset(outLineDistance + outDistance + itemDistance * 5, outLineDistance + outDistance + itemDistance * 7), paintLine);
    canvas.drawLine(Offset(outLineDistance + outDistance + itemDistance * 3, outLineDistance + outDistance + itemDistance * 7), Offset(outLineDistance + outDistance + itemDistance * 5, size.height - outLineDistance - outDistance - 1), paintLine);
  }

  void drawOut(Canvas canvas, Size size) {
    paintLine.strokeWidth = 3.0;
    Path path = new Path();
    path.moveTo(outDistance, outDistance);
    path.lineTo(outDistance, size.height - outDistance);
    path.lineTo(size.width - outDistance, size.height - outDistance);
    path.lineTo(size.width - outDistance, outDistance);
    path.close();
    canvas.drawPath(path, paintLine);
  }

  void drawOutLine(Canvas canvas, Size size) {
    paintLine.strokeWidth = 2.0;
    Path path = new Path();
    path.moveTo(outDistance + outLineDistance, outDistance + outLineDistance);
    path.lineTo(outDistance + outLineDistance, size.height - outDistance - outLineDistance);
    path.lineTo(size.width - outDistance - outLineDistance, size.height - outDistance - outLineDistance);
    path.lineTo(size.width - outDistance - outLineDistance, outDistance + outLineDistance);
    path.close();
    canvas.drawPath(path, paintLine);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}