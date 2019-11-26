import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/player.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constant.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller; //动画控制器
  CurvedAnimation curved; //曲线动画，动画插值，

  @override
  void initState() {
    super.initState();
    load();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    curved = CurvedAnimation(parent: controller, curve: Curves.ease);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) controller.forward(from: 0);
    });
  }

  load() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    await MusicFinder.allSongs().then((musics) {
      setState(() {
        songs = musics;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        audioPlayer.state;
      });
      switch (state) {
        case AudioPlayerState.PLAYING:
          break;

        case AudioPlayerState.PAUSED:
          break;

        case AudioPlayerState.STOPPED:
          break;

        case AudioPlayerState.COMPLETED:
          next();
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  "正在播放:",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                      fontSize: 20.0),
                ),
              ),
              Expanded(
                child: Text(
                  "${curMusic == null ? "无..." : curMusic.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                      fontSize: 18.0),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (curMusic != null) Navigator.of(context).pushNamed('/playing');
          },
          child: RotationTransition(
            turns: curved,
            child: Hero(
              tag: "albumArt",
              child: ((curMusic == null ||
                      curMusic.albumArt == null ||
                      curMusic.albumArt == ""))
                  ? Icon(
                      Icons.music_note,
                      color: getRandomColor(),
                    )
                  : ClipOval(
                      child: Image.file(
                        File(curMusic.albumArt),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
        body: songs == null
            ? Container()
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return musicItem(context, index, songs[index]);
                },
                itemCount: songs.length,
              ));
  }

  Widget musicItem(BuildContext context, int index, Song music) {
    return InkWell(
      highlightColor: Colors.black12,
      onTap: () {
        setState(() {
          curPosition = index;
          curMusic = music;
          stop();
          play();
          controller.forward(from: 0);
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
        height: 80.0,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: (music == null ||
                      music.albumArt == null ||
                      music.albumArt == "")
                  ? Icon(
                      Icons.music_note,
                      size: 50,
                      color: getRandomColor(),
                    )
                  : Image.file(
                      File(music.albumArt),
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      music.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      music.artist + " - " + music.album,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                          fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
//            IconButton(
//                icon: Icon(
//                  Icons.more_vert,
//                  color: Colors.grey,
//                ),
//                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
