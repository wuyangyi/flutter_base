
import 'package:flutter_base/bean/db/db_provider.dart';

import '../../FlieInfoBean.dart';

class MyLocalMusicDao extends BaseDBProvider {

  //表名
  final String name = "MyLocalMusicDao";

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
      fileName TEXT)
    ''';
  }

  //插入歌曲信息
  Future<int> insertData(FileInfoBean data) async {
    var db = await getDataBase();
    var code = db.insert(name, data.toJson());
    return code;
  }

  //批量插入歌曲信息
  Future insertDatas(List<FileInfoBean> data) async {
    await findAllData(callBack: (datas) async {
      for (int i = 0; i < data.length; i++) {
        bool needAdd = true;
        for (int j = 0; j < datas.length; j ++) {
          if (data[i].path == datas[j].path) {
            needAdd = false;
          }
        }
        if (needAdd) {
          insertData(data[i]);
        }
      }
    });

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

  /*
   * 批量删除记录
   */
  Future removeAll({Function callBack}) async {
    var data = await findAllData();
    var result;
    var db = await getDataBase();
    result = await db.delete(name);
    if (callBack != null) {
      callBack();
    }
    return result;
  }
  
}