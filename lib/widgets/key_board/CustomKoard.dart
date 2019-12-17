import 'package:flutter/material.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/res/index.dart';

import 'KeyBoardItem.dart';
import 'KeyDownEvent.dart';

/*
 * 自定义键盘
 */
class CustomKeyboard extends StatefulWidget {
  final callBack;
  final DateTime dateTime;
  final String desc;
  CustomKeyboard(this.callBack, {this.dateTime, this.desc});
  @override
  _CustomKeyboardState createState() => _CustomKeyboardState(desc, dateTime);
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String desc; //传过来的备注
  _CustomKeyboardState(this.desc, this.dateTime);

  void onOkKeyDown() {
    widget.callBack(new KeyDownEvent("ok", time: dateTime, desc: "${textEditingController.text}"));
    textEditingController.text = "";
  }

  void onDelKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("del"));
  }

  void onOneKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("1"));
  }

  void onTwoKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("2"));
  }

  void onThreeKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("3"));
  }

  void onFourKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("4"));
  }

  void onFiveKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("5"));
  }

  void onSixKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("6"));
  }

  void onSevenKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("7"));
  }

  void onEightKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("8"));
  }

  void onNineKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("9"));
  }

  void onZeroKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("0"));
  }

  void onAddKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("+"));
  }

  void onSubtractKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("-"));
  }

  void onPointKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("."));
  }

  void onHideKeyDown(BuildContext cont) {
    widget.callBack(new KeyDownEvent("hide"));
  }

  TextEditingController textEditingController = new TextEditingController();
  DateTime dateTime;
  String time;
  @override
  void initState() {
    super.initState();
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    time ="${dateTime.month}.${dateTime.day}";
    textEditingController.text = desc == null ? "" : desc;
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: 240.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40.0,
            color: MyColors.home_bg,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      //定义控件打开时默认选择日期
                      initialDate: dateTime,
                      //定义控件最早可以选择的日期
                      firstDate: DateTime(1900, 1),
                      //定义控件最晚可以选择的日期
                      lastDate: DateTime.now(),);
                    if (date != null) {
                      setState(() {
                        dateTime = date;
                        time = time ="${dateTime.month}.${dateTime.day}";
                      });
                    }
                  },

                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: MyColors.text_normal,
                          size: 16.0,
                        ),
                        Gaps.hGap5,
                        Text(
                          time,
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                  color: MyColors.text_normal,
                  width: 0.5,
                  height: double.infinity,
                ),
                Icon(
                  Icons.border_color,
                  color: MyColors.text_normal,
                  size: 16.0,
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    color: MyColors.home_bg,
                    child: Ink(
                      color: MyColors.home_bg,
                      child: InkWell(
                        onTap: () async {
                          String text = await showCenterDialog(context, CenterTextFieldDialog(
                            title: "账单备注",
                            hintText: "写点备注吧~",
                            text: textEditingController.text,
                          ));
                          if (text != null) {
                            textEditingController.text = text;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          color: MyColors.home_bg,
                          child: TextField(
                            controller: textEditingController,
                            enabled: false,
                            maxLines: 1,
                            style: TextStyle(
                              color: Color(0xFF363951),
                              fontSize: 12.0,
                            ),
                            scrollPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: InputDecoration( //外观样式
                              hintText: "写点备注吧",
                              border: InputBorder.none, //去除自带的下划线
                              hintStyle: TextStyle(
                                color: Color(0xFFCBCDD5),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  color: MyColors.text_normal,
                  width: 0.5,
                  height: double.infinity,
                ),
                GestureDetector(
                  onTap: (){
                    onHideKeyDown(context);
                  },
                  child: Container(
                    width: 50.0,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(Icons.expand_more, color: MyColors.text_normal,),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              KeyboardItem(
                text: "1",
                callBack: (val) => onOneKeyDown(context),
              ),
              KeyboardItem(
                text: "2",
                callBack: (val) => onTwoKeyDown(context),
              ),
              KeyboardItem(
                text: "3",
                callBack: (val) => onThreeKeyDown(context),
              ),
              KeyboardItem(
                text: "+",
                callBack: (val) => onAddKeyDown(context),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              KeyboardItem(
                text: "4",
                callBack: (val) => onFourKeyDown(context),
              ),
              KeyboardItem(
                text: "5",
                callBack: (val) => onFiveKeyDown(context),
              ),
              KeyboardItem(
                text: "6",
                callBack: (val) => onSevenKeyDown(context),
              ),
              KeyboardItem(
                text: "-",
                callBack: (val) => onSubtractKeyDown(context),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      KeyboardItem(
                        text: "7",
                        callBack: (val) => onSevenKeyDown(context),
                      ),
                      KeyboardItem(
                        text: "8",
                        callBack: (val) => onEightKeyDown(context),
                      ),
                      KeyboardItem(
                        text: "9",
                        callBack: (val) => onNineKeyDown(context),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      KeyboardItem(
                        text: ".",
                        callBack: (val) => onPointKeyDown(context),
                      ),
                      KeyboardItem(
                        text: "0",
                        callBack: (val) => onZeroKeyDown(context),
                      ),
                      KeyboardItem(
                        child: Icon(
                          Icons.backspace,
                        ),
                        callBack: (val) => onDelKeyDown(context),
                      ),
                    ],
                  ),
                ],
              ),
              KeyboardItem(
                text: "OK",
                color: Colors.white,
                bgColor: Colors.red,
                textSize: 20.0,
                height: 100.0,
                callBack: (val) => onOkKeyDown(),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
