import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/blocs/ReadBookMallBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_mall_route.dart';
import 'package:flutter_base/routes/book_read/bookrack_route.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/widgets/BookPageView.dart';

import 'home_classify_route.dart';

class BookReadHomeRoute extends BaseRoute {
  @override
  _BookReadHomeRouteState createState() => _BookReadHomeRouteState();
}

class _BookReadHomeRouteState extends BaseRouteState<BookReadHomeRoute> {
  _BookReadHomeRouteState(){
    needAppBar = false;
//    bodyColor = Colors.transparent;
  }

  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['书架','书城', '分类', '我的'];
  var _bodys;

  /*
   * 根据索引获得对应的normal或是press的icon
   */
  Icon getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }
  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
        style: new TextStyle(color: MyColors.main_color, fontSize: 10.0),);
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: MyColors.homeBottomColorNoSelect, fontSize: 10.0));
    }
  }

  void initData(BuildContext context) {
    /*
      bottom的按压图片
     */
    tabImages = [
      [
        Icon(Icons.chrome_reader_mode, color: Colors.black45,),
        Icon(Icons.chrome_reader_mode, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.local_mall, color: Colors.black45,),
        Icon(Icons.local_mall, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.widgets, color: Colors.black45,),
        Icon(Icons.widgets, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.account_box, color: Colors.black45,),
        Icon(Icons.account_box, color: MyColors.main_color,),
      ],
    ];

    _bodys = [
      BookRackRoute(context),
      BlocProvider(child: BookMallRoute(context), bloc: ReadBookMallBloc(),),
      HomeClassifyRoute(context),
      Container(),
    ];
  }

  @override
  void initState() {
    super.initState();
    bus.on(EventBusString.READ_BOOK_HOME_PAGE_CHANGE, (index){
      setState(() {
        _tabIndex = index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.READ_BOOK_HOME_PAGE_CHANGE);
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
    return buildBody(context,
      body: IndexedStack(
        index: _tabIndex,
        children: _bodys,
      ),
    );
  }

  @override
  Widget getBottomNavigationBar() {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: getTabIcon(0),title: getTabTitle(0),),
        new BottomNavigationBarItem(
          icon: getTabIcon(1),title: getTabTitle(1),),
        new BottomNavigationBarItem(
          icon: getTabIcon(2),title: getTabTitle(2),),
        new BottomNavigationBarItem(
          icon: getTabIcon(3),title: getTabTitle(3),),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _tabIndex,
      onTap: (index) {
        setState(() {
          _tabIndex = index;
        });
      },
    );
  }

}
