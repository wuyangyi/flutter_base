import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/chess/chess_rule.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';

import 'chess_list_info_route.dart';
import 'chess_play_double_route.dart';

class ChineseChessHomeRoute extends BaseRoute {
  @override
  _ChineseChessHomeRouteState createState() => _ChineseChessHomeRouteState();
}

class _ChineseChessHomeRouteState extends BaseRouteState<ChineseChessHomeRoute> {

  _ChineseChessHomeRouteState() {
    needAppBar = false;
  }

  @override
  void initState() {
    super.initState();
    ChessStartIndex.initImages();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, ChessPlayDoubleRoute(false));
              },
              child: Container(
                width: double.infinity,
                height: 50.0,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
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
                  "双人对决",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, ChessPlayDoubleRoute(true));
//                showToast("正在建设中");
              },
              child: Container(
                width: double.infinity,
                height: 50.0,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
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
                  "人机对决",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, ChessListInfoRoute());
              },
              child: Container(
                width: double.infinity,
                height: 50.0,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
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
                  "历史对局",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
