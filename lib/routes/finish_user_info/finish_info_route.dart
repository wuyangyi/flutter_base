import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/city_bean_entity.dart';
import 'package:flutter_base/bean/dao/UserDao.dart';
import 'package:flutter_base/bean/user_bean_entity.dart';
import 'package:flutter_base/bean/userinfo_select.dart';
import 'package:flutter_base/config/application.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/dialog/dialog.dart';
import 'package:flutter_base/dialog/show_dialog_util.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/home/home.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/button.dart';
import 'package:flutter_base/widgets/editview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'city_select_route.dart';

class FinishInfoRoute extends BaseRoute {
  final bool finishInfo;

  FinishInfoRoute(
      this.finishInfo,
      );
  @override
  _FinishInfoRouteState createState() => _FinishInfoRouteState(finishInfo);
}

class _FinishInfoRouteState extends BaseRouteState<FinishInfoRoute> {

  _FinishInfoRouteState(bool finishInfo){
    needAppBar = true;
    appBarElevation = 2.0;
    title = finishInfo ? "完善信息" : "修改信息";
    titleBarBg = MyColors.main_color;
    if (finishInfo) {
      leading = Container();
    }
    bodyColor = Color(0xFFF0F0F0);
  }
  UserBeanEntity user;
  String _headImagePath = "pic_default_secret";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _birthController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _synopsisController = TextEditingController();
  bool finishButtonEnable = false;
  String headImage = "";
  var imageFile;
  List<UserInfoSelectBean> sexList = UserInfoSelectBean.getListByListString(["男", "女"], 0);
  CityBeanProvincelistCitylistCountylist cityData;


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _sexController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _synopsisController.dispose();
    bus.off(EventBusString.CITY_SELECT);
  }

  initData(){
    if (user == null) {
      return;
    }
    if (user.name != null) {
      _nameController.text = user.name;
    }
    if (user.phone != null) {
      _phoneController.text = user.phone;
    }
    if (user.sex != null) {
      _sexController.text = user.sex;
    }
    if (user.birthDate != null) {
      _birthController.text = user.birthDate;
    }
    if (user.address != null) {
      _addressController.text = user.address;
    }
    if (user.synopsis != null) {
      _synopsisController.text = user.synopsis;
    }
  }

  @override
  void initState() {
    super.initState();
    NetClickUtil(context).getCityData(); //获取城市列表
    user = Provider.of<UserModel>(context, listen: false).user;
    initData();
    bus.on(EventBusString.CITY_SELECT, (data) {
      cityData = data;
      _addressController.text = cityData.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    padding: EdgeInsets.all(0.0),
                    alignment: Alignment.centerLeft,
                    decoration: Decorations.finishBottom,
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "头像",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //头像点击
                            int index = await showModalBottomSheetUtil(context , MySimpleDialog(title: "上传头像", items: ["相机", "相册"]));
                            if (index == 0) {
                              _takePhoto();
                            } else if(index == 1) {
                              _openGallery();
                            }
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: headImage.isNotEmpty ? FileImage(File(headImage)) : user?.logo != null ? FileImage(File(user.logo)) : AssetImage(Util.getImgPath(_headImagePath))
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FinishInput(
                    hintText: "手机号不可修改",
                    leftText: "手机号",
                    needRightImage: false,
                    controller: _phoneController,
                    onTextChange: (value) {
                      onButtonCheck();
                    },
                    maxLength: 11,
                    enable: false,
                  ),
                  FinishInput(
                    controller: _nameController,
                    hintText: "取个名字吧！10个字以内哦~",
                    leftText: "姓名",
                    needRightImage: false,
                    onTextChange: (value) {
                      onButtonCheck();
                    },
                    maxLength: 10,
                  ),
                  FinishInput(
                    hintText: "请选择性别",
                    leftText: "性别",
                    needRightImage: true,
                    controller: _sexController,
                    maxLength: 10,
                    enable: false,
                    onTextChange: (value) {
                      onButtonCheck();
                    },
                    onTap: () async {
                      int index = await showModalBottomSheetUtil(context, UserInfoSelectDialog(
                        list: sexList,
                        title: "性别选择",
                        desc: "请选择您的性别",
                      ),
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ));
                      if (index != null && index != -1) {
                        sexList = Util.upDataSelect(sexList, index);
                        _sexController.text = sexList[index].title;
                        setState(() {
                          _headImagePath = Util.getUserHeadImageName(sexList[index].title);
                        });
                      }
                    },
                  ),
                  FinishInput(
                    hintText: "请选择您的当前地址",
                    leftText: "地址",
                    needRightImage: true,
                    controller: _addressController,
                    enable: false,
                    onTextChange: (value) {
                      onButtonCheck();
                    },
                    onTap: () {
                      NavigatorUtil.pushPageByRoute(context, CityRoute());
                    },
                  ),
                  FinishInput(
                    hintText: "请选择您的出生年月",
                    leftText: "出生日期",
                    needRightImage: true,
                    controller: _birthController,
                    enable: false,
                    onTextChange: (value) {
                      onButtonCheck();
                    },
                    onTap: () {
                      showDefaultYearPicker(bodyContext);
                    },
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    constraints: BoxConstraints(
                      minHeight: 50.0,
                    ),
                    padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "简介",
                            style: TextStyle(
                              color: MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.topLeft,
                            child: TextField(
                              controller: _synopsisController,
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
                                hintText: "个性签名也很重要哦~",
                                contentPadding: const EdgeInsets.only(left:15.0,),
                                border: InputBorder.none, //去除自带的下划线
                                hintStyle: TextStyle(
                                  color: Color(0xFFCBCDD5),
                                  fontSize: 14.0,
                                ),
                              ),
                              onChanged: (value) {
                                onButtonCheck();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 44.0,
              margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 20.0),
              child: FinishButton(
                text: "完成",
                enable: finishButtonEnable,
                onTop: (){
                  doFinish();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
      headImage = image.path;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
      headImage = image.path;
    });
  }

  onButtonCheck() {
    finishButtonEnable = _synopsisController.text.isNotEmpty && _birthController.text.isNotEmpty &&_sexController.text.isNotEmpty
                        &&_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty && _addressController.text.isNotEmpty;
    setState(() {

    });
  }

  //时间选择
  void showDefaultYearPicker(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
      context: context,
      //定义控件打开时默认选择日期
      initialDate: DateTime.now(),
      //定义控件最早可以选择的日期
      firstDate: DateTime(1900, 1),
      //定义控件最晚可以选择的日期
      lastDate: DateTime.now(),
    );
    if (dateTime != null) {
      _birthController.text = "${dateTime.year}年${dateTime.month}月${dateTime.day}日";
    }
  }

  void doFinish() {
    showWaitDialog();
    user.phone = _phoneController.text;
    user.name = _nameController.text;
    user.sex = _sexController.text;
    user.setBirthDate(_birthController.text);
    user.synopsis = _synopsisController.text;
    user.address = _addressController.text;
    user.isFinishInfo = true;
    user.setLogo(headImage);
    UserDao().saveData(user);
    Provider.of<UserModel>(context, listen: false).user = user;
    Application.saveProfile(); //保存信息
    hideWaitDialog();
    showTopMessage(message: "提交成功");
    Future.delayed(Duration(seconds: 2)).then((e) { //等待2s后关闭
      if (widget.finishInfo) {
        NavigatorUtil.pushPageByRoute(bodyContext, HomeRoute(), isNeedCloseRoute: true);
      } else {
        finish();
      }
    });
  }


}
