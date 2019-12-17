import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/weather/weather_city_list_bean_entity.dart';
import 'package:flutter_base/res/color.dart';

class WeatherSelectCityRoute extends BaseRoute {
  final WeatherCityListBeanEntity cityList;
  final int index; //选中的位置

  WeatherSelectCityRoute(this.cityList, this.index);
  @override
  _WeatherSelectCityRouteState createState() => _WeatherSelectCityRouteState();
}

class _WeatherSelectCityRouteState extends BaseRouteState<WeatherSelectCityRoute> {

  _WeatherSelectCityRouteState() {
    appBarElevation = 0.0;
    title = "城市选择";
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Scrollbar(
        child: ListView.separated(
          itemCount: widget.cityList.citys.length + 1,
          separatorBuilder: (context, index){
            return index == 0 || widget.cityList.citys[index - 1].cityCode == null || widget.cityList.citys[index - 1].cityCode.isEmpty ?
            Container() :
            Container(
              width: double.infinity,
              height: 0.5,
              margin: EdgeInsets.only(left: 15.0),
              color: MyColors.loginDriverColor,
            );
          },
          itemBuilder: (context, index) {
            return index != 0 && (widget.cityList.citys[index - 1].cityCode == null || widget.cityList.citys[index - 1].cityCode.isEmpty) ?
            Container() :
            index == 0 ? Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 35.0,
                  color: MyColors.home_bg,
                  padding: EdgeInsets.only(left: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "当前城市",
                    style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 13.0
                    ),
                  ),
                ),
                Ink(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      finish(data: widget.index);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.cityList.citys[widget.index].cityName,
                              style: TextStyle(
                                color: MyColors.main_color,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          Icon(Icons.done, color: MyColors.main_color,),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 35.0,
                  color: MyColors.home_bg,
                  padding: EdgeInsets.only(left: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "更多城市",
                    style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 13.0
                    ),
                  ),
                ),
              ],
            ) :
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: (){
                  finish(data: index);
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.cityList.citys[index].cityName,
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      widget.index == index ? Icon(Icons.done, color: MyColors.main_color,) : Container(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
