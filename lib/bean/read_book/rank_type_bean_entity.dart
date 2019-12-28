//排行榜类型
class RankTypeBeanEntity {
	List<RankTypeBeanFemale> epub;
	List<RankTypeBeanFemale> female;
	bool ok;
	List<RankTypeBeanFemale> male;
	List<RankTypeBeanFemale> picture;

	RankTypeBeanEntity({this.epub, this.female, this.ok, this.male, this.picture});

	RankTypeBeanEntity.fromJson(Map<String, dynamic> json) {
		if (json['epub'] != null) {
			epub = new List<RankTypeBeanFemale>();(json['epub'] as List).forEach((v) { epub.add(new RankTypeBeanFemale.fromJson(v)); });
		}
		if (json['female'] != null) {
			female = new List<RankTypeBeanFemale>();(json['female'] as List).forEach((v) { female.add(new RankTypeBeanFemale.fromJson(v)); });
		}
		ok = json['ok'];
		if (json['male'] != null) {
			male = new List<RankTypeBeanFemale>();(json['male'] as List).forEach((v) { male.add(new RankTypeBeanFemale.fromJson(v)); });
		}
		if (json['picture'] != null) {
			picture = new List<RankTypeBeanFemale>();(json['picture'] as List).forEach((v) { picture.add(new RankTypeBeanFemale.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.epub != null) {
      data['epub'] =  this.epub.map((v) => v.toJson()).toList();
    }
		if (this.female != null) {
      data['female'] =  this.female.map((v) => v.toJson()).toList();
    }
		data['ok'] = this.ok;
		if (this.male != null) {
      data['male'] =  this.male.map((v) => v.toJson()).toList();
    }
		if (this.picture != null) {
      data['picture'] =  this.picture.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class RankTypeBeanFemale {
	String cover;
	String totalRank;
	String monthRank;
	String sId;
	String shortTitle;
	String title;
	bool collapse;

	RankTypeBeanFemale({this.cover, this.totalRank, this.monthRank, this.sId, this.shortTitle, this.title, this.collapse});

	RankTypeBeanFemale.fromJson(Map<String, dynamic> json) {
		cover = json['cover'];
		totalRank = json['totalRank'];
		monthRank = json['monthRank'];
		sId = json['_id'];
		shortTitle = json['shortTitle'];
		title = json['title'];
		collapse = json['collapse'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['cover'] = this.cover;
		data['totalRank'] = this.totalRank;
		data['monthRank'] = this.monthRank;
		data['_id'] = this.sId;
		data['shortTitle'] = this.shortTitle;
		data['title'] = this.title;
		data['collapse'] = this.collapse;
		return data;
	}
}
