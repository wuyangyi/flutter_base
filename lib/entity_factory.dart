import 'package:flutter_base/bean/chat/chat_info_bean_entity.dart';
import 'package:flutter_base/bean/chat/chat_message_bean_entity.dart';
import 'package:flutter_base/bean/chat/chat_message_info_bean_entity.dart';
import 'package:flutter_base/bean/chat/chat_send_bean_entity.dart';
import 'package:flutter_base/bean/chess/chess_game_info_bean_entity.dart';
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
import 'package:flutter_base/bean/read_book/classify_bean_entity.dart';
import 'package:flutter_base/bean/read_book/classify_bean_two_entity.dart';
import 'package:flutter_base/bean/read_book/hot_search_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_type_bean_entity.dart';
import 'package:flutter_base/bean/read_book/read_book_bean_entity.dart';
import 'package:flutter_base/bean/read_book/search_all_bean_entity.dart';
import 'package:flutter_base/bean/read_book/search_book_bean_entity.dart';
import 'package:flutter_base/bean/run/run_info_bean_entity.dart';
import 'package:flutter_base/bean/run/week_run_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/bean/user_coin_list_bean_entity.dart';
import 'package:flutter_base/bean/weather/weather_bean_entity.dart';
import 'package:flutter_base/bean/weather/weather_city_list_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ChatInfoBeanEntity") {
      return ChatInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ChatMessageBeanEntity") {
      return ChatMessageBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ChatMessageInfoBeanEntity") {
      return ChatMessageInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ChatSendBeanEntity") {
      return ChatSendBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ChessGameInfoBeanEntity") {
      return ChessGameInfoBeanEntity.fromJson(json) as T;
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
    } else if (T.toString() == "ClassifyBeanEntity") {
      return ClassifyBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ClassifyBeanTwoEntity") {
      return ClassifyBeanTwoEntity.fromJson(json) as T;
    } else if (T.toString() == "HotSearchBeanEntity") {
      return HotSearchBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "RankBeanEntity") {
      return RankBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "RankTypeBeanEntity") {
      return RankTypeBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ReadBookBeanEntity") {
      return ReadBookBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "SearchAllBeanEntity") {
      return SearchAllBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "SearchBookBeanEntity") {
      return SearchBookBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "RunInfoBeanEntity") {
      return RunInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WeekRunBeanEntity") {
      return WeekRunBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "UserBeanEntity") {
      return UserBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "UserCoinListBeanEntity") {
      return UserCoinListBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WeatherBeanEntity") {
      return WeatherBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "WeatherCityListBeanEntity") {
      return WeatherCityListBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}