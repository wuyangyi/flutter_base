import 'package:flutter/material.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:provider/provider.dart';


/*
 * 账本选择
 */
class TallyMenuBook extends StatefulWidget {
  final Function onItemTap;

  const TallyMenuBook({Key key,
    this.onItemTap,
  }) : super(key: key);
  @override
  _TallyMenuBookState createState() => _TallyMenuBookState();
}

class _TallyMenuBookState extends State<TallyMenuBook> {

  List<MyBookBeanEntity> books;
  double itemHeight = 50.0;
  bool isMore = false;


  @override
  void initState() {
    super.initState();
    books = Provider.of<BookModel>(context, listen: false).books;
  }
  @override
  Widget build(BuildContext context) {
    if (itemHeight * (books.length + 1) > MediaQuery.of(context).size.height / 2 - 40) {
      isMore = true;
    }
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight:  isMore ? MediaQuery.of(context).size.height / 2 - 40 : double.infinity,
      ),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
            margin: EdgeInsets.only(left: 15.0),
          );
        },
        itemCount: books.length + 1,
        itemBuilder: (context, index) {
          MyBookBeanEntity myBookBeanEntity;
          if (index == 0) {
            myBookBeanEntity = MyBookBeanEntity(name: "全部账单");
          } else {
            myBookBeanEntity = books[index - 1];
          }
          return Material(
            child: Ink(
              child: InkWell(
                onTap: (){
                  setState(() {
                    DataConfig.selectBookIndex = index;
                  });
                  if (widget.onItemTap != null) {
                    widget.onItemTap(index);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: itemHeight,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  padding: EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            myBookBeanEntity?.name,
                            style: TextStyle(
                              color: index == DataConfig.selectBookIndex ? MyColors.main_color : MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: index != DataConfig.selectBookIndex,
                        child: Icon(
                          Icons.done,
                          color: MyColors.main_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*
 * 时间选择
 */
class TallyMenuTime extends StatefulWidget {
  final Function onItemTap;

  TallyMenuTime({Key key,
    this.onItemTap
  }) : super(key: key);
  @override
  _TallyMenuTimeState createState() => _TallyMenuTimeState();
}

class _TallyMenuTimeState extends State<TallyMenuTime> {
  DateTime nowTime = DateTime.now();

  String selectTime; //选中的时间
  List<String> listYears = []; //年 （倒着排列）
  List<String> listMonths = []; //月
  List<String> listDays = []; //日
  int selectYearIndex = 0; //年选择的位置 (默认选择不限)
  int selectMonthIndex = 0; //月选择的位置
  int selectDayIndex = 0; //日选择的位置

  //年
  bool isScrollEndYearNotification = false; //滚动结束
  double _startYearLocation;
  double _endYearLocation;

  //月
  bool isScrollEndMonthNotification = false; //滚动结束
  double _startMonthLocation;
  double _endMonthLocation;

  //日
  bool isScrollEndDayNotification = false; //滚动结束
  double _startDayLocation;
  double _endDayLocation;

  double itemHeight = 40.0; //每个滑动项目的高度
  ScrollController _scrollYearController;
  ScrollController _scrollMonthController;
  ScrollController _scrollDayController;
  @override
  void initState() {
    super.initState();
    startInitSelect();
    initShowTime();
    _scrollYearController = new ScrollController(
      initialScrollOffset: selectYearIndex * itemHeight,
      keepScrollOffset: true,
    );
    _scrollMonthController = new ScrollController(
      initialScrollOffset: selectMonthIndex * itemHeight,
      keepScrollOffset: true,
    );
    _scrollDayController = new ScrollController(
      initialScrollOffset: selectDayIndex * itemHeight,
      keepScrollOffset: true,
    );
  }

  void startInitSelect(){
    initYearList();
    if (DataConfig.selectYear == "不限") {
      selectYearIndex = 0;
    } else {
      selectYearIndex = nowTime.year - int.parse(DataConfig.selectYear) + 1;
    }
    initMonthList();
    for (int i = 0; i < listMonths.length; i++) {
      if (listMonths[i] == DataConfig.selectMonth) {
        selectMonthIndex = i;
      }
    }
    initDayList();
    for (int j = 0; j < listDays.length; j++) {
      if (listDays[j] == DataConfig.selectDay) {
        selectDayIndex = j;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollYearController.dispose();
    _scrollMonthController.dispose();
    _scrollDayController.dispose();
  }

  //初始化显示的时间
  void initShowTime() {
    if (selectYearIndex == 0) {
      selectTime = "全部账单";
    } else {
      if (selectMonthIndex == 0) {
        selectTime = "${listYears[selectYearIndex]}年";
      } else {
        if (selectDayIndex == 0) {
          selectTime = "${listYears[selectYearIndex]}-${listMonths[selectMonthIndex]}";
        } else {
          selectTime = "${listYears[selectYearIndex]}-${listMonths[selectMonthIndex]}-${listDays[selectDayIndex]}";
        }
      }
    }
  }

  //年选择列表初始化(从当前年，到前100年为选择范围)
  void initYearList() {
    listYears.clear();
    listYears.add("不限"); //不限为所有年，月只能选择不限，日也是
    for(int i = 0; i < 100; i++) {
      listYears.add("${nowTime.year - i}");
    }
  }

  //初始化月的选择列表
  void initMonthList() {
    listMonths.clear();
    listMonths.add("不限");
    if (selectYearIndex == 0) {
      return;
    }
    int maxMonth = 12; //最大月数
    if (listYears[selectYearIndex] == "${nowTime.year}") { //当前年为今年
      maxMonth = nowTime.month;
    }
    for(int i = 1; i <= maxMonth; i++) {
      listMonths.add("$i");
    }
    print("月的个数：${listMonths.length}");
    return;
  }

  //初始化日的选择列表
  void initDayList() {
    listDays.clear();
    listDays.add("不限");
    if (selectYearIndex == 0 || selectMonthIndex == 0) {
      return;
    }
    int maxDay = Util.getMaxDay(int.parse(listYears[selectYearIndex]), int.parse(listMonths[selectMonthIndex]));
    //当前年当前月
    if (listYears[selectYearIndex] == "${nowTime.year}" && listMonths[selectMonthIndex] == "${nowTime.month}") {
      maxDay = nowTime.day;
    }
    for (int i = 1; i <= maxDay; i++) {
      listDays.add("$i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
//            margin: EdgeInsets.only(top: 10.0, bottom: 15.0),
            height: 40.0,
            alignment: Alignment.center,
            child: Text(
              selectTime,
              style: TextStyle(
                color: MyColors.title_color,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 150.0,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Color(0x10F1F2F3),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: itemHeight,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(top: BorderSide(width: 1.0, color: MyColors.loginDriverColor), bottom: BorderSide(width: 1.0, color: MyColors.loginDriverColor)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Color(0x10F1F2F3),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 20.0,
                      ),
                      //年
                      Expanded(
                        flex: 1,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification){
                            if (notification is ScrollStartNotification) {
                              isScrollEndYearNotification = false;
                              _startYearLocation = notification.metrics.pixels;
                            }
                            //滚动结束监听
                            if (notification is ScrollEndNotification && !isScrollEndYearNotification) {
                              _endYearLocation = notification.metrics.pixels;
                              isScrollEndYearNotification = true;
                              double differ = _endYearLocation - _startYearLocation; //滑动的差距
                              double offset = 0; //相对于起始位置，需要真实滑动的距离
                              if (differ > 0) {
                                offset = (differ.abs() ~/ itemHeight) * itemHeight;
                                if (differ % itemHeight >= itemHeight / 2) {
                                  offset += itemHeight;
                                }
                                selectYearIndex = (_startYearLocation + offset) ~/ itemHeight; //记录当前位置
                                _scrollYearController.jumpTo(_startYearLocation + offset);
                              } else if (differ < 0) {
                                differ = differ.abs();
                                offset = ((differ ~/ itemHeight) * itemHeight);
                                if ((differ % itemHeight) >= (itemHeight / 2)) {
                                  offset += itemHeight;
                                }
                                selectYearIndex = (_startYearLocation - offset) ~/ itemHeight; //记录当前位置
                                _scrollYearController.jumpTo(_startYearLocation - offset);
                              }
                              setState(() {
                                initMonthList();
                                if (selectMonthIndex >= listMonths.length) {
                                  selectMonthIndex = listMonths.length - 1;
                                  _scrollMonthController.jumpTo(itemHeight * selectMonthIndex);
                                } else if (selectMonthIndex != listMonths.length - 1) {
                                  _scrollMonthController.jumpTo(itemHeight * (selectMonthIndex + 1));
                                  _scrollMonthController.jumpTo(itemHeight * selectMonthIndex);
                                }
                                initDayList();
                                if (selectDayIndex >= listDays.length) {
                                  selectDayIndex = listDays.length - 1;
                                  _scrollDayController.jumpTo(itemHeight * selectDayIndex);
                                } else if (selectDayIndex != listDays.length - 1) {
                                  _scrollDayController.jumpTo(itemHeight * (selectDayIndex + 1));
                                  _scrollDayController.jumpTo(itemHeight * selectDayIndex);
                                }
                                initShowTime();
                              });
                            }

                            return true;
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: ListWheelScrollView(
                                  physics: BouncingScrollPhysics(),
                                  diameterRatio: 1.5,
                                  controller: _scrollYearController,
                                  itemExtent: itemHeight,
                                  children: listYears.map((item){
                                    return Container(
                                      height: itemHeight,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: MyColors.text_normal_5,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "年",
                                    style: TextStyle(
                                      color: MyColors.text_normal_5,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //月
                      Expanded(
                        flex: 1,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification){
                            if (notification is ScrollStartNotification) {
                              isScrollEndMonthNotification = false;
                              _startMonthLocation = notification.metrics.pixels;
                            }
                            //滚动结束监听
                            if (notification is ScrollEndNotification && !isScrollEndMonthNotification) {
                              _endMonthLocation = notification.metrics.pixels;
                              isScrollEndMonthNotification = true;
                              double differ = _endMonthLocation - _startMonthLocation; //滑动的差距
                              double offset = 0; //相对于起始位置，需要真实滑动的距离
                              if (differ > 0) {
                                offset = (differ.abs() ~/ itemHeight) * itemHeight;
                                if (differ % itemHeight >= itemHeight / 2) {
                                  offset += itemHeight;
                                }
                                selectMonthIndex = (_startMonthLocation + offset) ~/ itemHeight; //记录当前位置
                                _scrollMonthController.jumpTo(_startMonthLocation + offset);
                              } else if (differ < 0) {
                                differ = differ.abs();
                                offset = ((differ ~/ itemHeight) * itemHeight);
                                if ((differ % itemHeight) >= (itemHeight / 2)) {
                                  offset += itemHeight;
                                }
                                selectMonthIndex = (_startMonthLocation - offset) ~/ itemHeight; //记录当前位置
                                _scrollMonthController.jumpTo(_startMonthLocation - offset);
                              }
                              setState(() {
                                initDayList();
                                if (selectDayIndex >= listDays.length) {
                                  selectDayIndex = listDays.length - 1;
                                  _scrollDayController.jumpTo(itemHeight * selectDayIndex);
                                } else if (selectDayIndex != listDays.length - 1) {
                                  _scrollDayController.jumpTo(itemHeight * (selectDayIndex + 1));
                                  _scrollDayController.jumpTo(itemHeight * selectDayIndex);
                                }
                                initShowTime();
                              });
                            }
                            return true;
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: ListWheelScrollView(
                                  diameterRatio: 1.5,
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollMonthController,
                                  itemExtent: itemHeight,
                                  clipToSize: true,
                                  children: listMonths.map((item){
                                    return Container(
                                      height: itemHeight,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: MyColors.text_normal_5,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "月",
                                    style: TextStyle(
                                      color: MyColors.text_normal_5,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //日
                      Expanded(
                        flex: 1,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification){
                            if (notification is ScrollStartNotification) {
                              isScrollEndDayNotification = false;
                              _startDayLocation = notification.metrics.pixels;
                            }
                            //滚动结束监听
                            if (notification is ScrollEndNotification && !isScrollEndDayNotification) {
                              _endDayLocation = notification.metrics.pixels;
                              isScrollEndDayNotification = true;
                              double differ = _endDayLocation - _startDayLocation; //滑动的差距
                              double offset = 0; //相对于起始位置，需要真实滑动的距离
                              if (differ > 0) {
                                offset = (differ.abs() ~/ itemHeight) * itemHeight;
                                if (differ % itemHeight >= itemHeight / 2) {
                                  offset += itemHeight;
                                }
                                selectDayIndex = (_startDayLocation + offset) ~/ itemHeight; //记录当前位置
                                _scrollDayController.jumpTo(_startDayLocation + offset);
                              } else if (differ < 0) {
                                differ = differ.abs();
                                offset = ((differ ~/ itemHeight) * itemHeight);
                                if ((differ % itemHeight) >= (itemHeight / 2)) {
                                  offset += itemHeight;
                                }
                                selectDayIndex = (_startDayLocation - offset) ~/ itemHeight; //记录当前位置
                                _scrollDayController.jumpTo(_startDayLocation - offset);
                              }
                              setState(() {
                                initShowTime();
                              });
                            }
                            return true;
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: ListWheelScrollView(
                                  diameterRatio: 1.5,
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollDayController,
                                  itemExtent: itemHeight,
                                  children: listDays.map((item){
                                    return Container(
                                      height: itemHeight,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: MyColors.text_normal_5,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "日",
                                    style: TextStyle(
                                      color: MyColors.text_normal_5,
                                      fontSize: 15.0,
                                    ),
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
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 10.0, right: 10.0),
            width: double.infinity,
            height: 40.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      if (widget.onItemTap != null) {
                        widget.onItemTap(false);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(width: 1.0, color: MyColors.loginDriverColor),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      DataConfig.selectYear = listYears[selectYearIndex];
                      DataConfig.selectMonth = listMonths[selectMonthIndex];
                      DataConfig.selectDay = listDays[selectDayIndex];
                      if (widget.onItemTap != null) {
                        widget.onItemTap(true);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyColors.main_color,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Text(
                        "确定",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



/*
 * 账本选择
 */
class TallyMenuType extends StatefulWidget {
  final Function onItemTap;

  const TallyMenuType({Key key,
    this.onItemTap,
  }) : super(key: key);
  @override
  _TallyMenuTypeState createState() => _TallyMenuTypeState();
}

class _TallyMenuTypeState extends State<TallyMenuType> {

  List<String> typeList = ["不限", "支出", "收入"];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.loginDriverColor,
            margin: EdgeInsets.only(left: 15.0),
          );
        },
        itemCount: typeList.length,
        itemBuilder: (context, index) {
          return Material(
            child: Ink(
              child: InkWell(
                onTap: (){
                  setState(() {
                    DataConfig.selectType = typeList[index];
                  });
                  if (widget.onItemTap != null) {
                    widget.onItemTap();
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  padding: EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            typeList[index],
                            style: TextStyle(
                              color: typeList[index] == DataConfig.selectType ? MyColors.main_color : MyColors.title_color,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: typeList[index] != DataConfig.selectType,
                        child: Icon(
                          Icons.done,
                          color: MyColors.main_color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
