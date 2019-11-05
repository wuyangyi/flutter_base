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
          color: widget.enable ? MyColors.selectColor : MyColors.buttonNoSelectColor,
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
