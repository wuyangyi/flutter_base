import 'package:flutter_base/bean/official_accounts_bean_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "OfficialAccountsBeanEntity") {
      return OfficialAccountsBeanEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}