import 'package:flutter/material.dart';
//账本类别
class BookTypeBean {
  IconData icon;
  String title;
  String desc;
  List<BookItemBean> pay; //支出
  List<BookItemBean> income; //收入

  BookTypeBean(this.icon, this.title, this.desc, this.pay, this.income);

}

class BookItemBean {
  IconData icon;
  String name;
  Color color;
  BookItemBean(this.icon, this.name, this.color);
}