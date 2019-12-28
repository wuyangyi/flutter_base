//分类二级标题
class ClassifyBeanTwoEntity {
	List<ClassifyBeanTwoFemale> female;
	List<ClassifyBeanTwoFemale> press;
	bool ok;
	List<ClassifyBeanTwoFemale> male;
	List<ClassifyBeanTwoFemale> picture;

	ClassifyBeanTwoEntity({this.female, this.press, this.ok, this.male, this.picture});

	ClassifyBeanTwoEntity.fromJson(Map<String, dynamic> json) {
		if (json['female'] != null) {
			female = new List<ClassifyBeanTwoFemale>();(json['female'] as List).forEach((v) { female.add(new ClassifyBeanTwoFemale.fromJson(v)); });
		}
		if (json['press'] != null) {
			press = new List<ClassifyBeanTwoFemale>();(json['press'] as List).forEach((v) { press.add(new ClassifyBeanTwoFemale.fromJson(v)); });
		}
		ok = json['ok'];
		if (json['male'] != null) {
			male = new List<ClassifyBeanTwoFemale>();(json['male'] as List).forEach((v) { male.add(new ClassifyBeanTwoFemale.fromJson(v)); });
		}
		if (json['picture'] != null) {
			picture = new List<ClassifyBeanTwoFemale>();(json['picture'] as List).forEach((v) { picture.add(new ClassifyBeanTwoFemale.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.female != null) {
      data['female'] =  this.female.map((v) => v.toJson()).toList();
    }
		if (this.press != null) {
      data['press'] =  this.press.map((v) => v.toJson()).toList();
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

class ClassifyBeanTwoFemale {
	List<String> mins;
	String major;

	ClassifyBeanTwoFemale({this.mins, this.major});

	ClassifyBeanTwoFemale.fromJson(Map<String, dynamic> json) {
		mins = json['mins']?.cast<String>();
		major = json['major'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['mins'] = this.mins;
		data['major'] = this.major;
		return data;
	}
}
