
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';

class DataConfig {
  static CityBeanEntity cityData;

  static var myBookColors = [
    [Color(0xFFB5BCF3), Color(0xFFB5ADF3)],
    [Color(0xFFFFBDFF), Color(0xFFFF9FFF)],
    [Color(0xFF4BE3D5), Color(0xFF4BD5D5)],
    [Color(0x997F80CA), Color(0xFF7F80CA)],
    [Color(0x99BEF0FF), Color(0xFFBEF0FF)],
    [Color(0x997CAAFF), Color(0xFF7CAAFF)],
    [Color(0x99CF73FF), Color(0xFFCF73FF)],
    [Color(0x99FF8C00), Color(0xFFFF8C00)],
    [Color(0x99E5778B), Color(0xFFE5778B)],
    [Color(0x990495FB), Color(0xFF0495FB)],
    [Color(0x9939CE15), Color(0xFF39CE15)],
    [Color(0x99C12233), Color(0xFFC12233)],
  ];
  
  static var bookTypes = [
    BookTypeBean(Icons.shopping_cart, "日常账本", "记录生活点滴，和家人伙伴一起分享"),
    BookTypeBean(Icons.face, "宝宝账本", "陪伴宝宝一起成长"),
    BookTypeBean(Icons.card_travel, "生意账本", "流水实时掌握，轻松打理生意往来"),
    BookTypeBean(Icons.train, "旅行账本", "说走就走的旅行成本有多大"),
    BookTypeBean(Icons.school, "校园账本", "学生党必备，生活支出精打细算"),
    BookTypeBean(Icons.favorite_border, "结婚账本", "操办婚礼井井有条，要浪漫也要务实"),
    BookTypeBean(Icons.drive_eta, "汽车账本", "记录爱车消费，伴你记账伴你行"),
    BookTypeBean(Icons.format_paint, "装修账本", "转为装修场景打造，哔哔开销有据可查"),
  ];
}