
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/read_book/book_rack_bean_entity.dart';

//书架
class BookRackDao extends BaseDBProvider{

  //表名
  final String name = "BookRackDao";

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
      userId INTEGER,
      bookId TEXT,
      bookName TEXT,
      cover TEXT)
    ''';
  }

  //查询所有
  Future<List<BookRackBeanEntity>> findAllData(int userId, {Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "userId = ?", whereArgs: [userId]);
    List<BookRackBeanEntity> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        BookRackBeanEntity beanEntity = BookRackBeanEntity.fromJson(result[i]);
        data.add(beanEntity);
      }
      print("数据大小：${data.length}");
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }

  //查询通过bookId
  Future<List<BookRackBeanEntity>> findDataByBookId(String bookId, {Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "bookId = ?", whereArgs: [bookId]);
    List<BookRackBeanEntity> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        BookRackBeanEntity beanEntity = BookRackBeanEntity.fromJson(result[i]);
        data.add(beanEntity);
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
  Future removeAll(int userId, {Function callBack}) async {
    var data = await findAllData(userId);
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

  /*
   * 删除记录通过userId
   */
  Future removeById(String bookId, {Function callBack}) async {
    var data = await findDataByBookId(bookId);
    var result;
    if (data != null && data.isNotEmpty) {
      var db = await getDataBase();
      result = await db.delete(name, where: "bookId = ?", whereArgs: [bookId]);
    }
    if (callBack != null) {
      callBack();
    }
    return result;
  }

  //插入账单信息
  Future<int> insertData(BookRackBeanEntity data) async {
    var db = await getDataBase();
    var code = await db.insert(name, data.toJson());
    return code;
  }

}