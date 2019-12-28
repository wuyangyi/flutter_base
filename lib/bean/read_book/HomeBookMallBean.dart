
import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_type_bean_entity.dart';

class HomeBookMallBean extends BaseBean {
  List<RankBeanEntity> data;
  RankTypeBeanEntity type;
  HomeBookMallBean(this.data, this.type);
}