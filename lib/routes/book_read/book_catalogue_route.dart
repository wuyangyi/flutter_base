import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/read_book/read_book_catalogue_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/read_book_content_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/status_widget.dart';

class BookCatalogueRoute extends BaseRoute {
  final String bookId;
  final String bookName;

  BookCatalogueRoute(this.bookId, this.bookName);
  @override
  _BookCatalogueRouteState createState() => _BookCatalogueRouteState(bookName);
}

class _BookCatalogueRouteState extends BaseRouteState<BookCatalogueRoute> {
  _BookCatalogueRouteState(String bookName) {
    title = bookName;
    statusTextDarkColor = false;
    appBarElevation = 0.0;
    titleBarBg = Colors.white;
    bodyColor = Colors.white;
    titleColor = MyColors.title_color;
    showStartCenterLoading = true;
  }

  ReadBookCatalogueBeanEntity mReadBookCatalogueBean;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    NetClickUtil().getBookCatalogueInfo(widget.bookId, callBack: (ReadBookCatalogueBeanEntity data){
      mReadBookCatalogueBean = data;
      setState(() {
        loadStatus = Status.success;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: CupertinoScrollbar(
        child: ListView.separated(
          itemCount: mReadBookCatalogueBean?.chapters?.length ?? 0,
          separatorBuilder: (context, index){
            return Container(
              width: double.infinity,
              height: 0.5,
              color: MyColors.home_bg,
            );
          },
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, ReadBookContentRoute(widget.bookId, readIndex: index,));
              },
              child: Container(
                width: double.infinity,
                height: 45.0,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${index+1}.${mReadBookCatalogueBean.chapters[index].title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.text_normal_5,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    Text(
                      mReadBookCatalogueBean.chapters[index].isVip ? "" : "免费",
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
