import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/book_type_bean.dart';
import 'package:flutter_base/bean/dao/MyTallyDao.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/bean/my_tally_bean_entity.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/system/MyTextFild.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/key_board/CustomKoard.dart';
import 'package:flutter_base/widgets/key_board/KeyDownEvent.dart';
import 'package:provider/provider.dart';

class AddTallyRoute extends BaseRoute {
  final MyTallyBeanEntity myTallyBean;
  final BuildContext oldContext;

  AddTallyRoute({this.oldContext, this.myTallyBean});
  @override
  _AddTallyRouteState createState() => _AddTallyRouteState(myTallyBean);
}

class _AddTallyRouteState extends BaseRouteState<AddTallyRoute> {
  MyTallyBeanEntity myTallyBean;

  _AddTallyRouteState(this.myTallyBean){
    appBarElevation = 0.0;
    isUpdateTally = myTallyBean != null;
  }
  TallyModel tallyModel;
  List<MyBookBeanEntity> books;
  bool isUpdateTally = false; //是否是修改

  int selectBookIndex = 0;
  bool enableTitleClick;
  List<String> listBook = [];
  bool isPay = true; //是否是支出
  BookTypeBean bookTypeBean; //当前选中的账本类型

  bool showKeyBoard = true; //是否显示软键盘
  bool isCanInputOperator = false;
  TextEditingController controller = new TextEditingController();
  String result = ""; //运算结果
  double resultData = 0.00;
  bool isInputOperator = false; //是否输入了运算符
  bool canSeeResult = false; //是否能看结果

  int selectItem = 0; //选中的类别位置

  @override
  void initState() {
    super.initState();
    books = Provider.of<BookModel>(context, listen: false).books;
    tallyModel = Provider.of<TallyModel>(context, listen: false);
    enableTitleClick = books != null && books.length > 1;
    if (isUpdateTally) {
      for(int i = 0; i < books.length; i++) {
        if (books[i].id == myTallyBean.id) {
          selectBookIndex = i;
        }
      }
      isPay = myTallyBean.type == "支出";
      controller.text = "${myTallyBean.money.abs()}";
    }
    books.forEach((item){
      listBook.add(item.name);
    });
    initBookType();
    if (isUpdateTally && bookTypeBean != null) {
      if(isPay) {
        for (int i = 0; i < bookTypeBean.pay.length; i++) {
          if (myTallyBean.useType == bookTypeBean.pay[i].name) {
            selectItem = i;
          }
        }
      } else {
        for (int i = 0; i < bookTypeBean.income.length; i++) {
          if (myTallyBean.useType == bookTypeBean.income[i].name) {
            selectItem = i;
          }
        }
      }
    }
    controller.addListener((){
      String value = controller.text;
      if (value.isEmpty) {
        return;
      }
      if (value.endsWith(" ") || value.endsWith("+") || value.endsWith("-")) {
        isCanInputOperator = false;
      } else {
        isCanInputOperator = true;
      }
      isInputOperator = value.contains("+") || value.contains("-");
      canSeeResult = isInputOperator && value.isNotEmpty;
      if (canSeeResult) {
        //进行运算
        doOperation(value);
      } else if (!isInputOperator) {
        resultData = double.parse(value);
        result = "$resultData";
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  /*
   * 进行计算
   */
  void doOperation(String value) {
    if (!isCanInputOperator) {
      value = value.substring(0, value.length - 3);
    }
    print("value:$value");
    if (value.contains("+") || value.contains("-")) {
      List<String> list = value.split(" ");
      print("数组长度：${list.length}");
      resultData = double.parse(list[0]);
      for (int i = 1; i < list.length; i++) {
        if (i % 2 > 0) {
          print("运算符：${list[i]}");
          print("数据：${list[i + 1]}");
          if (list[i] == "+") {
            resultData = resultData + double.parse(list[i + 1]);
          } else if (list[i] == "-") {
            resultData = resultData - double.parse(list[i + 1]);
          }
        }
      }
    } else {
      resultData = double.parse(value);
    }
    print("结果：$resultData");
    result = "$resultData";
  }

  void _onKeyDown(KeyDownEvent data) async {
    print("键盘：${data.key}");
    if (data.key == "ok") {
      print("钱：$resultData");
      showWaitDialog();
      DateTime nowTime = DateTime.now();
      if (isPay) {
        books[selectBookIndex].pay += -resultData;
      } else {
        books[selectBookIndex].income += resultData;
      }

      bus.emit(EventBusString.TALLY_LOADING, true); //通知账单刷新
      int myId = -1;
      if (isUpdateTally) {
        myId = myTallyBean?.id;
      }
      myTallyBean = MyTallyBeanEntity(
        useType: isPay ? bookTypeBean.pay[selectItem].name : bookTypeBean.income[selectItem].name,
        address: user.address,
        money: isPay ? -resultData : resultData,
        userId: user.id,
        comment: data.desc,
        bookId: books[selectBookIndex].id,
        time: "${data.time.year}-${data.time.month}-${data.time.day}",
        type: isPay ? "支出" : "收入",
        year: data.time.year,
        month: data.time.month,
        day: data.time.day,
      );
      int id = await MyTallyDao().saveData(myTallyBean);
      if(myId == -1) {
        myTallyBean.id = id;
        if (data.time.year == nowTime.year && data.time.month == nowTime.month) { //本月
          tallyModel.add(myTallyBean);
        }
        showToast("添加成功");
      } else {
        myTallyBean.id = myId;
        tallyModel.update(myTallyBean);
        showToast("修改成功");
        if (widget.oldContext != null) {
          Navigator.pop(widget.oldContext);
        }
      }
      hideWaitDialog();
      finish();
    } else if (data.isDelete()) {
      if (controller.text.isNotEmpty) {
        if (controller.text.endsWith(" ")) {
          controller.text = controller.text.substring(0, controller.text.length - 3);
        } else {
          controller.text = controller.text.substring(0, controller.text.length - 1);
        }
      }
    } else if (data.key == '+' || data.key == '-') {
      if (isCanInputOperator) {
        controller.text += " ${data.key} ";
      }
    } else if(data.key == "hide") {
      setState(() {
        showKeyBoard = false;
      });
    } else {
      controller.text += data.key;
    }
  }

  //初始化账本类型
  void initBookType() {
    DataConfig.bookTypes.forEach((item){
      if (item.title == books[selectBookIndex].type) {
        bookTypeBean = item;
      }
    });
  }

  //初始化
  void init({bool pay}) {
    selectItem = 0;
    controller.text = "";
    isCanInputOperator = false;
    result = ""; //运算结果
    isInputOperator = false; //是否输入了运算符
    canSeeResult = false; //是否能看结果
    if (pay != null) {
      isPay = pay;
    }
    setState(() {
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: DefaultTabController(
                initialIndex: isUpdateTally ? myTallyBean.type == "支出" ? 0 : 1 : 0,
                length: 2,
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: MyColors.main_color,
                  indicatorPadding: EdgeInsets.all(0.0),
                  labelColor: MyColors.main_color,
                  unselectedLabelColor: MyColors.title_color,
                  onTap: (index){
                    init(pay: index == 0);
                  },
                  tabs: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text("支出"),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text("收入"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
              width: double.infinity,
              alignment: Alignment.center,
              color: isPay ? bookTypeBean.pay[selectItem].color : bookTypeBean.income[selectItem].color,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isPay ? bookTypeBean.pay[selectItem].name : bookTypeBean.income[selectItem].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: MyTextField(
                            controller: controller,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: canSeeResult ? 12.0 : 20.0,
                            ),
                            cursorColor: Colors.white,
                            cursorWidth: 2.0,
                            onTap: (){
                              setState(() {
                                showKeyBoard = true;
                              });
                            },
                            decoration: InputDecoration( //外观样式
                              hintText: "0.00",
                              border: InputBorder.none, //去除自带的下划线
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: !canSeeResult,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              result,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 60 / (MediaQuery.of(context).size.width / 5),
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: isPay ? bookTypeBean.pay.length : bookTypeBean.income.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectItem = index;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 40.0,
                          height: 40.0,
                          margin: EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                            border: selectItem == index ? Border.all(width: 1.0, color: isPay ? bookTypeBean.pay[selectItem].color : bookTypeBean.income[selectItem].color) : null,
                            borderRadius: BorderRadius.all(Radius.circular(360.0)),
                          ),
                          child: Icon(
                            isPay ? bookTypeBean.pay[index].icon : bookTypeBean.income[index].icon,
                            color: isPay ? bookTypeBean.pay[index].color : bookTypeBean.income[index].color,
                          ),
                        ),
                        Text(
                          isPay ? bookTypeBean.pay[index].name : bookTypeBean.income[index].name,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: index != selectItem ? MyColors.title_color : isPay ? bookTypeBean.pay[index].color : bookTypeBean.income[index].color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget getBottomNavigationBar() {
    return showKeyBoard ? isUpdateTally ? CustomKeyboard(_onKeyDown, desc: myTallyBean.comment, dateTime: new DateTime(myTallyBean.year, myTallyBean.month, myTallyBean.day),) : CustomKeyboard(_onKeyDown) : null;
  }
  
  @override
  Widget getTitleWidget() {
    return GestureDetector(
      onTap: () async {
        if (enableTitleClick) {
          int index = await showModalBottomSheetUtil(context, WheelRollDialog(
            centerTitle: "账本选择",
            list: listBook,
            selectIndex: selectBookIndex,
          ));
          if (index != null && index != -1) {
            selectBookIndex = index;
            initBookType();
            init(pay: true);
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            books[selectBookIndex].name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          Offstage(
            offstage: !enableTitleClick,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Image.asset(Util.getImgPath("ico_pull_down"), width: 10.0, height: 10.0,),
            ),
          ),
        ],
      ),
    );
  }
}
