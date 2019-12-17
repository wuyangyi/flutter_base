class WeatherBeanEntity {
	String date;
	WeatherBeanData data;
	WeatherBeanCityinfo cityInfo;
	String time;
	String message;
	int status;

	WeatherBeanEntity({this.date, this.data, this.cityInfo, this.time, this.message, this.status});

	WeatherBeanEntity.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		data = json['data'] != null ? new WeatherBeanData.fromJson(json['data']) : null;
		cityInfo = json['cityInfo'] != null ? new WeatherBeanCityinfo.fromJson(json['cityInfo']) : null;
		time = json['time'];
		message = json['message'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		if (this.cityInfo != null) {
      data['cityInfo'] = this.cityInfo.toJson();
    }
		data['time'] = this.time;
		data['message'] = this.message;
		data['status'] = this.status;
		return data;
	}
}

class WeatherBeanData {
	String shidu;
	WeatherBeanDataYesterday yesterday;
	double pm25;
	double pm10;
	String ganmao;
	List<WeatherBeanDataForecast> forecast;
	String wendu;
	String quality;

	WeatherBeanData({this.shidu, this.yesterday, this.pm25, this.pm10, this.ganmao, this.forecast, this.wendu, this.quality});

	WeatherBeanData.fromJson(Map<String, dynamic> json) {
		shidu = json['shidu'];
		yesterday = json['yesterday'] != null ? new WeatherBeanDataYesterday.fromJson(json['yesterday']) : null;
		pm25 = json['pm25'];
		pm10 = json['pm10'];
		ganmao = json['ganmao'];
		if (json['forecast'] != null) {
			forecast = new List<WeatherBeanDataForecast>();(json['forecast'] as List).forEach((v) { forecast.add(new WeatherBeanDataForecast.fromJson(v)); });
		}
		wendu = json['wendu'];
		quality = json['quality'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['shidu'] = this.shidu;
		if (this.yesterday != null) {
      data['yesterday'] = this.yesterday.toJson();
    }
		data['pm25'] = this.pm25;
		data['pm10'] = this.pm10;
		data['ganmao'] = this.ganmao;
		if (this.forecast != null) {
      data['forecast'] =  this.forecast.map((v) => v.toJson()).toList();
    }
		data['wendu'] = this.wendu;
		data['quality'] = this.quality;
		return data;
	}
}

class WeatherBeanDataYesterday {
	String date;
	String ymd;
	String high;
	String sunrise;
	String fx;
	String week;
	String low;
	String fl;
	String sunset;
	int aqi;
	String type;
	String notice;

	WeatherBeanDataYesterday({this.date, this.ymd, this.high, this.sunrise, this.fx, this.week, this.low, this.fl, this.sunset, this.aqi, this.type, this.notice});

	WeatherBeanDataYesterday.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		ymd = json['ymd'];
		high = json['high'];
		sunrise = json['sunrise'];
		fx = json['fx'];
		week = json['week'];
		low = json['low'];
		fl = json['fl'];
		sunset = json['sunset'];
		aqi = json['aqi'];
		type = json['type'];
		notice = json['notice'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		data['ymd'] = this.ymd;
		data['high'] = this.high;
		data['sunrise'] = this.sunrise;
		data['fx'] = this.fx;
		data['week'] = this.week;
		data['low'] = this.low;
		data['fl'] = this.fl;
		data['sunset'] = this.sunset;
		data['aqi'] = this.aqi;
		data['type'] = this.type;
		data['notice'] = this.notice;
		return data;
	}
}

class WeatherBeanDataForecast {
	String date;
	String ymd;
	String high;
	String sunrise;
	String fx;
	String week;
	String low;
	String fl;
	String sunset;
	int aqi;
	String type;
	String notice;

	WeatherBeanDataForecast({this.date, this.ymd, this.high, this.sunrise, this.fx, this.week, this.low, this.fl, this.sunset, this.aqi, this.type, this.notice});

	WeatherBeanDataForecast.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		ymd = json['ymd'];
		high = json['high'];
		sunrise = json['sunrise'];
		fx = json['fx'];
		week = json['week'];
		low = json['low'];
		fl = json['fl'];
		sunset = json['sunset'];
		aqi = json['aqi'];
		type = json['type'];
		notice = json['notice'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		data['ymd'] = this.ymd;
		data['high'] = this.high;
		data['sunrise'] = this.sunrise;
		data['fx'] = this.fx;
		data['week'] = this.week;
		data['low'] = this.low;
		data['fl'] = this.fl;
		data['sunset'] = this.sunset;
		data['aqi'] = this.aqi;
		data['type'] = this.type;
		data['notice'] = this.notice;
		return data;
	}
}

class WeatherBeanCityinfo {
	String parent;
	String city;
	String citykey;
	String updateTime;

	WeatherBeanCityinfo({this.parent, this.city, this.citykey, this.updateTime});

	WeatherBeanCityinfo.fromJson(Map<String, dynamic> json) {
		parent = json['parent'];
		city = json['city'];
		citykey = json['citykey'];
		updateTime = json['updateTime'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['parent'] = this.parent;
		data['city'] = this.city;
		data['citykey'] = this.citykey;
		data['updateTime'] = this.updateTime;
		return data;
	}
}
