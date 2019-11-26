import 'package:flutter/material.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/net/network.dart';

import 'bloc_provider.dart';

class MusicSingerBloc<MusicSingerBeanList> extends BlocListBase {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initPage() {
    page = 1;
  }

  @override
  Future getData({int userId, int page, bool isLoadMore}) async {
    return await NetClickUtil().getMusicSinger(page, AppConfig.PAGE_LIMIT).then((data){
      subjectSink.add(data);
    }).catchError((e){
      print(e);
    });
  }

}