
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/dao/UserDao.dart';
import 'package:flutter_base/bean/music/music_all_bean_entity.dart';
import 'package:flutter_base/bean/music/music_search_hot_key_entity.dart';
import 'package:flutter_base/bean/music/music_singer_bean_entity.dart';
import 'package:flutter_base/bean/music/recommend_bean_entity.dart';
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
import 'music_dio_util.dart';

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
  Future<UserBeanEntity> login(String username, String password, {Function callBack}) async {
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
    if(callBack != null) {
      callBack();
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



  ///音乐播放器
  //首页推荐
  static final String MUSCI_HOME_RECOMMEND = "musichall/fcgi-bin/fcg_yqqhomepagerecommend.fcg?g_tk=1928093487&inCharset=utf-8&outCharset=utf-8&notice=0&format=jsonp&platform=h5&uin=0&needNewCode=1&jsonpCallback=jp0";
  static final String MUSIC_SEARCH_HOTKEY = "splcloud/fcgi-bin/gethotkey.fcg?g_tk=531708863&uin=1297716249&format=json&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&needNewCode=1&_=1545026658181";
  static final String MUSIC_SINGER = "v8/fcg-bin/v8.fcg?g_tk=1928093487&inCharset=utf-8&outCharset=utf-8&notice=0&format=jsonp&channel=singer&page=list&key=all_all_all&hostUin=0&needNewCode=0&platform=yqq&jsonpCallback=jp0";

  //http://ustbhuangyi.com/music/api/getDiscList?g_tk=1928093487&inCharset=utf-8&outCharset=utf-8&notice=0&format=json&platform=yqq&hostUin=0&sin=0&ein=29&sortId=5&needNewCode=0&categoryId=10000000&rnd=0.23358193201300614
  //https://c.y.qq.com/splcloud/fcgi-bin/gethotkey.fcg?g_tk=531708863&uin=1297716249&format=json&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&needNewCode=1&_=1545026658181
  //https://c.y.qq.com/v8/fcg-bin/fcg_myqq_toplist.fcg?g_tk=1928093487&inCharset=utf-8&outCharset=utf-8&notice=0&format=jsonp&uin=0&needNewCode=1&platform=h5&jsonpCallback=jp0
  //https://c.y.qq.com/v8/fcg-bin/v8.fcg?g_tk=1928093487&inCharset=utf-8&outCharset=utf-8&notice=0&format=jsonp&channel=singer&page=list&key=all_all_all&pagesize=100&pagenum=1&hostUin=0&needNewCode=0&platform=yqq&jsonpCallback=jp0

  /*
   * 首页推荐
   */
  Future<RecommendBeanData> getMusicRecommendData({Function callBack}) async {
    var response = await MusicHttpUtils.request(MUSCI_HOME_RECOMMEND, method: MusicHttpUtils.GET);
    if (response == null || response["data"] == null) {
      return null;
    }
    RecommendBeanData data = RecommendBeanData.fromJson(response["data"]);
    if (callBack != null) {
      callBack(data);
    }
    print("数据L:${response.toString()}");
    return data;
  }


  /*
   * 搜索热词
   */
  Future<List<MusicSearchHotKeyHotkey>> getMusicSearchHotKey({Function callBack}) async {
    var response = await MusicHttpUtils.request(MUSIC_SEARCH_HOTKEY, method: MusicHttpUtils.GET);
    if (response == null || response["data"] == null) {
      return null;
    }
    MusicSearchHotKeyEntity data = MusicSearchHotKeyEntity.fromJson(response["data"]);
    if (callBack != null) {
      callBack(data.hotkey);
    }
    print("数据L:${response.toString()}");
    return data.hotkey;
  }


  //&pagesize=100&pagenum=2
  /*
   * 歌手
   * pagesize 一个的个数
   * pagenum 页面
   */
  Future<List<MusicSingerBeanList>> getMusicSinger(int page, int pageSize, {Function callBack}) async {
    addMap("pagenum", page.toString());
    addMap("pagesize", pageSize.toString());
    var response = await MusicHttpUtils.request(MUSIC_SINGER, method: MusicHttpUtils.GET, mapApi: mapApi);
    if (response == null || response["data"] == null) {
      return null;
    }
    MusicSingerBeanEntity data = MusicSingerBeanEntity.fromJson(response["data"]);
    if (callBack != null) {
      callBack(data.xList);
    }
    print("数据L:${response.toString()}");
    return data.xList;
  }
}