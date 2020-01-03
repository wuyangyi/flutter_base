import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/dao/read_book/BookLookHistoryDao.dart';
import 'package:flutter_base/bean/read_book/book_detail_info_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_rack_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_real_info_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_catalogue_route.dart';
import 'package:flutter_base/routes/book_read/book_commit_detail_route.dart';
import 'package:flutter_base/routes/book_read/read_book_content_route.dart';
import 'package:flutter_base/routes/book_read/write_commit_route.dart';
import 'package:flutter_base/utils/image_color_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

//小说详情页面
class BookInfoRoute extends BaseRoute {

  final String bookId;

  BookInfoRoute(this.bookId);
  @override
  _BookInfoRouteState createState() => _BookInfoRouteState(bookId);
}

class _BookInfoRouteState extends BaseRouteState<BookInfoRoute> {
  _BookInfoRouteState(this.bookId){
    needAppBar = false;
    resizeToAvoidBottomInset = false;
    titleBarBg = Colors.transparent;
    bodyColor = Colors.white;
    showStartCenterLoading = true;
    statusTextDarkColor = false;
    appBarElevation = 0.0;
    leading = IconButton(
      key: key_btn_left,
      icon: Image.asset(Util.getImgPath("icon_back_black"), height: 20.0,),
      onPressed: (){
        onLeftButtonClick();
      },
    );
    setRightButtonFromIcon(Icons.share, iconColor: MyColors.title_color);
  }
  final String bookId;
  BookDetailInfoBeanEntity mBookInfo;
  BookRealInfoBeanEntity mBookRealInfo;
  BookRackModel bookRackModel; //书架
  BookCommitModel bookCommitModel; //评论

  ScrollController _scrollController = ScrollController();
  Color topBgColor = Colors.white;

  bool showToolBarTitle = false;

  @override
  void initState() {
    super.initState();
    bookRackModel = Provider.of<BookRackModel>(context, listen: false);
    bookCommitModel = Provider.of<BookCommitModel>(context, listen: false);
    initData();
    _scrollController.addListener((){
      if (_scrollController.position.pixels < 90 && showToolBarTitle) {
        setState(() {
          showToolBarTitle = false;
          titleBarBg = Colors.transparent;
        });
      } else if (_scrollController.position.pixels >= 90 && !showToolBarTitle) {
        setState(() {
          showToolBarTitle = true;
          titleBarBg = Colors.white;
        });
      }
    });
  }

  @override
  void onRightButtonClick() {
    Share.share(AppConfig.SHARE_TITLE);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void initData() async {
    NetClickUtil().getBookDetailInfo(bookId, callBack: (BookDetailInfoBeanEntity data) async {
      setState(() {
        mBookInfo = data;
        loadStatus = Status.success;
      });
      getColorFromUrl(AppConfig.READ_BOOK_BASE_URL_USE + mBookInfo.cover).then((color){
        print("颜色：$color");
        setState(() {
          topBgColor = Color.fromARGB(150, color[0], color[1], color[2]);
        });
      });
      BookCommentDao().findAllDataByBookId(bookId, callBack: (data){
        bookCommitModel.addAll(data);
      });
      BookLookHistoryDao().insertData(RankBeanRankingBook(
        sId: bookId,
        title: mBookInfo.title,
        author: mBookInfo.author,
        cover: mBookInfo.cover,
        majorCate: mBookInfo.majorCate,
        shortIntro: mBookInfo.longIntro,
        userId: user.id,
        latelyFollower: mBookInfo.latelyFollower,
        time: Util.getNowTime(),
      ));
    }).catchError((e){
      setState(() {
        loadStatus = Status.fail;
      });
    });

    NetClickUtil().getRealBookDetailInfo(bookId, callBack: (BookRealInfoBeanEntity data){
      mBookRealInfo = data;
    });
  }

  List<Widget> getScoreWidget(String title, double score, {TextStyle textStyle, double imageSize}) {
    List<Widget> list = [];
    list.add(Text(
      title,
      style: textStyle ?? TextStyle(
        color: MyColors.text_normal,
        fontSize: 16.0,
      ),
    ));
    list.add(Gaps.hGap5);
    for(int i = 0; i < 5; i++) {
      list.add(Icon(
        Util.getIconByScore(i, score),
        size: imageSize ?? 13.0,
        color: Colors.orangeAccent,
      ));
    }
    return list;
  }

  @override
  Widget getBottomNavigationBar() {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){
                bookRackModel.upState(new BookRackBeanEntity(
                  cover: mBookInfo.cover,
                  bookId: mBookInfo.sId,
                  bookName: mBookInfo.title,
                  userId: user.id,
                ));
                setState(() {
                });
                showToast(bookRackModel.getStateById(mBookInfo.sId) ? "已添加到书架" : "已从书架移除");
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      bookRackModel.getStateById(mBookInfo?.sId ?? "") ? Icons.remove : Icons.add,
                      color: MyColors.main_color,
                    ),

                    Text(
                      bookRackModel.getStateById(mBookInfo?.sId ?? "") ? "取消" : "追书",
                      style: TextStyle(
                        color: MyColors.main_color,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, ReadBookContentRoute(mBookRealInfo.sId, readIndex: 0,));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.main_color,
                ),
                child:Text(
                  "开始阅读",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){
                NavigatorUtil.pushPageByRoute(context, WriteCommitRoute(mBookInfo));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.send,
                      color: MyColors.main_color,
                    ),

                    Text(
                      " 去评论",
                      style: TextStyle(
                        color: MyColors.main_color,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget getTitleWidget() {
    return showToolBarTitle ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3.0),
          child: Image.network(
            AppConfig.READ_BOOK_BASE_URL_USE + mBookInfo?.cover,
            height: 30.0,
            fit: BoxFit.fill,
          ),
        ),

        Gaps.hGap5,

        Text(
          mBookInfo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0,
            color: MyColors.title_color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [topBgColor, Colors.white],
                begin: Alignment.topRight,
                end: Alignment.center,
                tileMode: TileMode.repeated,
              ),
            ),
          ),

          mBookInfo == null ? Container() : Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                //AppBar
                AppBar(
                  brightness: statusTextDarkColor ? Brightness.dark : Brightness.light,
                  leading: new IconButton(
                    key: key_btn_left,
                    icon: Image.asset(Util.getImgPath("icon_back_black"), height: 20.0,),
                    onPressed: (){
                      onLeftButtonClick();
                    },
                  ),
                  title: getTitleWidget(),
                  centerTitle: centerTitle,
                  actions: <Widget>[
                    btn_border ?? new Container(width: 0, height: 0,),
                    btn_right ?? new Container(width: 0, height: 0,),
                  ],
                  backgroundColor: titleBarBg,
                  elevation: appBarElevation,
                ),

                Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    controller: _scrollController,
                    children: <Widget>[
                      //头部信息
                      Container(
                        width: double.infinity,
                        height: 90.0,
                        padding: EdgeInsets.only(left: 20.0, right: 15.0, bottom: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(1.0),
                              child: Image.network(
                                AppConfig.READ_BOOK_BASE_URL_USE + mBookInfo?.cover,
                                height: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),

                            Gaps.hGap10,

                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    mBookInfo.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Gaps.vGap5,

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        mBookInfo.author,
                                        style: TextStyle(
                                          color: MyColors.title_color,
                                          fontSize: 13.0
                                        ),
                                      ),

                                      Container(
                                        width: 1.0,
                                        height: 12.0,
                                        color: MyColors.buttonNoSelectColor,
                                        margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                      ),

                                      Text(
                                        mBookInfo?.copyright ?? "",
                                        style: TextStyle(
                                            color: MyColors.buttonNoSelectColor,
                                            fontSize: 12.0
                                        ),
                                      ),
                                    ],
                                  ),

                                  Gaps.vGap5,

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "${mBookInfo.safelevel}书币/千字",
                                        style: TextStyle(
                                            color: MyColors.title_color,
                                            fontSize: 13.0
                                        ),
                                      ),

                                      Container(
                                        width: 1.0,
                                        height: 12.0,
                                        color: MyColors.buttonNoSelectColor,
                                        margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                      ),

                                      Text(
                                        mBookInfo.wordCount > 10000 ? "${mBookInfo.wordCount ~/ 10000}万字" : "${mBookInfo.wordCount}字",
                                        style: TextStyle(
                                            color: MyColors.buttonNoSelectColor,
                                            fontSize: 12.0
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Gaps.hGap10,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: getScoreWidget(mBookInfo.rating.score.toStringAsFixed(1), mBookInfo.rating.score),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          mBookInfo.rating.tip,
                                          style: TextStyle(
                                            color: MyColors.text_normal,
                                            fontSize: 11.0,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${mBookInfo.retentionRatio}%",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        "读者留存",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        mBookInfo.latelyFollower >= 10000 ? "${(mBookInfo.latelyFollower / 1000).toStringAsFixed(1)}万" : "${mBookInfo.latelyFollower}",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        "7日人气",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        mBookInfo.totalFollower >= 10000 ? "${(mBookInfo.totalFollower / 10000).toStringAsFixed(1)}万" : "${mBookInfo.totalFollower}",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        "累计人气",
                                        style: TextStyle(
                                          color: MyColors.text_normal,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
                              child: Text(
                                "简介",
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20.0, right: 15.0,),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                alignment: WrapAlignment.start,
                                children: mBookInfo.tags.map((item){
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                                    decoration: BoxDecoration(
                                      color: MyColors.home_body_bg,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: MyColors.buttonNoSelectColor,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                              child: Text(
                                mBookInfo.longIntro,
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: (){
                                NavigatorUtil.pushPageByRoute(context, BookCatalogueRoute(mBookRealInfo?.sId ?? mBookInfo.sId, mBookInfo.title));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 20.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: MyColors.loginDriverColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "目录",
                                      style: TextStyle(
                                        color: MyColors.title_color,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Gaps.hGap5,
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "最近更新",
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Gaps.hGap5,
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        mBookInfo.lastChapter,
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: MyColors.buttonNoSelectColor,
                                        ),
                                      ),
                                    ),
                                    Gaps.hGap5,

                                    Image.asset(Util.getImgPath("ic_arrow_smallgrey"), width: 10.0,)
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: MyColors.loginDriverColor,
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20.0, right: 20.0),
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              width: double.infinity,
                              decoration: Decorations.bottom,
                              child: Text(
                                "评论",
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),

                            bookCommitModel.bookCommitList.isEmpty ? Container(
                              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: new Image.asset(
                                Util.getImgPath("ico_data_empty"),
                                width: 150,
                                height: 150,
                              ),
                            ) : ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              itemCount: bookCommitModel.bookCommitList.length,
                              separatorBuilder: (context, index){
                                return Container(
                                  width: double.infinity,
                                  height: 0.5,
                                  color: MyColors.loginDriverColor,
                                  margin: EdgeInsets.only(left: 70, right: 20.0),
                                );
                              },
                              itemBuilder: (c, index){
                                BookSendCommentBeanEntity commitItem = bookCommitModel.bookCommitList[index];
                                return Material(
                                  color: Colors.white,
                                  child: Ink(
                                    child: InkWell(
                                      onTap: (){
                                        NavigatorUtil.pushPageByRoute(context, BookCommitDetailRoute(selectIndex: index,));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0,),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            ClipOval(
                                              child: commitItem?.sendUser?.logo == null ? Image.asset(Util.getImgPath(
                                                Util.getUserHeadImageName(commitItem?.sendUser?.sex),),
                                                width: 35.0,
                                                height: 35.0,
                                              ) : Image.file(File(commitItem?.sendUser?.logo), width: 35.0,
                                                height: 35.0,),
                                            ),

                                            Gaps.hGap15,

                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    commitItem?.sendUser?.userName ?? "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: getScoreWidget("评分", commitItem.grade.toDouble(), textStyle: TextStyle(fontSize: 12.0, color: MyColors.text_normal), imageSize: 15.0),
                                                  ),

                                                  Gaps.vGap5,

                                                  Text(
                                                    commitItem.content,
                                                    style: TextStyle(
                                                      color: MyColors.title_color,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),

                                                  Gaps.vGap10,

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          Util.getTimeForNow(commitItem.sendTime),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: MyColors.text_normal,
                                                            fontSize: 11.0,
                                                          ),
                                                        ),
                                                      ),

                                                      GestureDetector(
                                                        onTap: (){
                                                          bookCommitModel.addGood(commitItem.id, user.id);
                                                          setState(() {

                                                          });
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 5),
                                                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                                          decoration: BoxDecoration(
                                                            color: MyColors.home_body_bg,
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Image.asset(
                                                                Util.getImgPath(Util.checkGood(commitItem.likeUserId, user.id) ? "ico_give_like_cancel" : "ico_give_like"),
                                                                height: 15.0,
                                                                fit: BoxFit.fill,
                                                              ),
                                                              Gaps.hGap10,
                                                              Text(
                                                                "${commitItem.likeNumber}",
                                                                style: TextStyle(
                                                                  color: Util.checkGood(commitItem.likeUserId, user.id) ? MyColors.main_color : MyColors.text_normal_5,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      GestureDetector(
                                                        onTap: (){
                                                          NavigatorUtil.pushPageByRoute(context, BookCommitDetailRoute(selectIndex: index,));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 5),
                                                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                                          decoration: BoxDecoration(
                                                            color: MyColors.home_body_bg,
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Image.asset(
                                                                Util.getImgPath("ico_commit"),
                                                                height: 15.0,
                                                                fit: BoxFit.fill,
                                                              ),
                                                              Gaps.hGap10,
                                                              Text(
                                                                "${commitItem.commitNumber}",
                                                                style: TextStyle(
                                                                  color: MyColors.text_normal_5,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
