import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/color.dart';
import 'package:provider/provider.dart';

//选择气泡背景
class SelectChatBgColorRoute extends BaseRoute {
  @override
  _SelectChatBgColorRouteState createState() => _SelectChatBgColorRouteState();
}

class _SelectChatBgColorRouteState extends BaseRouteState<SelectChatBgColorRoute> {

  _SelectChatBgColorRouteState(){
    bodyColor = MyColors.home_bg;
    title = "气泡颜色";
    appBarElevation = 0.0;
    setRightButtonFromIcon(Icons.done);
  }

  UserModel userModel;

  int _selectMyChatBg = 1;
  int _selectRoBotChatBg = 0;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    _selectMyChatBg = user.chatColor;
    _selectRoBotChatBg = user.robotColor;
  }

  @override
  void onRightButtonClick() {
    userModel.setMyChatBg(_selectMyChatBg);
    userModel.setRoBotChatBg(_selectRoBotChatBg);
    finish();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        padding: EdgeInsets.all(0.0),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: DataConfig.myChatColors[_selectMyChatBg][0],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(2.0),
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                )
              ),
              child: Text(
                "我的气泡颜色",
                style: TextStyle(
                  color: MyColors.title_color,
                  fontSize: 14.0
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: DataConfig.myChatColors.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectMyChatBg = index;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: DataConfig.myChatColors[index][0],
                        borderRadius: BorderRadius.circular(8.0),
                        border: _selectMyChatBg == index ? Border.all(width: 2.0, color: MyColors.main_color) : Border.all(width: 0, color: Colors.transparent)
                    ),
                  ),
                );
              },
            ),
          ),

          Center(
            child: Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 30.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: DataConfig.myChatColors[_selectRoBotChatBg][0],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.0),
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  )
              ),
              child: Text(
                "机器人的气泡颜色",
                style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 14.0
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: DataConfig.myChatColors.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectRoBotChatBg = index;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: DataConfig.myChatColors[index][0],
                        borderRadius: BorderRadius.circular(8.0),
                        border: _selectRoBotChatBg == index ? Border.all(width: 2.0, color: MyColors.main_color) : Border.all(width: 0, color: Colors.transparent)
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
