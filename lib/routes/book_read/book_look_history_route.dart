import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_no_bloc_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookLookHistoryDao.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/routes/book_read/book_item.dart';
import 'package:flutter_base/utils/utils.dart';

class BookLookHistoryRoute extends BaseListNoBlocRoute {
  @override
  _BookLookHistoryRouteState createState() => _BookLookHistoryRouteState();
}

class _BookLookHistoryRouteState extends BaseListNoBlocRouteState<BookLookHistoryRoute, RankBeanRankingBook> {

  _BookLookHistoryRouteState(){
    title = "历史记录";
    appBarElevation = 1.0;
    showStartCenterLoading = true;
    titleBarBg = Colors.white;
    titleColor = Colors.black;
    statusTextDarkColor = false;
  }

  @override
  Future getData() async {
    return await BookLookHistoryDao().findDataPage(user.id, page).catchError((e){
      print(e);
    });
  }

  @override
  Widget getItemBuilder(BuildContext c, int index) {
    index -= getHeadCount();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: index != 0 && Util.getTimeForNow(mListData[index].time) == Util.getTimeForNow(mListData[index - 1].time),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
            color: MyColors.loginDriverColor,
            alignment: Alignment.centerLeft,
            child: Text(
              Util.getTimeForNow(mListData[index].time),
              style: TextStyle(
                color: MyColors.text_normal,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        BookItem(
          mListData[index],
          parentContext: context,
        ),
      ],
    );
  }
}
