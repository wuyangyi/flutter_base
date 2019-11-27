
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';

class PlayMusicInfoDao extends BaseDBProvider {
  //表名
  final String name = "PlayMusicInfoDao";

  //表主键字段
  final String columnId = "_id";

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      music_id INTEGER,
      music_path TEXT,
      uri TEXT,
      music_name TEXT,
      file_name TEXT,
      singer TEXT,
      play_time INTEGER,
      value TEXT,
      max_time INTEGER,
      is_local TEXT,
      image_path TEXT,
      play_type INTEGER,
      is_playing TEXT,
      collected TEXT)
    ''';
  }

  //插入歌曲信息
  Future<int> insertData(PlayMusicInfo data) async {
    await removeAll();
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  /*
   * 批量删除记录
   */
  Future removeAll({Function callBack}) async {
    var db = await getDataBase();
    var result = await db.delete(name);
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  //查询所有
  Future<List<PlayMusicInfo>> findAllData({Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    List<PlayMusicInfo> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        PlayMusicInfo playMusicInfo = PlayMusicInfo.fromJson(result[i]);
        data.add(playMusicInfo);
      }
      print("数据大小：${data.length}");
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }

  //查询一条
  Future<PlayMusicInfo> findFirstData({Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    PlayMusicInfo lastData;
    print("当前播放：${result.length}");
    if (result.isNotEmpty) {
      lastData = PlayMusicInfo.fromJson(result.last);
    }
    print("当前：$lastData");
    if (callBack != null) {
      callBack(lastData);
    }
    return lastData;
  }
}