

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

  PlayMusicInfo.fromJson(Map<String, dynamic> json) {
    musicId = json['music_id'] == null ? 0 : json['music_id'];
    musicPath = json['music_path'];
    uri = json['uri'] == null ? null : Uri.dataFromString(json['uri']);
    musicName = json['music_name'];
    fileName = json['file_name'];
    singer = json['singer'];
    playTime = json['play_time'] == null ? 0 : json['play_time'];
    value = json['value'] == null ? 0.0 : double.parse(json['value']);
    maxTime = json['max_time'] == null ? 0 : json['max_time'];
    isLocal = json['is_local'] == null ? true : bool.fromEnvironment(json['is_local']);
    imagePath = json['image_path'];
    playType = json['play_type'] == null ? PLAY_STATUE_ONE : json['play_type'];
    isPlaying = json['is_playing'] == null ? false : bool.fromEnvironment(json['is_playing']);
    collected = json['collected'] == null ? false : bool.fromEnvironment(json['collected']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['music_id'] = this.musicId ?? 0;
    data['music_path'] = this.musicPath;
    data['uri'] = this.uri == null ? null : this.uri?.path;
    data['music_name'] = this.musicName;
    data['file_name'] = this.fileName;
    data['singer'] = this.singer;
    data['play_time'] = this.playTime ?? 0;
    data['value'] = this.value.toString();
    data['max_time'] = this.maxTime ?? 0;
    data['is_local'] = this.isLocal.toString();
    data['image_path'] = this.imagePath;
    data['play_type'] = this.playType ?? 0;
    data['is_playing'] = this.isPlaying.toString();
    data['collected'] = this.collected.toString();
    return data;
  }
}