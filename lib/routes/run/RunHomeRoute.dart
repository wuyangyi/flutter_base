import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/run/week_run_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/run/running_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'calendar_route.dart';

class RunHomeRoute extends BaseRoute {
  @override
  _RunHomeRouteState createState() => _RunHomeRouteState();
}

class _RunHomeRouteState extends BaseRouteState<RunHomeRoute> {
  static const myPlugin = const MethodChannel('com.example.flutter_base/plugin');

  _RunHomeRouteState(){
    needAppBar = false;
    bodyColor = Colors.white;
  }

  RunWeekModel runWeekModel;

  List<WeekRunBeanEntity> weekRunList;

  @override
  void initState() {
    super.initState();
    runWeekModel = Provider.of<RunWeekModel>(context, listen: false);
    initWeekData();
  }

  void initWeekData() {
    weekRunList =
    [
      WeekRunBeanEntity(week: "一", distance: runWeekModel.getOneDayAllPath("一")),
      WeekRunBeanEntity(week: "二", distance: runWeekModel.getOneDayAllPath("二")),
      WeekRunBeanEntity(week: "三", distance: runWeekModel.getOneDayAllPath("三")),
      WeekRunBeanEntity(week: "四", distance: runWeekModel.getOneDayAllPath("四")),
      WeekRunBeanEntity(week: "五", distance: runWeekModel.getOneDayAllPath("五")),
      WeekRunBeanEntity(week: "六", distance: runWeekModel.getOneDayAllPath("六")),
      WeekRunBeanEntity(week: "日", distance: runWeekModel.getOneDayAllPath("日")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          AppStatusBar(
            buildContext: context,
            color: Colors.white,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
            decoration: Decorations.bottom,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${user?.name ?? user?.phone}",
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 16.0,
                        ),
                      ),
                      Gaps.vGap5,
                      Text(
                        "本周运动数据",
                        style: TextStyle(
                          color: MyColors.buttonNoSelectColor,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  child: Icon(
                    Icons.insert_invitation,
                    color: MyColors.title_color,
                  ),
                  onTap: (){
                    NavigatorUtil.pushPageByRoute(context, CalendarRoute());
                  },
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(width: 0.5, color: MyColors.loginDriverColor),
                        ),
                        child: Text(
                          "运动里程过少将不会计入有效次数",
                          style: TextStyle(
                            color: MyColors.text_normal,
                            fontSize: 10.0
                          ),
                        ),
                      ),

                    ),
                  ),
                  Container(
                    width: DataConfig.appSize.width / 2,
                    height: DataConfig.appSize.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360.0),
                      border: Border.all(width:5.0, color: MyColors.home_body_bg),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "累计里程（公里）",
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 12.0,
                          ),
                        ),
                        Gaps.vGap15,
                        Text(
                          "${runWeekModel.getAllWeekPath()}",
                          style: TextStyle(
                            color: MyColors.main_color,
                            fontSize: 30.0,
                          ),
                        ),
                        Gaps.vGap10,
                        Text(
                          "跑步次数:${runWeekModel.getAllRunNumber()}",
                          style: TextStyle(
                            color: MyColors.buttonNoSelectColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        height: 45.0,
                        width: 150.0,
                        child: FinishButton(
                          text: "进入跑步",
                          radios: 25.0,
                          onTop: () async {
                            initMap();
                            bool need = await NavigatorUtil.pushPageByRoute(context, RunningRoute());
                            if (need) {
                              setState(() {
                                initWeekData();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom:30.0, left: 10.0, right: 10.0),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: weekRunList.map((item){
                return Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360.0),
                          border: Border.all(width:2.5, color: item.distance > 0 ? MyColors.main_color : MyColors.home_body_bg),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${item.week}",
                          style: TextStyle(
                            color: item.distance > 0 ? MyColors.main_color : MyColors.lineColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Gaps.vGap10,
                      Text(
                        "${item.distance}",
                        style: TextStyle(
                          color: item.distance > 0 ? MyColors.main_color : MyColors.lineColor,
                          fontSize: 10.0
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  //调用android原生 地图开始定位并传递用户id
  void initMap() async {
    Map<String, Object> map = {"userId": user.id};
    String result = await myPlugin.invokeMethod("start_location", map);
  }
}
