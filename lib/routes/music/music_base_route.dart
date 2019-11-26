import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:provider/provider.dart';

import 'music_play.dart';


abstract class MusicBaseRoute extends BaseRoute {
  const MusicBaseRoute({Key key}) : super(key: key);
}

abstract class MusicBaseRouteState<T extends MusicBaseRoute> extends BaseRouteState<T> {

  PlayMusicInfoModel musicInfoModel;
  List<FileInfoBean> musicList;

  @override
  void initState() {
    super.initState();
    musicInfoModel = Provider.of<PlayMusicInfoModel>(context, listen: false);
    musicList = musicInfoModel.playList;
    bus.on(EventBusString.MUSIC_PLAY_STATE, (state){
      if(state == AudioPlayerState.COMPLETED) {
        onStopPlay();
        if (musicInfoModel.playMusicInfo.playType == PlayMusicInfo.PLAY_STATUE_RANDOM) {
          randomMusic();
        } else if (musicInfoModel.playMusicInfo.playType == PlayMusicInfo.PLAY_STATUE_LIST) {
          nextMusic();
        } else {
          musicInfoModel.upPlayState(!musicInfoModel.playMusicInfo.isPlaying);
        }
      }
      setState(() {

      });
    });
  }

  //停止播放
  void onStopPlay() {

  }

  //随机播放
  void randomMusic() {
    if (musicList.isEmpty) {
      showToast("暂无歌曲");
      return;
    }
    int index = Random().nextInt(musicList.length-1);
    musicInfoModel.setMusicInfo(new PlayMusicInfo(
      musicPath: musicList[index].path,
      uri: musicList[index].uri,
      musicName: Util.getMusicName(musicList[index].fileName),
      singer: Util.getSingerName(musicList[index].fileName),
      fileName: musicList[index].fileName,
      isPlaying: true,
      isLocal: true,
    ));
    setState(() {

    });
  }

  //下一首
  void nextMusic(){
    if (musicList.isEmpty) {
      showToast("暂无歌曲");
      return;
    }
    int index = 0;
    for (int i = 0; i < musicInfoModel.playList.length; i++) {
      if(musicInfoModel.playList[i].path == musicInfoModel.playMusicInfo.musicPath) {
        if (i >= musicInfoModel.playList.length - 1) {
          index = 0;
        } else {
          index = i+1;
        }
      }
    }
    musicInfoModel.setMusicInfo(new PlayMusicInfo(
      musicPath: musicList[index].path,
      uri: musicList[index].uri,
      musicName: Util.getMusicName(musicList[index].fileName),
      singer: Util.getSingerName(musicList[index].fileName),
      fileName: musicList[index].fileName,
      isPlaying: true,
      isLocal: true,
    ));
    setState(() {

    });
  }

  //上一首
  void lastMusic(){
    if (musicList.isEmpty) {
      showToast("暂无歌曲");
      return;
    }
    int index = 0;
    for (int i = 0; i < musicInfoModel.playList.length; i++) {
      if(musicInfoModel.playList[i].path == musicInfoModel.playMusicInfo.musicPath) {
        if (i <= 0) {
          index = musicInfoModel.playList.length - 1;
        } else {
          index = i-1;
        }
      }
    }
    musicInfoModel.setMusicInfo(new PlayMusicInfo(
      musicPath: musicList[index].path,
      uri: musicList[index].uri,
      musicName: Util.getMusicName(musicList[index].fileName),
      singer: Util.getSingerName(musicList[index].fileName),
      fileName: musicList[index].fileName,
      isPlaying: true,
      isLocal: true,
    ));
    setState(() {

    });

  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.MUSIC_PLAY_STATE);
  }

  @override
  Widget getBottomNavigationBar() {
    return GestureDetector(
      onTap: (){
        if (musicInfoModel.playMusicInfo.musicPath == null) {
          showToast("暂无歌曲");
        } else {
          NavigatorUtil.pushPageByRoute(context, MusicPlayRoute());
        }
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
                musicInfoModel?.playMusicInfo?.fileName ?? "小小音乐",
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
                if (musicInfoModel.playMusicInfo.musicPath == null) {
                  showToast("暂无歌曲");
                  return;
                }
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
                if (musicInfoModel.playMusicInfo.playType == PlayMusicInfo.PLAY_STATUE_RANDOM) {
                  randomMusic();
                } else if (musicInfoModel.playMusicInfo.playType == PlayMusicInfo.PLAY_STATUE_LIST) {
                  nextMusic();
                }
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
