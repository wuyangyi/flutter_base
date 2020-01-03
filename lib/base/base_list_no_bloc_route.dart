import 'package:flutter/material.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'base_route.dart';


///
/// 集成上拉加载，下拉刷新的基类
abstract class BaseListNoBlocRoute extends BaseRoute {
  const BaseListNoBlocRoute({Key key}) : super(key: key);
}

abstract class BaseListNoBlocRouteState<T extends BaseListNoBlocRoute, D extends BaseBean> extends BaseRouteState<T> {
  List<D> mListData = [];
  /*
   * 是否需要下上拉加载 默认为true
   */
  bool enablePullUp = true;

  /*
   * 是否需要下拉刷新 默认为true
   */
  bool enablePullDown = true;

  /*
   * 滑动组件的控制器
   */
  ScrollController controller = new ScrollController();

  /*
   * 加载更多的状态
   */
  int loadMoreStatus = Status.success;

  /*
   * 是否需要返回顶部按钮, 默认为ture
   */
  bool enableJumpTop = true;

  /*
   * 滑动到底部距离
   * 开始加载更多
   */
  double startLoadMoreHeight = 10.0;

  //头布局
  List<Widget> _headView = [];
  //尾布局
  List<Widget> _floorView = [];

  /*
   * 是否正在加载更多
   */
  bool isLoadingMore = false;


  bool isShowFloatBtn = false; //显示悬浮按钮
  RefreshController refreshController = RefreshController(initialRefresh: false);

  int page = 0;

  //初始化分页
  void initPage() {
    page = 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.addListener((){
        var position = controller.position;
        int offset = position.pixels.toInt();
        //小于10px时触发上拉加载
        if (position.maxScrollExtent - position.pixels <= startLoadMoreHeight && loadMoreStatus == Status.success && !isLoadingMore) {
          onLoadMore();
        }
        if (offset < 100 && isShowFloatBtn) {
          isShowFloatBtn = false;
          setState(() {});
        } else if (offset > 100 && !isShowFloatBtn) {
          isShowFloatBtn = true;
          setState(() {});
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    if (isFirstInit) {
      isFirstInit = false;
      Observable.just(1).delay(new Duration(seconds: 1)).listen((_) {
        onRefresh();
      });
    }
    return buildListBody(
      context,
      child: getListChild(),
    );
  }

  //自己的listView
  Widget getListChild() {
    return null;
  }

  /*
   * 每个item的控件样式(得自己写)
   */
  Widget getItemBuilder(BuildContext context, int index) {
    return Container();
  }

  /*
   * 创建列表内容栏
   * child必须为可滑动组件
   * child和itemBuilder必须有一个不为空
   * 自己写child没有上拉加载功能，需要自己实现
   */
  Widget buildListBody(BuildContext context, {Widget child,}) {
    initHeadOrFloorView();
    return buildBody(context,
      body: SmartRefresher(
        enablePullUp: false,
        enablePullDown: enablePullDown,
        header: WaterDropHeader(
          refresh: WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
          complete:  WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        child: child ?? ListView.separated(
          controller: controller,
          shrinkWrap: true,
          itemCount: enablePullUp ? mListData.length + getHeadCount() + getFloorCount() + 1 : mListData.length + getHeadCount() + getFloorCount(),
          separatorBuilder: (context, index) {
            return getListDriver(context, index);
          },
          itemBuilder: (context, index) {
            return _getItemView(context, index);
          },
        ),
      ),
    );
  }

  Widget _getItemView(BuildContext context, int index) {
    if (index < getHeadCount()) {
      return getHeadOrFloorView(true)[index];
    } else if (index < getHeadCount()+mListData.length) {
      return getItemBuilder(context, index);
    } else if (index < getHeadCount() + mListData.length + getFloorCount()) {
      return getHeadOrFloorView(false)[index-getHeadCount()-mListData.length];
    } else {
      return loadMoreWidget();
    }
  }

  /*
   * 加载更多
   */
  Future onLoadMore() async {
    print("加载更多");
    isLoadingMore = true;
    _initData();
  }
  @override
  Future onRefresh() async {
    super.onRefresh();
    initPage();
    _initData();
  }

  //请求数据处理
  void _initData() async {
    try{
      List<D> list = await getData();
      onLoadSuccess(list, false);
      page++;
    }catch(e){
      onLoadSuccess([], true);
      page--;
    }
  }

  //请求数据
  Future getData();

  /*
   * 加载完成后的回调
   */
  onLoadSuccess(List<D> data, bool hasError) {
    if (isRefresh) {
      refreshController.refreshCompleted();
    }
    if (hasError) {
      print("异常");
      loadMoreStatus = Status.fail;
      if (mListData.isEmpty) {
        loadStatus = Status.fail;
      }
    } else {
      if (data != null && (isLoadingMore || isRefresh)) {
        if (isRefresh) {
          mListData.clear();
        }
        mListData.addAll(data);
      }
      if (data == null) {
        loadMoreStatus = Status.loading;
        if (isRefresh) {
          loadStatus = Status.loading;
        }
      } else if (data.isEmpty) {
        loadMoreStatus = Status.empty;
        if (isRefresh) {
          if (getHeadCount() == 0 && getFloorCount() == 0) {
            loadStatus = Status.empty;
          } else {
            loadStatus = Status.success;
          }
        }
      } else {
        if (data.length < AppConfig.PAGE_LIMIT) {
          loadMoreStatus = Status.empty; //没有更多了
        } else {
          loadMoreStatus = Status.success;
        }
        if (isRefresh) {
          loadStatus = Status.success;
          loadStatus = Status.success;
        }
      }
    }
    isRefresh = false;
    isLoadingMore = false;
    print("loadstatus:$loadStatus");
    setState(() {
    });
  }

  /*
   * 加载更多组件
   * 可以自己重写
   */
  Widget loadMoreWidget() {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: bodyColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Offstage(
            offstage: loadMoreStatus != Status.loading && loadMoreStatus != Status.success,
            child: WaitDialogProgress(Size(25.0, 25.0), "default_grey0", 9),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              getLoadingText(),
            ),
          ),
        ],
      ),
    );
  }

  String getLoadingText() {
    String text = "";
    switch(loadMoreStatus) {
      case Status.loading:
        text = "加载中......";
        break;
      case Status.success:
        text = "加载中......";
        break;
      case Status.empty:
        text = "没有更多了！";
        break;
      case Status.fail:
        text = "加载异常,刷新重试";
        break;
    }
    return text;
  }

  @override
  Widget buildFloatingActionButton() {
    if (controller == null || !isShowFloatBtn || !enableJumpTop) {
      return null;
    }
    return new FloatingActionButton(
        backgroundColor: MyColors.main_color,
//        focusColor: Colors.transparent,
//        foregroundColor: Colors.transparent,
//        hoverColor: Colors.transparent,
//        highlightElevation: 0.0,
//        elevation: 0.0,
        tooltip: "返回顶部",
//        child: Image.asset(Util.getImgPath("scroll_to_top_button"), width: 40.0,),
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          controller.animateTo(0.0,
              duration: new Duration(milliseconds: 300), curve: Curves.linear);
        });
  }

  //每个item的分割线，默认没有
  Widget getListDriver(BuildContext context, int index) {
    return Container(
      width: 0,
      height: 0,
      color: Colors.transparent,
    );
  }

  //初始化头布局和为布局
  void initHeadOrFloorView(){
    if (_headView.isNotEmpty) {
      _headView.clear();
    }
    _headView.addAll(initHeadView());
    if (_floorView.isNotEmpty) {
      _floorView.clear();
    }
    _floorView.addAll(initFloorView());
  }

  //获得头布局或者尾布局控件
  List<Widget> getHeadOrFloorView(bool isHead) {
    if (isHead) {
      return _headView;
    }
    return _floorView;
  }

  //初始化头布局
  List<Widget> initHeadView() {
    return[];
  }

  //初始化尾布局
  List<Widget> initFloorView() {
    return[];
  }

  //头布局个数
  int getHeadCount() {
    return _headView.length;
  }

  //尾布局个数
  int getFloorCount() {
    return _floorView.length;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


}
