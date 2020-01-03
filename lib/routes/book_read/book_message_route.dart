import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_no_bloc_route.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/routes/book_read/MessageItemView.dart';
import 'package:flutter_base/utils/utils.dart';

//我的消息
class BookMessageRoute extends BaseListNoBlocRoute {
  @override
  _BookMessageRouteState createState() => _BookMessageRouteState();
}

class _BookMessageRouteState extends BaseListNoBlocRouteState<BookMessageRoute, BookSendCommentBeanEntity> {

  _BookMessageRouteState(){
    title = "我的消息";
    enablePullUp = false;
    titleBarBg = Colors.white;
    appBarElevation = 0.5;
    titleColor = Colors.black;
    statusTextDarkColor = false;
    showStartCenterLoading = true;
  }

  bool showEditView = false; //显示底部评论
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  int commitIndex = 0; //回复的索引

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _commentFocus.dispose();
    _textEditingController.dispose();
  }

  @override
  void addListener() {
    hideSoftInput();
    setState(() {
      showEditView = false;
      commitIndex = 0;
    });
  }

  @override
  Future getData() async {
    List<BookSendCommentBeanEntity> headData = [];
    await BookCommentDao().findMyAllMessage(user.id, callBack: (List<BookSendCommentBeanEntity> data) async {
      if(data == null) {
        return;
      }
      for (int i = 0; i < data.length; i++) {
        if (!data[i].isRead) {
          data[i].isRead = true;
          BookCommentDao().upData(data[i]);
        }
        headData.add(data[i]);
      }
    });
    return headData;
  }


  @override
  Widget getItemBuilder(BuildContext c, int index) {
    index = index - getHeadCount();
    return MessageItemView(
      mListData[index],
      context,
      onCommitTap: (){
        _commentFocus.unfocus(); //失去焦点
        setState(() {
          showEditView = true;
          commitIndex = index;
        });
        FocusScope.of(bodyContext).requestFocus(_commentFocus);     // 获取焦点
      },
    );
  }

  @override
  Widget getListDriver(BuildContext context, int index) {
    index -= getHeadCount();
    return Container(
      width: double.infinity,
      height: 0.5,
      color: MyColors.loginDriverColor,
    );
  }

  BookSendCommentBeanEntity getParentData(List<BookSendCommentBeanEntity> list, int parentId) {
    BookSendCommentBeanEntity data;
    list.forEach((item){
      if(item.id == parentId) {
        data = item;
      }
    });
    return data;
  }

  @override
  Widget addOtherWidgetToBottom() {
    return Offstage(
      offstage: !showEditView,
      child: Container(
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
                  focusNode: _commentFocus,
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
                    hintText: "回复${mListData[commitIndex]?.sendUser?.userName}",
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
                BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity(
                  content: _textEditingController.text,
                  commitNumber: 0,
                  level: 2,
                  grade: -1,
                  isRead: false,
                  likeNumber: 0,
                  likeUserId: [],
                  parentId: mListData[commitIndex].id,
                  parentContent: mListData[commitIndex].content,
                  bookId: mListData[commitIndex].bookId,
                  bookCover: mListData[commitIndex].bookCover,
                  bookAuthor: mListData[commitIndex].bookAuthor,
                  bookName: mListData[commitIndex].bookName,
                  sendTime: Util.getNowTime(),
                  sendUser: CommitUserInfo(
                      userId: user.id,
                      userName: user?.name ?? user.phone,
                      sex: user?.sex,
                      logo: user?.logo
                  ),
                  receiverUser: mListData[commitIndex].sendUser,
                );
                BookCommentDao().insertData(beanEntity, callBack: (id){
                  beanEntity.id = id;
                  _textEditingController.clear();
                  showEditView = false;
                  commitIndex = 0;
                  hideSoftInput();
                  showToast("发送成功");
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
      ),
    );
  }

}
