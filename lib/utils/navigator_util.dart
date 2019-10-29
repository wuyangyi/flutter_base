import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {

  ///打开page
  static Future<T> pushPageByRouteName<T extends Object>(BuildContext context, String routeName, {bool needLogin = false, bool isNeedCloseRoute = false, Object arguments}) {
    if(context == null || routeName == null) return null;
//    if (needLogin && !Application.isLogin(context)) {
//      return Navigator.of(context).pushNamed(Ids.login, arguments: false);
//    }
    if (isNeedCloseRoute) {
      return Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
    }
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  ///打开page
  static Future<T> pushPageByRoute<T extends Object>(BuildContext context, Widget route, {bool needLogin = false, bool isNeedCloseRoute = false}) {
    if(context == null || route == null) return null;
//    if (needLogin && !Application.isLogin(context)) {
//      return Navigator.of(context).push(CupertinoPageRoute(
//        builder: (context){
//          return LoginRoute(isFirstCome: false,);
//        }
//      ));
//    }
    if (isNeedCloseRoute) {
      return Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context){
            return route;
          }
      ));
    }
    return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context){
          return route;
        }
    ));
  }
}