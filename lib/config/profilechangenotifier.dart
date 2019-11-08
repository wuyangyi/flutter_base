

import 'package:flutter/cupertino.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/profile_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';

import 'application.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  ProfileEntity get _profile => Application.profile;

  @override
  void notifyListeners() {
    Application.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

//用户状态
class UserModel extends ProfileChangeNotifier {
  UserBeanEntity get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null && _profile.isLogin;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(UserBeanEntity user) {
    _profile.user = user;
    _profile.isLogin = true;
    notifyListeners();
  }

  void outLogin() {
    _profile.isLogin = false;
    _profile.user = null;
    notifyListeners();
  }
}

//账本状态
class BookModel extends ChangeNotifier {
  //用于保存账本列表
  final List<MyBookBeanEntity> _books = [];

  List<MyBookBeanEntity> get books => _books;

  void add(MyBookBeanEntity bookBeanEntity) {
    _books.add(bookBeanEntity);
    notifyListeners();
  }

  void addAll(List<MyBookBeanEntity> bookBeanEntitys) {
    _books.addAll(bookBeanEntitys);
    notifyListeners();
  }
}