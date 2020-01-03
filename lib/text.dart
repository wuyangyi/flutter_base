void main() {
  DateTime data = DateTime.now();
  print(data.toString().substring(0, data.toString().lastIndexOf(".")));
}
