
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/dao/UserDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_coin_desc_info_bean_entity.dart';
import 'package:flutter_base/bean/official_accounts_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/bean/user_coin_list_bean_entity.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/string.dart';
import 'package:flutter_base/utils/utils.dart';
import 'dart:convert';

import 'dio_util.dart';

class NetClickUtil {
  static final String USER_LOGIN = "user/login"; //登录
  static final String USER_REGISTER = "user/register"; //注册
  static final String USER_COIN_LIST = "lg/coin/list/"; //个人积分列表
  static final String USER_COIN = "lg/coin/userinfo/json"; //个人积分

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

  ///登录
  Future<UserBeanEntity> login(String username, String password) async {
    addMap("username", username);
    addMap("password", password);
    var response = await HttpUtils.request(USER_LOGIN, method: HttpUtils.POST, mapApi: mapApi);
    if (response == null) {
      Application.profile.isLogin = false;
      return null;
    }
    int id = Util.getIntByJson(response["data"], "id", 0);
    if (id == 0) {
      return null;
    }
    UserBeanEntity data = await UserDao().findById(id);
    if (data == null) {
      data = UserBeanEntity.upDataByLogin(username, password, id);
      data.isFinishInfo = false;
      data.infoBg = "user_page_top_bg_01"; //设置默认背景
    } else {
      data.isFinishInfo = true;
    }
    return data;
  }

  ///注册
  Future<UserBeanEntity> register(String username, String password, String repassword) async {
    addMap("username", username);
    addMap("password", password);
    addMap("repassword", repassword);
    var response = await HttpUtils.request(USER_REGISTER, method: HttpUtils.POST, mapApi: mapApi);
    if (response == null) {
      Application.profile.isLogin = false;
      return null;
    }
    int id = Util.getIntByJson(response["data"], "id", 0);
    if (id == 0) {
      return null;
    }
    UserBeanEntity data = await UserDao().findById(id);
    if (data == null) {
      data = UserBeanEntity.upDataByLogin(username, password, id);
      data.isFinishInfo = false;
      data.infoBg = "user_page_top_bg_01"; //设置默认背景
    } else {
      data.isFinishInfo = true;
    }
    return data;
  }

  ///获取全国城市信息
  Future<CityBeanEntity> getCityData() async {
    if (DataConfig.cityData != null) {
      return DataConfig.cityData;
    }
    var response = await DefaultAssetBundle.of(context).loadString("jsons/city.json");
    if (response == null) {
      return getCityData();
    }
    print("接口数据: $response");
    DataConfig.cityData = CityBeanEntity.fromJson(json.decode(response));
    print("数据:${DataConfig.cityData.toJson() == null ? '空' : DataConfig.cityData.toJson()}");
    return DataConfig.cityData;
  }

  ///获得积分列表
  Future<List<MyCoinDescInfoBeanDataData>> getCoinList(int page) async {
    var response = await HttpUtils.request(USER_COIN_LIST + "$page/json", method: HttpUtils.GET);
    if (response == null) {
      return null;
    }
    MyCoinDescInfoBeanEntity allData = MyCoinDescInfoBeanEntity.fromJson(response);
    if (allData == null) {
      return null;
    }
    return allData?.data?.datas;
  }

  ///获得用户积分
  Future<UserBeanCoininfo> getIntegral() async {
    var response = await HttpUtils.request(USER_COIN, method: HttpUtils.GET);
    if (response == null) {
      return getIntegral();
    }
    if (response["data"] != null) {
      UserBeanCoininfo data = UserBeanCoininfo.fromJson(response["data"]);
      Application.profile.user.coinInfo = data;
      Application.saveProfile();
      return data;
    } else {
      return getIntegral();
    }
  }

  //保存或者修改账本信息
  Future saveBook(MyBookBeanEntity data) async {
    return MyBookDao().saveData(data);
  }

  //删除账本信息
  Future removeBook(int userId, int bookId, Function onCallBack) async {
    await MyTallyDao().removeDataByBookId(userId, bookId, callBack: () async { //删除关于此账本的账单
      await MyBookDao().removeDataById(bookId, callBack: onCallBack); //删除账本
    });

  }
}