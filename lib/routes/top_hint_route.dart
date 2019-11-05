import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/dialog/wait_dialog.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

// TODO: 第3步：实现“路由导航”。
/// 打开顶部提醒页面。
void openTopReminder(context, int status, {String message}) {
  // 导航器（`Navigator`）组件，用于管理具有堆栈规则的一组子组件。
  // 许多应用程序在其窗口组件层次结构的顶部附近有一个导航器，以便使用叠加显示其逻辑历史记录，
  // 最近访问过的页面可视化地显示在旧页面之上。使用此模式，
  // 导航器可以通过在叠加层中移动组件来直观地从一个页面转换到另一个页面。
  // 类似地，导航器可用于通过将对话框窗口组件放置在当前页面上方来显示对话框。
  // 导航器（`Navigator`）组件的关于（`of`）方法，来自此类的最近实例的状态，它包含给定的上下文。
  // 导航器（`Navigator`）组件的推（`push`）方法，将给定路径推送到最紧密包围给定上下文的导航器。
  Navigator.of(context).push(
    // 页面路由生成器（`PageRouteBuilder`）组件，用于根据回调定义一次性页面路由的实用程序类。
    PageRouteBuilder(
      // 转换完成后路由是否会遮盖以前的路由。
      opaque: false,
      // 页面构建器（`pageBuilder`）属性，用于构建路径的主要内容。
      pageBuilder: (BuildContext context, _, __) {
        return TopReminder(message: message, status: status,);
      },
      // TODO: 第5步：实现“过渡动画”。
      // 转换生成器（`transitionsBuilder`）属性，用于构建路径的转换。
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        // 淡出过渡（`FadeTransition`）组件，动画组件的不透明度。
        // https://docs.flutter.io/flutter/widgets/FadeTransition-class.html
        return FadeTransition(
          // 不透明度（`opacity`）属性，控制子组件不透明度的动画。
          opacity: animation,
          // 滑动过渡（`SlideTransition`）组件，动画组件相对于其正常位置的位置。
          // https://docs.flutter.io/flutter/widgets/SlideTransition-class.html
          child: SlideTransition(
            // 位置（`position`）属性，控制子组件位置的动画。
            // 两者之间（`Tween`）类，开始值和结束值之间的线性插值。
            // 偏移（`Offset`）类，不可变的2D浮点偏移量。
            position: Tween<Offset>(
              // 两者之间（`Tween`）类的开始（`begin`）属性，此变量在动画开头的值。
              begin: Offset(0.0, -0.3),
              // 两者之间（`Tween`）类的结束（`end`）属性，此变量在动画结束时的值。
              end: Offset.zero,
              // 两者之间（`Tween`）类的活跃（`animate`）方法，返回由给定动画驱动但接受由此对象确定的值的新动画。
            ).animate(animation),
            child: child,
          ),
        );
      },
    ),
  );
}

//自定义顶部提醒组件
class TopReminder extends StatefulWidget {
  /// 提醒文本。
  final String message;
  ///状态
  final int status;

  const TopReminder({Key key,
    this.message = "操作成功",
    this.status = Status.success,
  }) : super(key: key);

  @override
  _TopReminderState createState() => _TopReminderState();
}

class _TopReminderState extends State<TopReminder> {
  final double imageSize = 20.0; //图片的大小
  /// 倒计时的计时器。
  Timer _timer;
  @override
  void initState() {
    super.initState();
    //不是加载中动画时1.5秒后关闭
    if (widget.status != Status.loading) {
      _startTimer();
    }
  }

  /// 启动倒计时的计时器。
  _startTimer() {
    _timer = Timer(
      // 持续时间参数。
      Duration(milliseconds: 1500),
      // 回调函数参数。
          () {
        Navigator.of(context).pop(true);
      },
    );
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            // 双精度（`double`）类的无穷（`infinity`）常量，最大宽度。
            width: double.infinity,
            height: 80.0,
            padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 2.0), //阴影xy轴偏移量
                      blurRadius: 15.0, //阴影模糊程度
                      spreadRadius: 1.0 //阴影扩散程度
                  )
                ]),
            // 使用材料（`Material`）组件来避免文本下方的黄色线条。
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: getImage(),
                ),
                Material(
                  color: Colors.white,
                  child: Text(
                    widget.message ?? "操作成功",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: MyColors.title_color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        // TODO: 第4步：实现“倒计时抛”，关闭倒计时。
        _cancelTimer();
        Navigator.of(context).pop(true);
      },
    );
  }

  Widget getImage() {
    if (widget.status == Status.success) {
      return Image.asset(Util.getImgPath("msg_box_succeed"), width: imageSize, height: imageSize,);
    } else {
      return Image.asset(Util.getImgPath("msg_box_remind"), width: imageSize, height: imageSize,);
    }
  }
}
