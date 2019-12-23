import 'dart:math';

import 'package:flutter_base/bean/chess/chess_rule.dart';

class RobotChessInfo {
  int iStart;
  int jStart;
  int iEnd;
  int jEnd;
  double grade;
  RobotChessInfo({this.iStart, this.jStart, this.iEnd, this.jEnd}) {
    this.grade = getGrade();
    print("grade:$grade");
  }

  double getGrade() {
    double grade = 0;
    ChineseChess chess = ChessStartIndex.chessIndexRobot[iEnd][jEnd];
    grade = getChessGrade(chess);
    ChessStartIndex.chessIndexRobot[iEnd][jEnd] = ChessStartIndex.chessIndexRobot[iStart][jStart];
    ChessStartIndex.chessIndexRobot[iStart][jStart] = ChineseChess.no;
    double redMinGrade = 0;
    for (int i = 0; i < ChessStartIndex.chessIndexRobot.length; i++) {
      for (int j = 0; j < ChessStartIndex.chessIndexRobot[i].length; j++) {
        if (ChineseChessRule.checkIsMe(ChessStartIndex.chessIndexRobot[i][j], true)) { //是机器人的棋子
          List<Point<int>> canMove = ChineseChessRule.getAllCanMovePosition(i, j, true);
          canMove.forEach((item){
            if (getChessGrade(ChessStartIndex.chessIndexRobot[item.x][item.y]) < redMinGrade) {
              redMinGrade = getChessGrade(ChessStartIndex.chessIndexRobot[item.x][item.y]);
            }
          });
        }
      }
    }
    ChessStartIndex.chessIndexRobot[iStart][jStart] = ChessStartIndex.chessIndexRobot[iEnd][jEnd];
    ChessStartIndex.chessIndexRobot[iEnd][jEnd] = chess;
    grade += redMinGrade;
    return grade;
  }

  double getChessGrade(ChineseChess type) {
    double grade = 0;
    switch (type) {
      case ChineseChess.blackZu:
        grade = -2;
        break;
      case ChineseChess.blackPao:
        grade = -4;
        break;
      case ChineseChess.blackJu:
        grade = -5;
        break;
      case ChineseChess.blackMa:
        grade = -4;
        break;
      case ChineseChess.blackXiang:
        grade = -3;
        break;
      case ChineseChess.blackShi:
        grade = -3;
        break;
      case ChineseChess.blackBoss:
        grade = -100;
        break;
      case ChineseChess.redBing:
        grade = 2;
        break;
      case ChineseChess.redPao:
        grade = 4;
        break;
      case ChineseChess.redJu:
        grade = 5;
        break;
      case ChineseChess.redMa:
        grade = 4;
        break;
      case ChineseChess.redXiang:
        grade = 3;
        break;
      case ChineseChess.redShi:
        grade = 3;
        break;
      case ChineseChess.redBoss:
        grade = 100;
        break;
      case ChineseChess.no:
        grade = 1;
        break;
    }
    return grade;
  }
}