import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'dart:async';

import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_base/utils/utils.dart';

/*
 * 阅读API
 */
class ReadBookHttpUtils {

  /// global dio object
  static Dio readBookDio;

  /// default options
  static const int CONNECT_TIMEOUT = 20000;
  static const int RECEIVE_TIMEOUT = 10000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// request method
  static Future<Map> request (
      String url, {
        Map<String, dynamic> data, method,
        Map<String, String> mapApi,
      }) async {

    data = data ?? {};
    method = method ?? 'GET';

    if(mapApi != null) {
      mapApi.forEach((String name, String value) {
        if (url.contains("?")) {
          url = url + "&$name=$value";
        } else {
          url = url + "?$name=$value";
        }

      });
    }


    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + AppConfig.READ_BOOK_BASE_URL + url + '】');
    print('请求参数：' + data.toString());

    Dio dio = createInstance();
    var result;

    try {
      var response = await dio.request(url, options: new Options(method: method));

      result = response.data;
      /// 打印响应相关信息
      print('响应数据：' + response.toString());
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错：' + e.toString());
    }
    if (result == null) {
      return null;
    }
    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance () {
    if (readBookDio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: AppConfig.READ_BOOK_BASE_URL,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      readBookDio = new Dio(options);
    }

    return readBookDio;
  }

  /// 清空 dio 对象
  static clear () {
    readBookDio = null;
  }

}