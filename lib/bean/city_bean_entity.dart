import 'package:azlistview/azlistview.dart';

class CityBeanEntity {
	List<CityBeanProvincelist> provinceList;
	int errCode;
	String errMsg;

	CityBeanEntity({this.provinceList, this.errCode, this.errMsg});

	CityBeanEntity.fromJson(Map<String, dynamic> json) {
		if (json['provinceList'] != null) {
			provinceList = new List<CityBeanProvincelist>();(json['provinceList'] as List).forEach((v) { provinceList.add(new CityBeanProvincelist.fromJson(v)); });
		}
		errCode = json['errCode'];
		errMsg = json['errMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.provinceList != null) {
      data['provinceList'] =  this.provinceList.map((v) => v.toJson()).toList();
    }
		data['errCode'] = this.errCode;
		data['errMsg'] = this.errMsg;
		return data;
	}
}

class CityBeanProvincelist {
	String name;
	String id;
	List<CityBeanProvincelistCitylist> cityList;

	CityBeanProvincelist({this.name, this.id, this.cityList});

	CityBeanProvincelist.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		id = json['id'];
		if (json['cityList'] != null) {
			cityList = new List<CityBeanProvincelistCitylist>();(json['cityList'] as List).forEach((v) { cityList.add(new CityBeanProvincelistCitylist.fromJson(v, topTitle: name)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['id'] = this.id;
		if (this.cityList != null) {
      data['cityList'] =  this.cityList.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class CityBeanProvincelistCitylist extends ISuspensionBean {
	List<CityBeanProvincelistCitylistCountylist> countyList;
	String name;
	String id;
	String topTitle; //顶部显示的标题，及所在省

	CityBeanProvincelistCitylist({this.countyList, this.name, this.id});

	CityBeanProvincelistCitylist.fromJson(Map<String, dynamic> json, {String topTitle}) {
		if (json['countyList'] != null) {
			countyList = new List<CityBeanProvincelistCitylistCountylist>();(json['countyList'] as List).forEach((v) { countyList.add(new CityBeanProvincelistCitylistCountylist.fromJson(v)); });
		}
		name = json['name'];
		id = json['id'];
		this.topTitle = topTitle;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.countyList != null) {
      data['countyList'] =  this.countyList.map((v) => v.toJson()).toList();
    }
		data['name'] = this.name;
		data['id'] = this.id;
		return data;
	}

  @override
  String getSuspensionTag() {
    return topTitle;
  }
}

class CityBeanProvincelistCitylistCountylist {
	String name;
	String id;

	CityBeanProvincelistCitylistCountylist({this.name, this.id});

	CityBeanProvincelistCitylistCountylist.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['id'] = this.id;
		return data;
	}
}
