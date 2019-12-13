import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/widgets/BookPageView.dart';

class BookReadHomeRoute extends BaseRoute {
  @override
  _BookReadHomeRouteState createState() => _BookReadHomeRouteState();
}

class _BookReadHomeRouteState extends BaseRouteState<BookReadHomeRoute> {
  _BookReadHomeRouteState(){
    needAppBar = false;
    bodyColor = Colors.transparent;
  }
  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: BookPageView()
    );
  }
}
