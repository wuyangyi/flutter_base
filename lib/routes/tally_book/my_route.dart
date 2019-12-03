import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_mileage_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:provider/provider.dart';

import 'feedback_route.dart';
import 'good_reputation_route.dart';

class MyRoute extends BaseRoute {
  final BuildContext parentContext;

  MyRoute(this.parentContext);
  @override
  _MyRouteState createState() => _MyRouteState();
}

class _MyRouteState extends BaseRouteState<MyRoute> {
  _MyRouteState(){
    showStartCenterLoading = false;
    title = "我的";
    leading = Container();
    appBarElevation = 0.0;
    bodyColor = MyColors.home_bg;
    resizeToAvoidBottomInset = false;
  }

  TallyModel tallyModel;

  @override
  void initState() {
    super.initState();
    tallyModel = Provider.of<TallyModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 10.0, bottom: 20.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Hero(
                  tag: HeroString.BOOK_MINE_USER_HEAD, //唯一标记
                  child: ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: user?.logo == null ? Image.asset(Util.getImgPath(
                      Util.getUserHeadImageName(user?.sex),),
                      width: 60.0,
                      height: 60.0,
                    ) : Image.file(File(user?.logo), width: 60.0,
                      height: 60.0,),
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            user.name,
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                          Gaps.hGap10,
                          Image.asset(Util.getImgPath(getRankImageName()), height: 15.0,)
                        ],
                      ),
                      Gaps.vGap10,
                      Text(
                        user.synopsis ?? "这个人很懒，什么都没留下~",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
//                Gaps.hGap5,
//                GestureDetector(
//                  onTap: (){
//                    showToast("签到暂未开通~");
//                  },
//                  child: Container(
//                    height: 25.0,
//                    width: 60.0,
//                    decoration: BoxDecoration(
//                      color: MyColors.main_color,
//                      borderRadius: BorderRadius.circular(22.0),
//                    ),
//                    alignment: Alignment.center,
//                    child: Text("签到",
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 12.0,
//                      ),
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
          Gaps.vGap10,
          MyItemButton(
            leftWidget: Image.asset(Util.getImgPath("ico_mine_history"),),
            title: "账单里程",
            rightText: "看看你的账单里程吧",
            onTap: (){
              Navigator.push(widget.parentContext, PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                  return new FadeTransition(
                    opacity: animation,
                    child: TallyMileageRoute(),
                  );
                },
              ),);
            },
          ),
          MyItemButton(
            leftWidget: Image.asset(Util.getImgPath("ico_mine_project"),),
            title: "项目地址",
            rightText: "wuyangyi",
            onTap: (){
              NavigatorUtil.pushWeb(widget.parentContext,
                title: "项目地址",
                url: "https://github.com/wuyangyi/flutter_base",);
            },
          ),
          MyItemButton(
            leftWidget: Image.asset(Util.getImgPath("ico_mine_msg"),),
            title: "意见反馈",
            rightText: "",
            onTap: (){
              NavigatorUtil.pushPageByRoute(widget.parentContext, FeedBackRoute());
            },
          ),
          MyItemButton(
            leftWidget: Image.asset(Util.getImgPath("ico_mine_message"),),
            title: "五星好评",
            rightWidget: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(Util.getImgPath("ico_like"), width: 8.0, height: 8.0,),
                Image.asset(Util.getImgPath("ico_like"), width: 8.0, height: 8.0,),
                Image.asset(Util.getImgPath("ico_like"), width: 8.0, height: 8.0,),
                Image.asset(Util.getImgPath("ico_like"), width: 8.0, height: 8.0,),
                Image.asset(Util.getImgPath("ico_like"), width: 8.0, height: 8.0,),
              ],
            ),
            onTap: (){
              NavigatorUtil.pushPageByRoute(widget.parentContext, GoodReputationRoute());
            },
          ),
        ],
      ),
    );
  }

  //根据本月账单量设置头衔
  String getRankImageName() {
    String imageName = "ico_rank_three";
    if (tallyModel.tally.length > 20) {
      imageName = "ico_rank_top";
    } else if (tallyModel.tally.length > 10) {
      imageName = "ico_rank_two";
    } else {
      imageName = "ico_rank_three";
    }
    return imageName;
  }
}

