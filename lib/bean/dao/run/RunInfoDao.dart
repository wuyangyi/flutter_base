
import 'dart:math';

import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/utils/utils.dart';

class RunInfoDao extends BaseDBProvider {
  //表名
  String name = "RunInfoDao";
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
      path REAL,
      endDate TEXT,
      startDate TEXT,
      startTime INTEGER,
      endTime INTEGER,
      walkNumber INTEGER,
      time INTEGER,
      week TEXT,
      year INTEGER,
      month INTEGER,
      day INTEGER)
    ''';
  }

  /*
   * 运动信息
   * userId 用户id
   * year 年
   * month 月
   * day 日
   */
  Future<List<RunInfoBeanEntity>> findData(int userId, {int year, int month, int day, Function onCallBack}) async {
    String seltctSql = 'user_id = ?'; //查询的条件语句
    List<dynamic> list = [userId]; //条件
    if (year != null) {
      seltctSql = seltctSql + ' and year = ?';
      list.add(year);
    }
    if (year != null) {
      seltctSql = seltctSql + ' and month = ?';
      list.add(month);
    }
    if (year != null) {
      seltctSql = seltctSql + ' and day = ?';
      list.add(day);
    }
    var db = await getDataBase();
    print("条件参数：${seltctSql}");
//    List<Map> result = await db.rawQuery("select * from $name where $seltctSql");
    List<Map> result = await db.query(name, where: seltctSql, whereArgs: list);
    print("全部运动结果：$result");
    List<RunInfoBeanEntity> data = [];
    result.forEach((item) => data.add(RunInfoBeanEntity.fromJson(item)));
    if (onCallBack != null) {
      onCallBack(data);
    }
    return data;
  }

  /*
   * 获取某一周的运动数据
   * start 开始的时间戳
   * end 结束的时间戳
   */

  Future<List<RunInfoBeanEntity>> findDataByWeek(int userId, {Function onCallBack}) async {
    int start = (Util.getStartWeekTime().millisecondsSinceEpoch / 1000).floor(); //向下取整
    int end = (Util.getEndWeekTime().millisecondsSinceEpoch / 1000).ceil(); //向上取整
    List<RunInfoBeanEntity> data = await findDataByTime(userId, start: start, end: end);
    if (onCallBack != null) {
      onCallBack(data);
    }
    return data;
  }

  /*
   * 获取某一段时间的运动数据
   * start 开始的时间戳(单位：s)
   * end 结束的时间戳(单位：s)
   */
  Future<List<RunInfoBeanEntity>> findDataByTime(int userId, {int start, int end, Function onCallBack}) async {
    String seltctSql = 'user_id = $userId'; //查询的条件语句
//    List<dynamic> list = [userId]; //条件
    if (start != null) {
      seltctSql = seltctSql + ' and startTime > ${start - 1}';
//      list.add(start - 1);
    }
    if (end != null) {
      seltctSql = seltctSql + ' and endTime < ${end + 1}';
//      list.add(end + 1);
    }
    var db = await getDataBase();
    print("条件参数：${seltctSql}");
    List<Map> result = await db.rawQuery("select * from $name where $seltctSql");
//    List<Map> result = await db.query(name, where: seltctSql, whereArgs: list);
    print("本周运动结果：$result");
    List<RunInfoBeanEntity> data = [];
    result.forEach((item) => data.add(RunInfoBeanEntity.fromJson(item)));
    print("本周数据条数：${data.length}");
    if (onCallBack != null) {
      onCallBack(data);
    }
    return data;
  }


  //插入账单信息
  Future<int> insertData(RunInfoBeanEntity data, {Function onCallBack}) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    print("插入成功:$code");
    if (onCallBack != null) {
      onCallBack(code);
    }
    return code;
  }

}