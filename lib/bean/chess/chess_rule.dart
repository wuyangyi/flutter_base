//棋子和规则

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/utils.dart';
import 'dart:ui' as ui;

enum ChineseChess {
  //黑方卒
  blackZu,
  //黑方炮
  blackPao,
  //黑方车
  blackJu,
  //黑方马
  blackMa,
  //黑方象
  blackXiang,
  //黑方士
  blackShi,
  //黑方帅
  blackBoss,

  //红方兵
  redBing,
  //红方炮
  redPao,
  //红方车
  redJu,
  //红方马
  redMa,
  //红方相
  redXiang,
  //红方仕
  redShi,
  //红方将
  redBoss,

  //没有棋子
  no,
}


class ChessStartIndex {
  //红方在下
  static const List<List<ChineseChess>> redBottom = [
    [ChineseChess.blackJu, ChineseChess.blackMa, ChineseChess.blackXiang, ChineseChess.blackShi, ChineseChess.blackBoss, ChineseChess.blackShi, ChineseChess.blackXiang, ChineseChess.blackMa, ChineseChess.blackJu],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.no, ChineseChess.blackPao, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.blackPao, ChineseChess.no],
    [ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],

    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing],
    [ChineseChess.no, ChineseChess.redPao, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.redPao, ChineseChess.no],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.redJu, ChineseChess.redMa, ChineseChess.redXiang, ChineseChess.redShi, ChineseChess.redBoss, ChineseChess.redShi, ChineseChess.redXiang, ChineseChess.redMa, ChineseChess.redJu],
  ];

  //黑方在下
  static const List<List<ChineseChess>> blackBottom = [
    [ChineseChess.redJu, ChineseChess.redMa, ChineseChess.redXiang, ChineseChess.redShi, ChineseChess.redBoss, ChineseChess.redShi, ChineseChess.redXiang, ChineseChess.redMa, ChineseChess.redJu],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.no, ChineseChess.redPao, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.redPao, ChineseChess.no],
    [ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing, ChineseChess.no, ChineseChess.redBing],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],

    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu, ChineseChess.no, ChineseChess.blackZu],
    [ChineseChess.no, ChineseChess.blackPao, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.blackPao, ChineseChess.no],
    [ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no, ChineseChess.no],
    [ChineseChess.blackJu, ChineseChess.blackMa, ChineseChess.blackXiang, ChineseChess.blackShi, ChineseChess.blackBoss, ChineseChess.blackShi, ChineseChess.blackXiang, ChineseChess.blackMa, ChineseChess.blackJu],
  ];

  static List<List<ChineseChess>> chessIndex; //当前棋子的位置(双人对局)

  static List<List<ChineseChess>> chessIndexRobot; //当前棋子的位置(机器人下棋)

  static bool bottomIsRed = true; //下面是红色方 默认为true

  static bool bottomIsRedRobot = true; //下面是红色方 (机器人对局)

  static List<ui.Image> images = [];

  static bool redChange = true; //红色方下棋(双人对局)
  static bool redChangeRobot = true; //红色方下棋 (人机对局)


  static bool isFinish = false; //是否结束了(双人对局)
  static bool isFinishRobot = false; //是否结束了 (人机对局)

  static String winner = "";

  static Future initImages() async {
    if (images.isNotEmpty) {
      return;
    }
    await initImage(Util.getImgPath("chess/ico_qizi"));
    await initImage(Util.getImgPath("chess/ico_hongzu"));
    await initImage(Util.getImgPath("chess/ico_hongpao"));
    await initImage(Util.getImgPath("chess/ico_hongju"));
    await initImage(Util.getImgPath("chess/ico_hongma"));
    await initImage(Util.getImgPath("chess/ico_hongxiang"));
    await initImage(Util.getImgPath("chess/ico_hongshi"));
    await initImage(Util.getImgPath("chess/ico_hongjiang"));

    await initImage(Util.getImgPath("chess/ico_heibing"));
    await initImage(Util.getImgPath("chess/ico_heipao"));
    await initImage(Util.getImgPath("chess/ico_heiju"));
    await initImage(Util.getImgPath("chess/ico_heima"));
    await initImage(Util.getImgPath("chess/ico_heixiang"));
    await initImage(Util.getImgPath("chess/ico_heishi"));
    await initImage(Util.getImgPath("chess/ico_heishuai"));
    print("图片加载完成");
  }

  static Future initImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    ui.Image image = await loadDayImage(new Uint8List.view(data.buffer));
    images.add(image);
  }

  //加载图片
  static Future<ui.Image> loadDayImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static List<List<ChineseChess>> getChessIndex(List<List<ChineseChess>> list) {
    List<List<ChineseChess>> newList = [];
    list.forEach((item){
      newList.add(item.sublist(0));
    });
    return newList;
  }

  static void init(bool isRobot, {bool reStart = false}) {
    winner = "";
    if (isRobot) {
      bottomIsRed = true;
      ChessStartIndex.chessIndexRobot = ChessStartIndex.getChessIndex(ChessStartIndex.redBottom);
      redChangeRobot = true;
      isFinishRobot = false;
    } else {
      if (reStart) {
        ChessStartIndex.bottomIsRed = !ChessStartIndex.bottomIsRed;
      }
      bottomIsRed = ChessStartIndex.bottomIsRed;
      redChange = true;
      isFinish = false;
      if (bottomIsRed) {
        ChessStartIndex.chessIndex = ChessStartIndex.getChessIndex(ChessStartIndex.redBottom);
      } else {
        ChessStartIndex.chessIndex = ChessStartIndex.getChessIndex(ChessStartIndex.blackBottom);
      }
    }
  }

  static void finish(bool isRobot, String win) {
    if (isRobot) {
      ChessStartIndex.isFinishRobot = true;
    } else {
      ChessStartIndex.isFinish = true;
    }
    winner = win;
  }

}

class ChineseChessRule {

  //获得所有可移动的位置
  static List<Point<int>> getAllCanMovePosition(int i, int j, isRobot) {
    List<Point<int>> list = []; //所有可移动的位置
    if (i == -1 || j == -1){
      return list;
    }
    List<List<ChineseChess>> allList = isRobot ? ChessStartIndex.chessIndexRobot : ChessStartIndex.chessIndex; //当前棋局
    ChineseChess type = allList[i][j];
    bool bottomIsRed = isRobot ? ChessStartIndex.bottomIsRedRobot : ChessStartIndex.bottomIsRed;
    switch(type) {
      case ChineseChess.blackZu:
        if (bottomIsRed) {
          addList(Point(i+1, j), list, false, isRobot);
          if (i > 4) { //已过河
            addList(Point(i, j + 1), list, false, isRobot);
            addList(Point(i, j - 1), list, false, isRobot);
          }
        } else {
          addList(Point(i-1, j), list, false, isRobot);
          if (i < 5) { //已过河
            addList(Point(i, j + 1), list, false, isRobot);
            addList(Point(i, j - 1), list, false, isRobot);
          }
        }
        break;
        //炮
      case ChineseChess.blackPao:
      case ChineseChess.redPao:
        bool isRed = type == ChineseChess.redPao;
        int centerChessNumber = 0; //中间间隔棋子数目
        for (int index = i - 1; index >= 0; index--) {
          if (allList[index][j] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(index, j), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 1 && !checkIsMe(allList[index][j], isRed)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = i + 1; index <= 9; index++) {
          if (allList[index][j] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(index, j), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 1 && !checkIsMe(allList[index][j], isRed)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = j - 1; index >= 0; index--) {
          if (allList[i][index] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(i, index), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 1 && !checkIsMe(allList[i][index], isRed)) {
              addList(Point(i, index), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = j + 1; index <= 8; index++) {
          if (allList[i][index] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(i, index), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 1 && !checkIsMe(allList[i][index], isRed)) {
              addList(Point(i, index), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        break;
        //车
      case ChineseChess.blackJu:
      case ChineseChess.redJu:
        bool isRed = type == ChineseChess.redJu;
        int centerChessNumber = 0; //中间间隔棋子数目
        for (int index = i - 1; index >= 0; index--) {
          if (allList[index][j] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(index, j), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 0 && !checkIsMe(allList[index][j], isRed)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = i + 1; index <= 9; index++) {
          if (allList[index][j] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(index, j), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 0 && !checkIsMe(allList[index][j], isRed)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = j - 1; index >= 0; index--) {
          if (allList[i][index] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(i, index), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 0 && !checkIsMe(allList[i][index], isRed)) {
              addList(Point(i, index), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = j + 1; index <= 8; index++) {
          if (allList[i][index] == ChineseChess.no) {
            if(centerChessNumber == 0) {
              addList(Point(i, index), list, isRed, isRobot);
            }
          } else {
            if (centerChessNumber == 0 && !checkIsMe(allList[i][index], isRed)) {
              addList(Point(i, index), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        break;
      case ChineseChess.blackMa:
      case ChineseChess.redMa:
        bool isRed = type == ChineseChess.redMa;
        bool topHaveChess = i <= 1 || allList[i - 1][j] != ChineseChess.no;
        bool bottomHaveChess = i >= 8 || allList[i + 1][j] != ChineseChess.no;
        bool leftHaveChess = j <= 1 || allList[i][j - 1] != ChineseChess.no;
        bool rightHaveChess = j >= 7 || allList[i][j + 1] != ChineseChess.no;
        if (!topHaveChess) {
          if(j >= 1 && !checkIsMe(allList[i - 2][j - 1], isRed)) {
            addList(Point(i - 2, j - 1), list, isRed, isRobot);
          }
          if (j <= 7 && !checkIsMe(allList[i - 2][j + 1], isRed)) {
            addList(Point(i - 2, j + 1), list, isRed, isRobot);
          }
        }
        if (!bottomHaveChess) {
          if(j >= 1 && !checkIsMe(allList[i + 2][j - 1], isRed)) {
            addList(Point(i + 2, j - 1), list, isRed, isRobot);
          }
          if (j <= 7 && !checkIsMe(allList[i + 2][j + 1], isRed)) {
            addList(Point(i + 2, j + 1), list, isRed, isRobot);
          }
        }
        if (!leftHaveChess) {
          if (i >= 1 && !checkIsMe(allList[i - 1][j - 2], isRed)) {
            addList(Point(i - 1, j - 2), list, isRed, isRobot);
          }
          if (i <= 8 && !checkIsMe(allList[i + 1][j - 2], isRed)) {
            addList(Point(i + 1, j - 2), list, isRed, isRobot);
          }
        }
        if (!rightHaveChess) {
          if (i >= 1 && !checkIsMe(allList[i - 1][j + 2], isRed)) {
            addList(Point(i - 1, j + 2), list, isRed, isRobot);
          }
          if (i <= 8 && !checkIsMe(allList[i + 1][j + 2], isRed)) {
            addList(Point(i + 1, j + 2), list, isRed, isRobot);
          }
        }
        break;
      case ChineseChess.blackXiang:
      case ChineseChess.redXiang:
        bool isRed = type == ChineseChess.redXiang;
        bool topLeftHaveChess;
        bool bottomLeftHaveChess;
        bool topRightHaveChess;
        bool bottomRightHaveChess;
        if (bottomIsRed) {
          if (isRed) {
            topLeftHaveChess =
                i <= 6 || j <= 1 || allList[i - 1][j - 1] != ChineseChess.no;
            bottomLeftHaveChess =
                i >= 8 || j <= 1 || allList[i + 1][j - 1] != ChineseChess.no;
            topRightHaveChess =
                j >= 7 || i <= 6 || allList[i - 1][j + 1] != ChineseChess.no;
            bottomRightHaveChess =
                j >= 7 || i >= 8 || allList[i + 1][j + 1] != ChineseChess.no;
          } else {
            topLeftHaveChess =
                i <= 1 || j <= 1 || allList[i - 1][j - 1] != ChineseChess.no;
            bottomLeftHaveChess =
                i >= 3 || j <= 1 || allList[i + 1][j - 1] != ChineseChess.no;
            topRightHaveChess =
                j >= 7 || i <= 1 || allList[i - 1][j + 1] != ChineseChess.no;
            bottomRightHaveChess =
                j >= 7 || i >= 3 || allList[i + 1][j + 1] != ChineseChess.no;
          }
        } else {
          if (isRed) {
            topLeftHaveChess =
                i <= 1 || j <= 1 || allList[i - 1][j - 1] != ChineseChess.no;
            bottomLeftHaveChess =
                i >= 3 || j <= 1 || allList[i + 1][j - 1] != ChineseChess.no;
            topRightHaveChess =
                j >= 7 || i <= 1 || allList[i - 1][j + 1] != ChineseChess.no;
            bottomRightHaveChess =
                j >= 7 || i >= 3 || allList[i + 1][j + 1] != ChineseChess.no;
          } else {
            topLeftHaveChess =
                i <= 6 || j <= 1 || allList[i - 1][j - 1] != ChineseChess.no;
            bottomLeftHaveChess =
                i >= 8 || j <= 1 || allList[i + 1][j - 1] != ChineseChess.no;
            topRightHaveChess =
                j >= 7 || i <= 6 || allList[i - 1][j + 1] != ChineseChess.no;
            bottomRightHaveChess =
                j >= 7 || i >= 8 || allList[i + 1][j + 1] != ChineseChess.no;
          }
        }
        if (!topLeftHaveChess && !checkIsMe(allList[i - 2][j - 2], isRed)) {
          addList(Point(i - 2, j - 2), list, isRed, isRobot);
        }
        if (!bottomLeftHaveChess && !checkIsMe(allList[i + 2][j - 2], isRed)) {
          addList(Point(i + 2, j - 2), list, isRed, isRobot);
        }
        if (!topRightHaveChess && !checkIsMe(allList[i - 2][j + 2], isRed)) {
          addList(Point(i - 2, j + 2), list, isRed, isRobot);
        }
        if (!bottomRightHaveChess && !checkIsMe(allList[i + 2][j + 2], isRed)) {
          addList(Point(i + 2, j + 2), list, isRed, isRobot);
        }
        break;
      case ChineseChess.blackShi:
      case ChineseChess.redShi:
        bool isRed = type == ChineseChess.redShi;
        bool topLeft;
        bool bottomLeft;
        bool topRight;
        bool bottomRight;
        if (bottomIsRed) {
          if (isRed) {
            topLeft = i >= 8 && j >= 4 && !checkIsMe(allList[i - 1][j - 1], isRed);
            bottomLeft = i <= 8 && j >= 4 && !checkIsMe(allList[i + 1][j - 1], isRed);
            topRight = i >= 8 && j <= 4 && !checkIsMe(allList[i - 1][j + 1], isRed);
            bottomRight = i <= 8 && j <= 4 && !checkIsMe(allList[i + 1][j + 1], isRed);
          } else {
            topLeft = i >= 1 && j >= 4 && !checkIsMe(allList[i - 1][j - 1], isRed);
            bottomLeft = i <= 1 && j >= 4 && !checkIsMe(allList[i + 1][j - 1], isRed);
            topRight = i >= 1 && j <= 4 && !checkIsMe(allList[i - 1][j + 1], isRed);
            bottomRight = i <= 1 && j <= 4 && !checkIsMe(allList[i + 1][j + 1], isRed);
          }
        } else {
          if (isRed) {
            topLeft = i >= 1 && j >= 4 && !checkIsMe(allList[i - 1][j - 1], isRed);
            bottomLeft = i <= 1 && j >= 4 && !checkIsMe(allList[i + 1][j - 1], isRed);
            topRight = i >= 1 && j <= 4 && !checkIsMe(allList[i - 1][j + 1], isRed);
            bottomRight = i <= 1 && j <= 4 && !checkIsMe(allList[i + 1][j + 1], isRed);
          } else {
            topLeft = i >= 8 && j >= 4 && !checkIsMe(allList[i - 1][j - 1], isRed);
            bottomLeft = i <= 8 && j >= 4 && !checkIsMe(allList[i + 1][j - 1], isRed);
            topRight = i >= 8 && j <= 4 && !checkIsMe(allList[i - 1][j + 1], isRed);
            bottomRight = i <= 8 && j <= 4 && !checkIsMe(allList[i + 1][j + 1], isRed);
          }
        }
        if (topLeft) {
          addList(Point(i - 1, j - 1), list, isRed, isRobot);
        }
        if (topRight) {
          addList(Point(i - 1, j + 1), list, isRed, isRobot);
        }
        if (bottomLeft) {
          addList(Point(i + 1, j - 1), list, isRed, isRobot);
        }
        if (bottomRight) {
          addList(Point(i + 1, j + 1), list, isRed, isRobot);
        }
        break;
      case ChineseChess.blackBoss:
      case ChineseChess.redBoss:
        bool isRed = type == ChineseChess.redBoss;
        bool topMove;
        bool bottomMove;
        bool leftMove;
        bool rightMove;
        if (bottomIsRed) {
          if (isRed) {
            topMove = i >= 8 && !checkIsMe(allList[i - 1][j], isRed);
            bottomMove = i <= 8 && !checkIsMe(allList[i + 1][j], isRed);
            leftMove = j >= 4 && !checkIsMe(allList[i][j - 1], isRed);
            rightMove = j <= 4 && !checkIsMe(allList[i][j + 1], isRed);
          } else {
            topMove = i >= 1 && !checkIsMe(allList[i - 1][j], isRed);
            bottomMove = i <= 1 && !checkIsMe(allList[i + 1][j], isRed);
            leftMove = j >= 4 && !checkIsMe(allList[i][j - 1], isRed);
            rightMove = j <= 4 && !checkIsMe(allList[i][j + 1], isRed);
          }
        } else {
          if (isRed) {
            topMove = i >= 1 && !checkIsMe(allList[i - 1][j], isRed);
            bottomMove = i <= 1 && !checkIsMe(allList[i + 1][j], isRed);
            leftMove = j >= 4 && !checkIsMe(allList[i][j - 1], isRed);
            rightMove = j <= 4 && !checkIsMe(allList[i][j + 1], isRed);
          } else {
            topMove = i >= 8 && !checkIsMe(allList[i - 1][j], isRed);
            bottomMove = i <= 8 && !checkIsMe(allList[i + 1][j], isRed);
            leftMove = j >= 4 && !checkIsMe(allList[i][j - 1], isRed);
            rightMove = j <= 4 && !checkIsMe(allList[i][j + 1], isRed);
          }
        }
        if (topMove) {
          addList(Point(i - 1, j), list, isRed, isRobot);
        }
        if (bottomMove) {
          addList(Point(i + 1, j), list, isRed, isRobot);
        }
        if (leftMove) {
          addList(Point(i, j - 1), list, isRed, isRobot);
        }
        if (rightMove) {
          addList(Point(i, j + 1), list, isRed, isRobot);
        }
        //将和帅在一条直线上且中间没有棋子时可以吃了赢棋
        int centerChessNumber = 0; //中间间隔棋子数目
        for (int index = i - 1; index >= 0; index--) {
          if (allList[index][j] != ChineseChess.no) {
            if (centerChessNumber == 0 && (allList[index][j] == ChineseChess.redBoss || allList[index][j] == ChineseChess.blackBoss)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        centerChessNumber = 0;
        for (int index = i + 1; index <= 9; index++) {
          if (allList[index][j] != ChineseChess.no) {
            if (centerChessNumber == 0 && (allList[index][j] == ChineseChess.redBoss || allList[index][j] == ChineseChess.blackBoss)) {
              addList(Point(index, j), list, isRed, isRobot);
            }
            centerChessNumber++;
          }
        }
        break;
      case ChineseChess.redBing:
        if (bottomIsRed) {
          addList(Point(i-1, j), list, true, isRobot);
          if (i < 5) { //已过河
            addList(Point(i, j + 1), list, true, isRobot);
            addList(Point(i, j - 1), list, true, isRobot);
          }
        } else {
          addList(Point(i+1, j), list, true, isRobot);
          if (i > 4) { //已过河
            addList(Point(i, j + 1), list, true, isRobot);
            addList(Point(i, j - 1), list, true, isRobot);
          }
        }
        break;
      case ChineseChess.no:
        break;
    }
    return list;
  }

  //是否是正确的点（即是否超出边界）
  static void addList(Point<int> point, List<Point<int>> list, bool moveIsRed, bool isRobot) {
    if (point.x > 9 || point.x < 0 || point.y < 0 || point.y > 8) {
      return;
    }
    ChineseChess type = isRobot ? ChessStartIndex.chessIndexRobot[point.x][point.y] : ChessStartIndex.chessIndex[point.x][point.y];
    if (checkIsMe(type, moveIsRed)) {
      return;
    }
    list.add(point);
  }

  //判断该棋子是否能移动到这个位置
  static bool isCanMove(int iIndexStart, int jIndexStart, int iIndexEnd, int jIndexEnd, bool isRobot) {
    bool canMove = false;
    List<Point<int>> allPosition = getAllCanMovePosition(iIndexStart, jIndexStart, isRobot);
    allPosition.forEach((item){
      if (item.x == iIndexEnd && item.y == jIndexEnd) {
        canMove = true;
      }
    });
    return canMove;
  }

  //判断棋子是否是自己的
  static bool checkIsMe(ChineseChess type, bool moveIsRed) {
    bool isOneSelf = false;
    if (moveIsRed) {
      if (type == ChineseChess.redJu || type == ChineseChess.redPao ||
          type == ChineseChess.redBing || type == ChineseChess.redMa ||
          type == ChineseChess.redXiang || type == ChineseChess.redBoss || type == ChineseChess.redShi) {
        isOneSelf = true;
      }
    } else {
      if (type == ChineseChess.blackJu || type == ChineseChess.blackPao ||
          type == ChineseChess.blackZu || type == ChineseChess.blackMa ||
          type == ChineseChess.blackXiang || type == ChineseChess.blackBoss || type == ChineseChess.blackShi) {
        isOneSelf = true;
      }
    }
    return isOneSelf;
  }

  static void move(int iStart, int jStart, int iEnd, int jEnd, bool isRobot) {
    if (isRobot) {
      checkFinish(isRobot, ChessStartIndex.chessIndexRobot[iEnd][jEnd]);
      ChessStartIndex.chessIndexRobot[iEnd][jEnd] = ChessStartIndex.chessIndexRobot[iStart][jStart];
      ChessStartIndex.chessIndexRobot[iStart][jStart] = ChineseChess.no;
      ChessStartIndex.redChangeRobot = !ChessStartIndex.redChangeRobot;
    } else {
      checkFinish(isRobot, ChessStartIndex.chessIndex[iEnd][jEnd]);
      ChessStartIndex.chessIndex[iEnd][jEnd] = ChessStartIndex.chessIndex[iStart][jStart];
      ChessStartIndex.chessIndex[iStart][jStart] = ChineseChess.no;
      ChessStartIndex.redChange = !ChessStartIndex.redChange;
    }
  }

  static void checkFinish(bool isRobot, ChineseChess type) {
    if (type == ChineseChess.redBoss) {
      if (isRobot) {
        ChessStartIndex.isFinishRobot = true;
      } else {
        ChessStartIndex.isFinish = true;
      }
      ChessStartIndex.winner = "黑棋";
    } else if (type == ChineseChess.blackBoss) {
      if (isRobot) {
        ChessStartIndex.isFinishRobot = true;
      } else {
        ChessStartIndex.isFinish = true;
      }
      ChessStartIndex.winner = "红棋";
    }
  }

}