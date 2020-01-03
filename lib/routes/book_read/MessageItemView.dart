import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/dao/read_book/BookCommentDao.dart';
import 'package:flutter_base/bean/read_book/book_send_comment_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_commit_detail_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';


//我的消息item
class MessageItemView extends StatefulWidget {
  BookSendCommentBeanEntity itemData;
  final BuildContext parentContext;
  final Function onCommitTap;

  MessageItemView(this.itemData, this.parentContext, {this.onCommitTap});

  @override
  _MessageItemViewState createState() => _MessageItemViewState();
}

class _MessageItemViewState extends State<MessageItemView> {

  UserBeanEntity user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NavigatorUtil.pushPageByRoute(widget.parentContext, BookCommitDetailRoute(commentBeanEntity: widget.itemData, otherComeIn: true,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: widget.itemData?.sendUser?.logo == null ? Image.asset(Util.getImgPath(
                    Util.getUserHeadImageName(widget.itemData?.sendUser?.sex),),
                    width: 35.0,
                    height: 35.0,
                  ) : Image.file(File(widget.itemData?.sendUser?.logo), width: 35.0,
                    height: 35.0,),
                ),
                Gaps.hGap15,

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.itemData?.sendUser?.userName ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      Gaps.vGap5,
                      Text(
                        Util.getTimeForNow(widget.itemData.sendTime),
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

                GestureDetector(
                  onTap: (){
                    if (widget.onCommitTap != null) {
                      widget.onCommitTap();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
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
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      if (Util.checkGood(widget.itemData.likeUserId, user.id)) {
                        widget.itemData.likeUserId.remove(user.id);
                        widget.itemData.likeNumber--;
                      } else {
                        widget.itemData.likeUserId.add(user.id);
                        widget.itemData.likeNumber++;
                      }
                    });
                    BookCommentDao().upData(widget.itemData);
                  },
                  child: Container(
                    width: 60.0,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          Util.getImgPath(Util.checkGood(widget.itemData.likeUserId, user.id) ? "ico_give_like_cancel" : "ico_give_like"),
                          height: 15.0,
                          fit: BoxFit.fill,
                        ),
                        Gaps.hGap5,
                        Text(
                          "${Util.checkGood(widget.itemData.likeUserId, user.id) ? '已赞' : widget.itemData.likeNumber}",
                          style: TextStyle(
                            color: Util.checkGood(widget.itemData.likeUserId, user.id) ? MyColors.main_color : MyColors.text_normal_5,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Gaps.vGap10,

            Text(
              widget.itemData.content,
              style: TextStyle(
                color: MyColors.title_color,
                fontSize: 14.0,
              ),
            ),
            Gaps.vGap10,

            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: double.infinity,
                height: 85.0,
                color: MyColors.home_body_bg,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: AppConfig.READ_BOOK_BASE_URL_USE + widget.itemData.bookCover,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => new ProgressView(),
                      errorWidget: (context, url, error) => new Icon(Icons.broken_image),
                    ),

                    Gaps.hGap10,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "@${widget.itemData.receiverUser.userName}",
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 13.0,
                          ),
                        ),
                        Gaps.vGap5,
                        Text(
                          widget.itemData.parentContent,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyColors.text_normal,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
