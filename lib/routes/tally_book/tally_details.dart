import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/line.dart';
import 'package:provider/provider.dart';

import 'add_tally_route.dart';

/*
 * 账单详情
 */
class TallyDetailsRoute extends BaseRoute {
  final MyTallyBeanEntity myTallyBean;

  TallyDetailsRoute(this.myTallyBean);
  @override
  _TallyDetailsRouteState createState() => _TallyDetailsRouteState(myTallyBean);
}

class _TallyDetailsRouteState extends BaseRouteState<TallyDetailsRoute> {

  BookItemBean bookItemBean;
  MyTallyBeanEntity myTallyBean;
  BookModel bookModel;
  List<MyBookBeanEntity> books;
  TallyModel tallyModel;
  MyBookBeanEntity myBookBean;
  DateTime dateTime = DateTime.now();

  _TallyDetailsRouteState(this.myTallyBean){
    title = "账单详情";
    appBarElevation = 0.0;
    setRightButtonFromIcon(Icons.delete_outline);
  }

  @override
  void initState() {
    super.initState();
    bookModel = Provider.of<BookModel>(context, listen: false);
    books = bookModel.books;
    tallyModel = Provider.of<TallyModel>(context, listen: false);
    books.forEach((item){
      if (item.id == myTallyBean.bookId) {
        myBookBean = item;
      }
    });
    bookItemBean = Util.getBookItemBean(myTallyBean.useType, myTallyBean.type, myBookBean?.type);
  }

  @override
  void onRightButtonClick() async {
    int index = await showCenterDialog(context, CenterHintDialog(
      text: "是否确定要删除该项纪录？",
    ));
    if (index != null && index == 1) {
      await MyTallyDao().removeOne(myTallyBean.id);
      if (myTallyBean.year == dateTime.year && myTallyBean.month == dateTime.month) { //本月账单
        tallyModel.removeOne(myTallyBean.id);
        if (myTallyBean.type == "支出") {
          myBookBean.pay -= myTallyBean.money;
        } else {
          myBookBean.income -= myTallyBean.money;
        }
        bookModel.update(myBookBean);
      }
      showToast("删除成功");
      finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Util.getImgPath("ico_tally_details_bg")), repeat: ImageRepeat.repeatY),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              fit: StackFit.loose,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0, bottom: 22.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 35.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 20.0,
                            height: 20.0,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              border: Border.all(width: 1.0, color: bookItemBean?.color),
                            ),
                            child: Icon(
                              bookItemBean?.icon,
                              size: 15.0,
                              color: bookItemBean?.color,
                            ),
                          ),
                          Text(
                            myTallyBean.useType,
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 18.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${myTallyBean.money}",
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: MySeparator(),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          myTallyBean.comment,
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 14.0,
                          ),
                        ),
                      ),

                      Gaps.vGap20,

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "账单时间",
                            style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 13.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                myTallyBean.time,
                                style: TextStyle(
                                  color: MyColors.text_normal,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap10,

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "账单类别",
                            style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 13.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                myTallyBean.type,
                                style: TextStyle(
                                  color: MyColors.text_normal,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap10,

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "账单地址",
                            style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 13.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                myTallyBean?.address ?? "无",
                                style: TextStyle(
                                  color: MyColors.text_normal,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    NavigatorUtil.pushPageByRoute(context, AddTallyRoute(myTallyBean: myTallyBean, oldContext: context,));
                  },
                  child: Container(
                    width: 200.0,
                    height: 44.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColors.main_color,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.5, 0.5),
                          blurRadius: 22.0,
                        ),
                      ],
                    ),
                    child: Text(
                      "编辑",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
