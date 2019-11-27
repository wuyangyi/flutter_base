import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/bean/FlieInfoBean.dart';
import 'package:flutter_base/bean/userinfo_select.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:rxdart/rxdart.dart';

///dialog样式类

/*
 * 相册选择
 */
class MySimpleDialog extends StatefulWidget {
  final String title;
  final List<String> items;

  const MySimpleDialog({Key key, this.title, this.items}) : super(key: key);
  @override
  _MySimpleDialogState createState() => _MySimpleDialogState();
}

class _MySimpleDialogState extends State<MySimpleDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 43.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            ),
            child: Text(
              widget.title ?? "提示",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.main_title_color,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.main_title_color,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Color(0xFF989898),
                );
              },
              itemCount: widget.items?.length ?? 0,
              itemBuilder: (context, index) {
                bool last = index == (widget.items.length - 1);
                return GestureDetector(
                  child: Container(
                    height: 40.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: last ? Radius.circular(10.0) : Radius.circular(0.0), bottomRight: last ? Radius.circular(10.0) : Radius.circular(0.0))
                    ),
                    child: Text(
                      widget?.items[index] ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop(index);
                  },
                );
              },
            ),
          ),
          GestureDetector(
            child: Container(
              height: 40.0,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Text(
                "取消",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            onTap: (){
              Navigator.of(context).pop(-1);
            },
          ),
        ],
      ),
    );
  }
}



//底部性别年龄学历时间选择
class UserInfoSelectDialog extends StatefulWidget {
  final List<UserInfoSelectBean> list;
  final String title;
  final String desc;
  final int selectIndex;

  const UserInfoSelectDialog({Key key, this.list, this.title, this.desc, this.selectIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserInfoSelectDialogState(list, selectIndex);
  }
}

class _UserInfoSelectDialogState extends State<UserInfoSelectDialog> {
  List<UserInfoSelectBean> _list;
  int _selectIndex;
  static double _offset;
  ScrollController _controller;
  _UserInfoSelectDialogState(List<UserInfoSelectBean> list, int selectIndex) {
    this._list = list;
    _selectIndex = selectIndex == null ? 0 : selectIndex;
    _offset = _getScrollOffset();
    _controller = ScrollController(
      initialScrollOffset: _offset,
      keepScrollOffset: true,
    );
  }


  double _getScrollOffset(){
    if (_list.length <= 4) {
      return 0.0;
    }
    for(int index = 0; index < _list.length; index ++) {
      if (_list[index].selected) {
        if (index >= _list.length - 4) {
          return 51.0 * (_list.length - 4);
        } else {
          return 51.0 * index;
        }
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 37.5, right: 30.0),
            child: Row(
              children: <Widget>[
                Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 20.0,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(-1);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Image.asset(Util.getImgPath("ico_close"), fit: BoxFit.fill, width: 15.0, height: 15.0,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 37.5),
            child: Text(
              widget.desc,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFFA4A5AD),
                fontSize: 12.0,
              ),
            ),
          ),
          Container(
            height: _getListHeight(),
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15.0),
            constraints: BoxConstraints(
              maxHeight: 204.0,
            ),
            child: ListView.builder(
              controller: _controller,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                UserInfoSelectBean  selectBean = _list[index];
                return GestureDetector(
                  onTap: (){
                    for(int i = 0; i < _list.length; i++) {
                      _list[i].selected = i==index;
                    }
                    setState(() {

                    });
                    //延迟100毫秒后关闭
                    Observable.just(1).delay(new Duration(milliseconds: 100)).listen((_) {
                      Navigator.of(context).pop(index);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 51.0,
                    margin: const EdgeInsets.only(left: 37.5, right: 37.5),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(Util.getImgPath(selectBean.selected ? "ico_item_selected" : "ico_item_select"), fit: BoxFit.fill, width: 18.0, height: 18.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            selectBean.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: selectBean.selected ? MyColors.selectColor : MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                        ),

                      ],
                    ),
                    decoration: index == _list.length - 1 ? Decorations.bottomNo : Decorations.bottom,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getListHeight() {
    if(widget.list.length < 4) {
      return widget.list.length * 51.0;
    } else {
      return 204.0;
    }
  }

}


class UserCenterBgDialog extends StatefulWidget {
  final List<String> images;

  const UserCenterBgDialog({Key key, this.images}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserCenterBgDialogState();
  }
}

class _UserCenterBgDialogState extends State<UserCenterBgDialog> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "背景选择",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop(-1);
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(right: 20.0),
                      child: Image.asset(Util.getImgPath("ico_close"), fit: BoxFit.fill, width: 15.0, height: 15.0,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: _getListHeight(),
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15.0),
            constraints: BoxConstraints(
              maxHeight: 345.0,
            ),
            child: ListView.builder(
              itemCount: widget.images.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(index);
                  },
                  child: index < widget.images.length ? Container(
                    width: double.infinity,
                    height: 100.0,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: AssetImage(Util.getImgPath(widget.images[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) : Container(
                    width: double.infinity,
                    height: 100.0,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: MyColors.home_body_bg,
                    ),

                    child: Image.asset(
                      Util.getImgPath("ico_add_blue"),
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getListHeight() {
    if(widget.images.length < 2) {
      return widget.images.length * 115.0;
    } else {
      return 345.0;
    }
  }

}


//账单编辑弹窗
class BookUpDialog extends StatefulWidget {
  @override
  _BookUpDialogState createState() => _BookUpDialogState();
}

class _BookUpDialogState extends State<BookUpDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(left: 25.0,right: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "请选择",
                style: TextStyle(
                  color: MyColors.text_normal_5,
                  fontSize: 14.0,
                  decoration: TextDecoration.none,
                ),
              ),
              Gaps.vGap20,
              InkWellButton(
                text: "编辑账本",
                leftWidget: Icon(Icons.create, color: MyColors.buttonNoSelectColor,),
                onTap: (){
                  Navigator.pop(context, 0);
                },
              ),
              Gaps.vGap10,
              InkWellButton(
                text: "删除账本",
                leftWidget: Icon(Icons.delete_outline, color: MyColors.buttonNoSelectColor,),
                onTap: (){
                  Navigator.pop(context, 1);
                },
              ),
              Gaps.vGap20,
              GestureDetector(
                onTap: (){
                  Navigator.pop(context, -1);
                },
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: MyColors.text_normal_5,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//3d滚动选择
class WheelRollDialog extends StatefulWidget {
  final String centerTitle; //标题
  final List<String> list; //数据列表
  final int selectIndex; //初始选中第几个

  const WheelRollDialog({Key key,
    this.centerTitle = "请选择",
    this.list,
    this.selectIndex = 0,
  }) : super(key: key);

  @override
  _WheelRollDialogState createState() => _WheelRollDialogState(selectIndex);
}

class _WheelRollDialogState extends State<WheelRollDialog> {
  ScrollController _scrollController;
  _WheelRollDialogState(int selectIndex) {
    _scrollController = new ScrollController(
      initialScrollOffset: selectIndex * itemHeight,
      keepScrollOffset: true,
    );
    this.selectIndex = selectIndex;
  }

  bool isScrollEndNotification = false; //滚动结束
  double _startLocation;
  double _endLocation;

  double itemHeight = 40.0; //每个滑动项目的高度
  int selectIndex = 0; //当前选中的位置

  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(width: 0.5, color: MyColors.loginDriverColor), bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context, -1);
                  },
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.main_title_color,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.centerTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context, selectIndex);
                  },
                  child: Text(
                    "确定",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.main_title_color,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
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
                  child: NotificationListener(
                    onNotification: (ScrollNotification notification){
                      if (notification is ScrollStartNotification) {
                        isScrollEndNotification = false;
                        _startLocation = notification.metrics.pixels;
                        print("起始:$_startLocation");
                      }
                      //滚动结束监听
                      if (notification is ScrollEndNotification && !isScrollEndNotification) {
                        _endLocation = notification.metrics.pixels;
                        print("结束:$_endLocation");
                        isScrollEndNotification = true;
                        double differ = _endLocation - _startLocation; //滑动的差距
                        double offset = 0; //相对于起始位置，需要真实滑动的距离
                        if (differ > 0) {
                          offset = (differ.abs() ~/ itemHeight) * itemHeight;
                          if (differ % itemHeight >= itemHeight / 2) {
                            offset += itemHeight;
                          }
                          selectIndex = (_startLocation + offset) ~/ itemHeight; //记录当前位置
                          _scrollController.jumpTo(_startLocation + offset);
                        } else if (differ < 0) {
                          differ = differ.abs();
                          offset = ((differ ~/ itemHeight) * itemHeight);
                          if ((differ % itemHeight) >= (itemHeight / 2)) {
                            offset += itemHeight;
                          }
                          selectIndex = (_startLocation - offset) ~/ itemHeight; //记录当前位置
                          _scrollController.jumpTo(_startLocation - offset);
                        }

                        print("索引:$selectIndex");
                      }

                      return true;
                    },
                    child: ListWheelScrollView(
                      diameterRatio: 1.5,
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemExtent: itemHeight,
                      children: widget.list.map((item){
                        return Container(
                          width: double.infinity,
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
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}



//中间编辑弹窗
class CenterTextFieldDialog extends StatefulWidget {
  final String title;
  final TextInputType inputType;
  final int maxLength;
  final String hintText;
  final int maxLines;
  final String text;

  const CenterTextFieldDialog({Key key,
    this.title,
    this.inputType = TextInputType.text,
    this.maxLength = -1,
    this.hintText = "请输入",
    this.maxLines = 5,
    this.text = "",
  }) : super(key: key);
  @override
  _CenterTextFieldDialogState createState() => _CenterTextFieldDialogState(text);
}

class _CenterTextFieldDialogState extends State<CenterTextFieldDialog> {
  TextEditingController _controller = new TextEditingController();
  _CenterTextFieldDialogState(String text){
    _controller.text = text;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(top: 20.0),
                margin: EdgeInsets.only(left: 25.0,right: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.title ?? "填写信息",
                      style: TextStyle(
                        color: MyColors.text_normal_5,
                        fontSize: 14.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Gaps.vGap20,
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.left,
                        maxLines: widget.maxLines,
                        autofocus: true,
                        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
                        style: TextStyle(
                          color: Color(0xFF363951),
                          fontSize: 14.0,
                        ),
                        scrollPadding: EdgeInsets.all(0.0),
                        keyboardType: widget.inputType,
                        decoration: InputDecoration( //外观样式
                          hintText: widget.hintText,
                          contentPadding: const EdgeInsets.all(15.0),
                          border: InputBorder.none, //去除自带的下划线
                          hintStyle: TextStyle(
                            color: Color(0xFFCBCDD5),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Gaps.vGap15,
                    Container(
                      width: double.infinity,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context, null);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: MyColors.loginDriverColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0)),
                                ),
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                    color: MyColors.text_normal_5,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context, _controller.text);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: MyColors.main_color,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//中间提示弹窗
class CenterHintDialog extends StatelessWidget {
  final String text;

  const CenterHintDialog({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(top: 20.0),
                margin: EdgeInsets.only(left: 25.0,right: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minHeight: 80.0
                      ),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context, null);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: MyColors.loginDriverColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0)),
                                ),
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                    color: MyColors.text_normal_5,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context, 1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: MyColors.main_color,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//音乐列表选择
class MusicListDialog extends StatefulWidget {
  final List<FileInfoBean> list;

  final int selectIndex; //选择的位置

  MusicListDialog({Key key,
    this.list,
    this.selectIndex = 0
  }) : super(key: key);
  @override
  _MusicListDialogState createState() => _MusicListDialogState(selectIndex);
}

class _MusicListDialogState extends State<MusicListDialog> {

  _MusicListDialogState(this.selectIndex);

  int selectIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      constraints: BoxConstraints(
        maxHeight: DataConfig.appSize.height / 2
      ),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 30.0,
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Text("音乐列表",
                  style: TextStyle(
                      color: MyColors.text_normal_1,
                      fontSize: 16.0
                  ),
                ),
                Positioned(
                  right: 0, top: 0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop(-1);
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Image.asset(Util.getImgPath("ico_close"), fit: BoxFit.fill, width: 15.0, height: 15.0,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap20,
          Expanded(
            flex: 1,
            child: ListView.separated(
              itemCount: widget.list.length,
              separatorBuilder: (context, index){
                return Container(
                  width: double.infinity,
                  height: 0.5,
                  color: MyColors.loginDriverColor,
                  margin: EdgeInsets.only(left: 10.0),
                );
              },
              itemBuilder: (context, index){
                return Material(
                  color: Colors.transparent,
                  child: Ink(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          selectIndex = index;
                        });
                        //延迟100毫秒后关闭
                        Observable.just(1).delay(new Duration(milliseconds: 100)).listen((_) {
                          Navigator.of(context).pop(index);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10.0, top: 12.0, bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 30.0,
                              height: 30.0,
                              alignment: Alignment.center,
                              child: widget.list[selectIndex].path == widget.list[index].path ?
                              Icon(Icons.volume_up, color: MyColors.main_color, size: 18.0,) :
                              Text("${index + 1}",
                                style: TextStyle(
                                  color: MyColors.title_color,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Gaps.hGap5,
                            Expanded(
                              flex: 1,
                              child: Text(
                                widget.list[index].fileName,
                                style: TextStyle(
                                  color: widget.list[selectIndex].path == widget.list[index].path ? MyColors.main_color : MyColors.title_color,
                                  fontSize: 15.0,
                                ),
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
          ),
        ],
      ),
    );
  }
}
