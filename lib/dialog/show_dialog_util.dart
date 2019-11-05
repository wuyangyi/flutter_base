import 'package:flutter/material.dart';
import 'package:flutter_base/system/bottom_sheet.dart';


//从底部弹窗菜单列表  showModalBottomSheets是对源码showModalBottomSheet的修改  去掉了maxHeight
Future showModalBottomSheetUtil(BuildContext context, T, {ShapeBorder shapeBorder}) {
  return showModalBottomSheets(
      context: context,
      shape: shapeBorder,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return T;
      }
  );
}