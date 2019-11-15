import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/blocs/MyBookBloc.dart';
import 'package:flutter_base/blocs/MyTallyBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_list_route.dart';
import 'package:flutter_base/routes/tally_book/tally_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:provider/provider.dart';

import 'add_tally_route.dart';
import 'my_route.dart';

class BookHomeRoute extends BaseRoute {
  @override
  _BookHomeRouteState createState() => _BookHomeRouteState();
}

class _BookHomeRouteState extends BaseRouteState<BookHomeRoute> {
  _BookHomeRouteState() {
    needAppBar = false;
    showStartCenterLoading = false;
  }
  List<MyBookBeanEntity> books;

  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['账本','账单', '图表', '我的'];
  /*
   * 存储的五个页面
   */
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
        Icon(Icons.account_balance_wallet, color: Colors.black45,),
        Icon(Icons.account_balance_wallet, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.assignment, color: Colors.black45,),
        Icon(Icons.assignment, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.pie_chart, color: Colors.black45,),
        Icon(Icons.pie_chart, color: MyColors.main_color,),
      ],
      [
        Icon(Icons.account_box, color: Colors.black45,),
        Icon(Icons.account_box, color: MyColors.main_color,),
      ],
    ];

    _bodys = [
      BlocProvider(child: TallyRoute(context), bloc: MyBookBloc(),),
      BlocProvider(child: TallyListRoute(context), bloc: MyTallyBloc(),),
      Center(
        child: Text(appBarTitles[2]),
      ),
      MyRoute(context),
    ];
  }

  @override
  Widget buildFloatingActionButton() {
    return _tabIndex == 3 ? null : FloatingActionButton(
      child: Icon(Icons.create),
      onPressed: (){
        if (books == null || books.isEmpty) {
          showToast("请先添加账本哟！");
          return;
        }
        NavigatorUtil.pushPageByRoute(context, AddTallyRoute());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    books = Provider.of<BookModel>(context, listen: false).books;
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
