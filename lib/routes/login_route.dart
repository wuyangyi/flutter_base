import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/wait_dialog.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/bsr.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:flutter_base/widgets/editview.dart';
import 'package:flutter_base/widgets/image_code.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'finish_user_info/finish_info_route.dart';
import 'home/home.dart';
import 'top_hint_route.dart';

class LoginRoute extends BaseRoute {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends BaseRouteState<LoginRoute> {

  bool isLogin = true;
  bool buttonEnable = false;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _surePwdController = TextEditingController();
  ImageCodeContract _imageCodeContract = new ImageCodeContract(textLength: 4);
  
  _LoginRouteState(){
    needAppBar = false;
    statusTextDarkColor = true;
    Util.setTransAppBarDark(); //设置沉浸式状态栏 字体为黑色
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _pwdController.dispose();
    _surePwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: BottomClipper(),
                child: Image.asset(
                  Util.getImgPath("ico_login_top"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 230.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        isLogin = true;
                        _pwdController.clear();
                        _surePwdController.clear();
                        _checkButton();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: isLogin ? Decorations.bottomSelect : Decorations.bottom,
                        child: Text(
                          "登录",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isLogin ? MyColors.selectColor : MyColors.title_color,
                            fontSize: 15.0,
                          ),
                        ),
                      ),

                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        isLogin = false;
                        _codeController.clear();
                        _pwdController.clear();
                        _checkButton();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: isLogin ? Decorations.bottom : Decorations.bottomSelect,
                        child: Text(
                          "注册",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isLogin ? MyColors.title_color : MyColors.selectColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              Container(
                decoration: Decorations.bottom,
                width: double.infinity,
                height: 41.0,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
                alignment: Alignment.centerLeft,
                child: InputTextField(
                  leftIcon: Image.asset(Util.getImgPath("ico_login_phone"), width: 15.0, height: 20.0, fit: BoxFit.fill,),
                  inputType: TextInputType.phone,
                  maxLength: 11,
                  controller: _phoneController,
                  hintText: "请输入手机号",
                  onTextChange: (value) {
                    _checkButton();
                  },
                ),
              ),
              Container(
                decoration: Decorations.bottom,
                width: double.infinity,
                height: 41.0,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 15.0),
                alignment: Alignment.centerLeft,
                child: InputTextField(
                  leftIcon: Image.asset(Util.getImgPath("ico_login_password"), width: 15.0, height: 20.0, fit: BoxFit.fill,),
                  inputType: TextInputType.text,
                  maxLength: 20,
                  controller: _pwdController,
                  isPassword: true,
                  hintText: "请输入密码",
                  onTextChange: (value) {
                    _checkButton();
                  },
                ),
              ),
              isLogin ?
              Container(
                decoration: Decorations.bottom,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InputTextField(
                        height: 41.0,
                        leftIcon: Image.asset(Util.getImgPath("ico_login_image_code"), width: 15.0, height: 20.0, fit: BoxFit.fill,),
                        inputType: TextInputType.number,
                        maxLength: 4,
                        controller: _codeController,
                        hintText: "请输入验证码",
                        onTextChange: (value) {
                          _checkButton();
                        },
                      ),
                    ),
                    Gaps.hGap10,
                    CodeReview(
                      codeContract: _imageCodeContract,
                      onTap: (text) {
                      },
                    ),
                  ],
                ),
              ) :
              Container(
                decoration: Decorations.bottom,
                width: double.infinity,
                height: 41.0,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 15.0),
                child: InputTextField(
                  leftIcon: Image.asset(Util.getImgPath("ico_login_password"), width: 15.0, height: 20.0, fit: BoxFit.fill,),
                  inputType: TextInputType.text,
                  maxLength: 20,
                  controller: _surePwdController,
                  isPassword: true,
                  hintText: "请确认密码",
                  onTextChange: (value) {
                    _checkButton();
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Container(
                width: 150.0,
                height: 44.0,
                margin: EdgeInsets.only(bottom: 45.0),
                child: FinishButton(
                  text: isLogin ? "登录" : "注册",
                  enable: buttonEnable,
                  onTop: (){
                    if (isLogin) {
                      _doLogin(context);
                    } else {
                      _doRegister(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkButton() {
    bool checkPhone = _phoneController.text.isNotEmpty && Util.checkPhone(_phoneController.text, isNeedHint: false);
    if (isLogin && checkPhone && _codeController.text.isNotEmpty && _pwdController.text.isNotEmpty) {
      buttonEnable = true;
    } else if (!isLogin && checkPhone && _pwdController.text.isNotEmpty && _surePwdController.text.isNotEmpty) {
      buttonEnable = true;
    } else {
      buttonEnable = false;
    }
    setState(() {

    });
  }

  void _doLogin(BuildContext context) async {
    hideSoftInput();
    String username = _phoneController.text;
    String password = _pwdController.text;
    String code = _codeController.text;
    if (code != _imageCodeContract.codeText) {
      showTopMessage(message: "验证码错误", status:  Status.fail);
      return;
    }
    showWaitDialog();
    UserBeanEntity user;
    user = await NetClickUtil().login(username, password);
    hideWaitDialog();
    if (user != null) {
      Provider.of<UserModel>(context, listen: false).user = user;
      Application.profile.isLogin = true;
      Application.saveProfile(); //保存信息
      showTopMessage(message: "登录成功");
      Observable.just(1).delay(new Duration(seconds: 2)).listen((_){ //等待1s后关闭
        NavigatorUtil.pushPageByRoute(bodyContext, user.isFinishInfo ? HomeRoute() : FinishInfoRoute(true), isNeedCloseRoute: true);
      });

    }
  }

  void _doRegister(BuildContext context) async {
    String username = _phoneController.text;
    String password = _pwdController.text;
    String surePassword = _surePwdController.text;
    if (password != surePassword) {
      showTopMessage(message: "两次密码不一样", status: Status.fail);
    }
    showWaitDialog();
    UserBeanEntity user;
    user = await NetClickUtil().register(username, password, surePassword);
    hideWaitDialog();
    if (user != null) {
      Provider.of<UserModel>(context, listen: false).user = user;
      Application.profile.isLogin = true;
      Application.saveProfile(); //保存信息
      showTopMessage(message: "注册成功");
      Observable.just(1).delay(new Duration(seconds: 2)).listen((_){ //等待1s后关闭
        NavigatorUtil.pushPageByRoute(bodyContext, user.isFinishInfo ? HomeRoute() : FinishInfoRoute(true), isNeedCloseRoute: true);
      });
    }
  }
}
