
import 'package:flutter_base/bean/chess/chess_game_info_bean_entity.dart';
import 'package:flutter_base/bean/db/db_provider.dart';
/*
 * 游戏对局信息
 */
class ChessGameInfoDao extends BaseDBProvider{

  //表名
  String name = "ChessGameInfoDao";
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
      bottomIsRed TEXT,
      gameType TEXT,
      reason TEXT,
      winner TEXT,
      allGameTime INTEGER,
      startTime TEXT,
      endTime TEXT,
      collect TEXT)
    ''';
  }

  /*
   * 查询对局信息
   * desc 倒序
   */
  Future<List<ChessGameInfoBeanEntity>> findData({bool desc = true, Function onCallBack,}) async {
    var db = await getDataBase();
//    List<Map> result = await db.query(name);
    List<Map> result = await db.rawQuery("select * from $name order by $columnId ${desc ? 'desc' : 'asc'}");
    List<ChessGameInfoBeanEntity> data = [];
    result.forEach((item) => data.add(ChessGameInfoBeanEntity.fromJson(item)));
    if (onCallBack != null) {
      onCallBack(data);
    }
    return data;
  }


  //插入对局信息
  Future<int> insertData(ChessGameInfoBeanEntity data) async {
    var db = await getDataBase();
    print("插入的信息：${data.toJson()}");
    var code = await db.insert(name, data.toJson());
    print("插入：$code");
    return code;
  }

  Future<int> deleteById(int id) async {
    var db = await getDataBase();
    var code = await db.delete(name, where: '$columnId = ?', whereArgs: [id]);
    return code;
  }

  Future<int> upData(ChessGameInfoBeanEntity data) async {
    var db = await getDataBase();
    var code = await db.update(name, data.toJson(), where: "$columnId = ?", whereArgs: [data.id]);
    return code;
  }

}