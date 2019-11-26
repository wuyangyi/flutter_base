import '../base_bean.dart';

class MusicSingerBeanEntity {
	int perPage;
	int total;
	int totalPage;
	List<MusicSingerBeanList> xList;

	MusicSingerBeanEntity({this.perPage, this.total, this.totalPage, this.xList});

	MusicSingerBeanEntity.fromJson(Map<String, dynamic> json) {
		perPage = json['per_page'];
		total = json['total'];
		totalPage = json['total_page'];
		if (json['list'] != null) {
			xList = new List<MusicSingerBeanList>();(json['list'] as List).forEach((v) { xList.add(new MusicSingerBeanList.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['per_page'] = this.perPage;
		data['total'] = this.total;
		data['total_page'] = this.totalPage;
		if (this.xList != null) {
      data['list'] =  this.xList.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class MusicSingerBeanList extends BaseBean {
	String findex;
	String fsingerMid;
	String fotherName;
	String voc;
	String fattribute3;
	String ftype;
	String fattribute4;
	String fgenre;
	String fsingerName;
	String fsort;
	String fsingerTag;
	String farea;
	String fsingerId;
	String ftrend;

	MusicSingerBeanList({this.findex, this.fsingerMid, this.fotherName, this.voc, this.fattribute3, this.ftype, this.fattribute4, this.fgenre, this.fsingerName, this.fsort, this.fsingerTag, this.farea, this.fsingerId, this.ftrend});

	MusicSingerBeanList.fromJson(Map<String, dynamic> json) {
		findex = json['Findex'];
		fsingerMid = json['Fsinger_mid'];
		fotherName = json['Fother_name'];
		voc = json['voc'];
		fattribute3 = json['Fattribute_3'];
		ftype = json['Ftype'];
		fattribute4 = json['Fattribute_4'];
		fgenre = json['Fgenre'];
		fsingerName = json['Fsinger_name'];
		fsort = json['Fsort'];
		fsingerTag = json['Fsinger_tag'];
		farea = json['Farea'];
		fsingerId = json['Fsinger_id'];
		ftrend = json['Ftrend'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['Findex'] = this.findex;
		data['Fsinger_mid'] = this.fsingerMid;
		data['Fother_name'] = this.fotherName;
		data['voc'] = this.voc;
		data['Fattribute_3'] = this.fattribute3;
		data['Ftype'] = this.ftype;
		data['Fattribute_4'] = this.fattribute4;
		data['Fgenre'] = this.fgenre;
		data['Fsinger_name'] = this.fsingerName;
		data['Fsort'] = this.fsort;
		data['Fsinger_tag'] = this.fsingerTag;
		data['Farea'] = this.farea;
		data['Fsinger_id'] = this.fsingerId;
		data['Ftrend'] = this.ftrend;
		return data;
	}
}
