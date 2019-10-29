import 'package:flutter/material.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase<D> {

  Future getData({int page, bool isLoadMore});

  Future onRefresh();

  Future onLoadMore();

  void dispose();
}
//普通加载的抽象类
abstract class BlocDataBase<D extends BaseBean> extends BlocBase {
  BehaviorSubject<D> _subject = BehaviorSubject<D>();
  Sink<D> get subjectSink => _subject.sink;
  Stream<D> get subjectStream => _subject.stream;
}
//列表加载的抽象类
abstract class BlocListBase<D extends BaseBean> extends BlocBase{
  BehaviorSubject<List<D>> _subject = BehaviorSubject<List<D>>();
  Sink<List<D>> get subjectSink => _subject.sink;
  Stream<List<D>> get subjectStream => _subject.stream;
  int page = 0;

  @override
  Future onLoadMore() {
    page++;
    return getData(page: page, isLoadMore: true);
  }

  @override
  Future onRefresh() {
    initPage();
    return getData(page: page, isLoadMore: false);
  }

  void initPage();

  @override
  void dispose() {
    _subject.close();
  }
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.userDispose: true,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  final bool userDispose;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    if (widget.userDispose) widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
