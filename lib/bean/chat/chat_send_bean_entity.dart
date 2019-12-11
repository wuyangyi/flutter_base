class ChatSendBeanEntity {
	ChatSendBeanUserinfo userInfo;
	int reqType;
	ChatSendBeanPerception perception;

	ChatSendBeanEntity({this.userInfo, this.reqType, this.perception});

	ChatSendBeanEntity.fromJson(Map<String, dynamic> json) {
		userInfo = json['userInfo'] != null ? new ChatSendBeanUserinfo.fromJson(json['userInfo']) : null;
		reqType = json['reqType'];
		perception = json['perception'] != null ? new ChatSendBeanPerception.fromJson(json['perception']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
		data['reqType'] = this.reqType;
		if (this.perception != null) {
      data['perception'] = this.perception.toJson();
    }
		return data;
	}

	String toString() {
		return "{" +
				"\"userInfo\":\"" + userInfo.toString() + "\"" +
				", \"reqType\":" + reqType.toString() +
				"\"perception\":\"" + perception.toString() + "\"" +
				"}";
	}
}

class ChatSendBeanUserinfo {
	String apiKey;  //机器人标识
	String userId;  //用户唯一标识

	ChatSendBeanUserinfo({this.apiKey, this.userId});

	ChatSendBeanUserinfo.fromJson(Map<String, dynamic> json) {
		apiKey = json['apiKey'];
		userId = json['userId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['apiKey'] = this.apiKey;
		data['userId'] = this.userId;
		return data;
	}

	String toString() {
		return "{" +
				"\"apiKey\":\"" + apiKey + "\"" +
				", \"userId\":\"" + userId + "\"" +
				"}";
	}
}

class ChatSendBeanPerception {
	ChatSendBeanPerceptionSelfinfo selfInfo;
	ChatSendBeanPerceptionInputmedia inputMedia;
	ChatSendBeanPerceptionInputtext inputText;
	ChatSendBeanPerceptionInputimage inputImage;

	ChatSendBeanPerception({this.selfInfo, this.inputMedia, this.inputText, this.inputImage});

	ChatSendBeanPerception.fromJson(Map<String, dynamic> json) {
		selfInfo = json['selfInfo'] != null ? new ChatSendBeanPerceptionSelfinfo.fromJson(json['selfInfo']) : null;
		inputMedia = json['inputMedia'] != null ? new ChatSendBeanPerceptionInputmedia.fromJson(json['inputMedia']) : null;
		inputText = json['inputText'] != null ? new ChatSendBeanPerceptionInputtext.fromJson(json['inputText']) : null;
		inputImage = json['inputImage'] != null ? new ChatSendBeanPerceptionInputimage.fromJson(json['inputImage']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.selfInfo != null) {
      data['selfInfo'] = this.selfInfo.toJson();
    }
		if (this.inputMedia != null) {
      data['inputMedia'] = this.inputMedia.toJson();
    }
		if (this.inputText != null) {
      data['inputText'] = this.inputText.toJson();
    }
		if (this.inputImage != null) {
      data['inputImage'] = this.inputImage.toJson();
    }
		return data;
	}

	String toString() {
		return "{" +
				"\"selfInfo\":\"" + selfInfo.toString() + "\"" +
//				", \"inputMedia\":\"" + inputMedia.toString() + "\"" +
				", \"inputText\":\"" + inputText.toString() + "\"" +
//				", \"inputImage\":\"" + inputImage.toString() + "\"" +
				"}";
	}
}

class ChatSendBeanPerceptionSelfinfo {
	ChatSendBeanPerceptionSelfinfoLocation location;

	ChatSendBeanPerceptionSelfinfo({this.location});

	ChatSendBeanPerceptionSelfinfo.fromJson(Map<String, dynamic> json) {
		location = json['location'] != null ? new ChatSendBeanPerceptionSelfinfoLocation.fromJson(json['location']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.location != null) {
      data['location'] = this.location.toJson();
    }
		return data;
	}

	String toString() {
		return "{" +
				"\"location\":\"" + location.toString() + "\"" +
				"}";
	}
}

class ChatSendBeanPerceptionSelfinfoLocation {
	String province;
	String city;
	String street;

	ChatSendBeanPerceptionSelfinfoLocation({this.province, this.city, this.street});

	ChatSendBeanPerceptionSelfinfoLocation.fromJson(Map<String, dynamic> json) {
		province = json['province'];
		city = json['city'];
		street = json['street'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['province'] = this.province;
		data['city'] = this.city;
		data['street'] = this.street;
		return data;
	}

	String toString() {
		return "{" +
				"\"province\":\"" + province + "\"" +
				", \"city\":\"" + city + "\"" +
				", \"street\":\"" + street + "\"" +
				"}";
	}
}

class ChatSendBeanPerceptionInputmedia {
	String url;

	ChatSendBeanPerceptionInputmedia({this.url});

	ChatSendBeanPerceptionInputmedia.fromJson(Map<String, dynamic> json) {
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['url'] = this.url;
		return data;
	}

	String toString() {
		return "{" +
				"\"url\":\"" + url + "\"" +
				"}";
	}
}

class ChatSendBeanPerceptionInputtext {
	String text;

	ChatSendBeanPerceptionInputtext({this.text});

	ChatSendBeanPerceptionInputtext.fromJson(Map<String, dynamic> json) {
		text = json['text'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['text'] = this.text;
		return data;
	}

	String toString() {
		return "{" +
				"\"text\":\"" + text + "\"" +
				"}";
	}
}

class ChatSendBeanPerceptionInputimage {
	String url;

	ChatSendBeanPerceptionInputimage({this.url});

	ChatSendBeanPerceptionInputimage.fromJson(Map<String, dynamic> json) {
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['url'] = this.url;
		return data;
	}

	String toString() {
		return "{" +
				"\"url\":\"" + url + "\"" +
				"}";
	}
}
