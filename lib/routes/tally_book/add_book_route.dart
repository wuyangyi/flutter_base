import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/select_book_type_route.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:flutter_base/widgets/editview.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'book_color_route.dart';

class AddBookRoute extends BaseRoute {
  final MyBookBeanEntity bookBean;

  AddBookRoute({this.bookBean});
  @override
  _AddBookRouteState createState() => _AddBookRouteState(bookBean);
}

class _AddBookRouteState extends BaseRouteState<AddBookRoute> {
  TextEditingController _controllerType = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  int _colorIndex;
  UserBeanEntity user;
  BookModel bookModel;
  MyBookBeanEntity bookBean;

  _AddBookRouteState(this.bookBean){
    needAppBar = true;
    title = "添加账本";
    bodyColor = MyColors.home_body_bg;
    resizeToAvoidBottomInset = false;
  }

  int bookTypeSelectIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _controllerType.dispose();
    _controllerName.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user;
    bookModel = Provider.of<BookModel>(context, listen: false);
    //初始化数据，兼容修改账本信息的情况
    _controllerType.text = bookBean?.type ?? DataConfig.bookTypes[bookTypeSelectIndex].title; //默认为日常
    _controllerName.text = bookBean?.name ?? "";
    _colorIndex = bookBean?.color ?? Random().nextInt(DataConfig.myBookColors.length);
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          InkWellFinishInput(
            leftText: "记账场景",
            enable: false,
            needRightImage: true,
            bgColor: Colors.white,
            needBottomDriver: true,
            textAlign: TextAlign.right,
            controller: _controllerType,
            hintText: "请选择账本",
            margin: const EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.only(right: 10.0),
            onTap: () async {
              int index = await NavigatorUtil.pushPageByRoute(context, SelectBookTypeRoute(selectIndex: bookTypeSelectIndex,));
              if (index != null && index != -1) {
                bookTypeSelectIndex = index;
                _controllerType.text = DataConfig.bookTypes[bookTypeSelectIndex].title;
              }
            },
          ),
          InkWellFinishInput(
            leftText: "账本名称",
            enable: true,
            needRightImage: false,
            needBottomDriver: true,
            textAlign: TextAlign.right,
            bgColor: Colors.white,
            maxLines: 1,
            maxLength: 5,
            controller: _controllerName,
            hintText: "请输入5字以内名称",
            margin: const EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.only(right: 10.0),
          ),
          InkWellFinishInput(
            leftText: "记账颜色",
            needRightImage: true,
            needBottomDriver: true,
            bgColor: Colors.white,
            margin: const EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.only(right: 10.0),
            centerWidget: Container(
              width: 40.0,
              height: 25.0,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: DataConfig.myBookColors[_colorIndex],
                  center: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            onTap: () async {
              int index = await NavigatorUtil.pushPageByRoute(context, BookColorRoute(selectIndex: _colorIndex,));
              if (index != null && index != -1) {
                setState(() {
                  _colorIndex = index;
                });
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(Util.getImgPath("ico_hint_green"), width: 15.0, height: 15.0,),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Tip：没有记账本将无法记账哦~",
                    style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            width: 150.0,
            height: 44.0,
            margin: EdgeInsets.only(bottom: 45.0),
            child: FinishButton(
              text: "完成",
              onTop: () async {
                if (_controllerName.text.isEmpty) {
                  showToast("请输入账本名称");
                  return;
                }
                hideSoftInput();
                showWaitDialog();
                if (bookBean == null) {
                  bookBean = new MyBookBeanEntity(
                    type: _controllerType.text,
                    name: _controllerName.text,
                    color: _colorIndex,
                    createTime: DateTime.now().toString(),
                    pay: 0.00,
                    income: 0.00,
                    userId: user.id,
                  );
                  int id = await NetClickUtil().saveBook(bookBean);
                  bookBean.id = id;
                  bookModel.add(bookBean);
                } else {
                  bookBean.type = _controllerType.text;
                  bookBean.name = _controllerName.text;
                  bookBean.color = _colorIndex;
                  bookModel.update(bookBean);
                  await NetClickUtil().saveBook(bookBean);
                }
//                bus.emit(EventBusString.BOOK_LOADING, true);
                hideWaitDialog();
                showTopMessage();
                Observable.just(1).delay(new Duration(seconds: 2)).listen((_){
                  finish();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
