
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
  Future<List<MyTallyBeanEntity>> findData(int userId, {int bookId, int year, int month, String time, String type, Function onCallBack}) async {
    String seltctSql = 'user_id = ?'; //查询的条件语句
    List<dynamic> list = [userId]; //条件
    if (bookId != null) {
      seltctSql = seltctSql + ' and book_id = ?';
      list.add(bookId);
    }
    if (year != null) {
      seltctSql = seltctSql + ' and year = ?';
      list.add(year);
    }
    if (month != null) {
      seltctSql = seltctSql + ' and month = ?';
      list.add(month);
    }
    if (time != null) {
      seltctSql = seltctSql + ' and time = ?';
      list.add(time);
    }
    if (type != null) {
      seltctSql = seltctSql + ' and type = ?';
      list.add(type);
    }
    var db = await getDataBase();
    print("条件参数：${seltctSql}");
//    List<Map> result = await db.rawQuery("select * from $name where $seltctSql");
    List<Map> result = await db.query(name, where: seltctSql, whereArgs: list);
    print("结果：$result");
    List<MyTallyBeanEntity> data = [];
    result.forEach((item) => data.add(MyTallyBeanEntity.fromJson(item)));
    if (onCallBack != null) {
      onCallBack(data);
    }
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
  Future<List<MyTallyBeanEntity>> findDataPage(int page, int userId, {Map map}) async {
    String seltctSql = 'user_id = ?'; //查询的条件语句
    List<dynamic> list = [userId]; //条件
    if (map != null) {
      map.forEach((key, value){
        seltctSql += " and $key = ?";
        list.add(value);
      });
    }
    print("查询条件:$seltctSql");
//    if (bookId != null) {
//      seltctSql = seltctSql + ' and book_id = ?';
//      list.add(bookId);
//    }
//    if (year != null) {
//      seltctSql = seltctSql + ' and year = ?';
//      list.add(year);
//    }
//    if (month != null) {
//      seltctSql = seltctSql + ' and month = ?';
//      list.add(month);
//    }
//    if (time != null) {
//      seltctSql = seltctSql + ' and time = ?';
//      list.add(time);
//    }
//    if (type != null) {
//      seltctSql = seltctSql + ' and type = ?';
//      list.add(type);
//    }
    var db = await getDataBase();
    int offset = page * limit;
    print("分页offset: $offset");
    List<Map> result = await db.query(
      name,
      limit: limit,
      offset: offset,
      where: seltctSql,
      whereArgs: list
    );
    print("分页查询结果：$result");
    List<MyTallyBeanEntity> data = [];
    result.forEach((item) => data.add(MyTallyBeanEntity.fromJson(item)));
    return data;
  }

  //保存账单
  Future saveData(MyTallyBeanEntity data) async {
    if (data.id == null) {
      return await insertData(data);
    } else {
      MyTallyBeanEntity select = await findById(data.id);
      if (select == null) {
        return await insertData(data);
      } else {
        return await upUserInfoDate(data);
      }
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

  /*
   * 通过id删除一条记录
   */
  Future removeOne(int id, {Function callBack}) async {
    var data = await findById(id);
    var result;
    if (data != null) {
      var db = await getDataBase();
      result = await db.delete(name, where: "id = ?", whereArgs: [id]);
    }
    print("result:$result");
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  //查询所以数据
  Future<List<MyTallyBeanEntity>> findAll() async {
    var db = await getDataBase();
    List<Map> result = await db.rawQuery("select * from $name");
    List<MyTallyBeanEntity> data = [];
    result.forEach((item) => data.add(MyTallyBeanEntity.fromJson(item)));
    return data;
  }

}