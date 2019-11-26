import '../base_bean.dart';

class MusicSearchHotKeyEntity {
	List<MusicSearchHotKeyHotkey> hotkey;
	String specialKey;
	String specialUrl;

	MusicSearchHotKeyEntity({this.hotkey, this.specialKey, this.specialUrl});

	MusicSearchHotKeyEntity.fromJson(Map<String, dynamic> json) {
		if (json['hotkey'] != null) {
			hotkey = new List<MusicSearchHotKeyHotkey>();(json['hotkey'] as List).forEach((v) { hotkey.add(new MusicSearchHotKeyHotkey.fromJson(v)); });
		}
		specialKey = json['special_key'];
		specialUrl = json['special_url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.hotkey != null) {
      data['hotkey'] =  this.hotkey.map((v) => v.toJson()).toList();
    }
		data['special_key'] = this.specialKey;
		data['special_url'] = this.specialUrl;
		return data;
	}
}

class MusicSearchHotKeyHotkey extends BaseBean {
	String k;
	int n;

	MusicSearchHotKeyHotkey({this.k, this.n});

	MusicSearchHotKeyHotkey.fromJson(Map<String, dynamic> json) {
		k = json['k'];
		n = json['n'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['k'] = this.k;
		data['n'] = this.n;
		return data;
	}
}
