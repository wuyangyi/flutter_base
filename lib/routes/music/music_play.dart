import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/res/string.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/likebtn/like_button.dart';
import 'package:flutter_base/widgets/seekbar.dart';
import 'package:flutter_base/widgets/widgets.dart';

import 'music_base_route.dart';
import 'dart:math' as math;

class MusicPlayRoute extends MusicBaseRoute {
  @override
  _MusicPlayRouteState createState() => _MusicPlayRouteState();
}

class _MusicPlayRouteState extends MusicBaseRouteState<MusicPlayRoute> with SingleTickerProviderStateMixin {

  _MusicPlayRouteState(){
    needAppBar = false;
    statusTextDarkColor = false;
    resizeToAvoidBottomInset = false;
    bodyColor = Colors.black;
  }

  Animation<double> animation;
  AnimationController controller;

  double angle = 0.0; //旋转角度

  @override
  void initState(){
    super.initState();
    controller = new AnimationController(
        duration: const Duration(seconds: 25), vsync: this);
    animation = new Tween(begin: 0.0, end: math.pi * 2).animate(controller)
      ..addListener(() {
        setState(() {
          angle = animation.value;
        });
      });
    if (musicInfoModel.playMusicInfo.isPlaying) {
      controller.repeat();
    }
    bus.on(EventBusString.MUSIC_PROGRESS, (progress){
      setState(() {
      });
    });
  }

  @override
  void onStopPlay() {
    super.onStopPlay();
    controller.stop();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    bus.off(EventBusString.MUSIC_PROGRESS);
  }

  String getTime(int time) {
    String timeString = "";
    int m = time ~/ 60;
    if (m < 10) {
      timeString = "0$m:";
    } else {
      timeString = "$m:";
    }
    int s = time % 60;
    if (s < 10) {
      timeString += "0$s";
    } else {
      timeString += "$s";
    }
    return timeString;
  }

  @override
  Widget getBottomNavigationBar() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Util.getImgPath("ico_music_play_bg")), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            AppStatusBar(
              buildContext: context,
              color: Colors.transparent,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0,),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      Util.getImgPath("icon_back_white"),
                      height: 18.0,
                    ),
                    onPressed: (){
                      onLeftButtonClick();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        musicInfoModel?.playMusicInfo?.musicName ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  LikeButton(
                    width: 55.0,
                    duration: Duration(milliseconds: 500),
                    onIconClicked: (like) {

                    },
                  )
                ],
              ),
            ),

            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 15.0,
                    height: 1.0,
                    margin: EdgeInsets.only(right: 10.0),
                    color: Colors.white70,
                  ),

                  Text(
                    musicInfoModel?.playMusicInfo?.singer ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0
                    ),
                  ),

                  Container(
                    width: 15.0,
                    height: 1.0,
                    margin: EdgeInsets.only(left: 10.0),
                    color: Colors.white70,
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    padding: EdgeInsets.all(50.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Util.getImgPath("ico_music_default"),
                        ),
                      ),
                    ),
                    child: ClipOval(
                      child: Transform.rotate(
                        angle: angle,
                        child: Image.asset(
                          Util.getImgPath("ico_logo"),
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    getTime(musicInfoModel?.playMusicInfo?.playTime ?? 0),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      alignment: Alignment.center,
                      child: MusicSeekBar(
                        value: musicInfoModel?.playMusicInfo?.value ?? 0,
                        onValueChange: (value){
                          setState(() {
                            musicInfoModel.upPlayNowTime((value * musicInfoModel?.playMusicInfo?.maxTime ?? 0).toInt());
                          });
                        },
                      ),

                    ),
                  ),
                  Text(
                    getTime(musicInfoModel?.playMusicInfo?.maxTime ?? 0),
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          getPlayTypeIcon(musicInfoModel?.playMusicInfo?.playType ?? 0),
                          color: Colors.white,
                            size: 28.0,
                        ),
                        onPressed: (){
                          int type = musicInfoModel?.playMusicInfo?.playType ?? PlayMusicInfo.PLAY_STATUE_ONE;
                          type++;
                          if (type > PlayMusicInfo.PLAY_STATUE_ONE) {
                            type = 0;
                          }
                          if (type == PlayMusicInfo.PLAY_STATUE_RANDOM) {
                            showToast("随机播放");
                          }else if(type == PlayMusicInfo.PLAY_STATUE_LIST) {
                            showToast("列表循环");
                          } else {
                            showToast("单曲循环");
                          }
                          musicInfoModel.upPlayType(type);
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: (){
                          if (musicInfoModel?.playMusicInfo?.playType == PlayMusicInfo.PLAY_STATUE_RANDOM) {
                            randomMusic();
                          } else if (musicInfoModel?.playMusicInfo?.playType == PlayMusicInfo.PLAY_STATUE_LIST) {
                            lastMusic();
                          }
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        iconSize: 45.0,
                        icon: Icon(
                          musicInfoModel.playMusicInfo.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          color: Colors.white,
                          size: 45.0,
                        ),
                        onPressed: (){
                          setState(() {
                            musicInfoModel.upPlayState(!musicInfoModel.playMusicInfo.isPlaying);
                          });
                          if (musicInfoModel.playMusicInfo.isPlaying) {
                            controller.repeat();
                          } else {
                            controller.stop();
                          }
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: (){
                          if (musicInfoModel?.playMusicInfo?.playType == PlayMusicInfo.PLAY_STATUE_RANDOM) {
                            randomMusic();
                          } else if (musicInfoModel?.playMusicInfo?.playType == PlayMusicInfo.PLAY_STATUE_LIST) {
                            nextMusic();
                          }
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.playlist_play,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        onPressed: (){},
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getPlayTypeIcon(int type) {
    if(type == null) {
      return Icons.repeat_one;
    }
    switch(type) {
      case PlayMusicInfo.PLAY_STATUE_RANDOM:
        return Icons.shuffle;
        break;
      case PlayMusicInfo.PLAY_STATUE_LIST:
        return Icons.repeat;
        break;
      case PlayMusicInfo.PLAY_STATUE_ONE:
        return Icons.repeat_one;
        break;
    }
    return Icons.repeat_one;
  }
}
