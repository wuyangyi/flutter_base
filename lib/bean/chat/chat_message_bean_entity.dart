class ChatMessageBeanEntity {
	ChatMessageBeanIntent intent;
	List<ChatMessageBeanResult> results;

	ChatMessageBeanEntity({this.intent, this.results});

	ChatMessageBeanEntity.fromJson(Map<String, dynamic> json) {
		intent = json['intent'] != null ? new ChatMessageBeanIntent.fromJson(json['intent']) : null;
		if (json['results'] != null) {
			results = new List<ChatMessageBeanResult>();(json['results'] as List).forEach((v) { results.add(new ChatMessageBeanResult.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.intent != null) {
      data['intent'] = this.intent.toJson();
    }
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class ChatMessageBeanIntent {
	int code;
	String intentName;
	ChatMessageBeanIntentParameters parameters;
	String actionName;

	ChatMessageBeanIntent({this.code, this.intentName, this.parameters, this.actionName});

	ChatMessageBeanIntent.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		intentName = json['intentName'];
		parameters = json['parameters'] != null ? new ChatMessageBeanIntentParameters.fromJson(json['parameters']) : null;
		actionName = json['actionName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['intentName'] = this.intentName;
		if (this.parameters != null) {
      data['parameters'] = this.parameters.toJson();
    }
		data['actionName'] = this.actionName;
		return data;
	}
}

class ChatMessageBeanIntentParameters {
	String nearbyPlace;

	ChatMessageBeanIntentParameters({this.nearbyPlace});

	ChatMessageBeanIntentParameters.fromJson(Map<String, dynamic> json) {
		nearbyPlace = json['nearby_place'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['nearby_place'] = this.nearbyPlace;
		return data;
	}
}

class ChatMessageBeanResult {
	int groupType;
	Map<String, String> values;
	String resultType;

	ChatMessageBeanResult({this.groupType, this.values, this.resultType});

	ChatMessageBeanResult.fromJson(Map<String, dynamic> json) {
		groupType = json['groupType'];
		values = json['values'] != null ? new Map<String, dynamic>.from(json['values']) : null;
		resultType = json['resultType'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['groupType'] = this.groupType;
		if (this.values != null) {
      data['values'] = this.values;
    }
		data['resultType'] = this.resultType;
		return data;
	}
}

