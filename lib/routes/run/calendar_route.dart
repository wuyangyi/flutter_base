import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/run/view_month_calendar.dart';
import 'package:flutter_base/utils/utils.dart';

class CalendarRoute extends BaseRoute {
  @override
  _CalendarRouteState createState() => _CalendarRouteState();
}

class _CalendarRouteState extends BaseRouteState<CalendarRoute> {

  _CalendarRouteState(){
    title = "";
    setLeading(new IconButton(
      key: key_btn_left,
      icon: Image.asset(Util.getImgPath("icon_back_black"), height: 20.0,),
      onPressed: (){
        onLeftButtonClick();
      },
    ),);
    appBarElevation = 0.0;
    titleBarBg = MyColors.top_bg;
    statusTextDarkColor = false;
  }

  List<String> weeks = ["日", "一", "二", "三", "四", "五", "六"];
  PageController _pageController;

  int year; //当前年
  int month; //当前月

  int selectIndex;

  int nowIndex;

  bool notNeedSx = false;
//  int _selectYearIndex;
//  List<String> years = [];

  @override
  void initState() {
    super.initState();
    DateTime nowTime = DateTime.now();
    year = nowTime.year;
    month = nowTime.month;
    selectIndex = 1;
    nowIndex = selectIndex;
    getPage();
    _pageController = new PageController(
        initialPage: selectIndex
    );

//    initYear();
  }

//  void initYear() {
//    _selectYearIndex = 50;
//    for (int i = year - 50; i < year + 50; i++) {
//      years.add("$i年");
//    }
//  }

//  @override
//  Widget getTitleWidget() {
//    return GestureDetector(
//      onTap: () async {
//        int index = await showModalBottomSheetUtil(context, WheelRollDialog(
//          centerTitle: "年份选择",
//          list: years,
//          selectIndex: _selectYearIndex,
//        ));
//        if (index != null && index != -1) {
//          _selectYearIndex = index;
//          setState(() {
//            year = int.parse(years[_selectYearIndex].substring(0, years[_selectYearIndex].length - 1));
//            getPage();
//          });
//        }
//      },
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.center,
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Text(
//            "$year年",
//            style: TextStyle(
//              color: MyColors.main_color,
//              fontSize: 16.0,
//            ),
//          ),
//          Gaps.hGap5,
//          Icon(
//            Icons.arrow_drop_down,
//            size: 20.0,
//            color: MyColors.main_color,
//          ),
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(bottom: 10.0),
            color: MyColors.top_bg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if (selectIndex > 0) {
                      _pageController.animateToPage(selectIndex - 1, duration: Duration(microseconds: 1000), curve: Curves.linearToEaseOut);
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    "$year年${month < 10 ? '0$month' : month}月",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 15.0
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(selectIndex < _pages.length - 1) {
                      _pageController.animateToPage(selectIndex + 1, duration: Duration(microseconds: 1000), curve: Curves.linearToEaseOut);
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 10.0),
//            color: MyColors.top_bg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: weeks.map((item){
                return Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 12.0
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            flex: 1,
            child: NotificationListener(
              onNotification: (ScrollEndNotification e){
                if (nowIndex == selectIndex || notNeedSx) {
                  notNeedSx = false;
                  return false;
                }
                if (selectIndex > nowIndex) { //右滑到上个月
                  if (month == 1) {
                    year--;
                    month = 12;
                  } else {
                    month--;
                  }
                  notNeedSx = true;
                } else if (selectIndex < nowIndex) { //左滑到下个月
                  if (month == 12) {
                    year++;
                    month = 1;
                  } else {
                    month++;
                  }
                  notNeedSx = true;
                }
                setState(() {
                  getPage();
                });
                new Future.delayed(new Duration(milliseconds: 50)).then((e){
                  _pageController.jumpToPage(1);
                });

                return true;
              },
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(parent: const BouncingScrollPhysics()),
                onPageChanged: (index){
                  nowIndex = index;
                },
                children: _pages.map((page){
                  return page;
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _pages = [];

  void getPage() {
    int lastYear = year;
    int lastMonth = month - 1;
    int nextYear = year;
    int nextMonth = month + 1;
    if (lastMonth == 0) {
      lastMonth = 12;
      lastYear--;
    }
    if (nextMonth == 13) {
      nextMonth = 1;
      nextYear++;
    }

    _pages.clear();
    _pages = [
      ViewMonthCalendar(lastYear, lastMonth),
      ViewMonthCalendar(year, month),
      ViewMonthCalendar(nextYear, nextMonth),
    ];

//    for(int i = 1; i < 13; i++) {
//      _pages.add(ViewMonthCalendar(year, i));
//    }
  }
}
