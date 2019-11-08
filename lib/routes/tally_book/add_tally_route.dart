import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/my_book_bean_entity.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:provider/provider.dart';

class AddTallyRoute extends BaseRoute {
  @override
  _AddTallyRouteState createState() => _AddTallyRouteState();
}

class _AddTallyRouteState extends BaseRouteState<AddTallyRoute> {

  _AddTallyRouteState(){
    setRightButtonFromText("完成");
  }
  List<MyBookBeanEntity> books;
  int selectBookIndex = 0;
  bool enableTitleClick;

  @override
  void initState() {
    super.initState();
    books = Provider.of<BookModel>(context, listen: false).books;
    enableTitleClick = books != null && books.length > 1;
  }
  
  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container(),
    );
  }
  
  @override
  Widget getTitleWidget() {
    return GestureDetector(
      onTap: (){
        if (enableTitleClick) {

        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            books[selectBookIndex].name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          Offstage(
            offstage: !enableTitleClick,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Image.asset(Util.getImgPath("ico_pull_down"), width: 10.0, height: 10.0,),
            ),
          ),
        ],
      ),
    );
  }
}
