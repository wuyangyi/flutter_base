import 'package:flutter/material.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_item.dart';
import 'package:flutter_base/utils/utils.dart';

class HomeBookMallItem extends StatelessWidget {
  final RankBeanRanking data;
  final Function onMoreClick;

  const HomeBookMallItem(this.data, {Key key, this.onMoreClick,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return data?.books == null || data.books.isEmpty ? Container(): Container(
      width: double.infinity,
      child: Column(
        children: getListWidget(),
      ),
    );
  }

  List<Widget> getListWidget() {
    List<Widget> list = [
      Container(
        width: double.infinity,
        height: 8.0,
        color: MyColors.loginDriverColor,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                data.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Offstage(
              offstage: data.books.length <= 3,
              child: GestureDetector(
                onTap: (){
                  if (onMoreClick != null) {
                    onMoreClick();
                  }
                },
                child: Text(
                  "更多",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: MyColors.text_normal,
                  ),
                ),
              ),
            ),
            Gaps.hGap5,
            Offstage(
              offstage: data.books.length <= 3,
              child: Image.asset(Util.getImgPath("ic_arrow_smallgrey"), width: 10.0,),
            ),
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 0.5,
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        color: MyColors.loginDriverColor,
      ),
    ];

    for (int i = 0; i < 3 && i < data.books.length; i++) {
      list.add(BookItem(
        data.books[i],
      ));
    }
    return list;
  }
}
