import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/function.dart';
import 'package:flutter_base/utils/utils.dart';


//密码手机号等输入框
class InputTextField extends StatefulWidget {
  final bool needClear;
  final double height;
  final Widget leftIcon;
  final TextInputType inputType;
  final int maxLength;
  final bool isPassword;
  final TextEditingController controller;
  final String hintText;
  final bool enable;
  final OnTextChange onTextChange;
  final int maxLines;
  InputTextField({
    this.height,
    this.leftIcon,
    this.inputType = TextInputType.text,
    this.maxLength = -1,
    this.controller,
    this.isPassword = false,
    this.hintText,
    this.needClear = true,
    this.enable = true,
    this.onTextChange,
    this.maxLines = 1,
  });
  @override
  State<StatefulWidget> createState() {
    return _InputTextFieldState();
  }

}

class _InputTextFieldState extends State<InputTextField> {
  bool isShowClear = false; //是否显示清除
  bool showPassword = false; //是否显示密码
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height == null ? double.infinity : widget.height,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: widget.leftIcon,
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: widget.controller,
                textAlign: TextAlign.start,
                enabled: widget.enable,
                maxLines: widget.maxLines,
                inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
                style: TextStyle(
                  color: Color(0xFF363951),
                  fontSize: 14.0,
                ),
                scrollPadding: EdgeInsets.all(0.0),
                keyboardType: widget.inputType,
                decoration: InputDecoration( //外观样式
                  hintText: widget.hintText,
                  contentPadding: const EdgeInsets.all(15.0),
                  border: InputBorder.none, //去除自带的下划线
                  hintStyle: TextStyle(
                    color: Color(0xFFCBCDD5),
                    fontSize: 14.0,
                  ),
                ),
                obscureText: widget.isPassword && !showPassword,
                onChanged: (value) {
                  if (ObjectUtil.isNotEmpty(widget.onTextChange)) {
                    widget.onTextChange(value);
                  }
                  setState(() {
                    isShowClear = value.isNotEmpty;
                  });
                },
              ),
            ),
          ),
          (isShowClear && widget.needClear) ? GestureDetector(
            child: Image.asset(Util.getImgPath("ico_clear"), width: 17.0, height: 17.0, fit: BoxFit.fill,),
            onTap: (){
              setState(() {
                widget.controller.clear();
                isShowClear = false;
                if (ObjectUtil.isNotEmpty(widget.onTextChange)) {
                  widget.onTextChange("");
                }
              });
            },
          ) : Container(),
          widget.isPassword ? GestureDetector(
            onTap: (){
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Image.asset(Util.getImgPath(showPassword ? "ico_pwd_show" : "ico_pwd_hide"), width: 20.0, height: showPassword ? 15.0 : 10.0, fit: BoxFit.fill,),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}

///完善信息页面的输入
class FinishInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enable;
  final OnTextChange onTextChange;
  final TextInputType inputType;
  final int maxLength;
  final String leftText;
  final Function onTap;
  final bool needRightImage;
  final double height;
  final bool needClear;
  final bool needBottomDriver;
  final int maxLines;

  const FinishInput({Key key,
    this.inputType = TextInputType.text,
    this.maxLength = -1,
    this.controller,
    this.hintText,
    this.enable = true,
    this.onTextChange,
    this.leftText,
    this.onTap,
    this.needRightImage = true,
    this.height = 55.0,
    this.needClear = true,
    this.needBottomDriver = true,
    this.maxLines = 1,
  }) : super(key: key);
  @override
  _FinishInputState createState() => _FinishInputState();
}

class _FinishInputState extends State<FinishInput> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: widget.height,
        alignment: Alignment.centerLeft,
        decoration: widget.needBottomDriver ? Decorations.finishBottom : Decorations.bottomNo,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InputTextField(
                needClear: widget.needClear,
                maxLines: widget.maxLines,
                leftIcon: Text(
                  widget.leftText ?? "",
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 15.0,
                  ),
                ),
                inputType: widget.inputType,
                maxLength: widget.maxLength,
                isPassword: false,
                hintText: widget.hintText,
                enable: widget.enable,
                onTextChange: widget.onTextChange,
                controller: widget.controller,
              ),
            ),
            Offstage(
              offstage: !widget.needRightImage,
              child: Image.asset(Util.getImgPath("ic_arrow_smallgrey"), height: 25.0,),
            ),
          ],
        ),
      ),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
    );
  }
}
