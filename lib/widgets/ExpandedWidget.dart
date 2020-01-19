import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionLayout extends StatefulWidget {
  const ExpansionLayout({
    Key key,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.isExpanded,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.duration = _kExpand,
  }) : super(key: key);

  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;

  //增加字段控制是否折叠
  final bool isExpanded;

  final Color backgroundColor;
  final AlignmentGeometry alignment; //优先出来的方向（默认居中）
  final Duration duration; //动画时间(默认200毫秒)


  @override
  _ExpansionLayoutState createState() => _ExpansionLayoutState();
}

class _ExpansionLayoutState extends State<ExpansionLayout>
    with SingleTickerProviderStateMixin {
  //折叠展开的动画，主要是控制height
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);
  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded;

  @override
  void initState() {
    super.initState();
    //初始化控制器以及出事状态
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.isExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = widget.isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
        });
      }
      //保存页面数据
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    //回调展开事件
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return Container(
      color: widget.backgroundColor ?? Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRect(
            child: Align(
              alignment: widget.alignment,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //执行以下对应的Tap事件
    _handleTap();
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}