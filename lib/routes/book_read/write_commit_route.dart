import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/read_book/book_detail_info_bean_entity.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:provider/provider.dart';

class WriteCommitRoute extends BaseRoute {
  final BookDetailInfoBeanEntity mBookInfo;

  WriteCommitRoute(this.mBookInfo);
  @override
  _WriteCommitRouteState createState() => _WriteCommitRouteState();
}

class _WriteCommitRouteState extends BaseRouteState<WriteCommitRoute> {

  _WriteCommitRouteState() {
    title = "写评论";
    appBarElevation = 2.0;
    setRightButtonFromText("发布");
    bodyColor = MyColors.home_body_bg;
  }

  BookCommitModel bookCommitModel;

  int selectIndex = 4;
  TextEditingController _editingController = TextEditingController();
  int maxLength = 255; //最大输入长度
  String textLength = "0/255";

  @override
  void initState() {
    super.initState();
    bookCommitModel = Provider.of<BookCommitModel>(context, listen: false);
    textLength = "0/$maxLength";
  }


  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  void onRightButtonClick() {
    showWaitDialog();
    BookSendCommentBeanEntity beanEntity = BookSendCommentBeanEntity(
      content: _editingController.text.isEmpty ? "该用户没有发表评论~" : _editingController.text,
      commitNumber: 0,
      level: 1,
      grade: (selectIndex + 1) * 2,
      isRead: false,
      likeNumber: 0,
      likeUserId: [],
      parentId: -1,
      parentContent: "",
      bookId: widget.mBookInfo.sId,
      bookCover: widget.mBookInfo.cover,
      bookAuthor: widget.mBookInfo.author,
      bookName: widget.mBookInfo.title,
      sendTime: Util.getNowTime(),
      sendUser: CommitUserInfo(
        userId: user.id,
        userName: user?.name ?? user.phone,
        sex: user?.sex,
        logo: user?.logo
      ),
    );
    BookCommentDao().insertData(beanEntity, callBack: (id){
      beanEntity.id = id;
      bookCommitModel.add(beanEntity);
      hideWaitDialog();
      showToast("评论成功");
      finish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        padding: EdgeInsets.all(15.0),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Gaps.vGap5,
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Image.network(
                AppConfig.READ_BOOK_BASE_URL_USE + widget.mBookInfo?.cover,
                width: 70.0,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Container(
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0),
            alignment: Alignment.center,
            child: GoodWidget(
              selectIndex: selectIndex,
              onTap: (int index){
                selectIndex = index;
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    minHeight: 100.0,
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    controller: _editingController,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    maxLines: null,
                    inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                    scrollPadding: EdgeInsets.all(0.0),
                    decoration: InputDecoration( //外观样式
                      hintText: "写下优质评论，有机会得到作者评论哦(255字以内)~",
                      contentPadding: const EdgeInsets.all(0.0),
                      border: InputBorder.none, //去除自带的下划线
                      hintStyle: TextStyle(
                        color: Color(0xFFCBCDD5),
                        fontSize: 14.0,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        textLength = "${value.length}/$maxLength";
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    textLength,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 13.0
                    ),
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
