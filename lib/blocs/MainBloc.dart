import 'package:flutter/material.dart';
import 'package:flutter_base/net/network.dart';

import 'bloc_provider.dart';

class MainBloc<OfficialAccountsBeanDataData> extends BlocListBase {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initPage() {
    page = 1;
  }

  @override
  Future getData({int page, bool isLoadMore}) {
    return getListData(page, isLoadMore);
  }

  Future getListData(int page, bool isLoadMore) async {
    return await NetClickUtil().getWxarticleData(100, page).then((data) {
      subjectSink.add(data);
    }).catchError((_) {
      page--;
    });
  }

}