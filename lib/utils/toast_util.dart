
//Toast工具类
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  //Toast
  static void showToast(String msg, {ToastGravity gravity = ToastGravity.CENTER, Toast toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: 1,
        backgroundColor: Color(0x80000000),
        textColor: Color(0xFFFFFFFF)
    );
  }
}