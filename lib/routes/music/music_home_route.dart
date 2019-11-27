import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/music/home_menu_item_bean.dart';
import 'package:flutter_base/bean/music/recommend_bean_entity.dart';
import 'package:flutter_base/blocs/MusicRecommendBloc.dart';
import 'package:flutter_base/blocs/MusicSingerBloc.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/music/search_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'MyCollectRoute.dart';
import 'music_base_route.dart';
import 'music_singer_route.dart';
import 'my_music_route.dart';

class MusicHomeRoute extends MusicBaseRoute {
  @override
  _MusicHomeRouteState createState() => _MusicHomeRouteState();
}

class _MusicHomeRouteState extends MusicBaseRouteState<MusicHomeRoute> {

  _MusicHomeRouteState(){
    resizeToAvoidBottomInset = false;
    statusTextDarkColor = true;
    needAppBar = false;
    showStartCenterLoading = true;
  }

  MusicRecommendBloc bloc;

  RecommendBeanData mData;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<HomeMenuItemBean> homeMenuItems = [
    HomeMenuItemBean(
      title: "歌手",
      icon: Icons.keyboard_voice,
      color: Colors.red,
      route: BlocProvider(child: MusicSingerRoute(), bloc: MusicSingerBloc(),)
    ),
    HomeMenuItemBean(
        title: "排行",
        icon: Icons.equalizer,
        color: Colors.cyan,
        route: null
    ),
    HomeMenuItemBean(
        title: "歌单",
        icon: Icons.queue_music,
        color: Colors.indigoAccent,
        route: null
    ),
    HomeMenuItemBean(
        title: "本地",
        icon: Icons.library_music,
        color: Colors.blue,
        route: MyMusicRoute()
    ),

    HomeMenuItemBean(
        title: "收藏",
        icon: Icons.grade,
        color: Colors.redAccent,
        route: MyCollectRoute()
    ),
  ];

  int centerIndex = 0;


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();

  }


  @override
  Future onRefresh() async {
    super.onRefresh();
    bloc.onRefresh(userId: user.id);
    centerIndex = 0;
  }

  /*
   * 加载完成后的回调
   */
  onLoadSuccess(RecommendBeanData data, bool hasError) {
    print("数据:${data == null}");
    if (isRefresh) {
      refreshController.refreshCompleted();
    }
    if (hasError) {
      print("异常onLoadSuccess");
      loadStatus = Status.fail;
    } else {
      if (data == null) {
        if (isRefresh) {
          loadStatus = Status.loading;
        }
      } else {
        if (isRefresh) {
          loadStatus = Status.success;
        }
        mData = data;
      }
    }
    isRefresh = false;
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MusicRecommendBloc>(context);
    if (isFirstInit) {
      isFirstInit = false;
      Observable.just(1).delay(new Duration(seconds: 1)).listen((_) {
        onRefresh();
      });
    }
    return StreamBuilder(
      stream: bloc.subjectStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        onLoadSuccess(snapshot.data, snapshot.hasError);
        print("loadStatus:$loadStatus");
        return buildBody(context,
          body: Column(
            children: <Widget>[
              AppStatusBar(
                color: Colors.white,
                buildContext: context,
              ),
              GestureDetector(
                onTap: (){
                  NavigatorUtil.pushPageByRoute(context, MusicSearchRoute());
                },
                child: Container(
                  width: double.infinity,
                  height: 30.0,
                  margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                    color: MyColors.search_bg_color,
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        alignment: Alignment.center,
                        child: Image.asset(
                          Util.getImgPath("ico_search_gray"),
                          width: 13.0,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "快来搜搜你喜欢的歌吧~",
                          style: TextStyle(
                            color: MyColors.search_hint_color,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SmartRefresher(
                  enablePullUp: false,
                  enablePullDown: true,
                  header: WaterDropHeader(
                    refresh: WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                    complete:  WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                  ),
                  controller: refreshController,
                  onRefresh: onRefresh,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16.0 / 5.9,
                        child: Swiper(
                          indicatorAlignment: AlignmentDirectional.bottomCenter,
                          circular: true,
                          speed: 800,
                          interval: const Duration(seconds: 5),
                          indicator: CircleSwiperIndicator(),
                          children: mData?.slider == null ? [ProgressView()] : mData?.slider?.map((model) {
                            return new InkWell(
                              onTap: () {

                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: ClipRRect(
                                  child: new Image.network(
                                    model.picUrl,
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          })?.toList(),
                        ),
                      ),

                      //歌手 排行 歌单
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: homeMenuItems.map((item){
                            return Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  if (item.route != null) {
                                    NavigatorUtil.pushPageByRoute(context, item.route);
                                  } else {
                                    showToast("正在建设中，先听听本地音乐吧~");
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 38.0,
                                        height: 38.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: item.color,
                                          borderRadius: BorderRadius.circular(360),
//                                          border: Border.all(width: 1.0, color: item.color),
                                        ),
                                        child: Icon(
                                          item.icon,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          color: MyColors.title_color,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 20.0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: mData?.radioList == null ? [Container()] :
                          mData.radioList.map((item){
                            centerIndex++;
                            return Expanded(
                              flex: 1,
                              child: Container(
                                height: 75.0,
                                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                                padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                                decoration: BoxDecoration(
                                  color: DataConfig.myBookColors[centerIndex % 2][0],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        item.picUrl,
                                        width: 45.0,
                                      ),
                                    ),
                                    Gaps.hGap5,
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.ftitle,
                                          maxLines: 2,
                                          textDirection: TextDirection.ltr,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "推荐歌单",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: MyColors.title_color,
                          ),
                        ),
                      ),

                      GridView.builder(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 10.0,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mData?.songList?.length ?? 0,
                        itemBuilder: (context, index){
                          return Column(
                            children: <Widget>[
                              Container(
                                width: (MediaQuery.of(context).size.width - 40) / 3,
                                height: (MediaQuery.of(context).size.width - 40) / 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        mData?.songList[index]?.picUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        left: 5.0,
                                        bottom: 5.0,
                                        right: 5.0,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.hearing,
                                              color: Colors.white,
                                              size: 12.0,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 3.0, right: 5.0),
                                                child: Text(
                                                  "${getNumber(mData?.songList[index]?.accessnum ?? 0)}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.play_circle_filled,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Gaps.vGap5,
                              Expanded(
                                flex: 1,
                                child: Text(
                                  mData?.songList[index]?.songListDesc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: MyColors.title_color,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getNumber(int num) {
    String text = "";
    if (num < 1000) {
      text = "$num";
    } else {
      text = "${(num / 10000).toStringAsFixed(1)}万";
    }
    return text;
  }
}
