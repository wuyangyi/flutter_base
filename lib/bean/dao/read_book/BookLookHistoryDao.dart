
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';

class BookLookHistoryDao extends BaseDBProvider{

  //表名
  final String name = "BookLookHistoryDao";

  //表主键字段
  final String columnId = "id";

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
      _id TEXT,
      author TEXT,
      majorCate TEXT,
      latelyFollower INTEGER,
      title TEXT,
      cover TEXT,
      shortIntro TEXT,
      userId INTEGER,
      time TEXT)
    ''';
  }

  //分页查询
  Future<List<RankBeanRankingBook>> findDataPage(int userId, int page, {Function callBack}) async {
    var db = await getDataBase();
//    List<Map> result = await db.query(name, where: "userId = ?", whereArgs: [userId], limit: limit, offset: page * limit);
    List<Map> result = await db.rawQuery("select * from $name where userId = $userId order by $columnId desc limit ${page * limit}, $limit");
    print("查询结果：$result");
    List<RankBeanRankingBook> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        RankBeanRankingBook beanEntity = RankBeanRankingBook.fromJson(result[i]);
        data.add(beanEntity);
      }
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
    var db = await getDataBase();
    var result = await db.delete(name);
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  /*
   * 通过bookid删除记录
   */
  Future removeByBookId(int userId, String bookId, {Function callBack}) async {
    var db = await getDataBase();
    var result = await db.delete(name, where: "userId = ? and _id = ?", whereArgs: [userId, bookId]);
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  //插入记录
  Future<int> insertData(RankBeanRankingBook data) async {
    var db = await getDataBase();
    List<RankBeanRankingBook> datas = await findByBookId(data.userId, data.sId);
    if (datas.isNotEmpty) {
      await removeByBookId(data.userId, data.sId);
    }
    var code = await db.insert(name, data.toSql());
    return code;
  }

  //根据书id查询
  Future<List<RankBeanRankingBook>> findByBookId(int userId, String bookId, {Function callBack}) async {
    List<RankBeanRankingBook> data = [];
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "userId = ? and _id = ?", whereArgs: [userId, bookId],);
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        RankBeanRankingBook beanEntity = RankBeanRankingBook.fromJson(result[i]);
        data.add(beanEntity);
      }
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }


}