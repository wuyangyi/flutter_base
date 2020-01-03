import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/read_book/rank_type_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/rank_content_view.dart';
import 'package:flutter_base/widgets/status_widget.dart';

class BookRankRoute extends BaseRoute {

  final int leftIndex;
  final int topIndex;
  BookRankRoute({this.leftIndex = 0, this.topIndex = 0});


  @override
  _BookRankRouteState createState() => _BookRankRouteState(leftIndex: leftIndex, topIndex: topIndex);
}

class _BookRankRouteState extends BaseRouteState<BookRankRoute> with SingleTickerProviderStateMixin {

  _BookRankRouteState({this.leftIndex = 0, this.topIndex = 0}) {
    appBarElevation = 0.0;
    centerTitle = false;
    showStartCenterLoading = true;
    title = "排行";
    titleBarBg = Colors.white;
    titleColor = MyColors.title_color;
    bodyColor = Colors.white;
    statusTextDarkColor = false;
  }

  List<String> tabs = ["男频", "女频", "出版"];
  TabController _tabController;
  RankTypeBeanEntity mTypeData;

  int leftIndex = 0; //左边索引
  int topIndex = 0; //顶部的索引

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: topIndex, length: tabs.length, vsync: this);
    initData();
  }

  void initData() async {
    NetClickUtil().getRankType(callBack: (RankTypeBeanEntity data){
      mTypeData = data;
      setState(() {
        if (data == null) {
          loadStatus = Status.empty;
        } else {
          mTypeData = data;
          loadStatus = Status.success;
        }
      });
    }).catchError((e){
      setState(() {
        loadStatus = Status.fail;
      });
    });
  }

  @override
  Widget getAppBarBottom() {
    return TabBar(
      controller: _tabController,
      labelColor: MyColors.main_color,
      unselectedLabelColor: MyColors.title_color,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: MyColors.main_color,
      tabs: tabs.map((item){
        return Tab(text: item,);
      }).toList(),
    );
  }



  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                RankContentView(mTypeData?.male ?? [], leftIndex: topIndex == 0 ? leftIndex : 0, parentContext: context,),
                RankContentView(mTypeData?.female ?? [], leftIndex: topIndex == 1 ? leftIndex : 0, parentContext: context,),
                RankContentView(mTypeData?.epub ?? [], leftIndex: topIndex == 2 ? leftIndex : 0, parentContext: context,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
