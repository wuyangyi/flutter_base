
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/read_book/hot_search_bean_entity.dart';

class ReadBookSearchHistoryDao extends BaseDBProvider{

  //表名
  final String name = "ReadBookSearchHistoryDao";

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
      word TEXT,
      times INTEGER,
      isNew INTEGER,
      soaring INTEGER)
    ''';
  }

  //查询所有
  Future<List<HotSearchBeanSearchhotword>> findAllData({Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    List<HotSearchBeanSearchhotword> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        HotSearchBeanSearchhotword searchHotKeyHotkey = HotSearchBeanSearchhotword.fromJson(result[i]);
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

  //保存
  Future saveData(HotSearchBeanSearchhotword data) async {
    var myBeanEntity = await findByText(data.word);
    if (myBeanEntity == null) {
      return await insertData(data);
    }
  }

  //插入账单信息
  Future<int> insertData(HotSearchBeanSearchhotword data) async {
    var db = await getDataBase();
    var code = await db.insert(name, data.toJson());
    return code;
  }

  //根据搜索内容查询一条数据
  Future<HotSearchBeanSearchhotword> findByText(String text) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: 'word = ?', whereArgs: [text]);
    if (result.length > 0) {
      return HotSearchBeanSearchhotword.fromJson(result.first);
    }
    return null;
  }

}