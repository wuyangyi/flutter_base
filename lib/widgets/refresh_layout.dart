import 'package:flutter/material.dart';

class RefreshLayout extends StatefulWidget {
  final Widget child;

  const RefreshLayout({Key key, this.child}) : super(key: key);

  @override
  _RefreshLayoutState createState() => _RefreshLayoutState();
}

class _RefreshLayoutState extends State<RefreshLayout> {
  ScrollController controller = new ScrollController(
    initialScrollOffset: 100.0,
  );
  bool isOnScrolling = false; //是否正在滑动
  bool showTop = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event){isOnScrolling = true;},
      onPointerMove: (event){isOnScrolling = true;},
      onPointerUp: (event) {isOnScrolling = false;},
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {


          return true;
        },
        child: ListView(
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Offstage(
              offstage: isLoading ? true : !showTop,
              child: Container(
                width: double.infinity,
                height: 50.0,
              ),
            ),
            Offstage(
              offstage: isLoading ? false : !showTop,
              child: Container(
                width: double.infinity,
                height: 50.0,
                alignment: Alignment.center,
                child: Text(
                  "下拉刷新",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),),
              ),
            ),
            widget.child ?? Container(),
          ],
        ),
      ),
    );
  }
}
