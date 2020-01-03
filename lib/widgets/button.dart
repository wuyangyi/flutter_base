import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/function.dart';
import 'package:flutter_base/utils/utils.dart';



///完成的按钮
class FinishButton extends StatefulWidget {
  final String text;
  final OnTapClick onTop;
  final bool enable;
  final double radios;
  final double height;
  final double width;
  FinishButton({
    this.text,
    this.onTop,
    this.enable = true,
    this.radios = 22.0,
    this.height = double.infinity,
    this.width = double.infinity,
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
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.enable ? MyColors.main_color : MyColors.buttonNoSelectColor,
          borderRadius: BorderRadius.circular(widget.radios),
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


class MyItemButton extends StatelessWidget {
  final double height;
  final Function onTap;
  final Widget leftWidget;
  final String title;
  final Widget rightWidget;
  final String rightText;

  MyItemButton({Key key,
    this.height = 50.0,
    this.onTap, this.leftWidget, this.title, this.rightWidget, this.rightText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          onTap: (){
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.5, color: MyColors.home_bg)),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Offstage(
                  offstage: leftWidget == null,
                  child: Container(
                    width: 18.0,
                    height: 18.0,
                    margin: EdgeInsets.only(right: 15.0),
                    alignment: Alignment.center,
                    child: leftWidget ?? Container(),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title ?? "",
                    style: TextStyle(
                      color: MyColors.title_color,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: rightWidget ?? Text(
                      rightText ?? "",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: MyColors.text_normal,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
                Image.asset(Util.getImgPath("ic_arrow_smallgrey"), height: 22.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//评分
class GoodWidget extends StatefulWidget {
  final Function onTap;
  final double height;
  int selectIndex;

  GoodWidget({Key key, this.onTap, this.height = 30.0, this.selectIndex = -1}) : super(key: key);
  @override
  _GoodWidgetState createState() => _GoodWidgetState();
}

class _GoodWidgetState extends State<GoodWidget> {

  var goodList = [
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.center,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Container(
            width: 10.0,
            height: 10.0,
            color: Colors.transparent,
          );
        },
        itemCount: goodList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                widget.selectIndex = index;
              });
              if (widget.onTap != null) {
                widget.onTap(widget.selectIndex);
              }
            },
            child: Image.asset(
              Util.getImgPath(widget.selectIndex < index ? goodList[index][1] : goodList[index][0]),
              height: double.infinity,
            ),
          );
        },
      ),
    );
  }
}



class GoodInput extends StatefulWidget {
  final String leftText;
  final Function onTap;

  const GoodInput({Key key, this.leftText, this.onTap}) : super(key: key);

  @override
  _GoodInputState createState() => _GoodInputState();
}

class _GoodInputState extends State<GoodInput> {

  var goodList = [
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
    ["ico_like", "ico_dislike"],
  ];

  int selectIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.leftText ?? "",
          style: TextStyle(
            color: MyColors.main_color,
            fontSize: 14.0,
          ),
        ),
        Gaps.hGap10,
        Container(
          height: 18.0,
          alignment: Alignment.center,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(0.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Container(
                width: 10.0,
                height: 10.0,
                color: Colors.transparent,
              );
            },
            itemCount: goodList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectIndex = index;
                  });
                  if (widget.onTap != null) {
                    widget.onTap(selectIndex);
                  }
                },
                child: Image.asset(
                  Util.getImgPath(selectIndex < index ? goodList[index][1] : goodList[index][0]),
                ),
              );
            },
          ),
        ),
        Container(
          width: 50.0,
          height: 20.0,
          margin: EdgeInsets.only(left: 15.0),
          alignment: Alignment.center,
          child: selectIndex > -1 ? Icon(
            getIcon(selectIndex+1),
            color: MyColors.main_color,
            size: 20.0,
          ) : Text(
            "请打分",
            style: TextStyle(
                color: selectIndex > -1 ? MyColors.main_color : MyColors.text_normal,
                fontSize: 14.0
            ),
          ),
        ),
      ],
    );
  }

  IconData getIcon(int index) {
    IconData icon = Icons.sentiment_very_satisfied;
    switch(index) {
      case 1:
        icon = Icons.sentiment_very_dissatisfied;
        break;
      case 2:
        icon = Icons.sentiment_dissatisfied;
        break;
      case 3:
        icon = Icons.sentiment_neutral;
        break;
      case 4:
        icon = Icons.sentiment_satisfied;
        break;
      case 5:
        icon = Icons.sentiment_very_satisfied;
        break;
    }
    return icon;
  }
}
