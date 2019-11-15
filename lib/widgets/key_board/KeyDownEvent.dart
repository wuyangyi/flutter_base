class KeyDownEvent {
  ///  当前点击的按钮所代表的值
  String key;
  KeyDownEvent(this.key, {this.time, this.desc});
  bool isDelete() => this.key == "del";

  DateTime time; //时间
  String desc; //备注
}