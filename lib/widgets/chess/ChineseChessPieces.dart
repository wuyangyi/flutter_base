import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/bean/chess/RoubotChessBean.dart';
import 'package:flutter_base/bean/chess/chess_rule.dart';
import 'package:flutter_base/res/color.dart';

import 'ChineseChessCheckerboard.dart';
import 'dart:ui' as ui;

//棋子
class ChineseChessPieces extends StatefulWidget {
  final bool isRobot; //是否是人机对战
  final Function onChange; //下棋成功

  const ChineseChessPieces({Key key, this.isRobot = false, this.onChange}) : super(key: key);
  @override
  _ChineseChessPiecesState createState() => _ChineseChessPiecesState(isRobot);
}

class _ChineseChessPiecesState extends State<ChineseChessPieces> {
  final bool isRobot; //是否是人机对战

  double itemDistance; //方格的长宽

  int iIndexStart = -1; //选中棋子的横坐标（为-1则未选中棋子）
  int jIndexStart = -1; //选中棋子的纵坐标（为-1则未选中棋子）
  int iIndexEnd = -1; //选中棋子的横坐标（为-1则未选中棋子）
  int jIndexEnd = -1; //选中棋子的纵坐标（为-1则未选中棋子）

  bool isMove = false; //是否是移动
  bool isSelect = false; //是否是选中

  List<Point<int>> canMovePoint = []; //可以移动的位置


  _ChineseChessPiecesState(this.isRobot);

  @override
  Widget build(BuildContext context) {
    Size size = Size(MediaQuery.of(context).size.width - 40, (MediaQuery.of(context).size.width - 40.0 - ChineseChessCheckerboardPainter.outLineDistance * 2 - ChineseChessCheckerboardPainter.outLineDistance * 2) / 8 * 9 + ChineseChessCheckerboardPainter.outLineDistance * 2 + ChineseChessCheckerboardPainter.outLineDistance * 2);
    itemDistance = (size.width - ChineseChessCheckerboardPainter.outDistance * 2 - ChineseChessCheckerboardPainter.outLineDistance * 2) / 8;
    return Container(
      alignment: Alignment.center,
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerDown: (e) {
          getRealIndex(e.localPosition, isRobot ? ChessStartIndex.chessIndexRobot : ChessStartIndex.chessIndex);
          setState(() {

          });
        },
        child: CustomPaint(
          size: size,
          painter: ChineseChessPiecesPainter(isRobot, itemDistance, iIndexStart, jIndexStart, this.iIndexEnd, this.jIndexEnd, this.canMovePoint),
        ),
      ),
    );
  }

  getRealIndex (Offset offset, List<List<ChineseChess>> chess) {
    int iIndex = -1;
    int jIndex = -1;
    for (int i = 0; i < chess.length; i++) {
      for (int j = 0; j < chess[i].length; j++) {
        Offset center = Offset(ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + j * itemDistance, ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + i * itemDistance);
        if (offset.dx >= center.dx - itemDistance / 2 - ChineseChessPiecesPainter.ChessDistance && offset.dx <= center.dx + itemDistance / 2 + ChineseChessPiecesPainter.ChessDistance) {
          iIndex = j;
        }
        if (offset.dy >= center.dy - itemDistance / 2 - ChineseChessPiecesPainter.ChessDistance && offset.dy <= center.dy + itemDistance / 2 + ChineseChessPiecesPainter.ChessDistance) {
          jIndex = i;
        }
      }
    }

    bool isFinish = false;
    if (isRobot) {
      isFinish = ChessStartIndex.isFinishRobot;
    } else {
      isFinish = ChessStartIndex.isFinish;
    }

    if (isFinish) {
      return;
    }
    if (isRobot && !ChessStartIndex.redChangeRobot) {
      return;
    }
    if (isSelectMyChess(jIndex, iIndex)) {
      isMove = false;
      isSelect = true;
      iIndexEnd = -1;
      jIndexEnd = -1;
    } else {
      if (iIndexStart != -1 && jIndexStart != -1) {
        for (int index = 0; index < canMovePoint.length; index++) {
          if (canMovePoint[index] == Point(jIndex, iIndex)) {
            isMove = true;
            isSelect = false;
            canMovePoint = [];
          }
        }
      }
    }

    if(isMove) {
      iIndexEnd = iIndex;
      jIndexEnd = jIndex;
      print("iIndexStart:$iIndexStart  jIndexStart:$jIndexStart   iIndexEnd:$iIndexEnd   jIndexEnd:$jIndexEnd");
      ChineseChessRule.move(jIndexStart, iIndexStart, jIndexEnd, iIndexEnd, isRobot);
      isMove = false;
      isSelect = false;
      iIndexStart = -1;
      jIndexStart = -1;
      iIndexEnd = -1;
      jIndexEnd = -1;
      if (widget?.onChange != null) {
        widget.onChange();
      }
      if(!ChessStartIndex.isFinishRobot && !ChessStartIndex.redChangeRobot){
        //机器人走棋
        moveByRobot();
        if (widget?.onChange != null) {
          widget.onChange();
        }
      }
    }

    if (isSelect) {
      iIndexStart = iIndex;
      jIndexStart = jIndex;
      canMovePoint = ChineseChessRule.getAllCanMovePosition(jIndexStart, iIndexStart, isRobot);
      isSelect = false;
    }
  }


  //机器人走棋
  void moveByRobot(){
    List<RobotChessInfo> robotAllChess = [];
    for (int i = 0; i < ChessStartIndex.chessIndexRobot.length; i++) {
      for (int j = 0; j < ChessStartIndex.chessIndexRobot[i].length; j++) {
        if (ChineseChessRule.checkIsMe(ChessStartIndex.chessIndexRobot[i][j], false)) { //是机器人的棋子
          List<Point<int>> canMove = ChineseChessRule.getAllCanMovePosition(i, j, isRobot);
          canMove.forEach((item){
            robotAllChess.add(RobotChessInfo(iStart: i, jStart: j, iEnd: item.x, jEnd: item.y));
          });
        }
      }
    }
    double maxGrade = 0;
    robotAllChess.forEach((item){
      if (item.grade > maxGrade) {
        maxGrade = item.grade;
      }
    });
    List<RobotChessInfo> maxAllChess = [];
    robotAllChess.forEach((item){
      if (item.grade == maxGrade) {
        maxAllChess.add(item);
      }
    });
    RobotChessInfo index;
    if (maxAllChess.length > 0) {
      int i = Random().nextInt(maxAllChess.length);
      index = maxAllChess[i];
    }  else {
      int i = Random().nextInt(robotAllChess.length);
      index = robotAllChess[i];
    }
    ChineseChessRule.move(index.iStart, index.jStart, index.iEnd, index.jEnd, isRobot);
  }


  //是否点击到下棋方棋子
  bool isSelectMyChess(int i, int j) {
      bool select = false;
      ChineseChess type = isRobot ? ChessStartIndex.chessIndexRobot[i][j] : ChessStartIndex.chessIndex[i][j];
      if (isRobot) {
        select = ChineseChessRule.checkIsMe(type, true);
      } else {
        select = ChineseChessRule.checkIsMe(type, ChessStartIndex.redChange);
      }
      return select;
  }


}

//绘制棋子
class ChineseChessPiecesPainter extends CustomPainter{
  static const double ChessDistance = 2.0; //棋子间距
  static const double canMovePointRadio = 4.0; //可移动位置点的半径
  final double itemDistance; //方格的长宽

  final bool isRobot; //是否是人机对战

  final int iIndexStart; //选中棋子的横坐标（为-1则未选中棋子）
  final int jIndexStart; //选中棋子的纵坐标（为-1则未选中棋子）
  final int iIndexEnd; //选中棋子的横坐标（为-1则未选中棋子）
  final int jIndexEnd; //选中棋子的纵坐标（为-1则未选中棋子）

  final List<Point<int>> canMovePoint; //可以移动的位置

  var paintCircle = new Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = MyColors.main_color
    ..strokeWidth = 1;

  ChineseChessPiecesPainter(this.isRobot, this.itemDistance, this.iIndexStart, this.jIndexStart, this.iIndexEnd, this.jIndexEnd, this.canMovePoint);

  @override
  void paint(Canvas canvas, Size size) {
//    if (iIndex != -1 && jIndex != -1) {
//      canvas.drawCircle(Offset(ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + iIndex * itemDistance, ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + jIndex * itemDistance), itemDistance / 2 - ChessDistance, paintCircle);
//    }

    drawAllChess(canvas, size, isRobot ? ChessStartIndex.chessIndexRobot : ChessStartIndex.chessIndex);
    //绘制可移动的点
    canMovePoint.forEach((item){
      canvas.drawCircle(Offset(ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + item.y * itemDistance, ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + item.x * itemDistance), canMovePointRadio, paintCircle);
    });

  }


  void drawAllChess(Canvas canvas, Size size, List<List<ChineseChess>> chess) {
    for (int i = 0; i < chess.length; i++) {
      for (int j = 0; j < chess[i].length; j++) {
        Offset center = Offset(ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + j * itemDistance, ChineseChessCheckerboardPainter.outDistance + ChineseChessCheckerboardPainter.outLineDistance + i * itemDistance);
        drawChess(canvas, center, chess[i][j], i == jIndexStart && j == iIndexStart);
      }
    }
  }

  void drawChess(Canvas canvas, Offset center, ChineseChess type, bool select) {
    if (type == ChineseChess.no) {
      return;
    }
    ui.Image image = getImage(type);
    ui.Image imageChess = ChessStartIndex.images[0];
    canvas.drawImageRect(imageChess,Rect.fromLTWH(0, 0, imageChess.width.toDouble(),  imageChess.height.toDouble()),
        Rect.fromCenter(center: center, width: select ? itemDistance + ChessDistance * 2 : itemDistance - ChessDistance * 2, height: select ? itemDistance + ChessDistance * 2 : itemDistance - ChessDistance * 2), paintCircle);
    canvas.drawImageRect(image,Rect.fromLTWH(0, 0, image.width.toDouble(),  image.height.toDouble()),
        Rect.fromCenter(center: center, width: select ? (itemDistance + ChessDistance * 2) * sin(0.25 * pi) : (itemDistance - ChessDistance * 2) * sin(0.25 * pi), height: select ? (itemDistance + ChessDistance * 2) * sin(0.25 * pi) : (itemDistance - ChessDistance * 2) * sin(0.25 * pi)), paintCircle);

  }

  ui.Image getImage(ChineseChess type) {
    ui.Image image;
    switch(type) {
      case ChineseChess.blackZu:
        image = ChessStartIndex.images[8];
        break;
      case ChineseChess.blackPao:
        image = ChessStartIndex.images[9];
        break;
      case ChineseChess.blackJu:
        image = ChessStartIndex.images[10];
        break;
      case ChineseChess.blackMa:
        image = ChessStartIndex.images[11];
        break;
      case ChineseChess.blackXiang:
        image = ChessStartIndex.images[12];
        break;
      case ChineseChess.blackShi:
        image = ChessStartIndex.images[13];
        break;
      case ChineseChess.blackBoss:
        image = ChessStartIndex.images[14];
        break;
      case ChineseChess.redBing:
        image = ChessStartIndex.images[1];
        break;
      case ChineseChess.redPao:
        image = ChessStartIndex.images[2];
        break;
      case ChineseChess.redJu:
        image = ChessStartIndex.images[3];
        break;
      case ChineseChess.redMa:
        image = ChessStartIndex.images[4];
        break;
      case ChineseChess.redXiang:
        image = ChessStartIndex.images[5];
        break;
      case ChineseChess.redShi:
        image = ChessStartIndex.images[6];
        break;
      case ChineseChess.redBoss:
        image = ChessStartIndex.images[7];
        break;
      case ChineseChess.no:
        break;
    }
    return image;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}