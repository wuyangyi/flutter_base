import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/refresh_layout.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'base/base_list_route.dart';
import 'base/base_route.dart';
import 'bean/official_accounts_bean_entity.dart';
import 'blocs/MainBloc.dart';
import 'blocs/bloc_provider.dart';
import 'config/app_config.dart';
import 'dialog/wait_dialog.dart';

void main() => runApp(BlocProvider(child: MyApp(), bloc: MainBloc(),));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: AppConfig.IS_DEBUG,
      theme: ThemeData(
        primarySwatch: MyColors.main_color,
      ),
      home: MainPage(),
    );
  }
}


class MainPage extends BaseListRoute {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseListRouteState<MainPage, OfficialAccountsBeanDataData, MainBloc> {
  _MainPageState(){
    enablePullUp = true;
    needAppBar = true;
    leading = Container();
    enableEmptyClick = true;
    title = "公众号记录";
    setRightButtonFromIcon(Icons.mood);
    setBorderButtonFromIcon(Icons.mood_bad);
  }

  @override
  Widget getItemBuilder(BuildContext context, int index) {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      decoration: Decorations.homeBottom,
      child: ListTile(
        isThreeLine: false,
        contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
        title: Text(
          mListData[index].title,
        ),
        onTap: () {
          showLoadingDialog(context);
        },
      ),
    );
  }

  @override
  void onRightButtonClick() {
    NavigatorUtil.pushPageByRoute(bodyContext, DialogText());
  }

  @override
  void onBorderButtonClick() {
    NavigatorUtil.pushPageByRoute(bodyContext, PullOrPush());
  }
}


class DialogText extends BaseRoute {
  @override
  _DialogTextState createState() => _DialogTextState();
}

class _DialogTextState extends BaseRouteState<DialogText> {

  _DialogTextState(){
    needAppBar = true;
    leading = Container();
    title = "加载测试";
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(),
    );
  }
}


class PullOrPush extends BaseRoute {
  @override
  _PullOrPushState createState() => _PullOrPushState();
}

class _PullOrPushState extends BaseRouteState<PullOrPush> {
  RefreshController _refreshController = RefreshController();
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  _PullOrPushState(){
    needAppBar = true;
    leading = Container();
    title = "下拉刷新";
    loadStatus = Status.success;
  }
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("上拉加载");
            }
            else if(mode==LoadStatus.loading){
              body = Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    WaitDialogProgress(Size(25.0, 25.0), "default_grey0", 9),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(
                        "加载中...",
                      ),
                    ),
                  ],
                ),
              );
            }
            else if(mode == LoadStatus.failed){
              body = Text("加载失败!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("松开加载");
            }
            else{
              body = Text("没有更多数据！");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
          itemExtent: 100.0,
          itemCount: items.length,
        ),
      ),
    );
  }
}


