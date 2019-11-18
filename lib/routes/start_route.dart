import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'finish_user_info/finish_info_route.dart';
import 'home/home.dart';

class StartRoute extends StatefulWidget {
  @override
  _StartRouteState createState() => _StartRouteState();
}

class _StartRouteState extends State<StartRoute> with SingleTickerProviderStateMixin {
  TimerUtil timerUtil;
  int mTime = 5;
  Animation<double> animation;
  AnimationController controller;
  double rightPadding = -150.0;
//  BuildContext context;



  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    _startTimer();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = new Tween(begin: 150.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          rightPadding = -animation.value;
        });
      });
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (timerUtil == null) {
      timerUtil = TimerUtil();
      timerUtil.setInterval(1000); //设置时间间隔1s
      timerUtil.setTotalTime(5000); //总时间
      timerUtil.setOnTimerTickCallback((time){ //回调
        setState(() {
          mTime = mTime - 1;
        });
        if (mTime == 0) {
          doJumpNext();
        }
      });
    }
    timerUtil.startTimer();
  }

  //页面跳转
  void doJumpNext() {
    controller.reverse();
    Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_){
      _cancelTimer();
      if (Application.isLogin(context)) {
        Navigator.of(context).pushReplacementNamed(Ids.home);
      } else {
        //替换当前路由进入登录页面
        Navigator.of(context).pushReplacementNamed(Ids.login);
      }

    });
  }

  void _cancelTimer() {
    if (timerUtil != null && timerUtil.isActive()) { //timerUtil不为空且timerUtil是启动状态
      timerUtil.cancel();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.startBg,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Util.getImgPath("ico_start_bg")), fit: BoxFit.fill),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(Util.getImgPath("ico_start_top"), width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
                  Positioned(
                    top: 50.0,
                    right: rightPadding,
                    child: GestureDetector(
                      onTap: (){
                        doJumpNext();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        decoration: BoxDecoration(
                          color: Color(0x88000000),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0),)
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${mTime}s",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                              ),
                            ),
                            Container(
                              width: 1.0,
                              height: 10.0,
                              margin: EdgeInsets.only(left: 8.0,right: 8.0,),
                              color: Colors.white,
                            ),
                            Text(
                              "跳过",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(Util.getImgPath("ico_start_bg")), fit: BoxFit.fill),
              ),
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 35.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: AssetImage(Util.getImgPath("ico_logo"))
                        )
                    ),
                  ),
                  Center (
                    child: Text(
                      AppConfig.APP_NAME,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: MyColors.title_color,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
