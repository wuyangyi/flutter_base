
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/official_accounts_bean_entity.dart';

import 'dio_util.dart';

class NetClickUtil {
  static final String wxarticle_list = "wxarticle/list/"; //公众号历史

  Map<String, String> mapApi;

  addMap(String key, String value) {
    if(mapApi == null) {
      mapApi = Map();
    }
    mapApi[key] = value;
  }

  BuildContext context;
  NetClickUtil([BuildContext context]) {
    this.context = context;
  }

  ///获得学校列表
  Future<List<OfficialAccountsBeanDataData>> getWxarticleData(int id, int page) async {
    var response = await HttpUtils.request("$wxarticle_list/$id/$page/json", method: HttpUtils.GET,);
    if (response == null) {
      return null;
    }
    OfficialAccountsBeanEntity data = OfficialAccountsBeanEntity.fromJson(response);
    if (data == null || data.data == null) {
      return null;
    }
    return data.data.datas;
  }

}