import 'base_bean.dart';

class FileInfoBean extends BaseBean {
  String path;
  String fileName;
  Uri uri;
  bool collected; //收藏
  bool check; //是否选中
  FileInfoBean({this.path, this.fileName, this.uri, this.check, this.collected = false});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['fileName'] = this.fileName;
    data['collected'] = this.collected.toString();
    return data;
  }

  FileInfoBean.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    fileName = json['fileName'];
    collected = json['collected'] == null ? false : bool.fromEnvironment(json['collected']);
  }
}