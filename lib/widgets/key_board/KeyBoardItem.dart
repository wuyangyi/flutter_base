import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
/*
 * 自定义键盘--按键
 */
class KeyboardItem extends StatefulWidget {
  //按钮显示的文本内容
  final String text;
  //  按钮 点击事件的回调函数
  final callBack;

  final Widget child; //自定义, 为空则为Text

  final Color bgColor; //按键背景颜色

  final Color color; //按键文字

  final double textSize; //文字大小

  final int flex;  //宽度占比  默认为4，即为屏幕宽度的四分之一

  final double height; //高度  默认为50.0

  KeyboardItem({Key key,
    this.text,
    this.callBack,
    this.child,
    this.color = MyColors.title_color,
    this.textSize = 18.0,
    this.bgColor = Colors.white,
    this.flex = 4,
    this.height = 50.0,
  }) : super(key: key);

  @override
  _KeyboardItemState createState() => _KeyboardItemState();
}

class _KeyboardItemState extends State<KeyboardItem> {
  ///回调函数执行体
  var backMethod;

  void Tap() {
    widget?.callBack('$backMethod');
  }

  @override
  Widget build(BuildContext context) {
    /// 获取当前屏幕的总宽度，从而得出单个按钮的宽度
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;
    return Container(
      height: widget.height,
      width: _screenWidth / widget.flex,
      child: Container(
        color: widget.bgColor,
        child: new OutlineButton(
          onPressed: Tap,
          //直角
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
          //边框颜色
          borderSide: new BorderSide(color: MyColors.loginDriverColor),
          child: widget.child ?? new Text(
            widget.text,
            style: new TextStyle(
              color: widget.color,
              fontSize: widget.textSize,
            ),
          ),
        ),
      ),
    );
  }
}
