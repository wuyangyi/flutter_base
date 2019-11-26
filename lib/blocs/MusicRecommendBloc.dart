import 'package:flutter/material.dart';
import 'package:flutter_base/net/network.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class MusicRecommendBloc<MusicHomeBean> extends BlocDataBase {

  @override
  Future getData({int userId, int page, bool isLoadMore}) async {
    return await NetClickUtil().getMusicRecommendData().then((data) {
      print("data为空：${data == null}");
      subjectSink.add(data);
    }).catchError((e){
      print("异常MusicRecommendBloc :  $e");
    });
  }

  @override
  Future onLoadMore({int userId,}) {
    return getData(isLoadMore: true, userId: userId);
  }

  @override
  Future onRefresh({int userId,}) {
    return getData(isLoadMore: false, userId: userId);
  }





}