import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/function.dart';



///完成的按钮
class FinishButton extends StatefulWidget {
  final String text;
  final OnTapClick onTop;
  final bool enable;
  FinishButton({
    this.text,
    this.onTop,
    this.enable = true,
  });
  @override
  State<StatefulWidget> createState() {
    return _FinishButtonState();
  }
}
class _FinishButtonState extends State<FinishButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (widget.enable) {
          widget.onTop();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.enable ? MyColors.main_color : MyColors.buttonNoSelectColor,
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

}

//带水波动画的黑色边框按钮
class InkWellButton extends StatelessWidget {
  final double height;
  final String text;
  final Widget leftWidget;
  final Function onTap;

  const InkWellButton({Key key, this.height = 45, this.text, this.leftWidget, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: (){
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: MyColors.text_normal),
              borderRadius: BorderRadius.circular(20.0),
            ),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                leftWidget,
                Gaps.hGap5,
                Text(
                  text,
                  style: TextStyle(
                    color: MyColors.text_normal_5,
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
