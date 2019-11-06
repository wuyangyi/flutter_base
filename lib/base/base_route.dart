import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/top_hint_route.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// 普通页面的基类
abstract class BaseRoute extends StatefulWidget {
  const BaseRoute({Key key}) : super(key: key);
}

abstract class BaseRouteState<T extends BaseRoute> extends State<T> {
  bool isFirstInit = true;

  //最右边按钮标识
  final key_btn_right = GlobalKey();

  //右边第二个按钮标识
  final key_btn_border = GlobalKey();

  //最左边按钮标识
  final key_btn_left = GlobalKey();

  //窗口
  MaterialApp app;

  //body上下文  得用这个
  BuildContext bodyContext;

  //状态栏文字颜色是否是暗色, 默认为false
  bool statusTextDarkColor = false;

  //是否需要标题栏，默认为true
  bool needAppBar = true;

  //appBar阴影
  double appBarElevation = 4.0;

  //标题
  String title;

  //是否中部标题栏 默认为true
  bool centerTitle = true;

  //标题栏背景
  Color titleBarBg = MyColors.main_color;

  //左边组件
  Widget leading;

  //解决软键盘弹出界面被压缩问题(为false时，界面保持不变，软键盘覆盖界面，为ture界面被软键盘弹上去)
  bool resizeToAvoidBottomInset = true;

  //右边两个按钮
  IconButton btn_right, btn_border;

  //正文背景
  Color bodyColor = Colors.white;

  //加载状态Status
  int loadStatus = Status.loading;

  //是否需要初始的加载动画
  bool showStartCenterLoading = false;

  //是否需要加载异常点击刷新 ，默认为false
  // 开启需要重写onRefresh方法
  bool enableEmptyClick = false;

  /*
   * 是否正在刷新
   */
  bool isRefresh = false;

  bool isLoading = false;

  //创建内容栏
  Widget buildBody(BuildContext context, {Widget body}) {
    app = new MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusTextDarkColor ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: needAppBar ? AppBar(
            leading: leading ??
                new IconButton(
                  key: key_btn_left,
                  icon: Image.asset(Util.getImgPath(titleBarBg == Colors.white ? "icon_back_black" : "icon_back_white"), height: 20.0,),
                  onPressed: (){
                    onLeftButtonClick();
                  },
                ),
            title: new Text(title ?? "", style: TextStyle(
              fontSize: 16.0,
            ),),
            centerTitle: centerTitle,
            actions: <Widget>[
              btn_border ?? new Container(width: 0, height: 0,),
              btn_right ?? new Container(width: 0, height: 0,),
            ],
            backgroundColor: titleBarBg,
            elevation: appBarElevation,
          ) : MyEmptyAppBar(),
          body: new Builder(builder: (BuildContext context) {
            this.bodyContext = context;
            return _buildContext(body, context);
          }),
          backgroundColor: bodyColor,
          drawer: getDrawer(),
          floatingActionButton: buildFloatingActionButton(),
          bottomNavigationBar: getBottomNavigationBar(),
        ),
      ),
      debugShowCheckedModeBanner: AppConfig.IS_DEBUG,
    );
    return app;
  }

  Widget getBottomNavigationBar(){
    return null;
  }

  Widget getDrawer() {
    return null;
  }

  Widget buildFloatingActionButton() {
    return null;
  }

  //内容或者加载
  Widget _buildContext(Widget child, BuildContext context) {
    if (showStartCenterLoading && loadStatus != Status.success) {
      return StatusView(
        status: loadStatus,
        onTap: () {
          if (enableEmptyClick) {
            onRefresh();

          }
        },
      );
    } else {
      return Stack(
        children: <Widget>[
          child,
          Offstage(
            offstage: !isLoading,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Color(0x60000000),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  //控件里面内容主轴负轴居中显示
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //主轴高度最小
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    WaitDialogProgress(Size(30.0, 30.0), "ic_loading_white_", 11),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  /*
   * 刷新
   */
  Future onRefresh() async {
    isRefresh = true;
    loadStatus = Status.loading;
  }

  /*
   * 刷新成功的回调
   */
  onRefreshSuccess(int status) {
    loadStatus = status;
  }

  /*
   * 设置右边按钮图片
   */
  void setRightButtonFromImage(String imageName) {
    btn_right = new IconButton(
      key: key_btn_right,
      icon: Image.asset(Util.getImgPath(imageName), fit: BoxFit.fill,),
      onPressed: (){
        onRightButtonClick();
      },
    );
  }

  /*
   * 设置右边按钮图片
   */
  void setRightButtonFromIcon(IconData iconData) {
    btn_right = new IconButton(
      key: key_btn_right,
      icon: Icon(iconData),
      onPressed: (){
        onRightButtonClick();
      },
    );
  }

  /*
   * 设置右边按钮 文字
   */
  void setRightButtonFromText(String text, {Color textColor}) {
    btn_right = new IconButton(
      key: key_btn_right,
      icon: new Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14.0,
        ),
      ),
      onPressed: (){
        onRightButtonClick();
      },
    );
  }

  /*
   * 右边按钮点击事件
   */
  void onRightButtonClick() {
    showToast("正在建设中~");
  }

  /*
   * 设置侧边按钮图片
   */
  void setBorderButtonFromImage(String imageName) {
    btn_border = new IconButton(
      key: key_btn_border,
      icon: Image.asset(Util.getImgPath(imageName), fit: BoxFit.fill,),
      onPressed: (){
        onBorderButtonClick();
      },
    );
  }

  /*
   * 设置侧边按钮图片
   */
  void setBorderButtonFromIcon(IconData iconData) {
    btn_border = new IconButton(
      key: key_btn_border,
      icon: Icon(iconData),
      onPressed: (){
        onBorderButtonClick();
      },
    );
  }

  /*
   * 设置侧边按钮 文字
   */
  void setBorderButtonFromText(String text, {Color textColor}) {
    btn_border = new IconButton(
      key: key_btn_border,
      icon: new Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14.0,
        ),
      ),
      onPressed: (){
        onBorderButtonClick();
      },
    );
  }

  /*
   * 侧边按钮点击事件
   */
  void onBorderButtonClick() {
    showToast("正在建设中~");
  }

  /*
   * 左边按钮点击事件
   */
  void onLeftButtonClick() {
    finish();
  }

  /*
   * 设置状态栏文字颜色
   */
  void setStatusTextColor(bool statusTextDarkColor) {
    this.statusTextDarkColor = statusTextDarkColor;
  }

  /*
   * 设置是否需要标题栏
   */
  void setNeedAppBar(bool needAppBar) {
    this.needAppBar = needAppBar;
  }

  /*
   * 设置标题
   */
  void setTitle(String title) {
    this.title = title;
  }

  /*
   * 设置中部标题
   */
  void setCenterTitle(bool centerTitle) {
    this.centerTitle = centerTitle;
  }

  /*
   * 设置标题栏背景
   */
  void setTitleBarBg(Color titleBarBg) {
    this.titleBarBg = titleBarBg;
  }

  /*
   * 设置左边按钮
   */
  void setLeading(Widget leading) {
    this.leading = leading;
  }

  /*
   * 设置正文背景颜色
   */
  void setBodyColor(Color bodyColor) {
    this.bodyColor = bodyColor;
  }

  /*
   * 显示toast
   */
  void showToast(String msg, {ToastGravity gravity = ToastGravity.CENTER, Toast toastLength = Toast.LENGTH_SHORT}) {
    ToastUtil.showToast(msg, gravity: gravity, toastLength: toastLength);
  }

  /*
   * 底部显示SnackBar提示
   */
  void showSnackBar(String msg, {String label = "确定"}) {
    Scaffold.of(bodyContext).showSnackBar(
      SnackBar(
        content: Text("$msg"),
        action: new SnackBarAction(
            label: label,
            onPressed: (){
              onSnackBarPressed();
            },),
      ),
    );
  }

  /*
   * SnackBar点击回调
   */
  void onSnackBarPressed() {}

  /*
   * 隐藏软键盘
   */
  void hideSoftInput() {
    FocusScope.of(bodyContext).requestFocus(FocusNode());
  }

  /*
   * 返回上一场景
   */
  void finish() {
    Navigator.of(context).pop();
  }

  void showTopMessage({int status, String message}) {
    openTopReminder(bodyContext, status ?? Status.success, message: message);
  }

  //显示加载动画
  void showWaitDialog() {
    setState(() {
      isLoading = true;
    });
  }
  //关闭加载动画
  void hideWaitDialog() {
    setState(() {
      isLoading = false;
    });
  }
}
