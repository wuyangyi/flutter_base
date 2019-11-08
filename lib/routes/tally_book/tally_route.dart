import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/blocs/MyBookBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/VerticalText.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';

import 'add_book_route.dart';

class TallyRoute extends BaseListRoute {
  final BuildContext parentContext;

  TallyRoute(this.parentContext);
  @override
  _TallyRouteState createState() => _TallyRouteState();
}

class _TallyRouteState extends BaseListRouteState<TallyRoute, MyBookBeanEntity, MyBookBloc> {
  _TallyRouteState(){
    needAppBar = true;
    title = "我的账本";
    leading = Container();
    showStartCenterLoading = true;
  }
  DateTime nowDate = DateTime.now();
  MyBookBeanEntity selectBookBean; //当前展示的账本
  UserBeanEntity user;
  double pay = 0.00; //当月支出
  double getMoney = 0.00; //当月收入
  bool isCanUp = false; //是否可编辑状态

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user;
    bus.on(EventBusString.BOOK_LOADING, (isNeed){
      onRefresh();
    });
  }

  @override
  onLoadSuccess(List<MyBookBeanEntity> data, bool hasError) {
    if (isRefresh) {
      refreshController.refreshCompleted();
    }
    if (hasError) {
      loadMoreStatus = Status.fail;
      if (mListData.isEmpty) {
        loadStatus = Status.fail;
      }
    } else {
      if(data != null && data.isNotEmpty){
        if (selectBookBean == null) {
          selectBookBean = data[0];
        }
        doSelectPayOnMonth();
      }
      if (data != null && (isLoadingMore || isRefresh)) {
        if (isRefresh) {
          mListData.clear();
        }
        mListData.addAll(data);
      }
      if (data == null) {
        loadMoreStatus = Status.loading;
        if (isRefresh) {
          loadStatus = Status.loading;
        }
      } else {
        loadMoreStatus = Status.success;
        if (isRefresh) {
          loadStatus = Status.success;
        }
      }
    }
    isRefresh = false;
    isLoadingMore = false;

  }

  //查询当月的支出与收入
  doSelectPayOnMonth() async {
    await MyTallyDao().findNumber(user.id, year: nowDate.year, month: nowDate.month, bookId: selectBookBean.id, type: "收入", onCallBack: (money){
      getMoney = money;
    }).then((_) async {
      await MyTallyDao().findNumber(user.id, year: nowDate.year, month: nowDate.month, bookId: selectBookBean.id, type: "支出", onCallBack: (money){
        setState(() {
          hideWaitDialog();
          pay = money;
        });
      });
    });
  }

  @override
  Widget getListChild() {
    return ListView(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10.0),
          child: Container(
            width: 100.0,
            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(width: 0.5, color: MyColors.loginDriverColor),
            ),
            alignment: Alignment.center,
            child: Text(
              selectBookBean?.name ?? "添加账单",
              style: TextStyle(
                color: MyColors.text_normal,
                fontSize: 11.0,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 100.0,
          padding: EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${nowDate.month}月收入",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: MyColors.text_normal,
                        ),
                      ),
                      Gaps.vGap10,
                      Text(
                        "$getMoney",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: MyColors.title_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 10.0),
                color: MyColors.loginDriverColor,
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${nowDate.month}月支出",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: MyColors.text_normal,
                        ),
                      ),
                      Gaps.vGap10,
                      Text(
                        "$pay",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: MyColors.title_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 5.0,
                height: 15.0,
                color: MyColors.main_color,
                margin: EdgeInsets.only(right: 10.0),
              ),
              Text(
                "我的账本",
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 7 / 8,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: mListData.length + 1,
          itemBuilder: (context, index) {
            return index < mListData.length ? Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  GestureDetector(
                    onTap: () {
                      selectBookBean = mListData[index];
                      showWaitDialog();
                      doSelectPayOnMonth();
                    },
                    onLongPress: (){
                      setState(() {
                        isCanUp = !isCanUp;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: DataConfig.myBookColors[mListData[index].color],
                              center: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          width: 100.0,
                          height: 120.0,
                          child: VerticalCenterTextWidget(
                            width: 75,
                            height: 120,
                            text: mListData[index].name,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                            ),
                          ),
                        ),

                        //长按显示的蒙层
                        Offstage(
                          offstage: !isCanUp,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isCanUp = false;
                              });
                              int position = await showCenterDialog(bodyContext, BookUpDialog());
                              if (position != null) {
                                if (position == 0) { //编辑
                                  NavigatorUtil.pushPageByRoute(widget.parentContext, AddBookRoute(bookBean: mListData[index],));
                                } else if(position == 1) { //删除
                                  if (selectBookBean == mListData[index]) {
                                    if (mListData.length > 1) {
                                      selectBookBean = index > 0 ? mListData[index - 1] : mListData[index + 1];
                                    } else {
                                      selectBookBean = null;
                                    }
                                  }
                                  showWaitDialog();
                                  await NetClickUtil().removeBook(user.id, mListData[index].id, (){
                                    onRefresh();
                                    hideWaitDialog();
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [Colors.black38,Colors.black38],
                                  center: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 120.0,
                              child: Image.asset(Util.getImgPath("ico_up_white"), width: 20.0, height: 20.0,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "收入:${mListData[index].income}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 11.0,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      "支出:${mListData[index].pay}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      NavigatorUtil.pushPageByRoute(widget.parentContext, AddBookRoute());
                    },
                    child: Container(
                      width: 100.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 1, color: Color(0xFF999999)),
                      ),
                      child: VerticalCenterTextWidget(
                        width: 75,
                        height: 120,
                        text: "添加账本",
                        textStyle: TextStyle(
                          color: MyColors.text_normal,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
