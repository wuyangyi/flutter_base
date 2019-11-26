import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/bean/music/music_singer_bean_entity.dart';
import 'package:flutter_base/blocs/MusicSingerBloc.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/music/search_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';

import 'music_base_list_route.dart';

class MusicSingerRoute extends MusicBaseListRoute {
  @override
  _MusicSingerRouteState createState() => _MusicSingerRouteState();
}

class _MusicSingerRouteState extends MusicBaseRouteState<MusicSingerRoute, MusicSingerBeanList, MusicSingerBloc> {


  _MusicSingerRouteState() {
    title = "歌手";
    titleBarBg = Colors.white;
    titleColor = MyColors.title_color;
    appBarElevation = 0.0;
    bodyColor = MyColors.home_bg;
    statusTextDarkColor = false;
    setRightButtonFromImage("ico_search_black");
    showStartCenterLoading = true;
  }

  @override
  void onRightButtonClick() {
    NavigatorUtil.pushPageByRoute(context, MusicSearchRoute());
  }

  @override
  getItemBuilder(BuildContext context, int index) {
    return Ink(
      child: InkWell(
        onTap: (){

        },
        child: Container(
          height: 60.0,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  "https://y.gtimg.cn/music/photo_new/T001R300x300M000${mListData[index]?.fsingerMid}.jpg?max_age=2592000",
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.fill,
                ),
              ),
              Gaps.hGap10,
              Text(
                mListData[index]?.fsingerName,
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
