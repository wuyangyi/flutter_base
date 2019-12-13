import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/chat/chat_info_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/image/image_look_route.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';

class ChatCollectRoute extends BaseRoute {

  final List<ChatInfoBeanEntity> list;

  ChatCollectRoute(this.list);

  @override
  _ChatCollectRouteState createState() => _ChatCollectRouteState(list);
}

class _ChatCollectRouteState extends BaseRouteState<ChatCollectRoute> {
  List<ChatInfoBeanEntity> list;
  _ChatCollectRouteState(this.list) {
    title = "我的收藏";
    appBarElevation = 0.0;
    bodyColor = MyColors.home_bg;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (context, index){
          return Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
          );
        },
        itemBuilder: (context, index){
          return getItemBuilder(index);
        },
      ),
    );
  }

  Widget getItemBuilder(int index){
    ChatInfoBeanEntity data = list[index];
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "${data.isMe ? user?.name ?? user?.phone : "机器人助手"}: ",
            style: TextStyle(
              color: MyColors.title_color,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topLeft,
              child: getItemWidget(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget getItemWidget(int index) {
    ChatInfoBeanEntity data = list[index];
    Widget item;
    switch(data.type) {
      case ChatInfoBeanEntity.TEXT:
        item = Text(
          data.value,
          style: TextStyle(
            fontSize: 15.0,
            color: MyColors.title_color,
          ),
        );
        break;
      case ChatInfoBeanEntity.IMAGE:
        item = GestureDetector(
          onTap: (){
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                return new FadeTransition(
                  opacity: animation,
                  child: ImageLookRoute(data.value, index),
                );
              },
            ),);
          },
          child: Hero(
              tag: "${HeroString.IMAGE_DETIL_HEAD}$index", //唯一标记
              child: Container(
                width: DataConfig.appSize.width / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.file(File(data.value),),
                ),
              )
          ),
        );
        break;
      case ChatInfoBeanEntity.EMIL:
        item = Image.asset(Util.getImgPath(data.value));
        break;
      case ChatInfoBeanEntity.CARD:
        item = Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Util.getImgPath("ico_card_bg"),
              ),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user?.name ?? user.phone,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.hGap5,
                  Offstage(
                    offstage: user?.sex == null,
                    child: Image.asset(Util.getImgPath(user?.sex == "女" ? "ico_woman_white" : "ico_man_white"), width: 10.0, height: 10.0,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: user?.logo == null ? Image.asset(Util.getImgPath(
                      Util.getUserHeadImageName(user?.sex),),
                      width: 30.0,
                      height: 30.0,
                    ) : Image.file(File(user?.logo), width: 30.0,
                      height: 30.0,),
                  ),
                ],
              ),
              Gaps.vGap5,
              Text(
                "手机号： ${user?.phone ?? '暂无'}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "年龄： ${user?.age == null ? '未知' : '${user?.age}岁'}" ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "地址信息： ${user?.address ?? "暂无"}" ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "简介： ${user?.synopsis ?? "暂无"}" ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        );
        break;
    }
    return item;
  }
}
