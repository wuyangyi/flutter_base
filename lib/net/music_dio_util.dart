import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'dart:async';

import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_base/utils/utils.dart';

/*
 * 音乐播放器的请求
 * 用的qq音乐的API
 */
class MusicHttpUtils {

  /// global dio object
  static Dio musicDio;

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
        data, method,
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

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + AppConfig.QQ_MUSIC_BASE_URL + url + '】');
    print('请求参数：' + data.toString());

    Dio dio = createInstance();
    var result;

    try {
      var response = await dio.request(url, data: data, options: new Options(method: method));

      result = response.data;
      /// 打印响应相关信息
      print('响应数据：' + response.toString());
      if (!result.toString().startsWith("{") || !result.toString().endsWith("}")) {
        String r = result.toString();
        r = r.substring(r.indexOf("{"), r.lastIndexOf("}") + 1);
        result = json.decode(r);
      } else {
        result = json.decode(result.toString());
      }
      /// 打印响应相关信息
      print('响应数据：' + result.toString());
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
    if (musicDio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: AppConfig.QQ_MUSIC_BASE_URL,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      musicDio = new Dio(options);
    }

    return musicDio;
  }

  /// 清空 dio 对象
  static clear () {
    musicDio = null;
  }

}