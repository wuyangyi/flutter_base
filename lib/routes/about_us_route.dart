import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AboutUsRoute extends BaseRoute {
  @override
  _AboutUsRouteState createState() => _AboutUsRouteState();
}

class _AboutUsRouteState extends BaseRouteState<AboutUsRoute> {

  _AboutUsRouteState(){
    needAppBar = true;
    title = "关于我们";
    showStartCenterLoading = false;
    bodyColor = MyColors.home_bg;
  }

  Uint8List bytes;

  Future _generateBarCode() async {
    Uint8List result = await scanner.generateBarCode('https://github.com/wuyangyi/flutter_base');
    this.setState(() => this.bytes = result);
  }

  @override
  void initState() {
    super.initState();
    _generateBarCode();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 70.0,
            height: 70.0,
            margin: const EdgeInsets.only(top: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(Util.getImgPath("ico_logo")),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              "${AppConfig.APP_NAME}  ${AppConfig.APPVERSION}",
              style: TextStyle(
                fontSize: 14.0,
                color: MyColors.buttonNoSelectColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: RadialGradient(
                colors: [Colors.white, Colors.white],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "产品介绍及隐私协议",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: MyColors.buttonNoSelectColor,
                  ),
                ),
                Gaps.vGap10,
                Text(
                  "${AppConfig.APP_NAME}是以WanAndroid API为登录注册接口数据，基于Flutter框架实现的一款App，该App纯属个人项目实践，需要源码可在github上自行下载。\n\nGiehub：https://github.com/wuyangyi/flutter_base \n\n注册后用户将获得帐号的使用权，同时表示您同意此隐私协议。\n\n(一)、用户不应将其帐号及密码转让或出借予他人使用，如发现其帐号遭他人非法使用，应立即联系我们。我们将对用户所提供的用户信心进行严格的管理及保护，在未得到您的许可之前，我们不会把您重要的个人用户资料(包括用户账号、姓名、联系方式、照片等)对外公开或提供给无关的第三方(包括公司或个人)。\n\n(二)、当用户使用APP提交各种相关信息时，表示您已经同意授予与小小工具箱各种相关信息进行查看及使用的权利。对于因此而引起的任何法律纠纷，我们不承担任何法律责任。\n\n(三)、在如下情况下，将不对您的隐私泄露承担责任：\n   1. 您同意让第三方共享资料；\n   2. 您同意公开你的个人资料，享受为您提供的产品和服务；\n   3. 小小工具箱需要听从法庭传票、法律命令或遵循法律程序；\n   4. 因黑客行为或用户的保管疏忽导致帐号、密码遭他人非法使用。\n\n(四)、如果您对此隐私政策有任何疑问或建议，请通过以下方式联系我们:123456@qq.com，我们会尽一切努力保护您的隐私。\n",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: MyColors.buttonNoSelectColor,
                  ),
                ),

                Gaps.vGap10,

                bytes == null ? Container() : Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Image.memory(
                    bytes,
                    width: 150,
                    height: 150,
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
