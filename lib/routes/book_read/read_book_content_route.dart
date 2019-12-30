import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/read_book/read_book_catalogue_bean_entity.dart';
import 'package:flutter_base/bean/read_book/read_book_content_info_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/widgets/BookPageView.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

class ReadBookContentRoute extends BaseRoute {
  final String bookId;
  int readIndex;

  ReadBookContentRoute(this.bookId, {this.readIndex = 0});
  @override
  _ReadBookContentRouteState createState() => _ReadBookContentRouteState();
}

class _ReadBookContentRouteState extends BaseRouteState<ReadBookContentRoute> {

  _ReadBookContentRouteState(){
    needAppBar = false;
    showStartCenterLoading = true;
  }

  ReadBookCatalogueBeanEntity mReadBookCatalogueBean; //小说目录信息
  ReadBookContentInfoBeanEntity mBookContentInfo; //小说章节内容
  
  @override
  void initState() {
    super.initState();
    initData();
  }
  
  void initData() async {
    NetClickUtil().getBookCatalogueInfo(widget.bookId, callBack: (ReadBookCatalogueBeanEntity data) async {
      mReadBookCatalogueBean = data;
      initContentData();
    }).catchError((e){
      setState(() {
        loadStatus = Status.fail;
      });
    });
  }

  //获取章节内容
  void initContentData() async {
    NetClickUtil(context).getBookContentInfo(mReadBookCatalogueBean.chapters[widget.readIndex].link, callBack: (ReadBookContentInfoBeanEntity readData){
      setState(() {
        mBookContentInfo = readData;
        loadStatus = Status.success;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          AppStatusBar(
            buildContext: context,
          ),
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  mBookContentInfo?.chapter?.cpContent?.replaceAll("&&", "        ") ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
//      body: BookPageView(mBookContentInfo),
    );
  }
}
