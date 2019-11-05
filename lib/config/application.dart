import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:provider/provider.dart';

class Application {
  static ProfileEntity profile = ProfileEntity();

  ///初始化全局配置
  static Future init() async {
    await SpUtil.getInstance();
    var _profile = SpUtil.getString(Ids.appProfile);
    if (_profile != null) {
      try {
        profile = ProfileEntity.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }

  // 持久化Profile信息
  static saveProfile() =>
      SpUtil.putString(Ids.appProfile, jsonEncode(profile.toJson()));


  //是否已登录
  static bool isLogin(BuildContext context) {
    return profile != null && Provider.of<UserModel>(context).isLogin;
  }
}