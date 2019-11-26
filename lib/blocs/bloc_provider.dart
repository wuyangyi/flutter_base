import 'package:flutter/material.dart';
import 'package:flutter_base/bean/base_bean.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase<D> {

  Future getData({int userId, int page, bool isLoadMore});

  Future onRefresh({int userId,});

  Future onLoadMore({int userId,});

  void dispose();
}
//普通加载的抽象类
abstract class BlocDataBase<D extends BaseBean> extends BlocBase {
  BehaviorSubject<D> _subject = BehaviorSubject<D>();
  Sink<D> get subjectSink => _subject.sink;
  Stream<D> get subjectStream => _subject.stream;

  @override
  void dispose() {
//    _subject.close();
  }
}
//列表加载的抽象类
abstract class BlocListBase<D extends BaseBean> extends BlocBase{
  BehaviorSubject<List<D>> _subject = BehaviorSubject<List<D>>();
  Sink<List<D>> get subjectSink => _subject.sink;
  Stream<List<D>> get subjectStream => _subject.stream;
  int page = 0;
  Map maps; //条件

  @override
  Future onLoadMore({int userId,}) {
    page++;
    return getData(page: page, isLoadMore: true, userId: userId);
  }

  @override
  Future onRefresh({int userId,}) {
    initPage();
    return getData(page: page, isLoadMore: false, userId: userId);
  }

  void initPage();

  void initCondition(Map map){
    this.maps = map;
  }

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
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    if (widget.userDispose) widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
