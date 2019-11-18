import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/blocs/MyBookBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_details.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/VerticalText.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';

import 'add_book_route.dart';
import 'add_tally_route.dart';

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
    enablePullUp = false;
    enablePullDown = false;
  }
  DateTime nowDate = DateTime.now();
  MyBookBeanEntity selectBookBean; //当前展示的账本
  BookModel bookModel;
  TallyModel tallyModel;
  bool isCanUp = false; //是否可编辑状态

  @override
  void initState() {
    super.initState();
    bookModel = Provider.of<BookModel>(context, listen: false);
    tallyModel = Provider.of<TallyModel>(context, listen: false);
    mListData = bookModel.books;
//    bus.on(EventBusString.BOOK_LOADING, (isNeed){
//      onRefresh();
//    });
    MyBookDao().findAllData(user.id, callBack: (data) async {
      bookModel.clearAll();
      bookModel.addAll(data);
      if (mListData != null) {
        if (mListData.isNotEmpty) {
          selectBookBean = mListData[0];
          //查询当月的所有账单
          await MyTallyDao().findData(user.id, year: nowDate.year, month: nowDate.month, onCallBack: (data){
            tallyModel.clearAll();
            tallyModel.addAll(data);
          });
        }
        setState(() {
          loadStatus = Status.success;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildListBody(context,
      child: getListChild(),
    );
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
                        "${tallyModel.getIncome(selectBookBean?.id)}",
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
                        "${tallyModel.getPay(selectBookBean?.id).abs()}",
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
                      setState(() {
                        selectBookBean = mListData[index];
                      });

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
                                    mListData.removeAt(index);
                                    tallyModel.clearAll();
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
                      "支出:${mListData[index].pay.abs()}",
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
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 5.0,
                height: 15.0,
                color: MyColors.main_color,
                margin: EdgeInsets.only(right: 10.0),
              ),
              Text(
                "本月账单",
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        selectBookBean == null || tallyModel.getTallyByBookId(selectBookBean?.id).isEmpty ? Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Image.asset(
            Util.getImgPath("ico_data_empty"),
            width: 150,
            height: 150,
          ),
        ) : ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tallyModel.getTallyByBookId(selectBookBean?.id).length,
          reverse: true,
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 0.5,
              margin: EdgeInsets.only(left: 15.0),
              color: MyColors.loginDriverColor,
            );
          },
          itemBuilder: (context, index) {
            MyTallyBeanEntity item = tallyModel.getTallyByBookId(selectBookBean?.id)[index];
            BookItemBean bookItemBean = Util.getBookItemBean(item.useType, item.type, selectBookBean?.type);
            bool showDayTime = true; //是否显示时间
            if (index != tallyModel.getTallyByBookId(selectBookBean?.id).length - 1) {
              showDayTime = item.day != tallyModel.getTallyByBookId(selectBookBean?.id)[index + 1].day;
            }
            String time = "${item.day}日";
            if (item.day == nowDate.day) {
              time = "今天";
            } else if (item.day == nowDate.day - 1) {
              time = "昨天";
            }
            return Column(
              children: <Widget>[
                Offstage(
                  offstage: !showDayTime,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
                    color: MyColors.loginDriverColor,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Ink(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      NavigatorUtil.pushPageByRoute(widget.parentContext, TallyDetailsRoute(item,));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                border: Border.all(width: 1.0, color: bookItemBean?.color)
                            ),
                            child: Icon(
                              bookItemBean?.icon,
                              color: bookItemBean?.color,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${item.useType}  ${item.money}",
                                  style: TextStyle(
                                    color: MyColors.title_color,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Offstage(
                                  offstage: item.comment == null || item.comment.isEmpty,
                                  child: Gaps.vGap5,
                                ),
                                Offstage(
                                  offstage: item.comment == null || item.comment.isEmpty,
                                  child: Text(
                                    "${item.comment}",
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: MyColors.text_normal_5,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
