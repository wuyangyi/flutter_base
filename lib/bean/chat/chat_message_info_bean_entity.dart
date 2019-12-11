
//{
// "emotion":
// {
// "robotEmotion":{
// "a":0,
// "d":0,
// "emotionId":0,
// "p":0
// },
// "userEmotion":{
// "a":0,
// "d":0,"emotionId":21500,"p":0}},"intent":{"actionName":"","code":10004,"intentName":""},"results":[{"groupType":1,"resultType":"text","values":{"text":"我是小黑，就是那位人见人爱花见花开的小黑。"}}]}

class ChatMessageInfoBeanEntity {
	ChatMessageInfoBeanEmotion emotion;
	ChatMessageInfoBeanIntent intent;
	List<ChatMessageInfoBeanResult> results;

	ChatMessageInfoBeanEntity({this.emotion, this.intent, this.results});

	ChatMessageInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		emotion = json['emotion'] != null ? new ChatMessageInfoBeanEmotion.fromJson(json['emotion']) : null;
		intent = json['intent'] != null ? new ChatMessageInfoBeanIntent.fromJson(json['intent']) : null;
		if (json['results'] != null) {
			results = new List<ChatMessageInfoBeanResult>();(json['results'] as List).forEach((v) { results.add(new ChatMessageInfoBeanResult.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.emotion != null) {
      data['emotion'] = this.emotion.toJson();
    }
		if (this.intent != null) {
      data['intent'] = this.intent.toJson();
    }
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class ChatMessageInfoBeanEmotion {
	ChatMessageInfoBeanEmotionRobotemotion robotEmotion;
	ChatMessageInfoBeanEmotionUseremotion userEmotion;

	ChatMessageInfoBeanEmotion({this.robotEmotion, this.userEmotion});

	ChatMessageInfoBeanEmotion.fromJson(Map<String, dynamic> json) {
		robotEmotion = json['robotEmotion'] != null ? new ChatMessageInfoBeanEmotionRobotemotion.fromJson(json['robotEmotion']) : null;
		userEmotion = json['userEmotion'] != null ? new ChatMessageInfoBeanEmotionUseremotion.fromJson(json['userEmotion']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.robotEmotion != null) {
      data['robotEmotion'] = this.robotEmotion.toJson();
    }
		if (this.userEmotion != null) {
      data['userEmotion'] = this.userEmotion.toJson();
    }
		return data;
	}
}

class ChatMessageInfoBeanEmotionRobotemotion {
	int p;
	int a;
	int d;
	int emotionId;

	ChatMessageInfoBeanEmotionRobotemotion({this.p, this.a, this.d, this.emotionId});

	ChatMessageInfoBeanEmotionRobotemotion.fromJson(Map<String, dynamic> json) {
		p = json['p'];
		a = json['a'];
		d = json['d'];
		emotionId = json['emotionId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['p'] = this.p;
		data['a'] = this.a;
		data['d'] = this.d;
		data['emotionId'] = this.emotionId;
		return data;
	}
}

class ChatMessageInfoBeanEmotionUseremotion {
	int p;
	int a;
	int d;
	int emotionId;

	ChatMessageInfoBeanEmotionUseremotion({this.p, this.a, this.d, this.emotionId});

	ChatMessageInfoBeanEmotionUseremotion.fromJson(Map<String, dynamic> json) {
		p = json['p'];
		a = json['a'];
		d = json['d'];
		emotionId = json['emotionId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['p'] = this.p;
		data['a'] = this.a;
		data['d'] = this.d;
		data['emotionId'] = this.emotionId;
		return data;
	}
}

class ChatMessageInfoBeanIntent {
	int code;
	String intentName;
	String actionName;

	ChatMessageInfoBeanIntent({this.code, this.intentName, this.actionName});

	ChatMessageInfoBeanIntent.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		intentName = json['intentName'];
		actionName = json['actionName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['intentName'] = this.intentName;
		data['actionName'] = this.actionName;
		return data;
	}
}

class ChatMessageInfoBeanResult {
	int groupType;
	ChatMessageInfoBeanResultsValues values;
	String resultType;

	ChatMessageInfoBeanResult({this.groupType, this.values, this.resultType});

	ChatMessageInfoBeanResult.fromJson(Map<String, dynamic> json) {
		groupType = json['groupType'];
		values = json['values'] != null ? new ChatMessageInfoBeanResultsValues.fromJson(json['values']) : null;
		resultType = json['resultType'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['groupType'] = this.groupType;
		if (this.values != null) {
      data['values'] = this.values.toJson();
    }
		data['resultType'] = this.resultType;
		return data;
	}
}

class ChatMessageInfoBeanResultsValues {
	String text;
	String url;

	ChatMessageInfoBeanResultsValues({this.text, this.url});

	ChatMessageInfoBeanResultsValues.fromJson(Map<String, dynamic> json) {
		text = json['text'];
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['text'] = this.text;
		return data;
	}
}
