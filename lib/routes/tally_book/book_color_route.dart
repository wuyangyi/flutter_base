import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/widgets/VerticalText.dart';
import 'package:rxdart/rxdart.dart';

class BookColorRoute extends BaseRoute {
  final int selectIndex;

  BookColorRoute({this.selectIndex = 0});
  @override
  _BookColorRouteState createState() => _BookColorRouteState(selectIndex);
}

class _BookColorRouteState extends BaseRouteState<BookColorRoute> {
  int colorIndex = 0;
  _BookColorRouteState(this.colorIndex){
    title = "卡片颜色";
    showStartCenterLoading = false;
    bodyColor = MyColors.home_body_bg;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: DataConfig.myBookColors[colorIndex],
                  center: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              margin: EdgeInsets.only(bottom: 30.0),
              width: 100.0,
              height: 120.0,
              child: VerticalCenterTextWidget(
                width: 75,
                height: 120,
                text: "账本名称",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: DataConfig.myBookColors.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      colorIndex = index;
                    });
                    Observable.just(1).delay(new Duration(milliseconds: 200)).listen((_){
                      finish(data: index);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: DataConfig.myBookColors[index],
                        center: Alignment.centerLeft,
                        radius: .98,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                );
              },
            ),
          ]
        ),
      ),
    );
  }
}
