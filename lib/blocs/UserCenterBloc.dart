import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_base/net/network.dart';

import 'bloc_provider.dart';

///用户积分详情列表
class UserCenterBloc<MyCoinDescInfoBeanDataData> extends BlocListBase {

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
    return await NetClickUtil().getCoinList(page).then((data){
      subjectSink.add(data);
    }).catchError((_) {
      page--;
    });
  }

  //获得个人积分
  Future getIntegral() async {
    return await NetClickUtil().getIntegral();
  }

}