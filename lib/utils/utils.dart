import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/userinfo_select.dart';
import 'package:flutter_base/config/data_config.dart';
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

  static String getUserHeadImageName(String sex) {
    if (sex == null) {
      return "pic_default_secret";
    }
    if(sex == "男") {
      return "pic_default_man";
    } else if (sex == "女") {
      return "pic_default_woman";
    } else {
      return "pic_default_secret";
    }
  }

  //用户信息选择更改选择位置
  static List<UserInfoSelectBean> upDataSelect(List<UserInfoSelectBean> list, int selected) {
    if(list.isEmpty) {
      return list;
    }
    for (int index = 0; index < list.length; index++) {
      list[index].selected = index == selected;
    }
    return list;
  }

  //获得当前账单的图标和颜色
  static BookItemBean getBookItemBean(String useType, String type, String bookType) {
    BookItemBean bookItemBean;
    DataConfig.bookTypes.forEach((item){
      if (item.title == bookType) {
        if (type == "支出") {
          item.pay.forEach((data){
            if (data.name == useType) {
              bookItemBean = data;
            }
          });
        } else {
          item.income.forEach((data){
            if (data.name == useType) {
              bookItemBean = data;
            }
          });
        }
      }
    });
    return bookItemBean;
  }

  /*
   * 根据年月，获取最大天数
   */
  static int getMaxDay(int year, int month) {
    int maxDay = 30;
    switch(month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        maxDay = 31;
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        maxDay = 30;
        break;
      case 2:
        if (year % 100 == 0) { //整百年  能整除400为闰年
          if (year % 400 == 0) {
            maxDay = 29;
          } else {
            maxDay = 28;
          }
        } else { //非整百年，能整除4位闰年
          if (year % 4 == 0) {
            maxDay = 29;
          } else {
            maxDay = 28;
          }
        }
        break;
    }
    return maxDay;
  }

}