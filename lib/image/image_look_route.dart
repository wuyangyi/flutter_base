import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/res/index.dart';
/*
 * 显示图片详情
 */
class ImageLookRoute extends BaseRoute {

  final String imagePath;
  final int index;

  ImageLookRoute(this.imagePath, this.index);
  @override
  _ImageLookRouteState createState() => _ImageLookRouteState();
}

class _ImageLookRouteState extends BaseRouteState<ImageLookRoute> {

  _ImageLookRouteState(){
    needAppBar = false;
    statusTextDarkColor = false;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: GestureDetector(
        onTap: () {
          finish();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          alignment: Alignment.center,
          child: Hero(
            tag: "${HeroString.IMAGE_DETIL_HEAD}${widget.index}", //唯一标记
            child: Image.file(File(widget.imagePath)),
          ),
        ),
      ),
    );
  }
}
