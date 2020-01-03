import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/music/home_menu_item_bean.dart';
import 'package:flutter_base/bean/read_book/HomeBookMallBean.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/blocs/ReadBookMallBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_info_route.dart';
import 'package:flutter_base/routes/book_read/book_more_route.dart';
import 'package:flutter_base/routes/book_read/book_rank_route.dart';
import 'package:flutter_base/routes/book_read/book_search_route.dart';
import 'package:flutter_base/routes/book_read/home_book_mall_Item.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;


//书城
class BookMallRoute extends BaseRoute {
  final BuildContext parentContext;

  BookMallRoute(this.parentContext);
  @override
  _BookMallRouteState createState() => _BookMallRouteState();
}

class _BookMallRouteState extends BaseRouteState<BookMallRoute> {

  _BookMallRouteState(){
    needAppBar = false;
    showStartCenterLoading = true;
    resizeToAvoidBottomInset = false;
  }
  ReadBookMallBloc bloc;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<RankBeanEntity> mData;
  HomeBookMallBean homeBookMallBean;

  int manRankIndex = -1; //男频畅销索引
  List<RankBeanRankingBook> manBooks = [];
  int womanRankIndex = -1; //女频畅销索引
  List<RankBeanRankingBook> womanBooks = [];

  List<String> banner = [
    "ico_read_book_banner2",
    "ico_read_book_banner3",
    "ico_read_book_banner1",
  ];
  List<HomeMenuItemBean> homeMenuItems = [
    HomeMenuItemBean(
        title: "分类",
        icon: Icons.widgets,
        color: Colors.indigoAccent,
        route: Container(),
    ),
    HomeMenuItemBean(
        title: "排行",
        icon: Icons.equalizer,
        color: Colors.cyan,
        route: BookRankRoute()
    ),
    HomeMenuItemBean(
        title: "本地",
        icon: Icons.folder,
        color: Colors.blue,
        route: null,
    ),
    HomeMenuItemBean(
        title: "历史",
        icon: Icons.access_time,
        color: Colors.blueGrey,
        route: null
    ),
    HomeMenuItemBean(
        title: "消息",
        icon: Icons.message,
        color: Colors.purple,
        route: null
    ),
  ];

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();

  }

  /*
   * 加载完成后的回调
   */
  onLoadSuccess(List<RankBeanEntity> data, bool hasError) {
    if (isRefresh) {
      refreshController.refreshCompleted();
    }
    if (hasError) {
      print("异常onLoadSuccess");
      loadStatus = Status.fail;
    } else {
      if (data == null) {
        if (isRefresh) {
          loadStatus = Status.loading;
        }
      } else {
        if (isRefresh) {
          loadStatus = Status.success;
        }
        mData = data;
        initManAndWoManBook();
      }
    }
    isRefresh = false;
  }

  void initManAndWoManBook() {
    manBooks.clear();
    int minMan = math.min(5, mData[0]?.ranking?.books?.length ?? 0);
    for (int i = 0; i < minMan; i++) {
      manBooks.add(mData[0]?.ranking?.books[i]);
    }

    womanBooks.clear();
    int minWoMan = math.min(5, mData[1]?.ranking?.books?.length ?? 0);
    for (int i = 0; i < minWoMan; i++) {
      womanBooks.add(mData[1]?.ranking?.books[i]);
    }
  }


  @override
  Future onRefresh() async {
    super.onRefresh();
    bloc.onRefresh(userId: user.id);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ReadBookMallBloc>(context);
    if (isFirstInit) {
      isFirstInit = false;
      Observable.just(1).delay(new Duration(seconds: 1)).listen((_) {
        onRefresh();
      });
    }

    return StreamBuilder(
        stream: bloc.subjectStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
        onLoadSuccess(snapshot?.data?.data, snapshot.hasError);
        homeBookMallBean = snapshot.data;
        manRankIndex = -1;
        womanRankIndex = -1;
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
                child: SmartRefresher(
                  enablePullUp: false,
                  enablePullDown: true,
                  header: WaterDropHeader(
                    refresh: WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                    complete:  WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                  ),
                  controller: refreshController,
                  onRefresh: onRefresh,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    children: getListWidget(),
                  ),
                ),
              ),
            ],
          ),
        );
      });
  }

  List<Widget> getListWidget() {
    List<Widget> listWidget = [
      AspectRatio(
        aspectRatio: 16.0 / 6,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: ClipRRect(
            child: Swiper(
              indicatorAlignment: AlignmentDirectional.bottomCenter,
              circular: true,
              speed: 800,
              interval: const Duration(seconds: 5),
              indicator: CircleSwiperIndicator(),
              children: banner.map((model) {
                return new Image.asset(
                  Util.getImgPath(model),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              })?.toList(),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),


      //歌手 排行 歌单
      Container(
        height: 70.0,
        margin: EdgeInsets.all(15.0),
        child: Row(
          children: homeMenuItems.map((item){
            return Container(
              key: Key("key_${item.title}"),
              width: (MediaQuery.of(context).size.width - 30.0) / homeMenuItems.length,
              child: GestureDetector(
                onTap: (){
                  if (item.title == "分类") {
                    bus.emit(EventBusString.READ_BOOK_HOME_PAGE_CHANGE, 2);
                    return;
                  }
                  if (item.route != null) {
                    NavigatorUtil.pushPageByRoute(widget.parentContext, item.route);
                  } else {
                    showToast("正在建设中~");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 38.0,
                        height: 38.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
//                                      color: item.color,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1.0, color: item.route == null ? MyColors.lineColor : item.color),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.route == null ? MyColors.lineColor : item.color,
                          size: 22,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: item.route == null ? MyColors.lineColor : MyColors.title_color,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),

      //横着
      Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        height: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          children: <Widget>[
            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(widget.parentContext, BookRankRoute(topIndex: 0, leftIndex: 2,));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: double.infinity,
                margin: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        Util.getImgPath("ico_man_top"),
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: mData == null ? [] : manBooks.map((RankBeanRankingBook rankData){
                          manRankIndex++;
                          return getItemWidget(rankData, manRankIndex+1);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(widget.parentContext, BookRankRoute(topIndex: 1, leftIndex: 2,));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: double.infinity,
                margin: EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        Util.getImgPath("ico_woman_top"),
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: mData == null ? [] : womanBooks.map((RankBeanRankingBook rankData){
                          womanRankIndex++;
                          return getItemWidget(rankData, womanRankIndex+1);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(widget.parentContext, BookRankRoute());
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                color: MyColors.home_body_bg,
                alignment: Alignment.center,
                child: Text(
                  "查看更多",
                  style: TextStyle(
                    color: MyColors.text_normal,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    if (mData != null && mData.length > 2){
      for (int i = 2; i < mData.length; i++) {
        listWidget.add(HomeBookMallItem(
          mData[i].ranking,
          onMoreClick: (){
            NavigatorUtil.pushPageByRoute(widget.parentContext, BookMoreRoute(mData[i].ranking));
          },
          parentContext: widget.parentContext,
        ));
      }
    }
    return listWidget;
  }

  Widget getIndexWidget(int index) {
    Widget indexWidget;
    if (index <= 3) {
      String imagePath;
      if(index == 1) {
        imagePath = "ico_rank_top";
      } else if (index == 2) {
        imagePath = "ico_rank_two";
      } else {
        imagePath = "ico_rank_three";
      }
      indexWidget = Image.asset(Util.getImgPath(imagePath), width: 20.0,);
    } else {
      indexWidget = Text(
        "$index",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return indexWidget;
  }

  Widget getItemWidget(RankBeanRankingBook rankData, int index){
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.pushPageByRoute(widget.parentContext, BookInfoRoute(rankData.sId));
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: index == 5 ? 0.0 : 0.5, color: MyColors.loginDriverColor)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 20.0,
                alignment: Alignment.center,
                child: getIndexWidget(index),
              ),
              Gaps.hGap10,
              Expanded(
                flex: 1,
                child: Text(
                  rankData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Gaps.hGap5,
              Container(
                width: 55.0,
                height: 20.0,
                alignment: Alignment.center,
//              padding: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                decoration: BoxDecoration(
                  color: MyColors.loginDriverColor,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  rankData.majorCate,
                  style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 10.0
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
