import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/chess/chess_game_info_bean_entity.dart';
import 'package:flutter_base/bean/chess/chess_rule.dart';
import 'package:flutter_base/bean/chess/chess_rule.dart' as prefix0;
import 'package:flutter_base/bean/dao/chess/ChessGameInfoDao.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/chess/ChineseChessCheckerboard.dart';
import 'package:flutter_base/widgets/chess/ChineseChessPieces.dart';


class ChessPlayDoubleRoute extends BaseRoute {
  final bool isRobot; //是否人机对战

  ChessPlayDoubleRoute(this.isRobot);
  @override
  _ChessPlayDoubleRouteState createState() => _ChessPlayDoubleRouteState(isRobot);
}

class _ChessPlayDoubleRouteState extends BaseRouteState<ChessPlayDoubleRoute> {
  final bool isRobot; //是否人机对战
  static int maxTime = 300;// 每人游戏最多剩余时间

  _ChessPlayDoubleRouteState(this.isRobot) {
    needAppBar = false;
  }

  bool bottomIsRed = true; //下面是否是红色方

  int redMaxTime = maxTime; //红棋剩余时间
  int blackMaxTime = maxTime; //黑棋剩余时间
  TimerUtil timerUtil;
  bool isRedChange = true;
  DateTime startTime; //结束时间
  DateTime endTime; //开始时间
  int gameAllTime = 0; //游戏总时长

  @override
  void initState() {
    super.initState();
    ChessStartIndex.init(isRobot,);
    initChange();
    initTime();
  }

  void initChange() {
    if (isRobot) {
      isRedChange = ChessStartIndex.redChangeRobot;
    } else {
      isRedChange = ChessStartIndex.redChange;
    }
  }

  void initTime() {
    bottomIsRed = isRobot ? ChessStartIndex.bottomIsRedRobot : ChessStartIndex.bottomIsRed;
    redMaxTime = maxTime;
    blackMaxTime = maxTime;
    startTime = DateTime.now();
    gameAllTime = 0;
    _startTimer();
  }

  void _startTimer() {
    if (timerUtil == null) {
      timerUtil = TimerUtil();
      timerUtil.setInterval(1000); //设置时间间隔1s
      timerUtil.setOnTimerTickCallback((time){ //回调
        setState(() {
          if(isRedChange) {
            redMaxTime--;
          } else {
            blackMaxTime--;
          }
          gameAllTime++;
          if (redMaxTime == 0) {
            ChessStartIndex.finish(isRobot, "黑棋");
            showToast("黑棋胜利");
            _cancelTimer();
          }
          if (blackMaxTime == 0) {
            ChessStartIndex.finish(isRobot, "红棋");
            showToast("红棋胜利");
            _cancelTimer();
          }
        });

      });
    }
    timerUtil.startTimer();
  }

  void _cancelTimer() {
    if (timerUtil != null && timerUtil.isActive()) { //timerUtil不为空且timerUtil是启动状态
      timerUtil.cancel();
    }
  }

  void doGameOver(bool showHint, String reason) async {
    endTime = DateTime.now();
    ChessGameInfoBeanEntity chessInfo = ChessGameInfoBeanEntity(
      winner: ChessStartIndex.winner,
      bottomIsRed: bottomIsRed,
      gameType: isRobot ? "人机对战" : "双人对战",
      reason: reason,
      allGameTime: gameAllTime,
      startTime: startTime.toString().substring(0, startTime.toString().indexOf(".")),
      endTime: endTime.toString().substring(0, endTime.toString().indexOf(".")),
    );
    ChessGameInfoDao().insertData(chessInfo);
    _cancelTimer();
    if (showHint) {
      await showCenterDialog(context, ChessWinDialog(winner: ChessStartIndex.winner,));
    }
    ChessStartIndex.init(isRobot, reStart: true);
    initTime();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Util.getImgPath("ico_chess_background")),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(Util.getImgPath(ChessStartIndex.bottomIsRed ? "ico_chess_red_head" : "ico_chess_black_head"), width: 25.0,),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(Util.getImgPath("ico_chess_vs"), width: 25.0,),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(Util.getImgPath(ChessStartIndex.bottomIsRed ? "ico_chess_black_head" : "ico_chess_red_head"), width: 25.0,),
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap10,
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "时间:",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: ChessStartIndex.bottomIsRed ? MyColors.chess_text_color : Colors.black,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${ChessStartIndex.bottomIsRed ? redMaxTime : blackMaxTime}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.main_color,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "秒",
                                    style: TextStyle(
                                      color: ChessStartIndex.bottomIsRed ? MyColors.chess_text_color :Colors.black,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "时间:",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: ChessStartIndex.bottomIsRed ? Colors.black : MyColors.chess_text_color,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${ChessStartIndex.bottomIsRed ? blackMaxTime : redMaxTime}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MyColors.main_color,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "秒",
                                    style: TextStyle(
                                      color: ChessStartIndex.bottomIsRed ? Colors.black : MyColors.chess_text_color,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ChineseChessCheckerboard(),
                  ChineseChessPieces(
                    isRobot: isRobot,
                    onChange: (){
                      initChange();
                      if (isRobot) {
                        if (ChessStartIndex.isFinishRobot) {
                          doGameOver(true, "主将被吃");
                        }
                      } else {
                        if (ChessStartIndex.isFinish) {
                          doGameOver(true, "主将被吃");
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          ChessStartIndex.finish(isRobot, "重开局");
                          doGameOver(false, "重开局");
                          setState(() {

                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                Util.getImgPath("ico_chess_bt_bg"),
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "重开",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          ChessStartIndex.finish(isRobot, "平局");
                          doGameOver(true, "和棋");
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                Util.getImgPath("ico_chess_bt_bg"),
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "求和",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          ChessStartIndex.finish(isRobot, bottomIsRed ? "黑棋" : "红棋");
                          doGameOver(true, "认输");
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                Util.getImgPath("ico_chess_bt_bg"),
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Text(
                            "认输",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
