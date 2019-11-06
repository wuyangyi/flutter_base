import 'package:flutter/material.dart';
import 'package:flutter_base/bean/userinfo_select.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

///dialog样式类

/*
 * 相册选择
 */
class MySimpleDialog extends StatefulWidget {
  final String title;
  final List<String> items;

  const MySimpleDialog({Key key, this.title, this.items}) : super(key: key);
  @override
  _MySimpleDialogState createState() => _MySimpleDialogState();
}

class _MySimpleDialogState extends State<MySimpleDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 43.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            ),
            child: Text(
              widget.title ?? "提示",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.main_title_color,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: MyColors.main_title_color,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Color(0xFF989898),
                );
              },
              itemCount: widget.items?.length ?? 0,
              itemBuilder: (context, index) {
                bool last = index == (widget.items.length - 1);
                return GestureDetector(
                  child: Container(
                    height: 40.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: last ? Radius.circular(10.0) : Radius.circular(0.0), bottomRight: last ? Radius.circular(10.0) : Radius.circular(0.0))
                    ),
                    child: Text(
                      widget?.items[index] ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop(index);
                  },
                );
              },
            ),
          ),
          GestureDetector(
            child: Container(
              height: 40.0,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Text(
                "取消",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            onTap: (){
              Navigator.of(context).pop(-1);
            },
          ),
        ],
      ),
    );
  }
}



//底部性别年龄学历时间选择
class UserInfoSelectDialog extends StatefulWidget {
  final List<UserInfoSelectBean> list;
  final String title;
  final String desc;
  final int selectIndex;

  const UserInfoSelectDialog({Key key, this.list, this.title, this.desc, this.selectIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserInfoSelectDialogState(list, selectIndex);
  }
}

class _UserInfoSelectDialogState extends State<UserInfoSelectDialog> {
  List<UserInfoSelectBean> _list;
  int _selectIndex;
  static double _offset;
  ScrollController _controller;
  _UserInfoSelectDialogState(List<UserInfoSelectBean> list, int selectIndex) {
    this._list = list;
    _selectIndex = selectIndex == null ? 0 : selectIndex;
    _offset = _getScrollOffset();
    _controller = ScrollController(
      initialScrollOffset: _offset,
      keepScrollOffset: true,
    );
  }


  double _getScrollOffset(){
    if (_list.length <= 4) {
      return 0.0;
    }
    for(int index = 0; index < _list.length; index ++) {
      if (_list[index].selected) {
        if (index >= _list.length - 4) {
          return 51.0 * (_list.length - 4);
        } else {
          return 51.0 * index;
        }
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 37.5, right: 30.0),
            child: Row(
              children: <Widget>[
                Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 20.0,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(-1);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Image.asset(Util.getImgPath("ico_close"), fit: BoxFit.fill, width: 15.0, height: 15.0,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 37.5),
            child: Text(
              widget.desc,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFFA4A5AD),
                fontSize: 12.0,
              ),
            ),
          ),
          Container(
            height: _getListHeight(),
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15.0),
            constraints: BoxConstraints(
              maxHeight: 204.0,
            ),
            child: ListView.builder(
              controller: _controller,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                UserInfoSelectBean  selectBean = _list[index];
                return GestureDetector(
                  onTap: (){
                    for(int i = 0; i < _list.length; i++) {
                      _list[i].selected = i==index;
                    }
                    setState(() {

                    });
                    //延迟100毫秒后关闭
                    Observable.just(1).delay(new Duration(milliseconds: 100)).listen((_) {
                      Navigator.of(context).pop(index);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 51.0,
                    margin: const EdgeInsets.only(left: 37.5, right: 37.5),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(Util.getImgPath(selectBean.selected ? "ico_item_selected" : "ico_item_select"), fit: BoxFit.fill, width: 18.0, height: 18.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            selectBean.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: selectBean.selected ? MyColors.selectColor : MyColors.title_color,
                              fontSize: 15.0,
                            ),
                          ),
                        ),

                      ],
                    ),
                    decoration: index == _list.length - 1 ? Decorations.bottomNo : Decorations.bottom,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getListHeight() {
    if(widget.list.length < 4) {
      return widget.list.length * 51.0;
    } else {
      return 204.0;
    }
  }

}


class UserCenterBgDialog extends StatefulWidget {
  final List<String> images;

  const UserCenterBgDialog({Key key, this.images}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserCenterBgDialogState();
  }
}

class _UserCenterBgDialogState extends State<UserCenterBgDialog> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "背景选择",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColors.title_color,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop(-1);
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(right: 20.0),
                      child: Image.asset(Util.getImgPath("ico_close"), fit: BoxFit.fill, width: 15.0, height: 15.0,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: _getListHeight(),
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15.0),
            constraints: BoxConstraints(
              maxHeight: 345.0,
            ),
            child: ListView.builder(
              itemCount: widget.images.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(index);
                  },
                  child: index < widget.images.length ? Container(
                    width: double.infinity,
                    height: 100.0,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: AssetImage(Util.getImgPath(widget.images[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) : Container(
                    width: double.infinity,
                    height: 100.0,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: MyColors.home_body_bg,
                    ),

                    child: Image.asset(
                      Util.getImgPath("ico_add_blue"),
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getListHeight() {
    if(widget.images.length < 2) {
      return widget.images.length * 115.0;
    } else {
      return 345.0;
    }
  }

}