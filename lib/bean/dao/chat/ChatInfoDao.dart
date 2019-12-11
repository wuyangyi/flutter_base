
import 'dart:math';

import 'package:flutter_base/bean/chat/chat_info_bean_entity.dart';
import 'package:flutter_base/bean/db/db_provider.dart';

class ChatInfoDao extends BaseDBProvider {
  //表名
  String name = "ChatInfoDao";
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
      userId INTEGER,
      isMe TEXT,
      time TEXT,
      type TEXT,
      value TEXT,
      isRecall TEXT,
      isCollect TEXT)
    ''';
  }

  /*
   * 聊天信息
   * userId 用户id
   */
  Future<List<ChatInfoBeanEntity>> findData(int userId, {Function onCallBack}) async {
//    String seltctSql = 'userId = ?'; //查询的条件语句
//    List<dynamic> list = [userId]; //条件
    var db = await getDataBase();
//    print("条件参数：${seltctSql}");
//    List<Map> result = await db.query(name, where: seltctSql, whereArgs: list, orderBy: "id");
    List<Map> result = await db.rawQuery("select * from $name where userId = $userId order by id desc");
    print("全部聊天结果：$result");
    List<ChatInfoBeanEntity> data = [];
    result.forEach((item) => data.add(ChatInfoBeanEntity.fromJson(item)));
    if (onCallBack != null) {
      onCallBack(data);
    }
    return data;
  }


  //插入聊天信息
  Future<int> insertData(ChatInfoBeanEntity data, {Function onCallBack}) async {
    var db = await getDataBase();
    var code = await db.insert(name, data.toJson());
    print("插入成功:$code");
    if (onCallBack != null) {
      onCallBack(code);
    }
    return code;
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

  //更新数据
  Future upUserInfoDate(ChatInfoBeanEntity data) async {
    var db = await getDataBase();
    return db.update(name, data.toJson(), where: "id = ?", whereArgs: [data.id]);
  }

}