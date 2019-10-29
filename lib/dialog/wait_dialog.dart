import 'package:flutter/material.dart';
import 'package:flutter_base/widgets/widgets.dart';

typedef LoadCallback = Future<bool> Function(); //加载时执行的方法
///加载动画弹窗
///message 提示词
///doLoading 加载过程中所要执行的方法，必须返回一个Future<bool> ，为true关闭加载动画，为false不关闭
showLoadingDialog(BuildContext context, {LoadCallback doLoading}) async {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(true); //false屏蔽返回键
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Color(0x60000000),
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              //控件里面内容主轴负轴居中显示
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              //主轴高度最小
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                WaitDialogProgress(Size(30.0, 30.0), "ic_loading_white_", 11),
              ],
            ),
          ),
        ),
      );
    },
  );
  if (doLoading != null && await doLoading()) {
    Navigator.pop(context);
  }
}