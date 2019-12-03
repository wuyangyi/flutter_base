class RunInfoBeanEntity {
	int userId;
	double path;
	String endDate;
	int startTime;
	int endTime;
	int walkNumber;
	int time;
	String startDate;
	String week;
	int year; //年
	int month; //月
	int day;

	RunInfoBeanEntity({this.path, this.endDate, this.startTime, this.endTime, this.walkNumber, this.time, this.startDate, this.week, this.year, this.month, this.day});

	void initTime() {
		DateTime nowDate = DateTime.now();
		this.year = nowDate.year;
		this.month = nowDate.month;
		this.day = nowDate.day;
	}

	RunInfoBeanEntity.fromJson(Map<String, dynamic> json) {
		path = json['path'];
		endDate = json['endDate'];
		startTime = json['startTime'];
		endTime = json['endTime'];
		walkNumber = json['walkNumber'];
		time = json['time'];
		startDate = json['startDate'];
		week = json['week'];
		year = json['year'];
		month = json['month'];
		day = json['day'];
		userId = json['user_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['path'] = this.path;
		data['endDate'] = this.endDate;
		data['startTime'] = this.startTime;
		data['endTime'] = this.endTime;
		data['walkNumber'] = this.walkNumber;
		data['time'] = this.time;
		data['startDate'] = this.startDate;
		data['week'] = this.week;
		data['year'] = this.year;
		data['month'] = month;
		data['day'] = day;
		data['user_id'] = userId;
		return data;
	}
}
