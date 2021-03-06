

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/dao/music/MyLikeMusicDao.dart';
import 'package:flutter_base/bean/dao/music/MyLocalMusicDao.dart';
import 'package:flutter_base/bean/dao/music/PlayMusicInfoDao.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/dao/read_book/BookRackDao.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/bean/read_book/book_rack_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/bean/run/week_run_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/res/string.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';
import 'dart:math' as math;

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

  void setMyChatBg(int index) {
    user.chatColor = index;
    notifyListeners();
  }

  void setRoBotChatBg(int index) {
    user.robotColor = index;
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

  //获得当前播放的位置
  int getPlayIndex() {
    int index = 0;
    for (int i = 0; i < _playList.length; i++) {
      if (_playList[i].path == _playMusicInfo.musicPath) {
        index = i;
      }
    }
    return index;
  }

  //设置音乐
  void setMusicInfo(PlayMusicInfo musicInfo){
    if (_playMusicInfo?.playType != null) {
      musicInfo.playType = _playMusicInfo.playType;
    }
    this._playMusicInfo = musicInfo;
    audioPlayer.setVolume(0.5); //设置音量0-1
    if (_playMusicInfo.isPlaying) {
      play();
    }
    if (_playList.isEmpty) {
      _playList.add(FileInfoBean(path: musicInfo.musicPath, fileName: musicInfo.fileName, uri: musicInfo.uri, check: true));
    }
    notifyListeners();
    PlayMusicInfoDao().insertData(_playMusicInfo);
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

  //更新收藏状态
  void upCollect(bool collect) {
    _playMusicInfo.collected = collect;
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
      PlayMusicInfoDao().insertData(_playMusicInfo);
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

  //用于启动初始化
  void initPlay(){
    if (_playMusicInfo == null || _playMusicInfo.musicPath == null) {
      return;
    }
    audioPlayer.onDurationChanged.listen((Duration d){
      _playMusicInfo.maxTime = d.inSeconds;
      notifyListeners();
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p){
      _playMusicInfo.playTime = p.inSeconds;
      if (_playMusicInfo?.playTime == null || _playMusicInfo?.maxTime == null) {
        _playMusicInfo.value = 0.0;
      } else {
        _playMusicInfo.value = (_playMusicInfo.playTime / _playMusicInfo?.maxTime) ?? 0;
      }

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
      PlayMusicInfoDao().insertData(_playMusicInfo);
    });
    audioPlayer.setUrl(_playMusicInfo.musicPath);
    upPlayNowTime(_playMusicInfo?.playTime ?? 0);
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

  void addAll(List<FileInfoBean> data) async {
    //去重
    List<FileInfoBean> file = [];
    data.forEach((item){
      if(_fileInfoBean.isEmpty) {
        file.add(item);
      } else {
        bool needAdd = true;
        _fileInfoBean.forEach((itemHave) {
          if (item.fileName == itemHave.fileName) {
            needAdd = false;
          }
        });
        if (needAdd) {
          file.add(item);
        }
      }
    });
    _fileInfoBean.addAll(file);
    notifyListeners();

    await MyLocalMusicDao().insertDatas(_fileInfoBean);
  }

  //更新收藏状态
  void upCollect(bool collect, int index) async {
    _fileInfoBean[index].collected = collect;
    notifyListeners();
    await MyLocalMusicDao().upUserInfoDate(_fileInfoBean[index]);
  }

  //更新选中状态
  void upCheckState(bool check, int index) {
    _fileInfoBean[index].check = check;
    notifyListeners();
  }

  //删除选择的音乐
  void removeCheckMusic() {
    List<FileInfoBean> files = [];
    _fileInfoBean.forEach((item){
      if (item.check) {
        files.add(item);
      }
    });
    for (int i = 0; i < _fileInfoBean.length; i++) {
      if (_fileInfoBean[i].check) {
        files.add(_fileInfoBean[i]);
        _fileInfoBean.removeAt(i);
      }
    }
    MyLocalMusicDao().removeSome(files);
    notifyListeners();
  }
}


//我的喜欢歌单
class MyLikeMusicModel extends ChangeNotifier {
  List<FileInfoBean> _myLikeList = [];

  List<FileInfoBean> get myLikeList => _myLikeList;

  void addAll(List<FileInfoBean> data) {
    _myLikeList.addAll(data);
    notifyListeners();
  }

  void add(FileInfoBean data) async {
    data.collected = true;
    if(_myLikeList.isEmpty) {
      _myLikeList.add(data);
    } else {
      bool needAdd = true;
      _myLikeList.forEach((itemHave) {
        if (data.fileName == itemHave.fileName) {
          needAdd = false;
        }
      });
      if (needAdd) {
        _myLikeList.add(data);
      }
    }
    notifyListeners();
    await MyLikeMusicDao().insertData(data);
  }

  void remove(FileInfoBean data) async {
    for (int i = 0; i < _myLikeList.length; i++) {
      if (_myLikeList[i].path == data.path) {
        _myLikeList.removeAt(i);
      }
    }
    notifyListeners();
    await MyLikeMusicDao().removeOne(data);
  }
}

//本周运动数据
class RunWeekModel extends ChangeNotifier {
  List<RunInfoBeanEntity> _runInfoList = [];

  List<RunInfoBeanEntity> _allRunInfoList = [];

//  List<WeekRunBeanEntity> _weekList = [];
  void addAll(List<RunInfoBeanEntity> data) {
    _runInfoList.addAll(data);
    notifyListeners();
  }

  void add(RunInfoBeanEntity data) async {
    _runInfoList.add(data);
    _allRunInfoList.add(data);
    notifyListeners();
  }

  void addAllToAll(List<RunInfoBeanEntity> data) {
    _allRunInfoList.addAll(data);
    notifyListeners();
  }

  List<RunInfoBeanEntity> findAllByTime(int year, int month, int day) {
    List<RunInfoBeanEntity> list = [];
    _allRunInfoList.forEach((item){
      if (item.year == year && item.month == month && item.day == day) {
        list.add(item);
      }
    });
    return list;
  }


  //获取本周的运动里程
  double getAllWeekPath() {
    double allPath = 0;
    _runInfoList.forEach((item){
      allPath += item.path;
    });
    return double.parse(allPath.toStringAsFixed(2));
  }

  //获取本周的运动次数
  int getAllRunNumber() {
    return _runInfoList.length;
  }

  //获取某一天的总里程
  double getOneDayAllPath(String week) {
    double path = 0;
    _runInfoList.forEach((item){
      if (week == item.week) {
        path += item.path;
      }
    });
    return double.parse(path.toStringAsFixed(2));
  }
}


//书架
class BookRackModel extends ChangeNotifier {
  List<BookRackBeanEntity> _bookRackList = [];

  List<BookRackBeanEntity> get bookRackList => _bookRackList;

  void add(BookRackBeanEntity data) {
    _bookRackList.add(data);
    notifyListeners();
    BookRackDao().insertData(data);
  }

  void addAll(List<BookRackBeanEntity> data) {
    _bookRackList.addAll(data);
    notifyListeners();
  }

  void removeAll(int userId) {
    _bookRackList.clear();
    notifyListeners();
    BookRackDao().removeAll(userId);
  }

  void removeByBookId(String bookId) {
    for (int i = 0; i < _bookRackList.length; i++) {
      if (_bookRackList[i].bookId == bookId) {
        _bookRackList.removeAt(i);
        break;
      }
    }
    notifyListeners();
    BookRackDao().removeById(bookId);
  }

  bool getStateById(String bookId) {
    bool isAdd = false;
    for (int i = 0; i < _bookRackList.length; i++) {
      if (_bookRackList[i].bookId == bookId) {
        isAdd = true;
      }
    }
    return isAdd;
  }

  void upState(BookRackBeanEntity data) {
    if (getStateById(data.bookId)) {
      removeByBookId(data.bookId);
    } else {
      add(data);
    }
  }
}

//书的评论
class BookCommitModel extends ChangeNotifier {
  List<BookSendCommentBeanEntity> _bookCommitList = [];

  List<BookSendCommentBeanEntity> get bookCommitList => _bookCommitList;

  void add(BookSendCommentBeanEntity data) {
    _bookCommitList.add(data);
    notifyListeners();
  }

  void addAll(List<BookSendCommentBeanEntity> data) {
    _bookCommitList.clear();
    _bookCommitList.addAll(data);
    notifyListeners();
  }

  void addCommit(int id) {
    for(int i = 0; i < _bookCommitList.length; i++) {
      if (_bookCommitList[i].id == id) {
        _bookCommitList[i].commitNumber++;
        BookCommentDao().upData(_bookCommitList[i]);
      }
    }
    notifyListeners();
  }

  void addGood(int id, int userId) {
    for(int i = 0; i < _bookCommitList.length; i++) {
      if (_bookCommitList[i].id == id) {
        bool isGood = false;
        if (_bookCommitList[i].likeUserId != null) {
          for (int j = 0; j < _bookCommitList[i].likeUserId.length; j++) {
            if (_bookCommitList[i].likeUserId[j] == userId) {
              isGood = true;
              _bookCommitList[i].likeUserId.removeAt(j);
              _bookCommitList[i].likeNumber--;
              BookCommentDao().upData(_bookCommitList[i]);
              break;
            }
          }
        }
        if (!isGood) {
          _bookCommitList[i].likeUserId.add(userId);
          _bookCommitList[i].likeNumber++;
          BookCommentDao().upData(_bookCommitList[i]);
        }
      }
    }
    notifyListeners();
  }
}