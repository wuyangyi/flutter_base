import 'package:flutter/material.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/net/network.dart';

import 'bloc_provider.dart';

class ReadBookByTypeBloc<RankBeanRankingBook> extends BlocListBase {

  @override
  initPage() {
    page = 0;
  }

  @override
  Future getData({int userId, int page, bool isLoadMore}) async {
    maps['start'] = (page * AppConfig.PAGE_LIMIT).toString();
    maps['limit'] = AppConfig.PAGE_LIMIT.toString();
    return await NetClickUtil().getReadBookByType(map: maps).then((data){
      print("ReadBookByTypeBloc:${data == null}");
      subjectSink.add(data.books);
    }).catchError((e) {
      page--;
      print("异常：$e");
    });
  }


}