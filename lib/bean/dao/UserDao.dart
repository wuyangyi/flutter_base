

import 'package:flutter_base/bean/db/db_provider.dart';

import '../user_bean_entity.dart';

class UserDao extends BaseDBProvider {
  //表名
  final String name = "UserMessage";

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
      id INTEGER,
      phone TEXT,
      password TEXT,
      name TEXT,
      address TEXT,
      sex TEXT,
      birth_date TEXT,
      logo TEXT,
      coinInfo TEXT,
      synopsis TEXT,
      age INTEGER,
      info_bg TEXT)
    ''';
  }

  //保存用户
  Future saveData(UserBeanEntity user) async {
    if (findById(user.id) == null) {
      insertData(user);
    } else {
      upUserInfoDate(user);
    }
  }

  //插入用户信息
  Future<int> insertData(UserBeanEntity user) async {
    var db = await getDataBase();
    var code = db.insert(name, user.toJson());
    print("用户保存:$code");
    return code;
  }

  //更新数据
  Future upUserInfoDate(UserBeanEntity user) async {
    var db = await getDataBase();
    return db.update(name, user.toJson(), where: "id = ?", whereArgs: [user.id]);
  }

  //根据id查询一条数据
  Future<UserBeanEntity> findById(int id) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: 'id = ?', whereArgs: [id]);
    if (result.length > 0) {
      return UserBeanEntity.fromJson(result.first);
    }
    return null;
  }
}