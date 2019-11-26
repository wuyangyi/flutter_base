/*
 * 推荐
 */
import '../base_bean.dart';

class RecommendBeanData extends BaseBean {
	List<RecommandBeanDataSlider> slider;
	List<RecommandBeanDataSonglist> songList;
	List<RecommandBeanDataRadiolist> radioList;

	RecommendBeanData({this.slider, this.songList, this.radioList});

	RecommendBeanData.fromJson(Map<String, dynamic> json) {
		if (json['slider'] != null) {
			slider = new List<RecommandBeanDataSlider>();(json['slider'] as List).forEach((v) { slider.add(new RecommandBeanDataSlider.fromJson(v)); });
		}
		if (json['songList'] != null) {
			songList = new List<RecommandBeanDataSonglist>();(json['songList'] as List).forEach((v) { songList.add(new RecommandBeanDataSonglist.fromJson(v)); });
		}
		if (json['radioList'] != null) {
			radioList = new List<RecommandBeanDataRadiolist>();(json['radioList'] as List).forEach((v) { radioList.add(new RecommandBeanDataRadiolist.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.slider != null) {
      data['slider'] =  this.slider.map((v) => v.toJson()).toList();
    }
		if (this.songList != null) {
      data['songList'] =  this.songList.map((v) => v.toJson()).toList();
    }
		if (this.radioList != null) {
      data['radioList'] =  this.radioList.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class RecommandBeanDataSlider {
	String picUrl;
	String linkUrl;
	int id;

	RecommandBeanDataSlider({this.picUrl, this.linkUrl, this.id});

	RecommandBeanDataSlider.fromJson(Map<String, dynamic> json) {
		picUrl = json['picUrl'];
		linkUrl = json['linkUrl'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['picUrl'] = this.picUrl;
		data['linkUrl'] = this.linkUrl;
		data['id'] = this.id;
		return data;
	}
}

class RecommandBeanDataSonglist {
	String picUrl;
	String songListDesc;
	String picMid;
	String id;
	String songListAuthor;
	int accessnum;
	String albumPicMid;

	RecommandBeanDataSonglist({this.picUrl, this.songListDesc, this.picMid, this.id, this.songListAuthor, this.accessnum, this.albumPicMid});

	RecommandBeanDataSonglist.fromJson(Map<String, dynamic> json) {
		picUrl = json['picUrl'];
		songListDesc = json['songListDesc'];
		picMid = json['pic_mid'];
		id = json['id'];
		songListAuthor = json['songListAuthor'];
		accessnum = json['accessnum'];
		albumPicMid = json['album_pic_mid'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['picUrl'] = this.picUrl;
		data['songListDesc'] = this.songListDesc;
		data['pic_mid'] = this.picMid;
		data['id'] = this.id;
		data['songListAuthor'] = this.songListAuthor;
		data['accessnum'] = this.accessnum;
		data['album_pic_mid'] = this.albumPicMid;
		return data;
	}
}

class RecommandBeanDataRadiolist {
	String picUrl;
	String ftitle;
	int radioid;

	RecommandBeanDataRadiolist({this.picUrl, this.ftitle, this.radioid});

	RecommandBeanDataRadiolist.fromJson(Map<String, dynamic> json) {
		picUrl = json['picUrl'];
		ftitle = json['Ftitle'];
		radioid = json['radioid'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['picUrl'] = this.picUrl;
		data['Ftitle'] = this.ftitle;
		data['radioid'] = this.radioid;
		return data;
	}
}
