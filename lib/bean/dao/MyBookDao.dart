
import 'package:flutter_base/bean/db/db_provider.dart';

import '../my_book_bean_entity.dart';
/*
 * 我的账本
 */
class MyBookDao extends BaseDBProvider{

  //表名
  String name = "MyBookTable";
  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return
        '''
      create table $name (
      id INTEGER primary key autoincrement,
      name TEXT,
      income REAL,
      pay REAL,
      color INTEGER,
      create_time TEXT,
      user_id INTEGER,
      type TEXT)
    ''';
  }

  //查询所有
  Future<List<MyBookBeanEntity>> findAllData() async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    List<MyBookBeanEntity> data = [];
    result.forEach((item) => data.add(MyBookBeanEntity.fromJson(item)));
    return data;
  }

  //分页查询
  Future<List<MyBookBeanEntity>> findData(int page) async {
    var db = await getDataBase();
    int offset = page * limit + 1;
    List<Map> result = await db.query(
      name,
      limit: limit,
      offset: offset,
    );
    List<MyBookBeanEntity> data = [];
    result.forEach((item) => data.add(MyBookBeanEntity.fromJson(item)));
    return data;
  }

  //保存账单
  Future saveData(MyBookBeanEntity data) async {
    if (data.id == null || findById(data.id) == null) {
      insertData(data);
    } else {
      upBookInfoDate(data);
    }
  }

  //插入账单信息
  Future<int> insertData(MyBookBeanEntity data) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  //更新数据
  Future upBookInfoDate(MyBookBeanEntity data) async {
    var db = await getDataBase();
    return db.update(name, data.toJson(), where: "id = ?", whereArgs: [data.id]);
  }

  //根据id查询一条数据
  Future<MyBookBeanEntity> findById(int id) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return MyBookBeanEntity.fromJson(result.first);
    }
    return null;
  }

  //删除一条数据  通过id
  Future removeDataById(int id, {Function callBack}) async {
    var db = await getDataBase();
    var result = await db.delete(name, where: "id = ?", whereArgs: [id]);
    if (callBack != null) {
      callBack();
    }
    return result;
  }

}