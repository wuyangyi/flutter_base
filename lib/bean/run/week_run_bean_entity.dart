class WeekRunBeanEntity {
	String week;
	double distance;

	WeekRunBeanEntity({this.week, this.distance});

	WeekRunBeanEntity.fromJson(Map<String, dynamic> json) {
		week = json['week'];
		distance = json['distance'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['week'] = this.week;
		data['distance'] = this.distance;
		return data;
	}
}
