class ReadBookContentInfoBeanEntity {
	ReadBookContentInfoBeanChapter chapter;
	bool ok;

	ReadBookContentInfoBeanEntity({this.chapter, this.ok});

	ReadBookContentInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		chapter = json['chapter'] != null ? new ReadBookContentInfoBeanChapter.fromJson(json['chapter']) : null;
		ok = json['ok'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.chapter != null) {
      data['chapter'] = this.chapter.toJson();
    }
		data['ok'] = this.ok;
		return data;
	}
}

class ReadBookContentInfoBeanChapter {
	String created;
	String cpContent;
	int currency;
	String id;
	String title;
	String body;
	String updated;
	bool isVip;
	int order;

	ReadBookContentInfoBeanChapter({this.created, this.cpContent, this.currency, this.id, this.title, this.body, this.updated, this.isVip, this.order});

	ReadBookContentInfoBeanChapter.fromJson(Map<String, dynamic> json) {
		created = json['created'];
		cpContent = json['cpContent'];
		currency = json['currency'];
		id = json['id'];
		title = json['title'];
		body = json['body'];
		updated = json['updated'];
		isVip = json['isVip'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['created'] = this.created;
		data['cpContent'] = this.cpContent;
		data['currency'] = this.currency;
		data['id'] = this.id;
		data['title'] = this.title;
		data['body'] = this.body;
		data['updated'] = this.updated;
		data['isVip'] = this.isVip;
		data['order'] = this.order;
		return data;
	}
}
