import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/finish_user_info/TopSearch.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

class CityRoute extends BaseRoute {
  @override
  _CityRouteState createState() => _CityRouteState();
}

class _CityRouteState extends BaseRouteState<CityRoute> {
  bool searchHaveText = false; //搜索框是否有文字
  int selectLeft = 0; //左边选择的item
  int selectCenter = 0; //中间选择的item
  CityBeanEntity cityBean = DataConfig.cityData;
  ScrollController _controllerCenter = ScrollController();
  ScrollController _controllerRight = ScrollController();

  List<CityBeanProvincelistCitylist> selectList = []; //搜索选择item列表
  int _suspensionHeight = 40; //顶部悬停的高度
  int _itemHeight = 60; //列表item高度
  String _suspensionTag = ""; //顶部悬停的文本title

  _CityRouteState() {
    statusTextDarkColor = true;
    needAppBar = false;
    resizeToAvoidBottomInset = false;
    if (cityBean == null) {
      loadStatus = Status.loading;
      showStartCenterLoading = true;
    } else {
      loadStatus = Status.success;
      showStartCenterLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }


  _upDateSearchList(String value) {
    selectList.clear();
    if (value.isEmpty || cityBean == null) {
      return;
    }
    for (int i = 0; i < cityBean.provinceList.length; i++) {
      for (int j = 0; j < cityBean.provinceList[i].cityList.length; j++) {
        var city = cityBean.provinceList[i].name + cityBean.provinceList[i].cityList[j].name;
        if (city.contains(value)) {
          CityBeanProvincelistCitylist data = cityBean.provinceList[i].cityList[j];
          data.topTitle = cityBean.provinceList[i].name;
          selectList.add(data);
        } else {
          for (int k = 0; k < cityBean.provinceList[i].cityList[j].countyList.length; k++) {
            var KCity = city + cityBean.provinceList[i].cityList[j].countyList[k].name;
            if (KCity.contains(value)) {
              CityBeanProvincelistCitylist data = cityBean.provinceList[i].cityList[j];
              data.topTitle = cityBean.provinceList[i].name;
              selectList.add(data);
              break;
            }
          }
        }
      }
    }
    if (selectList.length > 0) {
      _suspensionTag = selectList[0].topTitle;
    }
  }

  ///构建列表 item Widget.
  Widget _buildListItem(CityBeanProvincelistCitylist model) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !(model.isShowSuspension == true),
          child: _buildSusWidget(model.getSuspensionTag()),
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFFF7F9FC),
            border: Border(bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor,)),
          ),
          constraints: BoxConstraints(
            minHeight: _itemHeight.toDouble(),
          ),
          child: ExpansionTile(
            title: Text(
              model.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0,
                color: MyColors.title_color,
              ),
            ),
            children: model.countyList.map((data){
              return GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 45.0,
                  padding: EdgeInsets.only(left: 25.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: MyColors.cityColor,
                    border: Border(bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor,)),
                  ),
                  child: Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: MyColors.title_color,
                    ),
                  ),
                ),
                onTap: (){
                  hideSoftInput();
                  CityBeanProvincelistCitylistCountylist myData = new CityBeanProvincelistCitylistCountylist();
                  myData.id = data.id;
                  myData.name = model.topTitle + model.name + data.name;
                  bus.emit(EventBusString.CITY_SELECT, myData);
                  finish();
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }


  ///构建悬停Widget.
  Widget _buildSusWidget(String susTag) {
    print("头部$susTag");
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Color(0xFFF0F4F3),
        border: Border(
            bottom: BorderSide(
              color: Color(0xFFDEDEDE),
              width: 1.0,
            )
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.0,
          color: MyColors.title_color,
        ),
      ),
    );
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  initData(BuildContext context) async {
    if (cityBean == null) {
      cityBean = await NetClickUtil(context).getCityData();
      if (cityBean != null) {
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
    return buildBody(context,
      body: Column(
        children: <Widget>[
          AppStatusBar(color: Colors.white, buildContext: context,),
          TopSearch(
            onChange: (value) {
              setState(() {
                searchHaveText = value.isNotEmpty;
                _upDateSearchList(value);
              });
            },
            leftOnTap: () {
              finish();
            },
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.citySelectColor,
          ),
          Expanded(
            flex: 1,
            child: searchHaveText ?
            Container(
              width: double.infinity,
              height: double.infinity,
              color: MyColors.citySelectColor,
              alignment: Alignment.topCenter,
              child: selectList.length == 0 ? Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                      child: Image.asset(Util.getImgPath("ico_search_empty"), fit: BoxFit.fill,),
                    ),
                    Text(
                      "暂无搜索结果",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ) :
              AzListView(
                data: selectList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
//                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
              ),
            ) :
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: cityBean.provinceList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            _controllerCenter.jumpTo(0);
                            _controllerRight.jumpTo(0);
                            selectCenter = 0; //这个得初始化
                            setState(() {
                              selectLeft = index;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectLeft == index ? MyColors.citySelectColor : Colors.white,
                              border: Border(bottom: BorderSide(width: 0.5, color: MyColors.citySelectColor,),),
                            ),
                            child: Text(
                              cityBean.provinceList[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.title_color,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: MyColors.citySelectColor,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controllerCenter,
                      itemCount: cityBean.provinceList[selectLeft].cityList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            _controllerRight.jumpTo(0);
                            setState(() {
                              selectCenter = index;
                            });
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectCenter == index ? MyColors.cityColor : MyColors.citySelectColor,
                              border: Border(bottom: BorderSide(width: 0.5, color: MyColors.cityColor,),),
                            ),
                            child: Text(
                              cityBean.provinceList[selectLeft]?.cityList[index]?.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.title_color,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: MyColors.cityColor,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controllerRight,
                      itemCount: cityBean.provinceList[selectLeft].cityList[selectCenter].countyList.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              hideSoftInput();
                              CityBeanProvincelistCitylistCountylist data = new CityBeanProvincelistCitylistCountylist();
                              data.id = cityBean.provinceList[selectLeft].cityList[selectCenter].countyList[index].id;
                              data.name = cityBean.provinceList[selectLeft].name + cityBean.provinceList[selectLeft].cityList[selectCenter].name + cityBean.provinceList[selectLeft].cityList[selectCenter].countyList[index].name;
                              bus.emit(EventBusString.CITY_SELECT, data);
                              finish();
                            });
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              cityBean.provinceList[selectLeft].cityList[selectCenter].countyList[index]?.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.title_color,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
