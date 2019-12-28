import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';

class BookRackRoute extends BaseRoute {
  final BuildContext parentContext;

  BookRackRoute(this.parentContext);
  @override
  _BookRackRouteState createState() => _BookRackRouteState();
}

class _BookRackRouteState extends BaseRouteState<BookRackRoute> {

  _BookRackRouteState(){
    title = "精品阅读";
    appBarElevation = 2.0;
    titleSize = 18.0;
    leading = Container();
    setRightButtonFromIcon(Icons.access_time);
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Container()
    );
  }
}
