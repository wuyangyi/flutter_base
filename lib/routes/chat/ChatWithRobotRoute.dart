import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/chat/chat_info_bean_entity.dart';
import 'package:flutter_base/bean/chat/chat_send_bean_entity.dart';
import 'package:flutter_base/bean/dao/chat/ChatInfoDao.dart';
import 'package:flutter_base/config/data_config.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/image/image_look_route.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/ExpandedWidget.dart';
import 'package:flutter_base/widgets/editview.dart';
//import 'package:amap_location/amap_location.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'ChatCollectRoute.dart';
import 'SelectChatBgColorRoute.dart';

//机器人助手
class ChatWithRobotRoute extends BaseRoute {
  @override
  _ChatWithRobotRouteState createState() => _ChatWithRobotRouteState();
}

class _ChatWithRobotRouteState extends BaseRouteState<ChatWithRobotRoute> {
  static final String ImageText = "/images/send/xiaoxiaogongjuxiang/"; //图片标记(用于机器人确定是图片)
  static final String CardText = "/card/info/send/xiaoxiaogongjuxiang/"; //名片标记(用于机器人确定是名片)

  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = new ScrollController();

  String province = "湖北"; //省
  String city = "武汉"; //城市
  String street = "珞雄路"; //街道

  List<ChatInfoBeanEntity> mData;

  Offset downOffset;

  _ChatWithRobotRouteState() {
    title = "机器人助手";
    appBarElevation = 2;
    bodyColor = Color(0xFFF6F7F8);
  }

  String lastTime;

  bool _showMenu = false; //显示底部的菜单

  bool _textBoardInput = false; //键盘是否输入文字

  int _downIndex = -1;//按下的item
  int _selectMenuIndex = -1; //选中的菜单item

  @override
  void initState() {
    super.initState();
    initLocation();
    initData();
    _focusNode.addListener((){
      if (_focusNode.hasFocus) {
        hideBottomMenu();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      jumpAnimateBottom();
    }
  }


  /*
   * 滑动到最底部
   */
  void jumpBottom() {
    _scrollController.jumpTo(0.0);
  }

  void jumpAnimateBottom() {
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 800), curve: Curves.linearToEaseOut);
  }

  void initData() async {
    await ChatInfoDao().findData(user.id, onCallBack: (data){
      setState(() {
        mData = data;
      });
    });
  }

  void initLocation() async {
//    AMapLocationClient.startup(new AMapLocationOption(
//        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
//
//    //监听坐标实时变换
//    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
//      if (!mounted) return;
//      setState(() {
//        province = loc.province;
//        city = loc.city;
//        street = loc.street;
//      });
//      print("定位信息:$province $city $street");
//    });
//
//    AMapLocationClient.startLocation();
  }

  @override
  void dispose() {
//    AMapLocationClient.shutdown();
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
  }

  //发送消息后刷新并滑动到最底部
  void doSetState() {
    setState(() {
    });
    jumpAnimateBottom();
  }

  void sendMessage(String text, String type) async {
    ChatInfoBeanEntity chatInfoBeanEntity = new ChatInfoBeanEntity(
      isMe: true,
      type: type,
      userId: user.id,
      value: text,
      isRecall: false,
      time: Util.getNowTime(),
      isCollect: false,
    );
    await ChatInfoDao().insertData(chatInfoBeanEntity, onCallBack: (id){
      chatInfoBeanEntity.id = id;
      if (mData == null || mData.isEmpty) {
        mData = [];
        mData.add(chatInfoBeanEntity);
      } else {
        mData.insert(0, chatInfoBeanEntity);
      }
      doSetState();
    });

    if (type == ChatInfoBeanEntity.IMAGE) {
      text = ImageText;
    }

    await NetClickUtil().sendMessage(text, ChatSendBeanPerceptionSelfinfoLocation(
      province: province,
      city: city,
      street: street,
    ), callBack: (chatMessageBeanEntity) async {
      if (chatMessageBeanEntity?.intent?.code != 4000) {
        chatMessageBeanEntity.results.forEach((item) async {
          ChatInfoBeanEntity chat = ChatInfoBeanEntity(
            isMe: false,
            type: item.resultType,
            userId: user.id,
            value: item.resultType == ChatInfoBeanEntity.TEXT ? item.values.text : item.values.url,
            isRecall: false,
            time: Util.getNowTime(),
            isCollect: false,
          );
          await ChatInfoDao().insertData(chat, onCallBack: (id) {
            chat.id = id;
            mData.insert(0, chat);
            doSetState();
          });
        });
      } else {
        ChatInfoBeanEntity chat = new ChatInfoBeanEntity(
          isMe: false,
          type: ChatInfoBeanEntity.TEXT,
          userId: user.id,
          value: "我没听清楚，您可以再说一遍吗？",
          isRecall: false,
          time: Util.getNowTime(),
          isCollect: false,
        );
        await ChatInfoDao().insertData(chat, onCallBack: (id){
          chat.id = id;
          mData.insert(0, chat);
          doSetState();
        });
      }
    });
  }

  //item布局
  Widget getItemWidget(BuildContext context, int index) {
    ChatInfoBeanEntity data = mData[index];
    if (index < mData.length-1) {
      lastTime = mData[index + 1].time;
    } else {
      lastTime = null;
    }
    Widget widgets;
    if (data.isRecall) { //删除了
      widgets = Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
          decoration: BoxDecoration(
            color: MyColors.buttonNoSelectColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            "${user?.name ?? '您'}删除了一条消息",
            style: TextStyle(
                color: Colors.white,
                fontSize: 12.0
            ),
          ),
        ),
      );
    } else {
      if (data.isMe) {
        widgets = Container(
          margin: EdgeInsets.only(left: 10.0),
          alignment: Alignment.topRight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 3.0,),
                  margin: EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          user?.name ?? user?.phone ?? "我",
                          style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 12.0
                          ),
                        ),
                      ),
                      Gaps.vGap5,
                      Align(
                        alignment: Alignment.topRight,
                        child: Listener(
                          onPointerDown: (e){
                            downOffset = e.position;
                            setState(() {
                              _downIndex = index;
                            });
                          },
                          onPointerUp: (e){
                            downOffset = null;
                            setState(() {
                              _downIndex = -1;
                            });
                          },
                          onPointerMove: (e) {
                            if (downOffset == null) {
                              return;
                            }
                            if ((e.position.dx - downOffset.dx).abs() > 5 || (e.position.dy - downOffset.dy).abs() > 5) {
                              downOffset = null;
                              setState(() {
                                _downIndex = -1;
                              });
                            }
                          },
                          child: getSendInfoWidget(data.type, index, data.isMe),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.hGap5,
              ClipOval(
                // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                child: user?.logo == null ? Image.asset(Util.getImgPath(
                  Util.getUserHeadImageName(user?.sex),),
                  width: 45.0,
                  height: 45.0,
                ) : Image.file(File(user?.logo), width: 45.0,
                  height: 45.0,),
              ),
            ],
          ),
        );
      } else {
        widgets = Container(
          margin: EdgeInsets.only(right: 10.0),
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              ClipOval(
                child: Image.asset(Util.getImgPath("ico_chat_robot"),
                  width: 45.0,
                  height: 45.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 3.0,),
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "机器人助手",
                          style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 12.0
                          ),
                        ),
                      ),
                      Gaps.vGap5,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Listener(
                          onPointerDown: (e){
                            downOffset = e.position;
                            setState(() {
                              _downIndex = index;
                            });
                          },
                          onPointerUp: (e){
                            downOffset = null;
                            setState(() {
                              _downIndex = -1;
                            });
                          },
                          onPointerMove: (e) {
                            if (downOffset == null) {
                              return;
                            }
                            if ((e.position.dx - downOffset.dx).abs() > 5 || (e.position.dy - downOffset.dy).abs() > 5) {
                              downOffset = null;
                              setState(() {
                                _downIndex = -1;
                              });
                            }
                          },
                          child: getSendInfoWidget(data.type, index, data.isMe),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
            offstage: getTime(data.time).isEmpty,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.all(10.0),
              child: Text(
                getTime(data.time),
                style: TextStyle(
                    color: MyColors.buttonNoSelectColor,
                    fontSize: 10.0
                ),
              ),
            ),
          ),
          widgets,
        ],
      ),
    );
  }

  //获得具体的发送的信息
  Widget getSendInfoWidget(String type, int index, bool isMe) {
    Widget item;
    ChatInfoBeanEntity data = mData[index];
    switch(type) {
      case ChatInfoBeanEntity.TEXT:
        item = Container(
          decoration: BoxDecoration(
            color: getSendBgColor(isMe, index),
            borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(8.0) : Radius.circular(2.0),
                topRight: isMe ? Radius.circular(2.0) : Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            data.value,
            style: TextStyle(
                color: MyColors.title_color,
                fontSize: 14.0
            ),
          ),
        );
        break;
      case ChatInfoBeanEntity.EMIL:
        item = Image.asset(Util.getImgPath(data.value));
        break;
      case ChatInfoBeanEntity.IMAGE:
        item = Hero(
          tag: "${HeroString.IMAGE_DETIL_HEAD}$index", //唯一标记
          child: Container(
            constraints: BoxConstraints(
              maxWidth: DataConfig.appSize.width / 2,
            ),
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.file(File(data.value),),
            ),
          ),
        );
        break;
      case ChatInfoBeanEntity.CARD:
        item = Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Util.getImgPath("ico_card_bg"),
              ),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user?.name ?? user.phone,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.hGap5,
                  Offstage(
                    offstage: user?.sex == null,
                    child: Image.asset(Util.getImgPath(user?.sex == "女" ? "ico_woman_white" : "ico_man_white"), width: 10.0, height: 10.0,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  ClipOval(
                    // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                    child: user?.logo == null ? Image.asset(Util.getImgPath(
                      Util.getUserHeadImageName(user?.sex),),
                      width: 30.0,
                      height: 30.0,
                    ) : Image.file(File(user?.logo), width: 30.0,
                      height: 30.0,),
                  ),
                ],
              ),
              Gaps.vGap5,
              Text(
                "手机号： ${user?.phone ?? '暂无'}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "年龄： ${user?.age == null ? '未知' : '${user?.age}岁'}" ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "地址信息： ${user?.address ?? "暂无"}" ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Gaps.vGap5,
              Text(
                "简介： ${user?.synopsis ?? "暂无"}" ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        );
        break;
    }
    return GestureDetector(
      onLongPress: () async {
        if(_downIndex != -1) {
          setState(() {
            _downIndex = -1;
            downOffset = null;
          });
          List<String> _list = [mData[index].isCollect ? "取消收藏" : "收藏", "删除"];
          if (type == ChatInfoBeanEntity.TEXT) {
            _list.add("复制");
          }
          int selectIndex = await showModalBottomSheetUtil(context , MySimpleDialog(title: "选择操作", items: _list));
          if (selectIndex == 0) {
            setState(() {
              mData[index].isCollect = !mData[index].isCollect;
            });
            await ChatInfoDao().upUserInfoDate(mData[index]);
            showToast(mData[index].isCollect ? "收藏成功" : "取消收藏成功");
          } else if (selectIndex == 1) {
            setState(() {
              mData[index].isRecall = true;
            });
            await ChatInfoDao().upUserInfoDate(mData[index]);
          } else if (selectIndex == 2) {
            Clipboard.setData(ClipboardData(text: mData[index].value));
            showToast("复制成功");
          }
        }
      },
      onTap: (){
        if (type == ChatInfoBeanEntity.IMAGE) {
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return new FadeTransition(
                opacity: animation,
                child: ImageLookRoute(mData[index].value, index),
              );
            },
          ),);
        }
      },
      child: item,
    );
  }

  //获得当前气泡的背景色
  Color getSendBgColor(bool isMe, int index) {
    if(isMe) {
      return index == _downIndex ? DataConfig.myChatColors[user?.chatColor ?? 1][1] : DataConfig.myChatColors[user?.chatColor ?? 1][0];
    } else {
      return _downIndex == index ? DataConfig.myChatColors[user?.robotColor ?? 0][1] : DataConfig.myChatColors[user?.robotColor ?? 0][0];
    }
  }

  //获得时间
  String getTime(String time) {
    String result = "";
    if (lastTime == null || lastTime.isEmpty) {
      result = getTimeByNow(time);
    } else {
      if (lastTime.substring(0, lastTime.length - 3) != time.substring(0, time.length - 3)) {
        result = getTimeByNow(time);
      }
    }
    return result;
  }

  //通过当前时间确定显示时间
  String getTimeByNow(String time) {
    String result = "";
    DateTime dateTime = DateTime.parse(time);
    DateTime nowTime = DateTime.now();
    if (dateTime.year != nowTime.year) {
      result = time.substring(0, time.length - 3);
    } else if (dateTime.month != nowTime.month) {
      result = time.substring(5, time.length - 3);
    } else if (dateTime.day != nowTime.day) {
      if (nowTime.day - dateTime.day == 1) {
        result = "昨天 " + time.substring(11, time.length - 3);
      } else {
        result = time.substring(5, time.length - 3);
      }
    } else {
      result = time.substring(11, time.length - 3);
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: mData == null ? StatusView(
              status: Status.loading,
            ) : Listener(
              onPointerDown: (e) {
                hideSoftInput();
                if (_selectMenuIndex != -1) {
                  hideBottomMenu();
                }
              },
              child: Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
//                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: mData.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return getItemWidget(context, index);
                  },
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: MyColors.top_bg,
              border: Border(
                  top: BorderSide(width: 0.5, color: MyColors.loginDriverColor),
                  bottom: BorderSide(width: 0.5, color: MyColors.loginDriverColor),
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    showToast("正在建设中~");
                    hideBottomMenu();
                    hideSoftInput();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                    child: Image.asset(Util.getImgPath("ico_chat_voice"), width: 25.0,),
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    constraints: BoxConstraints(
                      minHeight: 35.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF363951),
                        fontSize: 14.0,
                      ),
                      scrollPadding: EdgeInsets.all(0.0),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: InputDecoration( //外观样式
                        hintText: "快来和我玩玩吧~",
                        contentPadding: const EdgeInsets.only(left:5.0, right: 3.0),
                        border: InputBorder.none, //去除自带的下划线
                        hintStyle: TextStyle(
                          color: Color(0xFFCBCDD5),
                          fontSize: 14.0,
                        ),
                      ),
                      onChanged: (value){
                        setState(() {
                          _textBoardInput = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ),
                Gaps.hGap10,
                _textBoardInput ? GestureDetector(
                  onTap: (){
                    if (_textEditingController.text.isEmpty) {
                      return;
                    }
//                    jumpBottom();
                    sendMessage(_textEditingController.text, ChatInfoBeanEntity.TEXT);
                    _textEditingController.clear();
                    setState(() {
                      _textBoardInput = false;
                    });
                  },
                  child: Container(
                    height: 25.0,
                    width: 55.0,
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColors.main_color,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Text(
                      "发送",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0
                      ),
                    ),
                  ),
                ) : Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hideSoftInput();
                        if (_selectMenuIndex == 0) {
                          hideBottomMenu();
                        } else {
                          jumpAnimateBottom();
                          showBottomMenu(0);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Image.asset(Util.getImgPath(_selectMenuIndex == 0 ? "ico_chat_yes_emil" : "ico_chat_no_emil"), width: 25.0,),
                      ),
                    ),
                    Gaps.hGap10,
                    GestureDetector(
                      onTap: (){
                        hideSoftInput();
                        if (_selectMenuIndex == 1) {
                          hideBottomMenu();
                        } else {
                          jumpAnimateBottom();
                          showBottomMenu(1);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Image.asset(Util.getImgPath(_selectMenuIndex == 1 ? "ico_chat_more_yes" : "ico_chat_more"), width: 25.0,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExpansionLayout(
            isExpanded: _showMenu,
            alignment: Alignment.topCenter,
            children: <Widget>[
              menuWidget,
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _listMenu;
  Widget menuWidget;
  List<MenuItemBean> _moreMenuItemBean;

  /*
   * 显示底部菜单
   */
  void showBottomMenu(int index) {
    if (_moreMenuItemBean == null || _moreMenuItemBean.isEmpty) {
      initMoreMenuBean();
    }
    if (_listMenu == null || _listMenu.isEmpty) {
      initListMenu();
    }
    setState(() {
      menuWidget = _listMenu[index];
      _showMenu = true;
      _selectMenuIndex = index;
    });
  }

  /*
   * 隐藏底部菜单
   */
  void hideBottomMenu() {
    setState(() {
      _showMenu = false;
      _selectMenuIndex = -1;
    });
  }

  void initListMenu() {
    _listMenu = [
      Container(
        width: double.infinity,
        height: 250,
        color: MyColors.top_bg,
        child: GridView.builder(
          padding: EdgeInsets.all(5.0),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 35,
          itemBuilder: (context, index){
            return Center(
              child: GestureDetector(
                onTap: () {
                  sendMessage("emil/ee_${index+1}", ChatInfoBeanEntity.EMIL);
                },
                child: Image.asset(Util.getImgPath("emil/ee_${index+1}"),
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
      ),
      Container(
        width: double.infinity,
        height: 250,
        alignment: Alignment.center,
        color: MyColors.top_bg,
        child: GridView.builder(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 3 / 4,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: _moreMenuItemBean.length,
          itemBuilder: (context, index){
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (_moreMenuItemBean[index].onTap != null) {
                    _moreMenuItemBean[index].onTap();
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: (DataConfig.appSize.width - 100) / 4 - 10.0,
                      height: (DataConfig.appSize.width - 100) / 4 - 10.0,
                      margin: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Icon(
                        _moreMenuItemBean[index].iconData,
                        size: 26.0,
                      ),
                    ),
                    Text(
                      _moreMenuItemBean[index].text,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 10.0
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  //更多菜单初始化
  void initMoreMenuBean() {
    _moreMenuItemBean = [
      MenuItemBean(
        iconData: Icons.photo,
        text: "相册",
        onTap: (){
          _openGallery();
        }
      ),
      MenuItemBean(
        iconData: Icons.photo_camera,
        text: "相机",
        onTap: (){
          _takePhoto();
        }
      ),
      MenuItemBean(
          iconData: Icons.person,
          text: "发送名片",
          onTap: (){
            sendMessage(CardText, ChatInfoBeanEntity.CARD);
          }
      ),
      MenuItemBean(
          iconData: Icons.bookmark,
          text: "我的收藏",
          onTap: (){
            List<ChatInfoBeanEntity> d = [];
            mData.forEach((items){
              if (items.isCollect) {
                d.add(items);
              }
            });
            NavigatorUtil.pushPageByRoute(context, ChatCollectRoute(d));
          }
      ),
      MenuItemBean(
          iconData: Icons.question_answer,
          text: "气泡",
          onTap: (){
            NavigatorUtil.pushPageByRoute(context, SelectChatBgColorRoute());
          }
      ),

      MenuItemBean(
          iconData: Icons.folder,
          text: "文件(待)",
          onTap: (){
            showToast("正在建设中~");
          }
      ),
      MenuItemBean(
          iconData: Icons.location_on,
          text: "位置(待)",
          onTap: (){
            showToast("正在建设中~");
          }
      ),
      MenuItemBean(
          iconData: Icons.settings_voice,
          text: "语音(待)",
          onTap: (){
            showToast("正在建设中~");
          }
      ),
    ];
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null && image.path != null) {
      var imagePath = image.path;
      sendMessage(imagePath, ChatInfoBeanEntity.IMAGE);
    }
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null && image.path != null) {
      var imagePath = image.path;
      sendMessage(imagePath, ChatInfoBeanEntity.IMAGE);
    }
  }
}

class MenuItemBean {
  IconData iconData;
  String text;
  Function onTap;

  MenuItemBean({this.iconData, this.text, this.onTap});
}