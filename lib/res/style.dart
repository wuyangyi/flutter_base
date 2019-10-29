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
  // 垂直间隔
  static Widget vGap5 = new SizedBox(height: 5.0);
  static Widget vGap10 = new SizedBox(height: 10.0);
}


///分割线
class Decorations {
  //无分割线
  static Decoration bottomNo = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.0, color: Colors.transparent,)));


  //首页分割线
  static Decoration homeBottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFF1F3F5),)));
}