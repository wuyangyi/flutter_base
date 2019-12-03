import 'package:flutter/material.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:provider/provider.dart';

class ViewMonthCalendar extends StatefulWidget {
  final int year;
  final int month;

  ViewMonthCalendar(this.year, this.month);
  @override
  _ViewMonthCalendarState createState() => _ViewMonthCalendarState(year, month);
}

class _ViewMonthCalendarState extends State<ViewMonthCalendar> {

  _ViewMonthCalendarState(this.year, this.month);

  int year;
  int month;

  static int selectDay = DateTime.now().day; //选中的哪天 默认day为今天

  int maxDay = 30; //最大天数
  int startEmpty; //1号的前面空几个

  DateTime nowTime = DateTime.now();

  RunWeekModel runWeekModel;
  List<RunInfoBeanEntity> _listRun = [];

  @override
  void initState() {
    super.initState();
    runWeekModel = Provider.of<RunWeekModel>(context, listen: false);
    maxDay = Util.getMaxDay(year, month);
    DateTime dateTime = new DateTime(year, month, 1);
    startEmpty = getStartEmpty(dateTime.weekday);
    if (selectDay > Util.getMaxDay(year, month)) {
      selectDay = Util.getMaxDay(year, month);
    }
    initList();
  }

  void initList() {
    _listRun = runWeekModel.findAllByTime(year, month, selectDay);
  }

  int getStartEmpty(int week) {
    int t = 0;
    if (week < 7) {
      t = week;
    }
    return t;
  }

  //获得背景色
  Color getIndexBgColor(int index) {
    Color color = Colors.transparent;
    if (index - startEmpty + 1 == selectDay) { //当前选中
      if (nowTime.year == year && nowTime.month == month && nowTime.day == selectDay) { //选中的为今天
        color = MyColors.main_color;
      } else {
        color = Color(0x607C4DFF);
      }
    }
    return color;
  }

  //获得字体色
  Color getIndexColor(int index) {
    Color color = MyColors.title_color;
    if (index - startEmpty + 1 == selectDay) { //当前选中
      if (nowTime.year == year && nowTime.month == month && nowTime.day == selectDay) { //选中的为今天
        color = Colors.white;
      }
    } else {
      if (nowTime.year == year && nowTime.month == month && nowTime.day == index - startEmpty + 1) { //选中的为今天
        color = MyColors.main_color;
      }
    }
    return color;
  }

  //获得字底部指示器颜色
  Color getIndexShowColor(int index) {
    Color color = MyColors.main_color;
    if (index - startEmpty + 1 == selectDay) { //当前选中
      if (nowTime.year == year && nowTime.month == month && nowTime.day == selectDay) { //选中的为今天
        color = Colors.white;
      }
    } else {
      if (nowTime.year == year && nowTime.month == month && nowTime.day == index - startEmpty + 1) { //选中的为今天
        color = MyColors.main_color;
      }
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          width: double.infinity,
          height: (DataConfig.appSize.width - 20) / 7 * 6,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: maxDay + startEmpty,
            itemBuilder: (context, index) {
              return index < startEmpty ?
              Container() :
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectDay = index - startEmpty + 1;
                    initList();
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: getIndexBgColor(index),
                      borderRadius: BorderRadius.circular(360.0)
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Text(
                        "${index - startEmpty + 1}",
                        style: TextStyle(
                            color: getIndexColor(index),
                            fontSize: 15.0
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: runWeekModel.findAllByTime(year, month, index - startEmpty + 1).length > 0 ? Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 3.0,
                            height: 3.0,
                            decoration: BoxDecoration(
                              color: getIndexShowColor(index),
                              borderRadius: BorderRadius.circular(360)
                            ),
                          ),
                        ) : Container(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          margin: EdgeInsets.only(top: 10.0),
          color: MyColors.top_bg,
        ),
        Column(
          children: _listRun.map((item){
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Util.randomColor(),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  Gaps.hGap15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "开始:${item.startDate.substring(11, 19)}",
                        style: TextStyle(
                          color: MyColors.text_normal,
                          fontSize: 12.0
                        ),
                      ),
                      Gaps.vGap5,
                      Text(
                        "结束:${item.endDate.substring(11, 19)}",
                        style: TextStyle(
                            color: MyColors.text_normal,
                            fontSize: 12.0
                        ),
                      ),
                    ],
                  ),
                  Gaps.hGap15,
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${(item.path).toStringAsFixed(2)}公里",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MyColors.title_color,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Text(
                    "${getTime(item.time)}",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String getTime(int time) {
    int hh = time ~/ 3600;
    int mm = time % 3600 ~/ 60;
    int ss = time % 60;
    String timeS = "";
    if (hh != 0) {
      timeS += "$hh时";
    }
    if (hh != 0 && mm != 0) {
      timeS += "$mm分";
    }
    timeS += "$ss秒";
    return timeS;
  }
}
