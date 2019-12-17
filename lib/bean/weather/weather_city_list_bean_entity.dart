class WeatherCityListBeanEntity {
	List<WeatherCityListBeanCity> citys;

	WeatherCityListBeanEntity({this.citys});

	WeatherCityListBeanEntity.fromJson(Map<String, dynamic> json) {
		if (json['citys'] != null) {
			citys = new List<WeatherCityListBeanCity>();(json['citys'] as List).forEach((v) { citys.add(new WeatherCityListBeanCity.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.citys != null) {
      data['citys'] =  this.citys.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class WeatherCityListBeanCity {
	String cityName;
	String cityCode;
	int pid;
	int iId;
	int id;

	WeatherCityListBeanCity({this.cityName, this.cityCode, this.pid, this.iId, this.id});

	WeatherCityListBeanCity.fromJson(Map<String, dynamic> json) {
		cityName = json['city_name'];
		cityCode = json['city_code'];
		pid = json['pid'];
		iId = json['_id'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['city_name'] = this.cityName;
		data['city_code'] = this.cityCode;
		data['pid'] = this.pid;
		data['_id'] = this.iId;
		data['id'] = this.id;
		return data;
	}
}
