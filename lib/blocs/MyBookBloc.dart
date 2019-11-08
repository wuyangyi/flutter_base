
import 'package:flutter_base/bean/dao/MyBookDao.dart';

import 'bloc_provider.dart';

class MyBookBloc<MyBookBeanEntity> extends BlocListBase {
  @override
  void initPage() {
    page = 1;
  }

  @override
  Future getData({int page, bool isLoadMore}) async {
    return await MyBookDao().findAllData().then((data) {
      subjectSink.add(data);
    }).catchError((_){
    });
  }


}