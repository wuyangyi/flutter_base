class ChatInfoBeanEntity {
	static const String TEXT = "text"; //文本
	static const String URL = "url"; //链接
	static const String VOICE = "voice"; //音频
	static const String VIDEO = "video"; //视屏
	static const String IMAGE = "image"; //图片
	static const String NEWS = "news"; //图文
	static const String EMIL = "emil"; //表情
	static const String CARD = "card"; //名片

	int id;
	bool isMe; //是否是自己发送
	String time; //发送事件（2019-12-07 15:04:32）
	String type; //发送的类别
	int userId; //用户id
	String value; //内容或者链接
	bool isRecall; //是否撤回
	bool isCollect; //是否收藏

	ChatInfoBeanEntity({this.isMe, this.time, this.type, this.userId, this.value, this.isRecall, this.isCollect});

	ChatInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		isMe = json['isMe'].toString() == "true";
		time = json['time'];
		type = json['type'];
		userId = json['userId'];
		value = json['value'];
		isRecall = json['isRecall'].toString() == "true";
		isCollect = json['isCollect'].toString() == "true";
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['isMe'] = this.isMe.toString();
		data['time'] = this.time;
		data['type'] = this.type;
		data['userId'] = this.userId;
		data['value'] = this.value;
		data['isRecall'] = this.isRecall.toString();
		data['isCollect'] = this.isCollect.toString();
		return data;
	}
}
