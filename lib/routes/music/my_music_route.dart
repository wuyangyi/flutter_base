import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/bean/music/home_menu_item_bean.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/music/search_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'local_music_route.dart';
import 'music_base_route.dart';

class MyMusicRoute extends MusicBaseRoute {
  @override
  _MyMusicRouteState createState() => _MyMusicRouteState();
}

class _MyMusicRouteState extends MusicBaseRouteState<MyMusicRoute> {

  _MyMusicRouteState() {
    title = "本地歌曲";
    titleBarBg = Colors.white;
    titleColor = MyColors.title_color;
    appBarElevation = 0.0;
    bodyColor = MyColors.home_bg;
    statusTextDarkColor = false;
    setRightButtonFromIcon(Icons.create_new_folder);
  }

  LocalMusicModel localMusicModel;

  int index = 0;


  @override
  void onRightButtonClick() {
    NavigatorUtil.pushPageByRoute(context, LocalMusicRoute());
  }


  @override
  void initState() {
    super.initState();
    localMusicModel = Provider.of<LocalMusicModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    index = 0;
    return buildBody(
      context,
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          GestureDetector(
            onTap: (){
              NavigatorUtil.pushPageByRoute(context, MusicSearchRoute());
            },
            child: Container(
              width: double.infinity,
              height: 30.0,
              margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.0),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.center,
                    child: Image.asset(
                      Util.getImgPath("ico_search_gray"),
                      width: 13.0,
                    ),
                  ),
                  Text(
                    "搜索更多歌曲~",
                    style: TextStyle(
                      color: MyColors.search_hint_color,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Ink(
            child: InkWell(
              onTap: (){
                if (localMusicModel.fileInfoBean.length == 0) {
                  return;
                }
                musicInfoModel.setMusicInfo(new PlayMusicInfo(
                  musicPath: localMusicModel.fileInfoBean[0].path,
                  uri: localMusicModel.fileInfoBean[0].uri,
                  musicName: Util.getMusicName(localMusicModel.fileInfoBean[0].fileName),
                  singer: Util.getSingerName(localMusicModel.fileInfoBean[0].fileName),
                  fileName: localMusicModel.fileInfoBean[0].fileName,
                  isPlaying: true,
                  isLocal: true,
                ));
                musicInfoModel.setMusicList(localMusicModel.fileInfoBean);
                setState(() {

                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_filled,
                      color: MyColors.main_color,
                    ),
                    Gaps.hGap10,
                    Text(
                      "播放全部",
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: localMusicModel.fileInfoBean.map((item){
              index++;
              return Ink(
                child: InkWell(
                  onTap: (){
                    musicInfoModel.setMusicInfo(new PlayMusicInfo(
                      musicPath: item.path,
                      uri: item.uri,
                      musicName: Util.getMusicName(item.fileName),
                      singer: Util.getSingerName(item.fileName),
                      fileName: item.fileName,
                      isPlaying: true,
                      isLocal: true,
                    ));
                    musicInfoModel.setMusicList(localMusicModel.fileInfoBean);
                    setState(() {

                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10.0, top: 12.0, bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 30.0,
                          alignment: Alignment.center,
                          child: musicInfoModel.playMusicInfo.musicPath == item.path ?
                          Icon(Icons.volume_up, color: MyColors.main_color, size: 18.0,) :
                          Text("$index",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Gaps.hGap5,
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.fileName,
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        ],
      )
    );
  }
}
