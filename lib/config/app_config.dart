///全局配置
class AppConfig {
  static final String BASE_URL = "https://www.wanandroid.com/"; //玩android请求地址
  static final String QQ_MUSIC_BASE_URL = "http://c.y.qq.com/"; //音乐请求地址
  static final String TL_CHAT_BASE_URL = "http://openapi.tuling123.com/"; //图灵机器人请求地址
  static final String WEATHER_BASE_URL = "http://t.weather.sojson.com/api/weather/city/"; //天气请求地址
  static final String READ_BOOK_BASE_URL = "http://api.zhuishushenqi.com/"; //精品阅读地址
  static final String READ_BOOK_BASE_URL_USE = "http://statics.zhuishushenqi.com"; //精品阅读地址(图片)
  static final String READ_BOOK_BASE_URL_READ = "http://chapterup.zhuishushenqi.com/chapter"; //精品阅读地址(小说章节内容)

  static final bool IS_DEBUG = false; //是否是debug模式

  static final String APP_NAME = "小小工具箱";
  static final String APPVERSION = "1.0.0"; //版本号
  static final String APPCLIENT = "android"; //android端
  static final int PAGE_LIMIT = 20; //分页每页的数量

  //请求错误提示
  static final String MSG_ERROR = "网络异常";
}