import 'package:flutter/material.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_type_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_base/bean/read_book/HomeBookMallBean.dart';

import 'bloc_provider.dart';

//阅读 书城
class ReadBookMallBloc<HomeBookMallBean> extends BlocDataBase {

  @override
  Future getData({int userId, int page, bool isLoadMore}) async {
    return await NetClickUtil().getReadBookHomeAllData().then((data) {
      print("data为空：${data == null}");
      subjectSink.add(data);
    }).catchError((e){
      print("异常ReadBookMallBloc :  $e");
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