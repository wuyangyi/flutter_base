import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/web_scaffold.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/login_route.dart';

class NavigatorUtil {

  ///打开page
  static Future<T> pushPageByRouteName<T extends Object>(BuildContext context, String routeName, {bool needLogin = false, bool isNeedCloseRoute = false, Object arguments}) {
    if(context == null || routeName == null) return null;
    if (needLogin && !Application.isLogin(context)) {
      return Navigator.of(context).pushNamed(Ids.login);
    }
    if (isNeedCloseRoute) {
      return Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
    }
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  ///打开page
  static Future<T> pushPageByRoute<T extends Object>(BuildContext context, Widget route, {bool needLogin = false, bool isNeedCloseRoute = false}) {
    if(context == null || route == null) return null;
    if (needLogin && !Application.isLogin(context)) {
      return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context){
          return LoginRoute();
        }
      ));
    }
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

  ///打开webview
  static void pushWeb(BuildContext context,
      {String title, String url}) {
    if (context == null || url == null || url.isEmpty) return;
    NavigatorUtil.pushPageByRoute(context, WebScaffold(
      title: title,
      url: url,
    ));
  }
}