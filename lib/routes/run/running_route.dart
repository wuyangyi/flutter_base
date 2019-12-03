import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/run/RunInfoDao.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/color.dart';
import 'package:provider/provider.dart';



class RunningRoute extends BaseRoute {
  @override
  _RunningRouteState createState() => _RunningRouteState();
}

class _RunningRouteState extends BaseRouteState<RunningRoute> with SingleTickerProviderStateMixin {
  bool _showTime = true;
  int _showNumber = 3;
  double _textSize = 0;

  Animation<double> animation;
  AnimationController controller;

  RunWeekModel runWeekModel;

  bool needAdd = false;
  double _maxTextSize = 100.0;

  static const myEventPlugin = const EventChannel("com.example.flutter_base/event_plugin");
  StreamSubscription _streamSubscription;

  _RunningRouteState(){
    needAppBar = false;
  }

  @override
  void initState() {
    super.initState();
    runWeekModel = Provider.of<RunWeekModel>(context, listen: false);
    _streamSubscription = myEventPlugin.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = new Tween(begin: 0.0, end: _maxTextSize).animate(controller)
      ..addListener(() {

        setState(() {
          _textSize = animation.value;
          if (animation.value > _maxTextSize / 2 && !needAdd) {
            needAdd = true;
          }
          if(needAdd && animation.value < _maxTextSize / 2) {
            needAdd = false;
            _showNumber--;
            if (_showNumber < 1) {
              _showTime = false;
              controller.stop();
            }
          }
        });
      });
    controller.repeat();
  }

  //回调成功
  void _onEvent(Object event) {
    print("返回结果: ${event.toString()}");

    RunInfoBeanEntity runInfoBeanEntity = RunInfoBeanEntity.fromJson(json.decode(event.toString()));
    runInfoBeanEntity.initTime();
    runInfoBeanEntity.userId = user.id;
    if (runInfoBeanEntity.path < 0.01) {
      showToast("运动距离过短~");
      finish(data: false);
    } else {
      showWaitDialog();
      RunInfoDao().insertData(runInfoBeanEntity, onCallBack: (id) {
        runWeekModel.add(runInfoBeanEntity);
        hideWaitDialog();
        finish(data: true);
      });
    }

  }

  //异常
  void _onError(Object error) {
    print("返回异常: ${error.toString()}");
  }

  @override
  void dispose() {
    controller.dispose();
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new AndroidView(viewType: "MapView"),

          Offstage(
            offstage: !_showTime,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              color: MyColors.home_bg,
              child: Text(
                "$_showNumber",
                style: TextStyle(
                  color: MyColors.main_color,
                  fontSize: _textSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
