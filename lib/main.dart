import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';
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


