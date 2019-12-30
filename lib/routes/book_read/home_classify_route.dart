import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/read_book/classify_bean_entity.dart';
import 'package:flutter_base/bean/read_book/classify_bean_two_entity.dart';
import 'package:flutter_base/blocs/ReadBookByTypeBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_search_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

import 'book_classify_two_route.dart';

class HomeClassifyRoute extends BaseRoute {
  final BuildContext parentContext;

  HomeClassifyRoute(this.parentContext);
  @override
  _HomeClassifyRouteState createState() => _HomeClassifyRouteState();
}

class _HomeClassifyRouteState extends BaseRouteState<HomeClassifyRoute> {

  _HomeClassifyRouteState(){
    needAppBar = false;
    bodyColor = Colors.white;
    showStartCenterLoading = true;
    resizeToAvoidBottomInset = false;
  }

  ClassifyBeanEntity mData;
  List<String> leftTitle = ["男生", "女生", "出版", "标签"];
  int leftIndex = 0;

  ClassifyBeanTwoEntity mDataTwo; //二级小分类

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await NetClickUtil().getClassifyTwo(callBack: (ClassifyBeanTwoEntity data){
      mDataTwo = data;
    });
    await NetClickUtil().getClassify(callBack: (ClassifyBeanEntity data){
      setState(() {
        mData = data;
        if (mData == null) {
          loadStatus = Status.empty;
        } else {
          loadStatus = Status.success;
        }
      });
    }).catchError((_){
      setState(() {
        loadStatus = Status.fail;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          AppStatusBar(
            color: Colors.white,
            buildContext: context,
          ),
          //搜索
          GestureDetector(
            onTap: (){
              NavigatorUtil.pushPageByRoute(widget.parentContext, BookSearchRoute());
            },
            child: Container(
              width: double.infinity,
              height: 30.0,
              margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                color: MyColors.search_bg_color,
                borderRadius: BorderRadius.circular(22.0),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.center,
                    child: Image.asset(
                      Util.getImgPath("ico_search_gray"),
                      width: 13.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "快来搜搜你喜欢的小说吧~",
                      style: TextStyle(
                        color: MyColors.search_hint_color,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: getLeftTitle(),
                ),
                Container(
                  width: 0.8,
                  height: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  color: MyColors.loginDriverColor,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                height: 0.8,
                                color: MyColors.loginDriverColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.0, right: 5.0),
                              width: 3.0,
                              height: 3.0,
                              decoration: BoxDecoration(
                                color: MyColors.loginDriverColor,
                                borderRadius: BorderRadius.circular(360),
                              ),
                            ),
                            Text(
                              leftTitle[leftIndex],
                              style: TextStyle(
                                color: MyColors.text_normal,
                                fontSize: 14.0,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5.0, left: 5.0),
                              width: 3.0,
                              height: 3.0,
                              decoration: BoxDecoration(
                                color: MyColors.loginDriverColor,
                                borderRadius: BorderRadius.circular(360),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                height: 0.8,
                                color: MyColors.loginDriverColor,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio: 2 / 1,
                            ),
                            padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                            itemCount: getNowData().length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  NavigatorUtil.pushPageByRoute(widget.parentContext, BlocProvider(child: BookClassifyTwoRoute(getNowDataTwo(index), getNowGender()), bloc: ReadBookByTypeBloc(),));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: MyColors.home_bg,
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              getNowData()[index].name,
                                              style: TextStyle(
                                                color: MyColors.title_color,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                            Text(
                                              "${getNowData()[index].bookCount}本",
                                              style: TextStyle(
                                                color: MyColors.text_normal,
                                                fontSize: 11.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          alignment: Alignment.bottomCenter,
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: <Widget>[
                                              Positioned(
                                                left: 0.0,
                                                bottom: 4.0,
                                                top: 10.0,
                                                child: AspectRatio(
                                                  aspectRatio: 2 / 3,
                                                  child: Image.network(AppConfig.READ_BOOK_BASE_URL_USE + getNowData()[index]?.bookCover[1] ?? "",
                                                    fit: BoxFit.fill,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0.0,
                                                bottom: 4.0,
                                                top: 10.0,
                                                child: AspectRatio(
                                                  aspectRatio: 2 / 3,
                                                  child: Image.network(AppConfig.READ_BOOK_BASE_URL_USE + getNowData()[index]?.bookCover[2] ?? "",
                                                    fit: BoxFit.fill,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 5,
                                                bottom: 0,
                                                child: AspectRatio(
                                                  aspectRatio: 2 / 3,
                                                  child: Image.network(AppConfig.READ_BOOK_BASE_URL_USE + getNowData()[index]?.bookCover[0] ?? "",
                                                    fit: BoxFit.fill,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  List<Widget> getLeftTitle() {
    List<Widget> left = [];
    for (int i =0; i < leftTitle.length; i++) {
      left.add(GestureDetector(
        onTap: (){
          setState(() {
            leftIndex = i;
          });
        },
        child: Container(
          width: 60.0,
//          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 8.0),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(width: 2.0, color: leftIndex == i ? MyColors.main_color: Colors.transparent)),
          ),
          child: Text(
            leftTitle[i],
            style: TextStyle(
              color: leftIndex == i ? MyColors.main_color : MyColors.title_color,
              fontSize: 14.0,
            ),
          ),
        ),
      ));

      left.add(Container(
        width: 45.0,
        height: 0.5,
        color: MyColors.loginDriverColor,
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10.0),
      ));
    }
    return left;
  }

  List<ClassifyBeanFemale> getNowData() {
    List<ClassifyBeanFemale> data = mData?.male;
    switch(leftIndex) {
      case 0:
        data = mData?.male;
        break;
      case 1:
        data = mData?.female;
        break;
      case 2:
        data = mData?.press;
        break;
      case 3:
        data = mData?.picture;
        break;
    }
    return data ?? [];
  }

  ClassifyBeanTwoFemale getNowDataTwo(int index) {
    ClassifyBeanTwoFemale data = mDataTwo?.male[index];
    switch(leftIndex) {
      case 0:
        data = mDataTwo?.male[index];
        break;
      case 1:
        data = mDataTwo?.female[index];
        break;
      case 2:
        data = mDataTwo?.press[index];
        break;
      case 3:
        data = mDataTwo?.picture[index];
        break;
    }
    return data;
  }


  String getNowGender() {
    String data = "male";
    switch(leftIndex) {
      case 0:
        data = "male";
        break;
      case 1:
        data = "female";
        break;
      case 2:
        data = "press";
        break;
      case 3:
        data = "picture";
        break;
    }
    return data;
  }
}
