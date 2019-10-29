import 'package:flutter/material.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:flutter_base/blocs/bloc_provider.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'base_route.dart';


///
/// 集成上拉加载，下拉刷新的基类
abstract class BaseListRoute extends BaseRoute {
  const BaseListRoute({Key key}) : super(key: key);
}

abstract class BaseListRouteState<T extends BaseListRoute, D extends BaseBean, B extends BlocListBase> extends BaseRouteState<T> {
  List<D> mListData = [];
  /*
   * 是否需要上拉加载 默认为false
   * 需要重写onLoadMore方法
   * 下拉刷新需要重写onRefresh方法
   */
  bool enablePullUp = false;

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

  /*
   * 是否正在加载更多
   */
  bool isLoadingMore = false;

  B bloc;

  @override
  void initState() {
    super.initState();
    controller.addListener((){
      var position = controller.position;
      //小于10px时触发上拉加载
      if (position.maxScrollExtent - position.pixels <= startLoadMoreHeight && loadMoreStatus == Status.success && !isLoadingMore) {
        onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<B>(context);
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
        return buildListBody(
          context,
          itemBuilder: (context, index) {
            return getItemBuilder(context, index);
          },
        );
      },
    );
  }

  /*
   * 每个item的控件样式
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
  Widget buildListBody(BuildContext context, {Widget child, IndexedWidgetBuilder itemBuilder,}) {
    return buildBody(context,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: MyColors.main_color,
        child: child ?? ListView.builder(
          controller: controller,
          itemCount: mListData.length + 1,
          itemBuilder: (context, index) {
            return index < mListData.length ? itemBuilder(context, index) : loadMoreWidget();
          },
        ),
      ),
    );
  }

  /*
   * 加载更多
   */
  Future onLoadMore() async {
    print("加载更多");
    isLoadingMore = true;
    bloc.onLoadMore();
  }
  @override
  Future onRefresh() async {
    super.onRefresh();
    bloc.onRefresh();
  }

  /*
   * 加载完成后的回调
   */
  onLoadSuccess(List<D> data, bool hasError) {
    if (hasError) {
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
          loadStatus = Status.empty;
        }
      } else {
        loadMoreStatus = Status.success;
        if (isRefresh) {
          loadStatus = Status.success;
        }
      }
    }
    isRefresh = false;
    isLoadingMore = false;
  }

  /*
   * 加载更多组件
   * 可以自己重写
   */
  Widget loadMoreWidget() {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: Color(0xFFf8f8f8),
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


}
