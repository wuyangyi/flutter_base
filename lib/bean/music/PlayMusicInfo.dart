

class PlayMusicInfo {
  static const int PLAY_STATUE_RANDOM = 0; //随机播放
  static const int PLAY_STATUE_LIST = 1; //列表循环
  static const int PLAY_STATUE_ONE = 2; //单曲循环

  int musicId; //音乐id
  String musicPath; //音乐地址
  Uri uri;
  String musicName; //音乐名
  String fileName; //文件名（歌曲和歌手）
  String singer; //歌手
  int playTime; //当前播放的时间(单位：秒s)
  double value; //播放比例0-1
  int maxTime; //总时长(单位：秒s)
  bool isLocal; //是否是本地音乐
  String imagePath; //图片
  int playType; //播放模式（随机0 、列表循环1 、单曲循环2）
  bool isPlaying; //是否正在播放
  bool collected; //是否已收藏


  PlayMusicInfo({
    this.musicId,
    this.musicPath,
    this.uri,
    this.musicName,
    this.singer,
    this.playTime,
    this.maxTime,
    this.isLocal,
    this.imagePath,
    this.playType,
    this.isPlaying,
    this.collected,
    this.fileName,
    this.value = 0,
  });
}