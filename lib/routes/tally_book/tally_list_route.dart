import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_list_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/blocs/MyTallyBloc.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_details.dart';
import 'package:flutter_base/routes/tally_book/tally_menu_list.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/DropDownMenu.dart';
import 'package:flutter_base/widgets/editview.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TallyListRoute extends BaseListRoute {
  final BuildContext parentContext;

  TallyListRoute(this.parentContext);
  @override
  _TallyListRouteState createState() => _TallyListRouteState();
}

class _TallyListRouteState extends BaseListRouteState<TallyListRoute, MyTallyBeanEntity, MyTallyBloc> {
  TextEditingController textEditingController = new TextEditingController();

  _TallyListRouteState(){
    bodyColor = MyColors.home_bg;
    title = "账单列表";
    appBarElevation = 0.0;
//    titleBarBg = Colors.white;
//    titleColor = MyColors.title_color;
//    statusTextDarkColor = false;
    showStartCenterLoading = false;
    resizeToAvoidBottomInset = false;
    leading = Container();
    enableEmptyClick = false;
  }

  List<MenuBean> menuBeans = [];
  List<MyBookBeanEntity> books;
  BookModel bookModel;

  @override
  void initState() {
    super.initState();
    bookModel = Provider.of<BookModel>(context, listen: false);
    books = bookModel.books;
    initMenu();
    getData();
    bus.on(EventBusString.TALLY_LOADING, (need){
      print("账单页面刷新  $loadStatus");
      doRefresh();
    });
  }

  void getData() async {
    await MyBookDao().findAllData(user.id, callBack: (data) async {
      bookModel.clearAll();
      bookModel.addAll(data);
      if (DataConfig.selectBookIndex > books.length) {
        selectBookIndex = DataConfig.selectBookIndex = 0;
      }
      initMenu();
      setState(() {
        loadStatus = Status.success;
      });
    }).catchError((_){
      setState(() {
        bookModel.addAll([]);
        initMenu();
        loadStatus = Status.empty;
      });
    });
  }

  int selectBookIndex = 0;

  initMenu() {
    menuBeans = [
      new MenuBean(title:"账本选择", dropListWidget: TallyMenuBook(
        onItemTap: (index){
          selectBookIndex = index;
          doCloseMenu();
          doRefresh();
        },
      ),),
      new MenuBean(title:"日期选择", dropListWidget: TallyMenuTime(
        onItemTap: (sure) {
          doCloseMenu();
          if (sure) { //做刷新请求
            doRefresh();
          }
        },
      ),),
      new MenuBean(title:"类型选择", dropListWidget: TallyMenuType(
        onItemTap: (){
          doCloseMenu();
          doRefresh();
        },
      ),),
    ];
  }

  //关闭下拉菜单
  void doCloseMenu() {
    bus.emit(EventBusString.CLOSE_MENU, false);
  }

  //做刷新请求
  void doRefresh() {
    Map map = new Map();
    if (DataConfig.selectBookIndex != 0) {
      map["book_id"] = books[DataConfig.selectBookIndex - 1].id;
    }
    if (DataConfig.selectDay != "不限") {
      map["time"] = "${DataConfig.selectYear}-${DataConfig.selectMonth}-${DataConfig.selectDay}";
    } else {
      if (DataConfig.selectYear != "不限") {
        map["year"] = int.parse(DataConfig.selectYear);
      }
      if (DataConfig.selectMonth != "不限") {
        map["month"] = int.parse(DataConfig.selectMonth);
      }
    }
    if (DataConfig.selectType != "不限") {
      map["type"] = DataConfig.selectType;
    }
    showStartCenterLoading = false; //不需要中间加载失败的为空错误
    bloc.initCondition(map);
    refreshController.requestRefresh();
  }

  @override
  Widget buildListBody(BuildContext context, {Widget child,}) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: DropDownMenu(
              menuBean: menuBeans,
              child: SmartRefresher(
                enablePullUp: false,
                enablePullDown: enablePullDown,
                header: WaterDropHeader(
                  refresh: WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                  complete:  WaitDialogProgress(Size(50.0, 25.0), "refresh_icon_header_000", 14),
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                child: child ?? ListView.separated(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: enablePullUp ? mListData.length + 1 : mListData.length,
                  separatorBuilder: (context, index) {
                    return getListDriver(context, index);
                  },
                  itemBuilder: (context, index) {
                    return getItemView(context, index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget getListDriver(BuildContext context, int index) {
    return Container(
      width: double.infinity,
      height: 0.5,
      margin: EdgeInsets.only(left: 15.0),
      color: MyColors.loginDriverColor,
    );
  }

  @override
  Widget getItemBuilder(BuildContext context, int index) {
    MyTallyBeanEntity item = mListData[index];
    MyBookBeanEntity myBookBean;
    books.forEach((book){
      if (book.id == item.bookId) {
        myBookBean = book;
      }
    });
    BookItemBean bookItemBean = Util.getBookItemBean(item.useType, item.type, myBookBean?.type);
    return Ink(
      color: Colors.white,
      child: InkWell(
        onTap: (){
          NavigatorUtil.pushPageByRoute(widget.parentContext, TallyDetailsRoute(item,));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(width: 1.0, color: bookItemBean?.color)
                ),
                child: Icon(
                  bookItemBean?.icon,
                  color: bookItemBean?.color,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${item.useType}  ${item.money}",
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 15.0,
                      ),
                    ),
                    Offstage(
                      offstage: item.comment == null || item.comment.isEmpty,
                      child: Gaps.vGap5,
                    ),
                    Offstage(
                      offstage: item.comment == null || item.comment.isEmpty,
                      child: Text(
                        "${item.comment}",
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.text_normal_5,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.TALLY_LOADING);
  }

}