import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/function.dart';
import 'package:flutter_base/utils/utils.dart';

class TopSearch extends StatefulWidget {
  final OnTextChange onChange;
  final Function leftOnTap;

  const TopSearch({Key key, this.onChange, this.leftOnTap}) : super(key: key);

  @override
  _TopSearchState createState() => _TopSearchState();
}

class _TopSearchState extends State<TopSearch> {
  TextEditingController _controller = new TextEditingController();
  bool isShowClear = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              if (ObjectUtil.isNotEmpty(widget.leftOnTap)) {
                widget.leftOnTap();
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 15.0),
              child: Image.asset(Util.getImgPath("icon_back_black"), width: 17.0, height: 17.0,),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              height: 34.0,
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.0),
                color: MyColors.citySelectColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left:  15.0),
                      child: TextField(
                        scrollPadding: EdgeInsets.all(0.0),
                        controller: _controller,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 13.0,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        cursorColor: Colors.black45, //光标颜色
                        decoration: InputDecoration( //外观样式
                          hintText: "输入关键字进行查找",
                          border: InputBorder.none, //去除自带的下划线
                          contentPadding: const EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        onChanged: (value) {
                          if (ObjectUtil.isNotEmpty(widget.onChange)) {
                            widget.onChange(value);
                          }
                          setState(() {
                            isShowClear = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !isShowClear,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
                      child: GestureDetector(
                        onTap: (){
                          _controller.clear();
                          if (ObjectUtil.isNotEmpty(widget.onChange)) {
                            widget.onChange("");
                          }
                          setState(() {
                            isShowClear = false;
                          });
                        },
                        child: Image.asset(Util.getImgPath("ico_clear"), width: 17.0, height: 17.0,),
                      ),
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
