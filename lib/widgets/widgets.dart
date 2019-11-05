import 'package:flutter/material.dart';
import 'package:flutter_base/utils/utils.dart';


///图片加载动画
class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: 24.0,
        height: 24.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

///菊花加载
class WaitDialogProgress extends StatefulWidget {
  final Size size;
  final String imageName;
  final int imageNumber;

  const WaitDialogProgress(this.size, this.imageName, this.imageNumber);
  @override
  State<StatefulWidget> createState() {
    return _WaitDialogProgressState();
  }
}

class _WaitDialogProgressState extends State<WaitDialogProgress> with TickerProviderStateMixin {
  bool _disposed;
  Duration _duration;
  int _imageIndex;
  Widget image;

  @override
  void initState() {
    super.initState();
    _disposed = false;
    _duration = Duration(milliseconds: 60);
    _imageIndex = 0;
    _updateImage();
  }

  void _updateImage() {
    if (_disposed) {
      return;
    }

    setState(() {
      if (_imageIndex > widget.imageNumber) {
        _imageIndex = 0;
      }
      image = Image.asset(
        Util.getImgPath(widget.imageName + _getImage()),
        width: widget.size.width,
        height: widget.size.height,
        gaplessPlayback: true, //避免图片闪烁
      );
      _imageIndex++;
    });
    Future.delayed(_duration, () {
      _updateImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  String _getImage() {
    if (_imageIndex < 10) {
      return "0$_imageIndex";
    }
    return "$_imageIndex";
  }

}


///空appbar
class MyEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0,);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, 0);

}

///状态栏占位
class AppStatusBar extends StatelessWidget {
  final Color color;
  final BuildContext buildContext;
  const AppStatusBar({Key key, this.color, this.buildContext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(buildContext).padding.top,
      color: color,
    );
  }
}