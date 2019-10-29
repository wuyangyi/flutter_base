import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/toast_util.dart';

class Util {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'images/$name.$format';
  }

  //手机号验证
  static bool checkPhone(String phone, {bool isNeedHint = true}) {
    if (phone.isEmpty) {
      if (isNeedHint) {
        ToastUtil.showToast("手机号不能为空");
      }
      return false;
    }
    RegExp mobile = new RegExp(r"1[0-9]\d{9}$");
    if (!mobile.hasMatch(phone)) {
      if (isNeedHint) {
        ToastUtil.showToast("手机号格式不正确");
      }
      return false;
    }
    return true;
  }

  //密码验证
  static bool checkPwd(String password) {
    if (password.isEmpty) {
      ToastUtil.showToast("密码不能为空");
      return false;
    }
    if (password.length < 6) {
      ToastUtil.showToast("请输入6位以上的密码");
      return false;
    }
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$");
    if(!mobile.hasMatch(password)) {
      ToastUtil.showToast("请输入6-20位数字和字符的组合");
      return false;
    }
    return true;
  }

  //验证码验证
  static bool checkCode(String code) {
    if (code.isEmpty) {
      ToastUtil.showToast("验证码不能为空");
      return false;
    }
    RegExp mobile = new RegExp(r"\d{6}$");
    if(!mobile.hasMatch(code)) {
      ToastUtil.showToast("请输入6位的验证码");
      return false;
    }
    return true;
  }

  //姓名验证
  static bool checkName(String name) {
    if (name.isEmpty) {
      ToastUtil.showToast("姓名不能为空");
      return false;
    }
    RegExp mobile = new RegExp(r"(([\u4e00-\u9fa5]{2,8})|([a-zA-Z]{2,16}))$");
    if(!mobile.hasMatch(name)) {
      ToastUtil.showToast("姓名格式不正确");
      return false;
    }
    return true;
  }
  //邮箱验证
  static bool checkEmail(String email) {
    if (email.isEmpty) {
      ToastUtil.showToast("邮箱不能为空");
      return false;
    }
    RegExp mobile = new RegExp(r"[A-Z0-9a-z._%+-]*@[a-zA-Z0-9][\w-]*\.(?:com|cn|net|com.cn|qq.com|com.tw|sina.com|163.com|co.jp|com.hk)$");
    if(!mobile.hasMatch(email)) {
      ToastUtil.showToast("邮箱格式不正确");
      return false;
    }
    return true;
  }

  //设置沉浸式状态栏 字色为黑色
  static setTransAppBarDark(){
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  //设置沉浸式状态栏 字色为白色
  static setTransAppBarWhite(){
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  static String getStringByJson(Map<String, dynamic> json, String key, String defaultValue) {
    if (json[key] != null) {
      return json[key] as String;
    }
    return defaultValue;
  }

  static int getIntByJson(Map<String, dynamic> json, String key, int defaultValue) {
    if (json[key] != null) {
      return json[key] as int;
    }
    return defaultValue;
  }

}