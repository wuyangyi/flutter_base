import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/dao/MyBookDao.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/tally_book/tally_details.dart';
import 'package:flutter_base/routes/tally_book/tally_list_chart_route.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/line_chart.dart';
import 'package:flutter_base/widgets/pie_peogress_indicator.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';

//图表📈
class ChartRoute extends BaseRoute {

  final BuildContext parentContext;

  ChartRoute(this.parentContext);
  @override
  _ChartRouteState createState() => _ChartRouteState();
}

class _ChartRouteState extends BaseRouteState<ChartRoute> {

  _ChartRouteState(){
    title = "图表";
    appBarElevation = 0.0;
//    showStartCenterLoading = true;
    leading = Container();
  }


  List<MyTallyBeanEntity> myTallyBeans; //全部账单
  List<MyTallyBeanEntity> tallyList = []; //筛选后的账单
  List<BookItemBean> bookItemList = []; //筛选后的账单类别
  List<MyBookBeanEntity> books; //全部账本

  List<PieItemBean> pieItemBeans = [];
  double showCenterMoney = 0.00; //pieItemBeans里面钱的总额  总支出或者总收入等

  String payType = "支出"; //支出、收入
  int year = -1; //年份  //为-1时则为全部年
  int month = -1; //月份

  bool selectLeft = true; //是否选中左边的饼图
  String selectTime = "日"; //折线图横坐标单位

  List<int> yearList = []; //记过账的所有年

  List<LineChartBean> lineCharts = []; //折线图

  @override
  void initState() {
    super.initState();
    getData();
    bus.on(EventBusString.TALLY_LOADING, (need){
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.TALLY_LOADING);
  }

  void getData() async {
    await MyBookDao().findAllData(user.id, callBack: (bookData) {
      books = bookData;
      MyTallyDao().findData(user.id, onCallBack: (data){
        setState(() {
          myTallyBeans = data;
          if (myTallyBeans == null) {
            myTallyBeans = [];
          }
          initChartByTally();
          loadStatus = Status.success;
        });
      });
    });

  }

  //初始化画图数据
  void initChartByTally() {
    List<MyTallyBeanEntity> data = myTallyBeans;
    tallyList.clear();
    bookItemList.clear();
    pieItemBeans.clear();
    showCenterMoney = 0.00;
    yearList.clear();
    lineCharts.clear();
    data.forEach((item){
      if (item.type != payType) {
        return;
      }
      if (year != -1 && year != item.year) {
        return;
      }
      if (year != -1 && month != item.month) {
        return;
      }
      if (!yearHave(item.year)) {
        yearList.add(item.year);
      }
      int time;
      if (selectTime == "年") {
        time = item.year;
      } else if (selectTime == "月") {
        time = item.month;
      } else {
        time = item.day;
      }
      int indexLine = getLineIndex(time);
      if (indexLine == -1) {
        lineCharts.add(new LineChartBean(item.money.abs(), time));
      } else {
        lineCharts[indexLine].money = lineCharts[indexLine].money + item.money.abs();
      }
      tallyList.add(item);
      BookItemBean bookItemBean = Util.getTallyTypeByBookId(item.bookId, books, item.useType, item.type,);
      bookItemList.add(bookItemBean);
      int index = getTypeIndex(item.useType);
      showCenterMoney += item.money;
      if (index == -1) {
        pieItemBeans.add(PieItemBean(bookItemBean.color, item.money / showCenterMoney, title: item.useType, money: item.money, icon: bookItemBean.icon));
      } else {
        pieItemBeans[index].money += item.money;
      }
    });
    //最后计算比例
    pieItemBeans.forEach((pieItemBean){
      pieItemBean.value = pieItemBean.money / showCenterMoney;
    });
  }

  bool yearHave(int y) {
    bool haveYear = false;
    yearList.forEach((item){
      if (item == y) {
        haveYear = true;
      }
    });
    return haveYear;
  }

  //判断当前时间是否已创建
  int getLineIndex(int y) {
    int index = -1;
    for (int i = 0; i < lineCharts.length; i ++) {
      if (lineCharts[i].time == y) {
        index = i;
      }
    }
    return index;
  }


  int getMaxYear() {
    int maxYear = 0;
    yearList.forEach((item){
      if (item > maxYear) {
        maxYear = item;
      }
    });
    return maxYear;
  }

  int getMinYear() {
    int minYear = DateTime.now().year;
    yearList.forEach((item){
      if (item < minYear) {
        minYear = item;
      }
    });
    return minYear;
  }

  //判断当前类别是否拥有 为-1时没有 返回pieItemBeans对应的下标
  int getTypeIndex(String type) {
    for (int i = 0; i < pieItemBeans.length; i++) {
      if (type == pieItemBeans[i].title) {
        return i;
      }
    }
    return -1;
  }

  int getMax(){
    int max = 0;
    if (selectTime == "年") {
      max = getMaxYear();
    } else if (selectTime == "月") {
      max = 12;
    } else if(selectTime == "日") {
      if (year == -1 || month == -1) {
        max = 31;
      } else {
        max = Util.getMaxDay(year, month);
      }
    }
    return max;
  }

  int getMin(){
    int min;
    if (selectTime == "年") {
      min = getMin();
    } else if (selectTime == "月") {
      min = 1;
    } else if(selectTime == "日") {
      min = 1;
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: TabBar(
                isScrollable: true,
                indicatorColor: MyColors.main_color,
                indicatorPadding: EdgeInsets.all(0.0),
                labelColor: MyColors.main_color,
                unselectedLabelColor: MyColors.title_color,
                onTap: (index){
                  setState(() {
                    payType = index == 0 ? "支出" : "收入";
                    initChartByTally();
                  });
                },
                tabs: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text("总支出"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text("总收入"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: tallyList.isNotEmpty && pieItemBeans.isNotEmpty ?
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(0.0),
              itemCount: pieItemBeans.length + 1,
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 0.5,
                  color: MyColors.loginDriverColor,
                );
              },
              itemBuilder: (context, index) {
                return index == 0 ? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 60.0,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectLeft = true;
                                });
                              },
                              child: Container(
                                width: 60.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: selectLeft ? MyColors.main_color : MyColors.text_normal),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "饼图",
                                  style: TextStyle(
                                    color: selectLeft ? MyColors.main_color : MyColors.text_normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectLeft = false;
                                });
                              },
                              child: Container(
                                width: 60.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                                  border: Border.all(width: 0.5, color: selectLeft ? MyColors.text_normal : MyColors.main_color),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "折线图",
                                  style: TextStyle(
                                    color: selectLeft ? MyColors.text_normal : MyColors.main_color,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: selectLeft ? PieProgressIndicator(
                            radius: MediaQuery.of(context).size.width / 5,
                            strokeWidth: 15.0,
                            centerText: "${showCenterMoney.abs().toStringAsFixed(2)}",
                            needHintLabel: true,
                            pieItemBeans: pieItemBeans,
                          ) : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(15.0),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Offstage(
                                      offstage: yearList.length < 2,
                                      child: GestureDetector(
                                        onTap: (){
                                          if (selectTime != "年") {
                                            setState(() {
                                              selectTime = "年";
                                              initChartByTally();
                                            });
                                          }
                                        },
                                        child: Text(
                                          "年",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: selectTime == "年" ? MyColors.main_color : MyColors.title_color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.hGap20,

                                    GestureDetector(
                                      onTap: (){
                                        if (selectTime != "月") {
                                          setState(() {
                                            selectTime = "月";
                                            initChartByTally();
                                          });
                                        }
                                      },
                                      child: Text(
                                        "月",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: selectTime == "月" ? MyColors.main_color : MyColors.title_color,
                                        ),
                                      ),
                                    ),
                                    Gaps.hGap20,

                                    GestureDetector(
                                      onTap: (){
                                        if (selectTime != "日") {
                                          setState(() {
                                            selectTime = "日";
                                            initChartByTally();
                                          });
                                        }
                                      },
                                      child: Text(
                                        "日",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: selectTime == "日" ? MyColors.main_color : MyColors.title_color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: LineChart(
                                  list: lineCharts,
                                  xEnd: getMax(),
                                  xStart: getMin(),
                                  xUnit: selectTime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Ink(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      List<MyTallyBeanEntity> tallys = [];
                      BookItemBean bookItem;
                      tallyList.forEach((tally){
                        if (tally.useType == pieItemBeans[index - 1].title) {
                          tallys.add(tally);
                          bookItem = BookItemBean(pieItemBeans[index - 1].icon, pieItemBeans[index - 1].title, pieItemBeans[index - 1].color);
                        }
                      });
                      NavigatorUtil.pushPageByRoute(widget.parentContext, TallyListChartRoute(tallys, bookItem, bookItem.name));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0, right: 15.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                border: Border.all(width: 1.0, color: pieItemBeans[index - 1]?.color)
                            ),
                            child: Icon(
                              pieItemBeans[index - 1]?.icon,
                              color: pieItemBeans[index - 1]?.color,
                              size: 15.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${pieItemBeans[index - 1].title}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${(pieItemBeans[index - 1].value * 100).abs().toStringAsFixed(1)}%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 15.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${pieItemBeans[index - 1].money.toStringAsFixed(2)}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(Util.getImgPath("ic_arrow_smallgrey"), height: 22.0,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ) : Container(
              alignment: Alignment.center,
              child: StatusView(
                status: Status.empty,
                onTap: (){
                  getData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
