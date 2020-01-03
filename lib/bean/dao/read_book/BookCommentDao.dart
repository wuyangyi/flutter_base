
import 'package:flutter_base/bean/db/db_provider.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';

//书的评论
class BookCommentDao extends BaseDBProvider{

  //表名
  final String name = "BookCommentDao";

  //表主键字段
  final String columnId = "id";

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) + '''
      commitNumber INTEGER,
      level INTEGER,
      grade INTEGER,
      isRead TEXT,
      likeUserId TEXT,
      content TEXT,
      parentId INTEGER,
      likeNumber INTEGER,
      bookId TEXT,
      sendTime TEXT,
      sendUser TEXT,
      receiverUser TEXT,
      bookCover TEXT,
      bookName TEXT,
      bookAuthor TEXT)
    ''';
  }

  //查询一本书所有一级评论
  Future<List<BookSendCommentBeanEntity>> findAllDataByBookId(String bookId, {Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "bookId = ? and level = ?", whereArgs: [bookId, 1]);
    List<BookSendCommentBeanEntity> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity.fromJson(result[i]);
        data.add(beanEntity);
      }
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }

  //查询某评论的二级评论
  Future<List<BookSendCommentBeanEntity>> findAllDataByParentId(int parentId, int page, {Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "parentId = ?", whereArgs: [parentId], limit: limit, offset: page * limit);
    List<BookSendCommentBeanEntity> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity.fromJson(result[i]);
        data.add(beanEntity);
      }
    }
    print("data:${data.toString()}");
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }

  //通过id查询某评论
  Future<BookSendCommentBeanEntity> findDataById(int id, {Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name, where: "id = ?", whereArgs: [id]);
    List<BookSendCommentBeanEntity> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity.fromJson(result[i]);
        data.add(beanEntity);
      }
    }
    BookSendCommentBeanEntity beanEntity;
    if (data.length > 0) {
      beanEntity = data.first;
    }
    if (callBack != null) {
      callBack(beanEntity);
    }
    return beanEntity;
  }

  Future<int> upData(BookSendCommentBeanEntity data) async {
    var db = await getDataBase();
    int code = await db.update(name, data.toJson(), where: "id = ?", whereArgs: [data.id]);
    print("code:$code");
    return code;
  }


  //插入评论信息
  Future<int> insertData(BookSendCommentBeanEntity data, {Function callBack}) async {
    var db = await getDataBase();
    var code = await db.insert(name, data.toJson());
    if (callBack != null) {
      callBack(code);
    }
    return code;
  }

}