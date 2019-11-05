import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/my_coin_desc_info_bean_entity.dart';
import 'package:flutter_base/bean/official_accounts_bean_entity.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/bean/user_coin_list_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "CityBeanEntity") {
      return CityBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "MyCoinDescInfoBeanEntity") {
      return MyCoinDescInfoBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "OfficialAccountsBeanEntity") {
      return OfficialAccountsBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "ProfileEntity") {
      return ProfileEntity.fromJson(json) as T;
    } else if (T.toString() == "UserBeanEntity") {
      return UserBeanEntity.fromJson(json) as T;
    } else if (T.toString() == "UserCoinListBeanEntity") {
      return UserCoinListBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}