
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';

class DataConfig {
  static CityBeanEntity cityData;

  static Size appSize; //手机的高宽

  static var myBookColors = [
    [Color(0xFFFFBDFF), Color(0xFFFF9FFF)],
    [Color(0xFF4BE3D5), Color(0xFF4BD5D5)],
    [Color(0x99FF8C00), Color(0xFFFF8C00)],
    [Color(0xFFB5BCF3), Color(0xFFB5ADF3)],
    [Color(0x997F80CA), Color(0xFF7F80CA)],
    [Color(0x99BEF0FF), Color(0xFFBEF0FF)],
    [Color(0x997CAAFF), Color(0xFF7CAAFF)],
    [Color(0x99CF73FF), Color(0xFFCF73FF)],
    [Color(0x99E5778B), Color(0xFFE5778B)],
    [Color(0x990495FB), Color(0xFF0495FB)],
    [Color(0x9939CE15), Color(0xFF39CE15)],
    [Color(0x99C12233), Color(0xFFC12233)],
  ];
  
  static var bookTypes = [
    BookTypeBean(Icons.shopping_cart, "日常账本", "记录生活点滴，和家人伙伴一起分享",
        [
          BookItemBean(Icons.restaurant_menu, "餐饮", Colors.orangeAccent),
          BookItemBean(Icons.flash_on, "电费", Colors.lightGreen),
          BookItemBean(Icons.opacity, "水费", Colors.amber),
          BookItemBean(Icons.home, "居住", Colors.greenAccent),
          BookItemBean(Icons.shopping_cart, "购物", Colors.blue),
          BookItemBean(Icons.settings_cell, "话费", Colors.deepPurpleAccent),
          BookItemBean(Icons.local_hospital, "医疗", Colors.red),
          BookItemBean(Icons.hot_tub, "娱乐", Colors.lightBlue),
          BookItemBean(Icons.fitness_center, "健身", Colors.pinkAccent),
          BookItemBean(Icons.local_taxi, "交通", Colors.green),
          BookItemBean(Icons.school, "教育", Colors.limeAccent),
          BookItemBean(Icons.attach_money, "人情", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.work, "工资", Colors.amber),
          BookItemBean(Icons.local_post_office, "红包", Colors.red),
          BookItemBean(Icons.monetization_on, "生活费", Colors.limeAccent),
          BookItemBean(Icons.speaker, "奖金", Colors.deepPurpleAccent),
          BookItemBean(Icons.assignment, "报销", Colors.green),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]
    ),
    BookTypeBean(Icons.face, "宝宝账本", "陪伴宝宝一起成长",
        [
          BookItemBean(Icons.restaurant, "宝宝食物", Colors.amber),
          BookItemBean(Icons.child_friendly, "宝宝用品", Colors.lightGreen),
          BookItemBean(Icons.child_care, "写真", Colors.greenAccent),
          BookItemBean(Icons.local_hospital, "医疗护理", Colors.red),
          BookItemBean(Icons.attach_money, "零花钱", Colors.deepPurpleAccent),
          BookItemBean(Icons.pool, "玩乐", Colors.orangeAccent),
          BookItemBean(Icons.music_note, "培训", Colors.lightBlue),
          BookItemBean(Icons.school, "教育", Colors.limeAccent),
          BookItemBean(Icons.toys, "玩具", Colors.green),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.card_giftcard, "礼金", Colors.red),
          BookItemBean(Icons.attach_money, "压岁钱", Colors.lightBlue),
          BookItemBean(Icons.monetization_on, "生活费", Colors.pinkAccent),
          BookItemBean(Icons.speaker, "奖学金", Colors.green),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]
    ),
    BookTypeBean(Icons.card_travel, "生意账本", "流水实时掌握，轻松打理生意往来",
        [
          BookItemBean(Icons.business, "物业租金", Colors.amber),
          BookItemBean(Icons.featured_play_list, "货品材料", Colors.lightGreen),
          BookItemBean(Icons.data_usage, "运营费用", Colors.greenAccent),
          BookItemBean(Icons.monetization_on, "税费", Colors.red),
          BookItemBean(Icons.attach_money, "零花钱", Colors.deepPurpleAccent),
          BookItemBean(Icons.desktop_windows, "办公费用", Colors.orangeAccent),
          BookItemBean(Icons.local_shipping, "货物运输", Colors.lightBlue),
          BookItemBean(Icons.people, "人工支出", Colors.limeAccent),
          BookItemBean(Icons.business_center, "出差报销", Colors.green),
          BookItemBean(Icons.local_bar, "团建聚会", Colors.green),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.equalizer, "销售额", Color(0xFFFF9FFF)),
          BookItemBean(Icons.score, "提成", Colors.red),
          BookItemBean(Icons.attach_money, "退款", Color(0xFF4BD5D5)),
          BookItemBean(Icons.input, "投资", Colors.deepPurpleAccent),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
    BookTypeBean(Icons.train, "旅行账本", "说走就走的旅行成本有多大",
        [
          BookItemBean(Icons.restaurant_menu, "餐饮", Colors.orangeAccent),
          BookItemBean(Icons.home, "居住", Colors.greenAccent),
          BookItemBean(Icons.shopping_cart, "购物", Colors.blue),
          BookItemBean(Icons.supervised_user_circle, "参团费", Colors.red),
          BookItemBean(Icons.hot_tub, "娱乐", Colors.lightBlue),
          BookItemBean(Icons.local_taxi, "交通", Colors.green),
          BookItemBean(Icons.explore, "导游", Colors.pinkAccent),
          BookItemBean(Icons.card_travel, "景点门票", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.attach_money, "退款", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
    BookTypeBean(Icons.school, "校园账本", "学生党必备，生活支出精打细算",
        [
          BookItemBean(Icons.restaurant_menu, "餐饮", Colors.orangeAccent),
          BookItemBean(Icons.fastfood, "零食", Colors.lightGreen),
          BookItemBean(Icons.shopping_cart, "日用品", Colors.blue),
          BookItemBean(Icons.settings_cell, "话费网费", Colors.deepPurpleAccent),
          BookItemBean(Icons.hot_tub, "娱乐", Colors.lightBlue),
          BookItemBean(Icons.local_bar, "聚餐", Colors.pinkAccent),
          BookItemBean(Icons.local_taxi, "交通", Colors.green),
          BookItemBean(Icons.home, "住宿", Colors.limeAccent),
          BookItemBean(Icons.attach_money, "学杂费", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.monetization_on, "生活费", Colors.pinkAccent),
          BookItemBean(Icons.work, "兼职", Colors.red),
          BookItemBean(Icons.attach_money, "压岁钱", Colors.lightBlue),
          BookItemBean(Icons.speaker, "奖学金", Colors.green),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
    BookTypeBean(Icons.favorite_border, "结婚账本", "操办婚礼井井有条，要浪漫也要务实",
        [
          BookItemBean(Icons.category, "结婚物品", Colors.redAccent),
          BookItemBean(Icons.card_travel, "婚礼支出", Colors.red),
          BookItemBean(Icons.favorite_border, "度蜜月", Colors.pinkAccent),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.card_giftcard, "礼金", Colors.redAccent),
          BookItemBean(Icons.local_post_office, "红包", Colors.red),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
    BookTypeBean(Icons.drive_eta, "汽车账本", "记录爱车消费，伴你记账伴你行",
        [
          BookItemBean(Icons.local_gas_station, "加油费", Colors.blueAccent),
          BookItemBean(Icons.local_parking, "停车费", Colors.blue),
          BookItemBean(Icons.security, "保险费", Color(0xFFBEF0FF)),
          BookItemBean(Icons.local_drink, "定期保养", Colors.green),
          BookItemBean(Icons.local_car_wash, "洗车擦车", Colors.lightBlue),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.attach_money, "退款", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
    BookTypeBean(Icons.format_paint, "装修账本", "转为装修场景打造，哔哔开销有据可查",
        [
          BookItemBean(Icons.local_florist, "软装", Colors.lightGreen),
          BookItemBean(Icons.layers, "硬装", Colors.greenAccent),
          BookItemBean(Icons.person, "装修工人", Color(0xFF7CAAFF)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ],
        [
          BookItemBean(Icons.attach_money, "退款", Color(0xFF4BD5D5)),
          BookItemBean(Icons.star_border, "其他", Colors.blueGrey),
        ]),
  ];


  //条件选择
  static int selectBookIndex = 0; //账本选择位置
  static String selectYear = "不限"; //选择的年
  static String selectMonth = "不限"; //选择的月
  static String selectDay = "不限"; //选择的天
  static String selectType = "不限"; //类别选择


  static var myChatColors = [
    [Colors.white, Color(0xFFCCCCCC)],
    [Colors.deepPurpleAccent[100], Colors.deepPurpleAccent[200]],
    [Color(0xFF4BE3D5), Color(0xFF4BD5D5)],
    [Color(0x99FF8C00), Color(0xFFFF8C00)],
    [Color(0xFFB5BCF3), Color(0xFFB5ADF3)],
    [Color(0x997F80CA), Color(0xFF7F80CA)],
    [Color(0x99BEF0FF), Color(0xFFBEF0FF)],
    [Color(0x997CAAFF), Color(0xFF7CAAFF)],
    [Color(0x99CF73FF), Color(0xFFCF73FF)],
    [Color(0x99E5778B), Color(0xFFE5778B)],
    [Color(0x990495FB), Color(0xFF0495FB)],
  ];
}