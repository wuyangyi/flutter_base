import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/res/index.dart';

class TallyRoute extends BaseRoute {
  final BuildContext parentContext;

  TallyRoute(this.parentContext);
  @override
  _TallyRouteState createState() => _TallyRouteState();
}

class _TallyRouteState extends BaseRouteState<TallyRoute> {
  _TallyRouteState(){
    needAppBar = true;
    title = "我的账本";
    leading = Container();
  }
  DateTime nowDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${nowDate.month}月收入",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: MyColors.text_normal,
                          ),
                        ),
                        Gaps.vGap10,
                        Text(
                          "0.00",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: MyColors.title_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  height: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  color: MyColors.loginDriverColor,
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${nowDate.month}月支出",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: MyColors.text_normal,
                          ),
                        ),
                        Gaps.vGap10,
                        Text(
                          "0.00",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: MyColors.title_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
