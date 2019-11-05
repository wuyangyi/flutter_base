import 'package:flutter/material.dart';

class HomeAppBean {
  String title;
  String desc;
  String logo;
  Widget route;
  HomeAppBean(this.title, this.desc, this.logo, {this.route});
}