
import 'package:flutter_base/bean/db/db_provider.dart';

import '../../FlieInfoBean.dart';

class MyLikeMusicDao extends BaseDBProvider {
  //表名
  final String name = "MyLikeMusicDao";

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
      path TEXT,
      fileName TEXT,
      collected TEXT)
    ''';
  }

  //插入歌曲信息
  Future<int> insertData(FileInfoBean data) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  //查询所有
  Future<List<FileInfoBean>> findAllData({Function callBack}) async {
    var db = await getDataBase();
    List<Map> result = await db.query(name);
    List<FileInfoBean> data = [];
    if (result.length > 0) {
      for(int i = 0; i < result.length; i++) {
        FileInfoBean fileInfoBean = FileInfoBean.fromJson(result[i]);
        data.add(fileInfoBean);
      }
      print("数据大小：${data.length}");
    }
    if (callBack != null) {
      callBack(data);
    }
    return data;
  }


  Future removeOne(FileInfoBean file, {Function callBack}) async {
    var db = await getDataBase();
    await db.delete(name, where: "path = ?", whereArgs: [file.path]);
    if (callBack != null) {
      callBack();
    }
  }

  //更新数据
  Future upUserInfoDate(FileInfoBean data) async {
    var db = await getDataBase();
    return db.update(name, data.toJson(), where: "path = ?", whereArgs: [data.path]);
  }


}