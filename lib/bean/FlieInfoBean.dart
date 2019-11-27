class FileInfoBean {
  String path;
  String fileName;
  Uri uri;
  bool check; //是否选中
  FileInfoBean({this.path, this.fileName, this.uri, this.check});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['fileName'] = this.fileName;
    return data;
  }

  FileInfoBean.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    fileName = json['fileName'];
  }
}