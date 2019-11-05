
class UserInfoSelectBean {
  String title;
  bool selected;
  UserInfoSelectBean(this.title, this.selected);

  /// List<String> 转 List<UserInfoSelectBean>
  /// index从0开始
  static List<UserInfoSelectBean> getListByListString(List<String> titles, int index) {
    if(titles.isEmpty) {
      return [];
    }
    List<UserInfoSelectBean> list = [];
    for (int i = 0; i < titles.length; i++) {
      list.add(UserInfoSelectBean(titles[i], i==index));
    }
    return list;
  }
}