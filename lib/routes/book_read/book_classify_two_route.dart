import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/bean/read_book/classify_bean_two_entity.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/blocs/ReadBookByTypeBloc.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/routes/book_read/book_item.dart';
import 'package:flutter_base/routes/book_read/classify_top_view.dart';
import 'package:flutter_base/widgets/status_widget.dart';

class BookClassifyTwoRoute extends BaseListRoute {
  final ClassifyBeanTwoFemale mTwoClassify;
  final String gender;//男生:mael 女生:female 出版:press

  BookClassifyTwoRoute(this.mTwoClassify, this.gender);
  @override
  _BookClassifyTwoRouteState createState() => _BookClassifyTwoRouteState(mTwoClassify, gender);
}

class _BookClassifyTwoRouteState extends BaseListRouteState<BookClassifyTwoRoute, RankBeanRankingBook, ReadBookByTypeBloc> {
  _BookClassifyTwoRouteState(this.mTwoClassify, this.gender){
    appBarElevation = 0.0;
    centerTitle = false;
    showStartCenterLoading = true;
    title = mTwoClassify.major;
    titleBarBg = Colors.white;
    titleColor = MyColors.title_color;
    if (mTwoClassify.mins != null) {
      minors.addAll(mTwoClassify.mins);
    }
    bodyColor = Colors.white;
    statusTextDarkColor = false;
  }
  final ClassifyBeanTwoFemale mTwoClassify;
  final String gender;
  List<String> types = ["全部", "热门", "新书", "完结"];
  List<String> minors = ["全部"];
  String type = "全部"; //类别
  String minor = "全部"; //小类别

  @override
  Future onRefresh() async {
    initMap();
    super.onRefresh();
    bloc.onRefresh(userId: user.id);
  }

  @override
  onLoadSuccess(List<RankBeanRankingBook> data, bool hasError) {
    super.onLoadSuccess(data, hasError);
    if (loadStatus == Status.empty) {
      loadStatus = Status.success;
    }
  }

  void initMap() {
    Map<String, String> map = new Map();
    map["gender"] = gender;
    map["major"] = mTwoClassify.major;
    if (type != "全部") {
      map["type"] = getType();
    }
    if(minor != "全部") {
      map["minor"] = minor;
    }
    bloc.initCondition(map);
  }

  String getType() {
    String t = "hot";
    switch(type) {
      case "热门":
        t = "hot";
        break;
      case "新书":
        t = "new";
        break;
      case "完结":
        t = "over";
        break;
    }
    return t;
  }

  @override
  List<Widget> initHeadView() {
    return [

      ClassifyTopView(
        minors,
        minor,
        callBack: (String nowItem) {
          setState(() {
            minor = nowItem;
          });
          onRefresh();
        },
      ),

      Container(
        width: double.infinity,
        height: 0.5,
        color: MyColors.loginDriverColor,
      ),

      ClassifyTopView(
        types,
        type,
        callBack: (String nowItem) {
          setState(() {
            type = nowItem;
          });
          onRefresh();
        },
      ),

      Container(
        width: double.infinity,
        height: 0.5,
        color: MyColors.loginDriverColor,
        margin: EdgeInsets.only(bottom: 15.0,),
      ),
    ];
  }

  @override
  Widget getItemBuilder(BuildContext context, int index) {
    return BookItem(mListData[index - getHeadCount()]);
  }

}
