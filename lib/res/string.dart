class Ids {
  static const String appProfile = "flutter_base";
  static const String keyAppToken = 'flutter_base_token'; //cookic

  static final String login = "login";
  static final String home = "home";
}

class EventBusString {
  static final String CITY_SELECT = "city_select"; //城市选择

  //账单
  static final String TALLY_LOADING = "tally_loading"; //账单页面需要刷新
  //关闭下拉菜单
  static final String CLOSE_MENU = "close_menu"; //关闭菜单栏

  //音乐播放进度
  static final String MUSIC_PROGRESS = "music_progress";

  //音乐播放状态
  static final String MUSIC_PLAY_STATE = "music_play_state";

  static final String READ_BOOK_HOME_PAGE_CHANGE = "read_book_home_page_change"; //精品阅读首页tab切换

  //二级评论（点赞数目和评论数目更新）
  static final String COMMIT_SEND_UPDATA = "COMMIT_SEND_UPDATA";

  //关闭所有二级评论
  static final String COMMIT_TWO_FINISH = "COMMIT_TWO_FINISH";
}

class HeroString {
  static final String BOOK_MINE_USER_HEAD = "book_mine_user_head"; //记账本我的页面头像

  static final String IMAGE_DETIL_HEAD = "image_detil_head"; //图片详情
}