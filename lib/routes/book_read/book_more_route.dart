import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/routes/book_read/book_item.dart';
import 'package:flutter_base/widgets/widgets.dart';

class BookMoreRoute extends BaseRoute {
  final RankBeanRanking data;

  BookMoreRoute(this.data);
  @override
  _BookMoreRouteState createState() => _BookMoreRouteState(data.shortTitle);
}

class _BookMoreRouteState extends BaseRouteState<BookMoreRoute> {

  _BookMoreRouteState(String topTitle){
    title = topTitle;
    titleBarBg = Colors.white;
    appBarElevation = 0.0;
    titleColor = MyColors.title_color;
    statusTextDarkColor = false;
    bodyColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView.builder(
        padding: EdgeInsets.all(0.0),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget?.data?.books == null ? 0 : widget.data.books.length + 1,
        itemBuilder: (context, index){
          return index < widget.data.books.length ? BookItem(
            widget.data.books[index],
          ) : ListBottomLine();
        },
      ),
    );
  }
}
