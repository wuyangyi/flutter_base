import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/music/music_all_bean_entity.dart';
import 'package:flutter_base/bean/music/music_search_hot_key_entity.dart';
import 'package:flutter_base/bean/music/music_singer_bean_entity.dart';
import 'package:flutter_base/bean/music/recommend_bean_entity.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_coin_desc_info_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/bean/official_accounts_bean_entity.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/bean/run/week_run_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/bean/user_coin_list_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "CityBeanEntity") {
      return CityBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "MusicAllBeanEntity") {
      return MusicAllBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "MusicSearchHotKeyEntity") {
      return MusicSearchHotKeyEntity.fromJson(json) as T;
    } else if (T.toString() == "MusicSingerBeanEntity") {
      return MusicSingerBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "RecommendBeanData") {
      return RecommendBeanData.fromJson(json) as T;
    } else if (T.toString() == "MyBookBeanEntity") {
      return MyBookBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "MyCoinDescInfoBeanEntity") {
      return MyCoinDescInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "MyTallyBeanEntity") {
      return MyTallyBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "OfficialAccountsBeanEntity") {
      return OfficialAccountsBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ProfileEntity") {
      return ProfileEntity.fromJson(json) as T;
    } else if (T.toString() == "RunInfoBeanEntity") {
      return RunInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WeekRunBeanEntity") {
      return WeekRunBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "UserBeanEntity") {
      return UserBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "UserCoinListBeanEntity") {
      return UserCoinListBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}