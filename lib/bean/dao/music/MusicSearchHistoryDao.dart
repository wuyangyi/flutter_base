
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/music/music_search_hot_key_entity.dart';

class MusicSearchHistoryDao extends BaseDBProvider{

  //表名
  final String name = "MusicSearchHistory";

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
      k TEXT,
      n INTEGER)
    ''';
  }

  //查询所有
  Future<List<MusicSearchHotKeyHotkey>> findAllData({Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    List<MusicSearchHotKeyHotkey> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        MusicSearchHotKeyHotkey searchHotKeyHotkey = MusicSearchHotKeyHotkey.fromJson(result[i]);
        data.add(searchHotKeyHotkey);
      }
      print("数据大小：${data.length}");
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }

  /*
   * 批量删除记录
   */
  Future removeAll({Function callBack}) async {
    var data = await findAllData();
    var result;
    if (data != null && data.isNotEmpty) {
      var db = await getDataBase();
      result = await db.delete(name);
    }
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  //保存账单
  Future saveData(MusicSearchHotKeyHotkey data) async {
    var myBookBeanEntity = await findByText(data.k);
    if (myBookBeanEntity == null) {
      return await insertData(data);
    } else {
      myBookBeanEntity.n++;
      return await upBookInfoDate(myBookBeanEntity);
    }
  }

  //插入账单信息
  Future<int> insertData(MusicSearchHotKeyHotkey data) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  //更新数据
  Future upBookInfoDate(MusicSearchHotKeyHotkey data) async {
    var db = await getDataBase();
    return await db.update(name, data.toJson(), where: "k = ?", whereArgs: [data.k]);
  }

  //根据搜索内容查询一条数据
  Future<MusicSearchHotKeyHotkey> findByText(String text) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: 'k = ?', whereArgs: [text]);
    if (result.length > 0) {
      return MusicSearchHotKeyHotkey.fromJson(result.first);
    }
    return null;
  }

}