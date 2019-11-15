

import 'package:flutter/cupertino.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
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

  void clearAll() {
    _books.clear();
    notifyListeners();
  }

  void removeOne(int index) {
    _books.removeAt(index);
    notifyListeners();
  }

  void update(MyBookBeanEntity data) {
    for(int i = 0; i< _books.length; i++) {
      if (_books[i].id == data.id) {
        _books[i] = data;
      }
    }
  }
}

//本月账单列表
class TallyModel extends ChangeNotifier {
  //用于保存本月账单列表
  final List<MyTallyBeanEntity> _tally = [];

  List<MyTallyBeanEntity> get tally => _tally;

  void add(MyTallyBeanEntity myTallyBeanEntity) {
    _tally.add(myTallyBeanEntity);
    notifyListeners();
  }

  void addAll(List<MyTallyBeanEntity> myTallyBeanEntitys) {
    _tally.addAll(myTallyBeanEntitys);
    notifyListeners();
  }

  void clearAll() {
    _tally.clear();
    notifyListeners();
  }

  void removeOne(int id) {
    for(int i = 0; i < _tally.length; i++) {
      if (id == _tally[i].id) {
        _tally.removeAt(i);
        return;
      }
    }
    notifyListeners();
  }

  void update(MyTallyBeanEntity data) {
    for(int i = 0; i< _tally.length; i++) {
      if (_tally[i].id == data.id) {
        _tally[i] = data;
      }
    }
    notifyListeners();
  }

  //获得某本账本本月的账单
  List<MyTallyBeanEntity> getTallyByBookId(int bookId) {
    List<MyTallyBeanEntity> data = [];
    _tally.forEach((item){
      if (item.bookId == bookId) {
        data.add(item);
      }
    });
    return data;
  }

  //本月支出
  double getPay(int bookId) {
    double pay = 0.00;
    _tally.forEach((item){
      if (item.type == "支出") {
        if (item.bookId == bookId) {
          pay += item.money;
        }
      }
    });
    return pay;
  }

  //本月收入
  double getIncome(int bookId) {
    double income = 0.00;
    _tally.forEach((item){
      if (item.type == "收入") {
        if (item.bookId == bookId) {
          income += item.money;
        }
      }
    });
    return income;
  }
}