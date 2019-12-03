import 'package:flutter/material.dart';

import 'index.dart';

class TextStyles {
  static TextStyle listContent = TextStyle(
    fontSize: 14.0,
    color: MyColors.text_normal,
  );
}

//  间隔
class Gaps {
  // 水平间隔
  static Widget hGap5 = new SizedBox(width: 5.0);
  static Widget hGap10 = new SizedBox(width: 10.0);
  static Widget hGap15 = new SizedBox(width: 15.0);
  static Widget hGap20 = new SizedBox(width: 20.0);
  // 垂直间隔
  static Widget vGap5 = new SizedBox(height: 5.0);
  static Widget vGap10 = new SizedBox(height: 10.0);
  static Widget vGap15 = new SizedBox(height: 15.0);
  static Widget vGap20 = new SizedBox(height: 20.0);
}


///分割线
class Decorations {
  //无分割线
  static Decoration bottomNo = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.0, color: Colors.transparent,)));
  //登录页面分割线
  static Decoration bottom = BoxDecoration(
    color: Colors.white,
      border: Border(bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor,)));
  //登录页面分割线
  static Decoration bottomSelect = BoxDecoration(
      border: Border(bottom: BorderSide(width: 2.0, color: MyColors.selectColor,)));

  //首页分割线
  static Decoration homeBottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFF1F3F5),)));
  //完善信息页面分割线
  static Decoration finishBottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.5, color: MyColors.finishDriverColor,)));
}