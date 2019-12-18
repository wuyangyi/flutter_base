import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/weather/weather_bean_entity.dart';
import 'package:flutter_base/bean/weather/weather_city_list_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/style.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/GradientCircularProgressIndicator.dart';
import 'package:flutter_base/widgets/SunUpDown.dart';
import 'package:flutter_base/widgets/WeatherLineWidget.dart';
import 'package:flutter_base/widgets/rain/RainView.dart';
import 'package:flutter_base/widgets/snow/SnowView.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

import 'flWidget.dart';
import 'weather_select_city_route.dart';


class WeatherHomeRoute extends BaseRoute {
  @override
  _WeatherHomeRouteState createState() => _WeatherHomeRouteState();
}

class _WeatherHomeRouteState extends BaseRouteState<WeatherHomeRoute> {
  WeatherCityListBeanEntity cityList; //城市
  String cityNumber;

  WeatherBeanEntity weatherData;

  List<ui.Image> images = [];

  int _cityIndex = 0;



  _WeatherHomeRouteState(){
    needAppBar = false;
    statusTextDarkColor = false;
    showStartCenterLoading = true;
  }



  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void onRightButtonClick() async {
    int index = await NavigatorUtil.pushPageByRoute(context, WeatherSelectCityRoute(cityList, _cityIndex));
    if (index != null && index != -1) {
      setState(() {
        _cityIndex = index;
        cityNumber = cityList.citys[_cityIndex].cityCode;
        loadStatus = Status.loading;
        initWeatherData();
      });
    }
  }


  Future initImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    ui.Image image = await loadDayImage(new Uint8List.view(data.buffer));
    images.add(image);
  }


  //加载天气图片
  Future<ui.Image> loadDayImage(List<int> img) async {

    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future initImages() async {
    await initImage(Util.getImgPath("weather/0"));
    await initImage(Util.getImgPath("weather/1"));
    await initImage(Util.getImgPath("weather/2"));
    await initImage(Util.getImgPath("weather/3"));
    await initImage(Util.getImgPath("weather/31"));
    await initImage(Util.getImgPath("weather/32"));
    await initImage(Util.getImgPath("weather/4"));
    await initImage(Util.getImgPath("weather/41"));
    await initImage(Util.getImgPath("weather/42"));
  }

  void initData() async {
    await initImages();
    await NetClickUtil(context).getCityListData(callBack: (data) async {
      cityList = data;
      String address = user?.address ?? "北京";
      print("当前城市：$address");
      for (int i = 0; i < cityList.citys.length; i++) {
        var item = cityList.citys[i];
        if (item.cityCode != null && item.cityCode.isNotEmpty && address.contains(item.cityName)) {
          cityNumber = item.cityCode;
          _cityIndex = i;
          break;
        }
      }
      print("当前城市代码：$cityNumber");
      await initWeatherData();
    });
  }

  Future initWeatherData() async {
    await NetClickUtil().getWeather(cityNumber, callBack: (weather){
      weatherData = weather;
      setState(() {
        if (weatherData != null && weatherData.status == 200) {
          loadStatus = Status.success;
        } else {
          loadStatus = Status.fail;
        }
      });
    });
  }

  //获取太阳落山的时间
  int getSunDownTime() {
    if (weatherData == null) {
      return 18;
    }
    return int.parse(weatherData.data.forecast[0].sunset.substring(0, weatherData.data.forecast[0].sunset.indexOf(":")));
  }

  Widget getBgWidget() {
    Widget bgWidget = Container( //默认阴天
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF415A64), Color(0xCC415A64), Color(0x77C415A64)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )
      ),
    );
    if (weatherData == null) {
      return bgWidget;
    }
    switch (weatherData.data.forecast[0].type) {
      case "晴":
        bgWidget = Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            Util.getImgPath(DateTime.now().hour >= getSunDownTime() + 1 ? "ico_weather_sun_night" : DateTime.now().hour >= getSunDownTime() - 1 ? "ico_weather_sun_dusk" : "ico_weather_sun"),//ico_weather_sun_two
            fit: BoxFit.cover,
          ),
        );
        break;
      case "多云":
        bgWidget = Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            Util.getImgPath(DateTime.now().hour >= getSunDownTime() + 1 ? "ico_weather_sun_night" : DateTime.now().hour >= getSunDownTime() - 1 ? "ico_weather_sun_dusk" : "ico_seather_cloudy"),
            fit: BoxFit.cover,
          ),
        );
        break;
      case "阴":
        bgWidget = Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF415A64), Color(0xCC415A64), Color(0x77C415A64)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
        );
        break;
      case "小雨":
        bgWidget = RainView(type: 0,);
        break;
      case "中雨":
        bgWidget = RainView(type: 1,);
        break;
      case "大雨":
        bgWidget = RainView(type: 2,);
        break;
      case "小雪":
        bgWidget = SnowView(type: 0,);
        break;
      case "中雪":
        bgWidget = SnowView(type: 1,);
        break;
      case "大雪":
        bgWidget = SnowView(type: 2,);
        break;
    }
    return bgWidget;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Stack(
        children: <Widget>[
          getBgWidget(),
          weatherData == null ? Container() :
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black26,
            child: Column(
              children: <Widget>[
                AppStatusBar(
                  buildContext: context,
                  color: Colors.transparent,
                ),
                Container(
                  width: double.infinity,
                  height: 45.0,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new IconButton(
                        key: key_btn_left,
                        icon: Image.asset(Util.getImgPath("icon_back_white"), height: 20.0,),
                        onPressed: (){
                          onLeftButtonClick();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      new IconButton(
                        key: key_btn_border,
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          onRightButtonClick();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[

                      Gaps.vGap50,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Text(
                            weatherData.data.wendu,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 45.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "℃",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: "${weatherData.data.forecast[0].high.substring(2)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                  ),
                                ),
                                TextSpan(
                                  text: " / ${weatherData.data.forecast[0].low.substring(2)}",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),

                      Center(
                        child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(
                                  text: "${weatherData.data.forecast[0].type}",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14.0,
                                  ),
                                ),
                                TextSpan(
                                  text: " 空气${weatherData.data.quality}",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),

                      Gaps.vGap50,

                      Center(
                        child: Text(
                          "${weatherData.cityInfo.city}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                          ),
                        ),
                      ),

                      Center(
                        child: Text(
                          "发布时间：${weatherData.cityInfo.updateTime}",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10.0
                          ),
                        ),
                      ),

                      Gaps.vGap20,

                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "中国气象",
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10.0
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${weatherData.data.ganmao}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10.0
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.white24,
                      ),

                      Container(
                        height: 330.0,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: WeatherLineWidget(weatherData: weatherData, images: images,),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.white24,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "空气质量",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "污染指数",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Gaps.vGap10,

                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    GradientCircularProgressIndicator(
                                      radius: (MediaQuery.of(context).size.width - 40.0) / 5,
                                      colors: [Colors.lightBlueAccent, Colors.lightBlueAccent],
                                      strokeWidth: 8.0,
                                      backgroundColor: Color(0x80CCCCCC),
                                      strokeCapRound: true,
                                      value: weatherData.data.forecast[0].aqi / 500,
                                      totalAngle: pi * 1.7,
                                      angle: 0.63 * pi,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "${weatherData.data.quality}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0
                                          ),
                                        ),
                                        Gaps.vGap5,
                                        Text(
                                          "${weatherData.data.forecast[0].aqi}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: 40.0,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "PM10",
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Gaps.vGap10,
                                        Text(
                                          "PM2.5",
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 40.0,
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "${weatherData.data.pm10}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Gaps.vGap10,
                                        Text(
                                          "${weatherData.data.pm25}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.white24,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "舒适度",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "空气湿度",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Gaps.vGap10,

                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    GradientCircularProgressIndicator(
                                      radius: (MediaQuery.of(context).size.width - 40.0) / 5,
                                      colors: [Colors.white, Colors.white],
                                      strokeWidth: 8.0,
                                      backgroundColor: Color(0x80CCCCCC),
                                      strokeCapRound: true,
                                      value: (double.parse(weatherData.data.shidu.substring(0, weatherData.data.shidu.length - 1)) / 100),
                                      totalAngle: pi * 1.7,
                                      angle: 0.63 * pi,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "${weatherData.data.shidu}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "体感温度",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      Gaps.hGap10,
                                      Text(
                                        "${weatherData.data.wendu}℃",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                        ),
                                      ),

                                    ],
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    "${weatherData.data.forecast[0].notice}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.white24,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "风向风力",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                        height: 150,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: (MediaQuery.of(context).size.width - 40.0) / 5 * 2,
                              alignment: Alignment.center,
                              child: FlWidget(),
                            ),

                            Expanded(
                              flex: 1,
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "风向",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      Gaps.hGap10,
                                      Text(
                                        "${weatherData.data.forecast[0].fx}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                        ),
                                      ),

                                    ],
                                  ),
                                  Gaps.vGap10,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "风力",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      Gaps.hGap10,
                                      Text(
                                        "${weatherData.data.forecast[0].fl}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.white24,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "日出日落",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: SunUpDown(
                          startTime: weatherData.data.forecast[0].sunrise,
                          endTime: weatherData.data.forecast[0].sunset,
                        ),
                      ),

                      Center(
                        child: Text(
                          "天气版本：v${AppConfig.APPVERSION}",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "@2019 小小工具箱——天气预报",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      Gaps.vGap10,

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
