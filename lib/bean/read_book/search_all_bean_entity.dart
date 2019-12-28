class SearchAllBeanEntity {
	List<String> keywords;
	bool ok;

	SearchAllBeanEntity({this.keywords, this.ok});

	SearchAllBeanEntity.fromJson(Map<String, dynamic> json) {
		keywords = json['keywords']?.cast<String>();
		ok = json['ok'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['keywords'] = this.keywords;
		data['ok'] = this.ok;
		return data;
	}
}
