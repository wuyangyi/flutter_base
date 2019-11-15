import 'package:flutter/material.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';

import 'bloc_provider.dart';

class MyTallyBloc extends BlocListBase {

  @override
  Future getData({int userId, int page, bool isLoadMore}) async {
    return await MyTallyDao().findDataPage(page, userId, map: maps).then((data){
      print("数据个数：${data?.length}");
      subjectSink.add(data);
    }).catchError((e){
      print("异常：$e");
    });
  }

  @override
  void initPage() {
    page = 0;
  }

}