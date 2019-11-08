
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../my_tally_bean_entity.dart';
/*
 * 我的账单
 */
class MyTallyDao extends BaseDBProvider{

  //表名
  String name = "MyTallyTable";
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
      user_id INTEGER,
      book_id INTEGER,
      money REAL,
      use_type TEXT,
      time TEXT,
      address TEXT,
      type TEXT,
      comment TEXT,
      year INTEGER,
      month INTEGER,
      day INTEGER)
    ''';
  }

  /*
   * 查询用户账单信息
   * userId 用户id
   * bookId 账本id
   * year 年
   * month 月
   * time 具体时间包含年月日
   * type 账单类别（支出 收入）
   */
  Future<List<MyTallyBeanEntity>> findData(int userId, {int bookId, int year, int month, String time, String type}) async {
    String seltctSql = 'user_id = ?'; //查询的条件语句
    List<dynamic> list = [userId]; //条件
    if (bookId != null) {
      seltctSql = seltctSql + ' &book_id = ?';
      list.add(bookId);
    }
    if (year != null) {
      seltctSql = seltctSql + ' &year = ?';
      list.add(year);
    }
    if (month != null) {
      seltctSql = seltctSql + ' &month = ?';
      list.add(month);
    }
    if (time != null) {
      seltctSql = seltctSql + ' &time = ?';
      list.add(time);
    }
    if (type != null) {
      seltctSql = seltctSql + ' &type = ?';
      list.add(type);
    }
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: seltctSql, whereArgs: list);
    List<MyTallyBeanEntity> data = [];
    result.forEach((item) => MyTallyBeanEntity.fromJson(item));
    return data;
  }

  /*
   * 查询账单支出或者收入的总和
   * userId 用户id
   * bookId 账本id
   * year 年
   * month 月
   * time 具体时间包含年月日
   * type 账单类别（支出 收入）
   */
  Future<double> findNumber(int userId,{int bookId, int year, int month, String time, String type, Function onCallBack}) async {
    double money = 0.00;
    List<MyTallyBeanEntity> data = await findData(userId, bookId: bookId, year: year, month: month, time: time, type: type);
    if(data!=null){
      data.forEach((item){
        money=money+item.money;
      });
    }
    if (onCallBack != null) {
      onCallBack(money);
    }
    return money;
  }

  //分页查询
  Future<List<MyTallyBeanEntity>> findDataPage(int page, int userId, {int bookId, int year, int month, String time, String type}) async {
    String seltctSql = 'user_id = ?'; //查询的条件语句
    List<dynamic> list = [userId]; //条件
    if (bookId != null) {
      seltctSql = seltctSql + ' &book_id = ?';
      list.add(bookId);
    }
    if (year != null) {
      seltctSql = seltctSql + ' &year = ?';
      list.add(year);
    }
    if (month != null) {
      seltctSql = seltctSql + ' &month = ?';
      list.add(month);
    }
    if (time != null) {
      seltctSql = seltctSql + ' &time = ?';
      list.add(time);
    }
    if (type != null) {
      seltctSql = seltctSql + ' &type = ?';
      list.add(type);
    }
    var db = await getDataBase();
    int offset = page * limit + 1;
    List<Map> result = await db.query(
      name,
      limit: limit,
      offset: offset,
    );
    List<MyTallyBeanEntity> data = [];
    result.forEach((item) => MyTallyBeanEntity.fromJson(item));
    return data;
  }

  //保存账单
  Future saveData(MyTallyBeanEntity data) async {
    if (findById(data.id) == null) {
      insertData(data);
    } else {
      upUserInfoDate(data);
    }
  }

  //插入账单信息
  Future<int> insertData(MyTallyBeanEntity data) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  //更新数据
  Future upUserInfoDate(MyTallyBeanEntity data) async {
    var db = await getDataBase();
    return db.update(name, data.toJson(), where: "id = ?", whereArgs: [data.id]);
  }

  //根据id查询一条数据
  Future<MyTallyBeanEntity> findById(int id) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return MyTallyBeanEntity.fromJson(result.first);
    }
    return null;
  }

  /*
   * 批量删除记录  通过账本id
   */
  Future removeDataByBookId(int userId, int bookId, {Function callBack}) async {
    var data = await findData(userId, bookId: bookId);
    var result;
    if (data != null && data.isNotEmpty) {
      var db = await getDataBase();
      result = await db.delete(name, where: "book_id = ?", whereArgs: [bookId]);
    }
    if (callBack != null) {
      callBack();
    }
    return result;
  }

}