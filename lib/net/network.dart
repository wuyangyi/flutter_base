
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/chat/chat_message_info_bean_entity.dart';
import 'package:flutter_base/bean/chat/chat_send_bean_entity.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/dao/UserDao.dart';
import 'package:flutter_base/bean/dao/chat/ChatInfoDao.dart';
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

import 'chat_dio_util.dart';
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
      RecommendBeanData data = RecommendBeanData(
        slider: [
          RecommandBeanDataSlider(
            picUrl: "http://hbimg.b0.upaiyun.com/f890b857cbe851d5ccd63418d2662797a1a70b9576216-OctfNE_fw658",
            id: 0,
            linkUrl: "http://hbimg.b0.upaiyun.com/f890b857cbe851d5ccd63418d2662797a1a70b9576216-OctfNE_fw658",
          ),
          RecommandBeanDataSlider(
            picUrl: "http://img.zcool.cn/community/018b8a5adea216a80120927b1e20ec.jpg@1280w_1l_2o_100sh.jpg",
            id: 0,
            linkUrl: "http://img.zcool.cn/community/018b8a5adea216a80120927b1e20ec.jpg@1280w_1l_2o_100sh.jpg",
          ),
          RecommandBeanDataSlider(
            picUrl: "http://img.zcool.cn/community/01626259f67c4fa801202b0cab54b5.jpg@1280w_1l_2o_100sh.jpg",
            id: 0,
            linkUrl: "http://img.zcool.cn/community/01626259f67c4fa801202b0cab54b5.jpg@1280w_1l_2o_100sh.jpg",
          ),
          RecommandBeanDataSlider(
            picUrl: "http://img.zcool.cn/community/01988459ecae0ba801216a4b9322ab.jpg@1280w_1l_2o_100sh.jpg",
            id: 0,
            linkUrl: "http://img.zcool.cn/community/01988459ecae0ba801216a4b9322ab.jpg@1280w_1l_2o_100sh.jpg",
          ),
          RecommandBeanDataSlider(
            picUrl: "http://img.zcool.cn/community/01950e58acf2baa801219c775ad064.jpg",
            id: 0,
            linkUrl: "http://img.zcool.cn/community/01950e58acf2baa801219c775ad064.jpg",
          ),
          RecommandBeanDataSlider(
            picUrl: "http://img.zcool.cn/community/0142eb59758719a8012193a38ff3d5.jpg@1280w_1l_2o_100sh.png",
            id: 0,
            linkUrl: "http://img.zcool.cn/community/0142eb59758719a8012193a38ff3d5.jpg@1280w_1l_2o_100sh.png",
          ),
        ],
        radioList: [
          RecommandBeanDataRadiolist(
            picUrl: "http://wx4.sinaimg.cn/orj360/776990e0ly1g1yjcsn35wj20v90r0ae9.jpg",
            ftitle: "热歌",
            radioid: 0,
          ),
          RecommandBeanDataRadiolist(
            picUrl: "http://p2.music.126.net/TFF5xp3Iltc_m4RACMBY-A==/5514050813393442.jpg",
            ftitle: "一人一首出名歌",
            radioid: 0,
          ),
        ],
        songList: [
          RecommandBeanDataSonglist(
            picUrl: "http://p1.music.126.net/UwAkAD_0ZDrkLEVC3lrrJw==/3416182628949245.jpg",
            songListDesc: "[VIP专享]一周新歌推荐",
            id: "0",
            albumPicMid: "0",
            picMid: "0",
            accessnum: 12554500,
            songListAuthor: ""
          ),
          RecommandBeanDataSonglist(
              picUrl: "http://p1.music.126.net/8PkYZGk0AbThTciV_EjbiQ==/18015498021373133.jpg",
              songListDesc: "失恋歌单，只有歌曲才能安慰自己！",
              id: "0",
              albumPicMid: "0",
              picMid: "0",
              accessnum: 22834800,
              songListAuthor: ""
          ),
          RecommandBeanDataSonglist(
              picUrl: "http://p1.music.126.net/jr5gmterKUdu1A7Cv6pqcA==/6668538023356477.jpg",
              songListDesc: "在这些孤单角色里，你是否能找到自己？",
              id: "0",
              albumPicMid: "0",
              picMid: "0",
              accessnum: 46489600,
              songListAuthor: ""
          ),
          RecommandBeanDataSonglist(
              picUrl: "http://hbimg.huabanimg.com/96394ce383f3e03eb1d5873b0cf2e7ac1053d705ca961-3ON38T_fw236",
              songListDesc: "夜里做了美丽的噩梦",
              id: "0",
              albumPicMid: "0",
              picMid: "0",
              accessnum: 54655200,
              songListAuthor: ""
          ),
          RecommandBeanDataSonglist(
              picUrl: "http://pic76.nipic.com/file/20150825/9431976_161223102862_2.jpg",
              songListDesc: "原有星光的夜晚，总有浪漫的期许",
              id: "0",
              albumPicMid: "0",
              picMid: "0",
              accessnum: 25658600,
              songListAuthor: ""
          ),
          RecommandBeanDataSonglist(
              picUrl: "http://hbimg.b0.upaiyun.com/fe63f355ccdb6ae3f7d7c279b4dc39e614af99ef34ad7-GJ6hqp_fw658",
              songListDesc: "薛之谦 陈奕迅 李荣浩 林宥嘉 凌俊杰 郭顶",
              id: "0",
              albumPicMid: "0",
              picMid: "0",
              accessnum: 12315500,
              songListAuthor: ""
          ),
        ],
      );
      return data;
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


  static final String TL_CHAT = "openapi/api/v2";

  //聊天
  Future<ChatMessageInfoBeanEntity> sendMessage(String text, ChatSendBeanPerceptionSelfinfoLocation location, {Function callBack}) async {
    ChatSendBeanEntity chatSendBeanEntity = new ChatSendBeanEntity(
      userInfo: ChatSendBeanUserinfo(
        apiKey: "73808218b0544165a57901cb4c4cf5f7",
        userId: "484225",
      ),
      reqType: 0,
      perception: ChatSendBeanPerception(
        inputText: ChatSendBeanPerceptionInputtext(
          text: text,
        ),
        selfInfo: ChatSendBeanPerceptionSelfinfo(
          location: location,
        ),
      ),
    );
    var response = await ChatHttpUtils.request(TL_CHAT, method: ChatHttpUtils.POST, data: chatSendBeanEntity.toJson());
    if (response == null) {
      return null;
    }
    ChatMessageInfoBeanEntity chatMessageBeanEntity = ChatMessageInfoBeanEntity.fromJson(response);
    if (callBack != null) {
      callBack(chatMessageBeanEntity);
    }
    return chatMessageBeanEntity;
  }
}