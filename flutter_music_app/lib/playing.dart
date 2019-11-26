import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/player.dart';

class PlayingPage extends StatefulWidget {
  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage>
    with AutomaticKeepAliveClientMixin {
  double value = 0.0;

  @override
  void initState() {
    audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        value = (p.inSeconds / audioPlayer.duration.inSeconds) * 100;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        audioPlayer.state;
      });
    });
    super.initState();
  }

  String getTime(int duration) {
    duration = (duration / 1000).floor();
    String second_str = (duration % 60).floor().toString();
    int minute = (duration / 60).floor();
    String minute_str = (minute % 60).toString();
    String hour_str = (minute / 60).floor().toString();

    if (minute_str.length <= 1) minute_str = "0$minute_str";

    if (second_str.length <= 1) second_str = "0$second_str";

    if (hour_str != "0") return "$hour_str:$minute_str:$second_str";

    return "$minute_str:$second_str";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//              image: FileImage(File(curMusic.albumArt)),
//              fit: BoxFit.cover,
//            )),
//            child: BackdropFilter(
//              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
//              child: Container(
//                color: Colors.black.withOpacity(0.5),
//              ),
//            ),
//          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _musicInfo(),
                _progress(),
                _controller(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _musicInfo() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(left: 20),
              child: Hero(
                tag: "albumArt",
                child: Card(
                  elevation: 6.0,
                  child: ((curMusic == null ||
                          curMusic.albumArt == null ||
                          curMusic.albumArt == ""))
                      ? Icon(
                          Icons.music_note,
                          size: 40,
                          color: Colors.redAccent,
                        )
                      : Image.file(
                          File(curMusic.albumArt),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      curMusic.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                          fontSize: 20.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      curMusic.artist + " - " + curMusic.album,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.black87,
                          fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progress() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.width / 1.5,
      child: Card(
        elevation: 4,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${value.floor().toString()}%",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w100,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      getTime(curMusic.duration),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w100,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 1.5,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    value: value / 100,
                    strokeWidth: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controller() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      padding: EdgeInsets.only(left: 10.0, right: 10, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
              shape:
                  CircleBorder(side: BorderSide(width: 0, color: Colors.white)),
              child: Container(
                padding: EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    previous();
                  },
                ),
              )),
          Card(
              shape:
                  CircleBorder(side: BorderSide(width: 0, color: Colors.white)),
              child: Container(
                padding: EdgeInsets.all(10),
                child: IconButton(
                  icon: audioPlayer.state == AudioPlayerState.PLAYING
                      ? Icon(
                          Icons.pause,
                          size: 30,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 30,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    audioPlayer.state == AudioPlayerState.PLAYING
                        ? pause()
                        : play();
                  },
                ),
              )),
          Card(
              shape:
                  CircleBorder(side: BorderSide(width: 0, color: Colors.white)),
              child: Container(
                padding: EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(Icons.skip_next, size: 30, color: Colors.red),
                  onPressed: () {
                    next();
                  },
                ),
              )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
