import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_no_bloc_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/read_book/book_detail_info_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_info_route.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BookCommitDetailRoute extends BaseListNoBlocRoute {
  final int selectIndex;
  BookSendCommentBeanEntity commentBeanEntity;
  final bool otherComeIn;

  BookCommitDetailRoute({this.selectIndex = -1, this.commentBeanEntity, this.otherComeIn = false});
  
  @override
  _BookCommitDetailRouteState createState() => _BookCommitDetailRouteState(selectIndex);
}

class _BookCommitDetailRouteState extends BaseListNoBlocRouteState<BookCommitDetailRoute, BookSendCommentBeanEntity> {
  _BookCommitDetailRouteState(this.selectIndex){
    title = "";
    titleColor = MyColors.title_color;
    centerTitle = false;
    appBarElevation = 0.5;
    titleBarBg = Colors.white;
    statusTextDarkColor = false;
    showStartCenterLoading = true;
    bodyColor = Colors.white;
    resizeToAvoidBottomInset = true;
    enableJumpTop = false;
  }

  TextEditingController _textEditingController = new TextEditingController();

  final int selectIndex;
  BookCommitModel bookCommitModel; //评论
  BookSendCommentBeanEntity parentCommitBean;

  @override
  void initState() {
    super.initState();
    bookCommitModel = Provider.of<BookCommitModel>(context, listen: false);
    print("selectIndex:$selectIndex");
    if (selectIndex != -1) {
      parentCommitBean = bookCommitModel.bookCommitList[selectIndex];
    }
    bus.on(EventBusString.COMMIT_SEND_UPDATA, (id) {
      for (int i = 0; i < mListData.length; i++) {
        if (mListData[i].id == id) {
          setState(() {
          });
        }
      }
    });
    bus.on(EventBusString.COMMIT_TWO_FINISH, (d){
      finish();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    bus.off(EventBusString.COMMIT_SEND_UPDATA);
    bus.off(EventBusString.COMMIT_TWO_FINISH);
  }
  
  @override
  Future getData() async {
    return await BookCommentDao().findAllDataByParentId(parentCommitBean.id, page);
  }

  @override
  Widget addOtherWidgetToBottom() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 0.5,color: MyColors.loginDriverColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.send,
            size: 20.0,
            color: MyColors.lineColor,
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 7.0, left: 3.0, right: 3.0),
              constraints: BoxConstraints(
                minHeight: 35.0,
              ),
              child: TextField(
                controller: _textEditingController,
                autofocus: false,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF363951),
                  fontSize: 14.0,
                ),
                scrollPadding: EdgeInsets.all(0.0),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration( //外观样式
                  hintText: parentCommitBean?.receiverUser?.userId == user.id ? "回复${parentCommitBean?.sendUser?.userName ?? ''}" : "添加评论...",
                  contentPadding: const EdgeInsets.only(left:5.0, right: 3.0),
                  border: InputBorder.none, //去除自带的下划线
                  hintStyle: TextStyle(
                    color: Color(0xFFCBCDD5),
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              if (_textEditingController.text.isEmpty) {
                showToast("输入的内容为空~");
                return;
              }
              hideSoftInput();
              showWaitDialog();
              bus.emit(EventBusString.COMMIT_SEND_UPDATA, parentCommitBean.id);
              BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity(
                content: _textEditingController.text,
                commitNumber: 0,
                level: 2,
                grade: -1,
                isRead: false,
                likeNumber: 0,
                likeUserId: [],
                parentId: parentCommitBean.id,
                parentContent: parentCommitBean.content,
                bookId: parentCommitBean.bookId,
                bookCover: parentCommitBean.bookCover,
                bookAuthor: parentCommitBean.bookAuthor,
                bookName: parentCommitBean.bookName,
                sendTime: Util.getNowTime(),
                sendUser: CommitUserInfo(
                    userId: user.id,
                    userName: user?.name ?? user.phone,
                    sex: user?.sex,
                    logo: user?.logo
                ),
                receiverUser: parentCommitBean.sendUser,
              );
              BookCommentDao().insertData(beanEntity, callBack: (id){
                beanEntity.id = id;
                if (parentCommitBean.parentId == -1) {
                  bookCommitModel.addCommit(parentCommitBean.id);
                } else {
                  parentCommitBean.commitNumber++;
                  BookCommentDao().upData(parentCommitBean);
                }
                mListData.add(beanEntity);
                _textEditingController.clear();
                hideSoftInput();
                hideWaitDialog();
              });

            },
            child: Container(
              height: 25.0,
              width: 55.0,
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: MyColors.main_color,
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Text(
                "发送",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget getListDriver(BuildContext context, int index) {
    return index - getHeadCount() < 0 ? Container(
      width: 0,
      height: 0,
      color: Colors.transparent,
    ) : Container(
      width: double.infinity,
      height: 0.5,
      color: MyColors.loginDriverColor,
      margin: EdgeInsets.only(left: 70, right: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("parentCommitBean:${parentCommitBean == null}");
    if (parentCommitBean == null && widget.commentBeanEntity != null) {
      parentCommitBean = widget.commentBeanEntity;
    }
    setState(() {
      title = parentCommitBean.bookName;
    });
    return super.build(context);
  }
  
  @override
  List<Widget> initHeadView() {
    return [
      Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: parentCommitBean?.sendUser?.logo == null ? Image.asset(Util.getImgPath(
                    Util.getUserHeadImageName(parentCommitBean?.sendUser?.sex),),
                    width: 35.0,
                    height: 35.0,
                  ) : Image.file(File(parentCommitBean?.sendUser?.logo), width: 35.0,
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
                        parentCommitBean?.sendUser?.userName ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      Gaps.vGap5,
                      Text(
                        Util.getTimeForNow(parentCommitBean.sendTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            
            Gaps.vGap5,
            
            Offstage(
              offstage: parentCommitBean?.grade == -1,
              child: Row(
                children: getScoreWidget(parentCommitBean.grade.toDouble()),
              ),
            ),

            Gaps.vGap5,

            Text(
              parentCommitBean.content,
              style: TextStyle(
                color: MyColors.title_color,
                fontSize: 13.0,
              ),
            ),

            Gaps.vGap10,
            
            GestureDetector(
              onTap: (){
                if (widget.otherComeIn) {
                  NavigatorUtil.pushPageByRoute(context, BookInfoRoute(parentCommitBean.bookId));
                } else {
                  bus.emit(EventBusString.COMMIT_TWO_FINISH); //关闭所有评论详情页面
                }
              },
              child: Container(
                width: double.infinity,
                height: 80.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  border: Border.all(width: 0.8, color: MyColors.lineColor),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: AppConfig.READ_BOOK_BASE_URL_USE + parentCommitBean.bookCover,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => new ProgressView(),
                      errorWidget: (context, url, error) => new Icon(Icons.broken_image),
                    ),
                    Gaps.hGap10,
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            parentCommitBean?.bookName ?? "",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                          Gaps.vGap5,
                          Text(
                            parentCommitBean?.bookAuthor ?? "",
                            style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Gaps.vGap10,
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    "${mListData.length}条评论",
                    style: TextStyle(
                      color: MyColors.text_normal,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if (parentCommitBean.parentId == -1) {
                      bookCommitModel.addGood(parentCommitBean.id, user.id);
                    } else {
                      bus.emit(EventBusString.COMMIT_SEND_UPDATA, parentCommitBean.id);
                      if (Util.checkGood(parentCommitBean.likeUserId, user.id)) {
                        parentCommitBean.likeUserId.remove(user.id);
                        parentCommitBean.likeNumber--;
                      } else {
                        parentCommitBean.likeNumber++;
                        parentCommitBean.likeUserId.add(user.id);
                      }
                      BookCommentDao().upData(parentCommitBean);
                    }
                    setState(() {
                      initHeadOrFloorView();
                    });

                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          Util.getImgPath(Util.checkGood(parentCommitBean.likeUserId, user.id) ? "ico_give_like_cancel" : "ico_give_like"),
                          height: 15.0,
                          fit: BoxFit.fill,
                        ),
                        Gaps.hGap10,
                        Text(
                          "${parentCommitBean.likeNumber}",
                          style: TextStyle(
                            color: Util.checkGood(parentCommitBean.likeUserId, user.id) ? MyColors.main_color : MyColors.text_normal_5,
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

      Container(
        width: double.infinity,
        height: 5.0,
        color: MyColors.home_body_bg,
      ),
    ];
  }

  List<Widget> getScoreWidget(double score) {
    List<Widget> list = [];
    for(int i = 0; i < 5; i++) {
      list.add(Icon(
        Util.getIconByScore(i, score),
        size: 15.0,
        color: Colors.orangeAccent,
      ));
    }
    return list;
  }

  

  @override
  Widget getItemBuilder(BuildContext c, int index) {
    BookSendCommentBeanEntity commitItem = mListData[index - getHeadCount()];
    return Material(
      color: Colors.white,
      child: Ink(
        child: InkWell(
          onTap: (){
            NavigatorUtil.pushPageByRoute(context, BookCommitDetailRoute(commentBeanEntity: mListData[index - getHeadCount()],));
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
                      Text(
                        "${index - getHeadCount() + 1}楼",
                        style: TextStyle(
                          color: MyColors.text_normal,
                          fontSize: 12.0,
                        ),
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
                              if (Util.checkGood(mListData[index - getHeadCount()].likeUserId, user.id)) {
                                mListData[index - getHeadCount()].likeNumber--;
                                mListData[index - getHeadCount()].likeUserId.remove(user.id);
                              } else {
                                mListData[index - getHeadCount()].likeNumber++;
                                mListData[index - getHeadCount()].likeUserId.add(user.id);
                              }
                              BookCommentDao().upData(mListData[index - getHeadCount()]);
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
                              NavigatorUtil.pushPageByRoute(context, BookCommitDetailRoute(commentBeanEntity: mListData[index - getHeadCount()],));
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
  }
  
  
}
