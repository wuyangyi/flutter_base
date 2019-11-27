import 'package:flutter/material.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';

import 'music_base_route.dart';

class MyCollectRoute extends MusicBaseRoute {
  @override
  _MyCollectRouteState createState() => _MyCollectRouteState();
}

class _MyCollectRouteState extends MusicBaseRouteState<MyCollectRoute> {

  _MyCollectRouteState() {
    title = "我的收藏";
    appBarElevation = 0.0;
  }

  MyLikeMusicModel myLikeMusicModel;


  @override
  void initState() {
    super.initState();
    myLikeMusicModel = Provider.of<MyLikeMusicModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: myLikeMusicModel.myLikeList.isEmpty ? StatusView(
        status: Status.empty,
        enableEmptyClick: false,
      ) : ListView.separated(
        padding: EdgeInsets.all(0.0),
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0,
            margin: EdgeInsets.only(left: 10.0),
            color: MyColors.loginDriverColor,
          );
        },
        itemCount: myLikeMusicModel.myLikeList.length,
        itemBuilder: (context, index){
          return Ink(
            child: InkWell(
              onTap: (){
                musicInfoModel.setMusicInfo(new PlayMusicInfo(
                  musicPath: myLikeMusicModel.myLikeList[index].path,
                  uri: myLikeMusicModel.myLikeList[index].uri,
                  musicName: Util.getMusicName(myLikeMusicModel.myLikeList[index].fileName),
                  singer: Util.getSingerName(myLikeMusicModel.myLikeList[index].fileName),
                  fileName: myLikeMusicModel.myLikeList[index].fileName,
                  isPlaying: true,
                  isLocal: true,
                ));
                musicInfoModel.setMusicList(myLikeMusicModel.myLikeList);
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
                      height: 30.0,
                      alignment: Alignment.center,
                      child: musicInfoModel.playMusicInfo.musicPath == myLikeMusicModel.myLikeList[index].path ?
                      Icon(Icons.volume_up, color: MyColors.main_color, size: 18.0,) :
                      Text("${index + 1}",
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
                        myLikeMusicModel.myLikeList[index].fileName,
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
        },
      ),
    );
  }

}
