import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/widgets.dart';


///加载状态占位
class StatusView extends StatefulWidget {
  int status;
  final GestureTapCallback onTap;
  final bool enableEmptyClick;

  StatusView({Key key, this.status, this.onTap, this.enableEmptyClick = false});
  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  _StatusViewState();
  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case Status.fail: //失败  显示网络异常
        return new Container(
          width: double.infinity,
          child: new Material(
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                if (!widget.enableEmptyClick) {
                  return;
                }
                setState(() {
                  widget.status = Status.loading;
                });
                if(widget.onTap != null) {
                  widget.onTap();
                }
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    Util.getImgPath("ico_network_error"),
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case Status.loading: //加载中
        return new Container(
          alignment: Alignment.center,
          color: MyColors.gray_f0,
          child: new WaitDialogProgress(Size(45.0, 45.0), "default_center_000", 29),
        );
        break;
      case Status.empty: //为空
        return new Container(
          width: double.infinity,
          child: new Material(
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                if (!widget.enableEmptyClick) {
                  return;
                }
                setState(() {
                  widget.status = Status.loading;
                });
                if(widget.onTap != null) {
                  widget.onTap();
                }
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    Util.getImgPath("ico_data_empty"),
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}

class Status {
  //加载失败异常
  static const int fail = -1;
  //加载中
  static const int loading = 0;
  //加载成功  在加载更多中，表示还有更多数据可加载
  static const int success = 1;
  //数据为空，没有更多数据
  static const int empty = 2;
}