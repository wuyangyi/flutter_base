import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/chess/chess_game_info_bean_entity.dart';
import 'package:flutter_base/bean/dao/chess/ChessGameInfoDao.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';

class ChessListInfoRoute extends BaseRoute {
  @override
  _ChessListInfoRouteState createState() => _ChessListInfoRouteState();
}

class _ChessListInfoRouteState extends BaseRouteState<ChessListInfoRoute> {

  _ChessListInfoRouteState(){
    title = "对局列表";
    showStartCenterLoading = true;
  }

  List<ChessGameInfoBeanEntity> mListData = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await ChessGameInfoDao().findData(onCallBack: (data){
      mListData = data;
      setState(() {

        if (mListData.isEmpty) {
          loadStatus = Status.empty;
        } else{
          loadStatus = Status.success;
        }
      });
      print("loadStatus:$loadStatus");
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView.separated(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: mListData.length,
        separatorBuilder: (context, index){
          return Container(
            width: double.infinity,
            height: 0.5,
            margin: EdgeInsets.only(left: 15.0),
            color: MyColors.lineColor,
          );
        },
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key("key_${mListData[index].id}"),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              String centerHint = "是否删除该记录？";
              bool isDismiss = false;
              int i = await showCenterDialog(context, CenterHintDialog(text: centerHint,));
              if (i == 1) {
                isDismiss = true;
              }
              return isDismiss;
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              color: MyColors.home_bg,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        mListData[index].gameType,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.hGap10,
                      Image.asset(
                        Util.getImgPath(getImageName(mListData[index].winner)),
                        width: 25.0,
                      ),
                      Gaps.hGap10,
                      mListData[index].collect ? Icon(Icons.grade, color: Colors.green,size: 20.0,) : Container(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          getWinner(mListData[index].winner, mListData[index].bottomIsRed),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: getWinnerColor(mListData[index].winner, mListData[index].bottomIsRed),
                            fontSize: 13.0,
                          ),
                        )
                      ),

                    ],
                  ),
                  Gaps.vGap5,
                  Text(
                    "结束原因：${mListData[index].reason}",
                    style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 11.0,
                    ),
                  ),
                  Gaps.vGap5,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "总时长：${mListData[index].allGameTime ~/ 60 > 0 ? '${mListData[index].allGameTime ~/ 60}分' : ''}${mListData[index].allGameTime % 60}秒",
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 14.0,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "开始时间：${getTime(mListData[index].startTime)}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            onDismissed: (direction){
              if (direction == DismissDirection.endToStart) { //删除
                ChessGameInfoDao().deleteById(mListData[index].id);
                if (mListData.contains(mListData[index])) {
                  setState(() {
                    mListData.remove(mListData[index]);
                  });
                }
              }
            },
          );
        },
      ),
    );
  }

  String getImageName(String winner) {
    String image = "chess/ico_qizi";
    if (winner == "黑棋") {
      image = "ico_chess_black_head";
    } else if (winner == "红棋") {
      image = "ico_chess_red_head";
    }
    return image;
  }


  String getWinner(String winner, bool bottomIsRed) {
    String win = winner;
    if ((winner == "红棋" && bottomIsRed) || (winner == "黑棋" && !bottomIsRed)) {
      win = "胜利";
    }
    if ((winner == "红棋" && !bottomIsRed) || (winner == "黑棋" && bottomIsRed)) {
      win = "失败";
    }
    return win;
  }

  Color getWinnerColor(String winner, bool bottomIsRed) {
    Color color = MyColors.main_color;
    if ((winner == "红棋" && bottomIsRed) || (winner == "黑棋" && !bottomIsRed)) {
      color = Colors.green;
    }
    if ((winner == "红棋" && !bottomIsRed) || (winner == "黑棋" && bottomIsRed)) {
      color = Colors.red;
    }
    return color;
  }

  String getTime(String time) {
    String t = time;
    DateTime dateTime = DateTime.parse(time);
    DateTime nowTime = DateTime.now();
    if (dateTime.year == nowTime.year) {
      t = time.substring(5);
      if (dateTime.month == nowTime.month && dateTime.day == nowTime.day) {
        t = "今天${time.substring(time.indexOf(" "))}";
      }
    }

    var oldDate = nowTime.add(Duration(days: -1));
    if(oldDate.year == dateTime.year && oldDate.month == dateTime.month && oldDate.day == dateTime.day) {
      t = "昨天${time.substring(time.indexOf(" "))}";
    }
    return t;
  }
}
