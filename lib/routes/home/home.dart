import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/dao/music/MyLikeMusicDao.dart';
import 'package:flutter_base/bean/dao/music/MyLocalMusicDao.dart';
import 'package:flutter_base/bean/dao/music/PlayMusicInfoDao.dart';
import 'package:flutter_base/bean/dao/run/RunInfoDao.dart';
import 'package:flutter_base/bean/home_app_bean.dart';
import 'package:flutter_base/bean/music/PlayMusicInfo.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/blocs/MainBloc.dart';
import 'package:flutter_base/blocs/MusicRecommendBloc.dart';
import 'package:flutter_base/blocs/UserCenterBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/BookReadHomeRoute.dart';
import 'package:flutter_base/routes/chat/ChatWithRobotRoute.dart';
import 'package:flutter_base/routes/chinese_chess/chinese_chess_home_route.dart';
import 'package:flutter_base/routes/music/music_home_route.dart';
import 'package:flutter_base/routes/run/RunHomeRoute.dart';
import 'package:flutter_base/routes/tally_book/tally_book_home_route.dart';
import 'package:flutter_base/routes/user_center/user_center_route.dart';
import 'package:flutter_base/routes/weather/weather_home_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../about_us_route.dart';
import '../login_route.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomeRoute extends BaseRoute {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends BaseRouteState<HomeRoute> {
  UserBeanEntity user;
  List<HomeAppBean> homeAppBeans = [
    HomeAppBean("记账本", "\"小小记账本，一键记账，给你舒适的理财投资便捷享受！\"", "ic_book", route: BookHomeRoute()),
    HomeAppBean("机器人助手", "\"这是一款智能机器人助手，逗你笑、逗你玩、查资料等等，快来跟你的专属机器人度过琐碎无聊的时间吧~\"", "ic_chat_robot", route: ChatWithRobotRoute()),
    HomeAppBean("天气预报", "\"专业贴心的天气APP，亿万用户的选择，覆盖全国城市天气预报和实时天气。各种天气从容应对，帮你做好生活决策，为你出行保驾护航~\"", "ic_weather", route: WeatherHomeRoute()),
    HomeAppBean("音乐播放器", "\"耳目一新的乐库，新歌速递、权威榜单、精选歌单，你要找的音乐，都在这里，开启欲罢不能的音乐之旅！\"", "ic_music", route: BlocProvider(child: MusicHomeRoute(), bloc: MusicRecommendBloc(),)),
    HomeAppBean("运动计步器", "\"运动轨迹计步工具，无论你是在进行健身散步还是仅仅在做日常运动，都可以用运动计步器来记录你的运动轨迹哦！\"", "ic_run", route: RunHomeRoute()),
    HomeAppBean("中国象棋", "\"在闲余的时光，来和我一起切磋切磋一下棋艺吧，我在里面等你来哦~\"", "ic_chinese_chess", route: ChineseChessHomeRoute()),
    HomeAppBean("精品阅读", "\"热门小说电子书阅读神器，热门小说尽在其中，全部畅看，种类广泛，畅销好书，应有尽有，快来和我一起尽情阅读吧~\"", "ic_reed_book", route: BookReadHomeRoute()),
//    HomeAppBean("备忘录", "\"一款界面优美、操作便捷的备忘录应用，可以让你每时每刻记录下每一天的好心情，让昨天的回忆变成今天的记忆！\"", "ic_notepad"),
    HomeAppBean("更多功能", "\"不断完善是我的理念，让我们一起期待更多新的功能哟~\"", "ic_more_app"),
  ];
  PageController _pageController = new PageController(
    /**视图比例**/
    viewportFraction: 0.82,
  );

  LocalMusicModel localMusicModel;
  PlayMusicInfoModel playMusicInfoModel;
  MyLikeMusicModel myLikeMusicModel;
  RunWeekModel runWeekModel;

  _HomeRouteState(){
    needAppBar = true;
    title = AppConfig.APP_NAME;
    titleBarBg = MyColors.main_color;
    bodyColor = MyColors.home_body_bg;
    appBarElevation = 0.0;
    leading = Container();
    setRightButtonFromIcon(Icons.share);
  }
  
  @override
  void onRightButtonClick() {
    Share.share(AppConfig.SHARE_TITLE);
  }

  @override
  void initState() {
    super.initState();
    Util.setTransAppBarDark(); //设置沉浸式状态栏 字体为黑色
    user = Provider.of<UserModel>(context, listen: false).user;
    localMusicModel = Provider.of<LocalMusicModel>(context, listen: false);
    playMusicInfoModel = Provider.of<PlayMusicInfoModel>(context, listen: false);
    myLikeMusicModel = Provider.of<MyLikeMusicModel>(context, listen: false);
    runWeekModel = Provider.of<RunWeekModel>(context, listen: false);

    initData();
  }

  void initData() async {
    showWaitDialog();
    await NetClickUtil().login(user.phone, user.password, callBack: (){
      NetClickUtil().getIntegral(); //获得用户积分
    }); //更新下cookie，防止很久前登陆的，cookie过期

    //获取本地歌曲
    await MyLocalMusicDao().findAllData(callBack: (data){
      localMusicModel.addAll(data);
      playMusicInfoModel.setMusicList(data);
    });

    //获取当前播放的音乐
    await PlayMusicInfoDao().findFirstData(callBack: (data){
      if (data == null){
        data = new PlayMusicInfo(
          isPlaying: false,
        );
      } else {
        data.isPlaying = false;
      }
      playMusicInfoModel.setMusicInfo(data);
      playMusicInfoModel.initPlay(); //添加监听
    });

    //获取收藏的音乐
    await MyLikeMusicDao().findAllData(callBack: (data){
      myLikeMusicModel.addAll(data);
    });

    //获取本周运动数据
    await RunInfoDao().findDataByWeek(user.id, onCallBack: (data){
      runWeekModel.addAll(data);
    });

    //获取用户全部运动数据
    await RunInfoDao().findData(user.id, onCallBack: (data){
      runWeekModel.addAllToAll(data);
    });
    hideWaitDialog();
  }

  @override
  Widget build(BuildContext context) {
    buildLeftButton();
    return buildBody(context, body: Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              children: homeAppBeans.map((homeBean){
                return getPageView(homeBean);
              }).toList(),
            ),
          ),
        ],
      ),
    ),);
  }

  //首页pageview子页面
  Widget getPageView(HomeAppBean homeBean) {
    return GestureDetector(
      onTap: () async {
        if (homeBean.route == null) {
          showToast("敬请期待");
        } else {
          NavigatorUtil.pushPageByRoute(context, homeBean.route);
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        decoration: BoxDecoration(
          color: MyColors.citySelectColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 150.0,
              padding: EdgeInsets.only(left: 15.0,right: 15.0,top: 25.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      homeBean.title,
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      homeBean.desc,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                  image: DecorationImage(
                    image: AssetImage(
                      Util.getImgPath(homeBean.logo),
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  //权限申请
//  Future<bool> requestPermission() async {
//    //请求权限
//    Map<PermissionGroup, PermissionStatus> permissions =
//    await PermissionHandler()
//        .requestPermissions([PermissionGroup.location]);
//    //校验权限
//    if(permissions[PermissionGroup.location] != PermissionStatus.granted){
//      return false;
//    }
//    return true;
//
//  }


  //appbar上左边头像
  buildLeftButton() {
    setLeading(GestureDetector(
      onTap: (){
        Scaffold.of(bodyContext).openDrawer();
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: user?.logo != null ? FileImage(File(user.logo)) : AssetImage(Util.getImgPath(getImageName())),
          ),
        ),
      ),
    ));
    setState(() {
    });
  }

  String getImageName() {
    if (user == null && user?.sex == null) {
      return "pic_default_secret";
    }
    if(user.sex == "男") {
      return "pic_default_man";
    } else if (user.sex == "女") {
      return "pic_default_woman";
    } else {
      return "pic_default_secret";
    }
  }

  @override
  Widget getDrawer() {
    return MyDrawer(parentcontext: context,);
  }

}



///抽屉
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
    this.parentcontext
  }) : super(key: key);

  final BuildContext parentcontext;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel value, Widget child) {
        return GestureDetector(
          child: Container(
            width: double.infinity,
            color: MyColors.main_color,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 40, bottom: 20, left: 0.0, right: 0.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipOval(
                        // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                        child: value.user?.logo == null ? Image.asset(Util.getImgPath(
                          Util.getUserHeadImageName(value?.user?.sex),),
                          width: 60.0,
                          height: 60.0,
                        ) : Image.file(File(value.user?.logo), width: 60.0,
                          height: 60.0,),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            value?.user?.name ?? value?.user?.phone ?? "点击登录",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          Offstage(
                            offstage: !value.isLogin,
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Offstage(
                                    offstage: value.user?.sex == null,
                                    child: Image.asset(Util.getImgPath(value.user?.sex == "女" ? "ico_woman_white" : "ico_man_white"), width: 10.0, height: 10.0,),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "${value.user?.age}岁" ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Offstage(
                  offstage: !value.isLogin,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.0, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "    个性签名：${value?.user?.synopsis ?? '这个人很懒，什么都没留下~'}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            NavigatorUtil.pushPageByRoute(context, BlocProvider(child: UserCenterRoute(), bloc: UserCenterBloc(),));
          },
        );
      },
    );
  }


  /// 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text("关于我们"),
              onTap: () {
                NavigatorUtil.pushPageByRoute(context, AboutUsRoute(), isNeedCloseRoute: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.crop_free),
              title: Text("扫一扫"),
              onTap: scan,
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: Text("退出登录"),
              onTap: () async {
                int index = await showCenterDialog(context, CenterHintDialog(text: "您即将退出当前账号，退出后部分功能将无法使用，是否确定退出？",));
                if (index != null && index == 1) {
                  _outLogin(userModel, context);
                }
              },
            ),

          ],
        );
      },
    );
  }

  _outLogin(UserModel userModel, BuildContext context) {
    userModel.outLogin();
    NavigatorUtil.pushPageByRoute(context, LoginRoute(), isNeedCloseRoute: true);
  }

  Future scan() async {
    String barcode = await scanner.scan();
    print("扫描的信息:$barcode");
    if (barcode.startsWith("http")) {
      NavigatorUtil.pushWeb(parentcontext, url: barcode);
    }
  }

}