void main() {
  List<int> list = [1, 2, 2];
  List l = list.sublist(0,);

  l[0] = 2;
  print("长度l:${l.toString()}");
  print("长度:${list.toString()}");
}
