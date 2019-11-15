import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/widgets/button.dart';

class FeedBackRoute extends BaseRoute {
  @override
  _FeedBackRouteState createState() => _FeedBackRouteState();
}

class _FeedBackRouteState extends BaseRouteState<FeedBackRoute> {

  _FeedBackRouteState(){
    title= "意见反馈";
    bodyColor = MyColors.home_bg;
    resizeToAvoidBottomInset = false;
  }

  TextEditingController _editingController = TextEditingController();
  int maxLength = 255; //最大输入长度
  String textLength = "0/255";

  @override
  void initState() {
    super.initState();
    textLength = "0/$maxLength";
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    minHeight: 100.0,
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    controller: _editingController,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    maxLines: null,
                    inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 14.0,
                    ),
                    scrollPadding: EdgeInsets.all(0.0),
                    decoration: InputDecoration( //外观样式
                      hintText: "请简单描述下你遇到的问题哟~",
                      contentPadding: const EdgeInsets.all(0.0),
                      border: InputBorder.none, //去除自带的下划线
                      hintStyle: TextStyle(
                        color: Color(0xFFCBCDD5),
                        fontSize: 14.0,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        textLength = "${value.length}/$maxLength";
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    textLength,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 13.0
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 45.0,
            margin: EdgeInsets.all(30.0),
            child: FinishButton(
              text: "提交反馈",
              enable: _editingController.text.isNotEmpty,
              onTop: (){
                showToast("提交成功");
                finish();
              },
            ),
          ),
        ],
      ),
    );
  }
}
