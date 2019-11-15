import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/event_bus.dart';
import 'package:flutter_base/utils/function.dart';
import 'package:flutter_base/utils/utils.dart';

import 'ExpandedWidget.dart';
//下拉菜单
class DropDownMenu extends StatefulWidget {
  final List<MenuBean> menuBean;
  final Widget child;

  const DropDownMenu({Key key, this.menuBean, this.child}) : super(key: key);
  @override
  _DropDownMenuState createState() => _DropDownMenuState(menuBean);
}

class _DropDownMenuState extends State<DropDownMenu> {
  bool showMenu = false;
  int selectIndex = 0;
  List<MenuBean> menuBean;
  _DropDownMenuState(this.menuBean,);

  @override
  void initState() {
    super.initState();
    bus.on(EventBusString.CLOSE_MENU, (open){
      _resumeMenu(-1);
      showMenu = false;
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusString.CLOSE_MENU);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40.0),
          child: widget.child,
        ),
        Offstage(
          offstage: !showMenu,
          child: GestureDetector(
            onTap: (){
              setState(() {
                showMenu = false;
                _resumeMenu(-1);
              });
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0x20000000),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: _getMenu(menuBean),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40.0),
          constraints: BoxConstraints(
//            maxHeight:  MediaQuery.of(context).size.height / 2 - 40,
          ),
          color: Colors.white,
          child: ExpansionLayout(
            isExpanded: showMenu,
            children: <Widget>[
              menuBean[selectIndex].dropListWidget ?? Container(height: 0, width: 0,),
            ],
          ),
        ),
      ],
    );
  }

  _resumeMenu(int index) {
    for (int i = 0; i < menuBean.length; i++) {
      if (i == index) {
        menuBean[i].isOpen = !menuBean[i].isOpen;
      } else {
        menuBean[i].isOpen = false;
      }

    }
  }

  List<Widget> _getMenu(List<MenuBean> menuBean) {
    List<Widget> menu = [];
    if (menuBean != null) {
      for (int i=0; i < menuBean.length; i++) {
        menu.add(Expanded(
          child: GestureDetector(
              onTap: () {
                if (ObjectUtil.isNotEmpty(menuBean[i].onTop)) {
                  menuBean[i].onTop(!menuBean[i].isOpen);
                }
                setState(() {
                  selectIndex = i;
                  showMenu = !menuBean[i].isOpen && ObjectUtil.isNotEmpty(menuBean[i].dropListWidget);
                  _resumeMenu(i);
                });
              },
              child:Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      menuBean[i].isOpen ? menuBean[i].selectTitle : menuBean[i].title,
                      style: TextStyle(
                        color: menuBean[i].isOpen ? menuBean[i].selectColor : MyColors.title_color,
                        fontSize: 14.0,
                      ),
                    ),
                    Offstage(
                      offstage: !menuBean[i].isNeedIcon,
                      child: menuBean[i].isFullItem ? Expanded(
                        flex: 1,
                        child: Container(),
                      ) : Container(
                        width: 5.0,
                      ),
                    ),
                    Offstage(
                      offstage: !menuBean[i].isNeedIcon,
                      child: Icon(Icons.arrow_drop_down,
                        color: menuBean[i].isOpen ? menuBean[i].selectColor : MyColors.buttonNoSelectColor,
                        size: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ));
        if (i != menuBean.length - 1) {
          menu.add(Container(
            width: 1.0,
            height: double.infinity,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            color: Color(0xFFe3e3e3),
          ));
        }
      }
    }
    return menu;
  }
}

class MenuBean {
  Widget dropListWidget; //划出的控件
  String title; //标题
  String selectTitle; //选中的标题
  Color selectColor; //选中的颜色
  bool isFullItem;  //是否只有一个，占满
  bool isOpen; //是否展开
  bool isNeedIcon; //是否需要右边的图标
  OnMenuTop onTop; //点击事件
  MenuBean({this.title,
    this.isFullItem = false,
    this.isOpen = false,
    this.dropListWidget,
    this.isNeedIcon = true,
    this.selectTitle,
    this.onTop,
    this.selectColor = MyColors.main_color}) {
    if(selectTitle == null) {
      selectTitle = title;
    }
  }
}
