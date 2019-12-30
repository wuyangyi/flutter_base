class BookRealInfoBeanEntity {
	String name;
	String link;
	String host;
	int chaptersCount;
	bool isCharge;
	String sId;
	String source;
	bool starting;
	String lastChapter;
	String updated;

	BookRealInfoBeanEntity({this.name, this.link, this.host, this.chaptersCount, this.isCharge, this.sId, this.source, this.starting, this.lastChapter, this.updated});

	BookRealInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		link = json['link'];
		host = json['host'];
		chaptersCount = json['chaptersCount'];
		isCharge = json['isCharge'];
		sId = json['_id'];
		source = json['source'];
		starting = json['starting'];
		lastChapter = json['lastChapter'];
		updated = json['updated'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['link'] = this.link;
		data['host'] = this.host;
		data['chaptersCount'] = this.chaptersCount;
		data['isCharge'] = this.isCharge;
		data['_id'] = this.sId;
		data['source'] = this.source;
		data['starting'] = this.starting;
		data['lastChapter'] = this.lastChapter;
		data['updated'] = this.updated;
		return data;
	}
}
