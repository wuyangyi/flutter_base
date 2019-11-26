

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/res/string.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';

import 'application.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  ProfileEntity get _profile => Application.profile;

  @override
  void notifyListeners() {
    Application.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

//用户状态
class UserModel extends ProfileChangeNotifier {
  UserBeanEntity get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null && _profile.isLogin;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(UserBeanEntity user) {
    _profile.user = user;
    _profile.isLogin = true;
    notifyListeners();
  }

  void outLogin() {
    _profile.isLogin = false;
    _profile.user = null;
    notifyListeners();
  }
}

//账本状态
class BookModel extends ChangeNotifier {
  //用于保存账本列表
  final List<MyBookBeanEntity> _books = [];

  List<MyBookBeanEntity> get books => _books;

  void add(MyBookBeanEntity bookBeanEntity) {
    _books.add(bookBeanEntity);
    notifyListeners();
  }

  void addAll(List<MyBookBeanEntity> bookBeanEntitys) {
    _books.addAll(bookBeanEntitys);
    notifyListeners();
  }

  void clearAll() {
    _books.clear();
    notifyListeners();
  }

  void removeOne(int index) {
    _books.removeAt(index);
    notifyListeners();
  }

  void update(MyBookBeanEntity data) {
    for(int i = 0; i< _books.length; i++) {
      if (_books[i].id == data.id) {
        _books[i] = data;
      }
    }
  }
}

//本月账单列表
class TallyModel extends ChangeNotifier {
  //用于保存本月账单列表
  final List<MyTallyBeanEntity> _tally = [];

  List<MyTallyBeanEntity> get tally => _tally;

  void add(MyTallyBeanEntity myTallyBeanEntity) {
    _tally.add(myTallyBeanEntity);
    notifyListeners();
  }

  void addAll(List<MyTallyBeanEntity> myTallyBeanEntitys) {
    _tally.addAll(myTallyBeanEntitys);
    notifyListeners();
  }

  void clearAll() {
    _tally.clear();
    notifyListeners();
  }

  void removeOne(int id) {
    for(int i = 0; i < _tally.length; i++) {
      if (id == _tally[i].id) {
        _tally.removeAt(i);
        return;
      }
    }
    notifyListeners();
  }

  void update(MyTallyBeanEntity data) {
    for(int i = 0; i< _tally.length; i++) {
      if (_tally[i].id == data.id) {
        _tally[i] = data;
      }
    }
    notifyListeners();
  }

  //获得某本账本本月的账单
  List<MyTallyBeanEntity> getTallyByBookId(int bookId) {
    List<MyTallyBeanEntity> data = [];
    _tally.forEach((item){
      if (item.bookId == bookId) {
        data.add(item);
      }
    });
    return data;
  }

  //本月支出
  double getPay(int bookId) {
    double pay = 0.00;
    _tally.forEach((item){
      if (item.type == "支出") {
        if (item.bookId == bookId) {
          pay += item.money;
        }
      }
    });
    return pay;
  }

  //本月收入
  double getIncome(int bookId) {
    double income = 0.00;
    _tally.forEach((item){
      if (item.type == "收入") {
        if (item.bookId == bookId) {
          income += item.money;
        }
      }
    });
    return income;
  }
}

//当前播放的音乐
class PlayMusicInfoModel extends ChangeNotifier{
  PlayMusicInfo _playMusicInfo;
  static AudioPlayer audioPlayer = AudioPlayer();
  List<FileInfoBean> _playList = []; //当前播放列表的所有歌曲

  PlayMusicInfo get playMusicInfo{
    if (_playMusicInfo == null) {
      _playMusicInfo = new PlayMusicInfo(isPlaying: false);
      notifyListeners();
    }
    return _playMusicInfo;
  }

  List<FileInfoBean> get playList{
    return _playList;
  }

  //设置音乐
  void setMusicInfo(PlayMusicInfo musicInfo){
    if (_playMusicInfo.playType != null) {
      musicInfo.playType = _playMusicInfo.playType;
    } else {
      _playMusicInfo.playType = PlayMusicInfo.PLAY_STATUE_ONE;
    }
    this._playMusicInfo = musicInfo;
    audioPlayer.setVolume(0.5); //设置音量0-1
    play();
    if (_playList.isEmpty) {
      _playList.add(FileInfoBean(path: musicInfo.musicPath, fileName: musicInfo.fileName, uri: musicInfo.uri, check: true));
    }
    notifyListeners();
  }

  void setMusicList(List<FileInfoBean> music) {
    _playList = music;
    notifyListeners();
  }

  //更新播放状态
  void upPlayState(bool play) {
    _playMusicInfo.isPlaying = play;
    if (_playMusicInfo.isPlaying){
      audioPlayer.resume();
    } else {
      audioPlayer.pause();
    }
    notifyListeners();
  }

  void upPlayNowTime(int time) {
    audioPlayer.seek(Duration(seconds: time));
    _playMusicInfo.playTime = time;
    notifyListeners();
  }

  play() async {
    audioPlayer.onDurationChanged.listen((Duration d){
      _playMusicInfo.maxTime = d.inSeconds;
      notifyListeners();
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p){
      _playMusicInfo.playTime = p.inSeconds;
      _playMusicInfo.value = _playMusicInfo.playTime / _playMusicInfo.maxTime;
      notifyListeners();
      bus.emit(EventBusString.MUSIC_PROGRESS, _playMusicInfo.value);
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s){
      print("播放状态：${s.toString()}");
      bus.emit(EventBusString.MUSIC_PLAY_STATE, s);
      if (s == AudioPlayerState.PLAYING) {
        _playMusicInfo.isPlaying = true;
      } else {
        _playMusicInfo.isPlaying = false;
      }
    });
    int result = await audioPlayer.play(_playMusicInfo.isLocal ? _playMusicInfo.musicPath : _playMusicInfo.uri, isLocal: _playMusicInfo.isLocal,);
    if (result == 1) {
      print("播放成功");
    } else {
      print("播放失败");
    }
  }

  //更新播放状态
  void upPlayType(int type) {
    playMusicInfo.playType = type;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}

//本地音乐列表
class LocalMusicModel extends ChangeNotifier {
  List<FileInfoBean> _fileInfoBean = [];

  List<FileInfoBean> get fileInfoBean => _fileInfoBean;

  void addAll(List<FileInfoBean> data) {
    //去重
    List<FileInfoBean> file = [];
    data.forEach((item){
      if(_fileInfoBean.isEmpty) {
        file.add(item);
      } else {
        _fileInfoBean.forEach((itemHave) {
          if (item.fileName != itemHave.fileName) {
            file.add(item);
          }
        });
      }
    });
    _fileInfoBean.addAll(file);
    notifyListeners();
  }
}