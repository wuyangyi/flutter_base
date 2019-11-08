

import 'package:flutter/material.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:sqflite/sqflite.dart';

import 'db_manager.dart';

///
/// 数据表操作类
///
abstract class BaseDBProvider {
  bool isTableExits = false; //数据表是否存在
  int limit = AppConfig.PAGE_LIMIT; //数据库分页查询的条数

  //返回创建表的具体sql
  tableSqlString();

  //返回要创建的表名
  tableName();

  //返回主键字段的基本sql定义，
  // 子类将其他字段的sql定义拼接到这个函数的返回值的后面
  tableBaseString(String name, String columnId) {
    return '''
      create table $name (
      $columnId integer primary key autoincrement,
    ''';
  }

  //返回一个数据库实例
  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DBManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await DBManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), tableSqlString());
    }
    return await DBManager.getCurrentDatabase();
  }
}