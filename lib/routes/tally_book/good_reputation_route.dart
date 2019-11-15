import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';

//五星好评
class GoodReputationRoute extends BaseRoute {
  @override
  _GoodReputationRouteState createState() => _GoodReputationRouteState();
}

class _GoodReputationRouteState extends BaseRouteState<GoodReputationRoute> {
  _GoodReputationRouteState(){
    title = "评价";
    appBarElevation = 0.0;
//    bodyColor = MyColors.home_bg;
  }

  int selectIndex1 = -1;
  int selectIndex2 = -1;
  int selectIndex3 = -1;
  TextEditingController _editingController = TextEditingController();

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
            width: double.infinity,
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors.main_color,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150.0), bottomRight: Radius.circular(150.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.8,
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.circular(360.0)
                  ),
                  child: ClipOval(
                    child: Image.asset(Util.getImgPath("ic_book"), fit: BoxFit.cover,),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "小小记账本",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: Text(
              "您的好评就是我们的动力，请认真对待哦~",
              style: TextStyle(
                color: MyColors.text_normal,
                fontSize: 13.0,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
            child: GoodInput(
              leftText: "服务态度",
              onTap: (index){
                setState(() {
                  selectIndex1 = index;
                });
              },
            ),

          ),

          Container(
            margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: GoodInput(
              leftText: "用户体验",
              onTap: (index){
                setState(() {
                  selectIndex2 = index;
                });
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: GoodInput(
              leftText: "功能全面",
              onTap: (index){
                setState(() {
                  selectIndex3 = index;
                });
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            constraints: BoxConstraints(
              minHeight: 80.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: MyColors.main_color, width: 1.0),
            ),
            child: TextField(
              controller: _editingController,
              textAlign: TextAlign.left,
              maxLines: null,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              style: TextStyle(
                color: MyColors.title_color,
                fontSize: 13.0,
              ),
              scrollPadding: EdgeInsets.all(0.0),
              decoration: InputDecoration( //外观样式
                hintText: "我还有话说~",
                contentPadding: const EdgeInsets.all(10.0),
                border: InputBorder.none, //去除自带的下划线
                hintStyle: TextStyle(
                  color: Color(0xFFCBCDD5),
                  fontSize: 13.0,
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
            alignment: Alignment.center,
            child: FinishButton(
              text: "提交评价",
              radios: 5.0,
              enable: selectIndex1 != -1 && selectIndex2 != -1 && selectIndex3 != -1,
              width: 150.0,
              height: 35.0,
              onTop: (){
                showToast("评价成功");
                finish();
              },
            ),
          ),
        ],
      ),
    );
  }
}
