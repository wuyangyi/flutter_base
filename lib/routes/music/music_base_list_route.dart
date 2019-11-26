import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:provider/provider.dart';

import 'music_play.dart';


abstract class MusicBaseListRoute extends BaseListRoute {
  const MusicBaseListRoute({Key key}) : super(key: key);
}

abstract class MusicBaseRouteState<T extends BaseListRoute, D extends BaseBean, B extends BlocListBase> extends BaseListRouteState<T, D, B> {

  PlayMusicInfoModel musicInfoModel;

  @override
  void initState() {
    super.initState();
    musicInfoModel = Provider.of<PlayMusicInfoModel>(context, listen: false);
  }

  @override
  Widget getBottomNavigationBar() {
    return GestureDetector(
      onTap: (){
        NavigatorUtil.pushPageByRoute(context, MusicPlayRoute());
      },
      child: Container(
        width: double.infinity,
        height: 50.0,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                Util.getImgPath("ico_music_default"),
                width: 35.0,
                height: 35.0,
              ),
            ),
            Gaps.hGap10,
            Expanded(
              flex: 1,
              child: Text(
                musicInfoModel.playMusicInfo.musicName ?? "小小音乐",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 14.0,
                ),
              ),
            ),

            Gaps.hGap10,

            GestureDetector(
              onTap: (){
                setState(() {
                  musicInfoModel.upPlayState(!musicInfoModel.playMusicInfo.isPlaying);
                });
              },
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: MyColors.loginDriverColor,
                  borderRadius: BorderRadius.circular(360.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  musicInfoModel.playMusicInfo.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 18.0,
                  color: MyColors.title_color,
                ),
              ),
            ),

            GestureDetector(
              onTap: (){

              },
              child: Container(
                width: 25.0,
                height: 25.0,
                margin: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: MyColors.loginDriverColor,
                  borderRadius: BorderRadius.circular(360.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.skip_next,
                  size: 18.0,
                  color: MyColors.title_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
