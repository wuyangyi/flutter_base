import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/UserDao.dart';
import 'package:flutter_base/bean/my_coin_desc_info_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/blocs/UserCenterBloc.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/finish_user_info/finish_info_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_base/dialog/dialog.dart';

class UserCenterRoute extends BaseListRoute {
  @override
  _UserCenterRouteState createState() => _UserCenterRouteState();
}

class _UserCenterRouteState extends BaseListRouteState<UserCenterRoute, MyCoinDescInfoBeanDataData, UserCenterBloc> {
  final double defaultBgHeight = 250.0;
  double topBgHeight = 250.0; //顶部图片的高度
  UserBeanEntity user;
  double _opacity = 0.0; //顶部名字透明度
  bool isScrollTop = true; //是否在顶部
  List<String> imageBg = ["user_page_top_bg_01", "user_page_top_bg_02", "user_page_top_bg_03"]; //所有可选的背景图片

  _UserCenterRouteState(){
    needAppBar = false;
    showStartCenterLoading = true;
    loadStatus = Status.loading;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener((){
      if (controller.offset < topBgHeight / 2) {
        _opacity = 0.0;
      } else if (controller.offset < topBgHeight) {
        _opacity = (controller.offset - topBgHeight / 2) / (topBgHeight / 2);
      } else {
        _opacity = 1.0;
      }
      isScrollTop = controller.offset <= 0.0;
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context).user;
    if (user?.coinInfo == null) {
      NetClickUtil().getIntegral();
    }
    return super.build(context);
  }

  @override
  Widget buildListBody(BuildContext context, {Widget child, itemBuilder}) {
    return StreamBuilder(
        stream: bloc.subjectStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          onLoadSuccess(snapshot.data, snapshot.hasError);
          return buildBody(context,
            body: GestureDetector(
              child: CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    centerTitle: true,
                    expandedHeight: topBgHeight,
                    title: Opacity(
                      opacity: _opacity,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15.0),
                        child: Text(
                          user?.name ?? "个人中心",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),

                      ),
                    ),
                    leading: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 15.0),
                      child: IconButton(
                        icon: Image.asset(Util.getImgPath(titleBarBg == Colors.white ? "icon_back_black" : "icon_back_white"), height: 20.0,),
                        onPressed: (){
                          onLeftButtonClick();
                        },
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 15.0),
                          child: Image.asset(Util.getImgPath("ico_redact_info"), width: 17.0, height: 17.0,),
                        ),
                        onPressed: (){
                          NavigatorUtil.pushPageByRoute(bodyContext, FinishInfoRoute(false), isNeedCloseRoute: false);
                        },
                      )
                    ],
                    backgroundColor: MyColors.main_color,
                    flexibleSpace: FlexibleSpaceBar(
                      background: GestureDetector(
                        onLongPress: () async {
                          int index = await showModalBottomSheetUtil(context, UserCenterBgDialog(
                              images:imageBg,
                            ),
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          );
                          if (index != null && index != -1) {
                            if (index < imageBg.length) {
                              user.infoBg = imageBg[index];
                              Application.saveProfile();
                              UserDao().saveData(user);
                              setState(() {});
                            } else {
                              int index = await showModalBottomSheetUtil(context , MySimpleDialog(title: "上传背景", items: ["相机", "相册"]));
                              if (index == 0) {
                                _takePhoto();
                              } else if(index == 1) {
                                _openGallery();
                              }
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: user.infoBg.contains("/") ? FileImage(File(user.infoBg)) : AssetImage(Util.getImgPath(user.infoBg)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            //控件里面内容主轴负轴居中显示
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //主轴高度最小
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipOval(
                                // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                                child: user?.logo != null ? Image.file(File(user.logo), width: 60.0, height: 60.0,) : Image.asset(Util.getImgPath(Util.getUserHeadImageName(user?.sex)), width: 60.0, height: 60.0,),
                              ),
                              Gaps.vGap10,
                              Text(
                                user?.name ?? user?.phone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              Gaps.vGap10,
                              Text(
                                ObjectUtil.isEmpty(user.coinInfo) ? "" : "积分：${user.coinInfo.coinCount}   排行：${user.coinInfo.rank}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 80.0,
                    delegate: new SliverChildBuilderDelegate((BuildContext context, int index){
                      return index < mListData.length ? getItemBuilder(context, index) : loadMoreWidget();
                    },
                      childCount: mListData.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget getItemBuilder(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              mListData[index].reason,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: MyColors.title_color,
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Text(
              mListData[index].desc.substring(0, 19),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14.0
              ),
            ),
          ),
          Text(
            "+ ${mListData[index].coinCount}",
            style: TextStyle(
                color: MyColors.main_title_color,
                fontSize: 13.0
            ),
          ),
        ],
      ),
      decoration: Decorations.bottom,
    );
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      user.infoBg = image.path;
      Application.saveProfile();
      UserDao().saveData(user);
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      user.infoBg = image.path;
      Application.saveProfile();
      UserDao().saveData(user);
    });
  }

}
