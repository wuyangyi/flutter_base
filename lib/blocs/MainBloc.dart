import 'package:flutter/material.dart';

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
  Future getData({int userId, int page, bool isLoadMore}) {
    // TODO: implement getData
    return null;
  }





}