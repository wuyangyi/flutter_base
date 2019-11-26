import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/music/MusicSearchHistoryDao.dart';
import 'package:flutter_base/bean/music/music_search_hot_key_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/editview.dart';
import 'package:flutter_base/widgets/widgets.dart';

import 'music_base_route.dart';


class MusicSearchRoute extends MusicBaseRoute {
  @override
  _MusicSearchRouteState createState() => _MusicSearchRouteState();
}

class _MusicSearchRouteState extends MusicBaseRouteState<MusicSearchRoute> {

  _MusicSearchRouteState(){
    needAppBar = false;
    resizeToAvoidBottomInset = false;
  }

  bool isShowClear = false; //是否显示清除

  TextEditingController _textEditingController = new TextEditingController();
  List<MusicSearchHotKeyHotkey> hotKey = [];
  List<MusicSearchHotKeyHotkey> historyKey = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    await MusicSearchHistoryDao().findAllData(
      callBack: (data){
        setState(() {
          historyKey = data;
        });
      }
    );
    await NetClickUtil().getMusicSearchHotKey(callBack: (data){
      setState(() {
        hotKey = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context,
      body: Column(
        children: <Widget>[
          AppStatusBar(
            color: Colors.white,
            buildContext: context,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Image.asset(
                  Util.getImgPath("icon_back_black"),
                  height: 18.0,
                ),
                onPressed: (){
                  onLeftButtonClick();
                },
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: 30.0,
                  margin: EdgeInsets.only(right: 15.0, top: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                    color: MyColors.search_bg_color,
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        alignment: Alignment.center,
                        child: Image.asset(
                          Util.getImgPath("ico_search_gray"),
                          width: 13.0,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _textEditingController,
                          textAlign: TextAlign.left,
                          autofocus: true,
                          style: TextStyle(
                            color: MyColors.text_normal_5,
                            fontSize: 13.0,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration( //外观样式
                            hintText: "请输入搜索内容",
                            border: InputBorder.none, //去除自带的下划线
                            hintMaxLines: 1,
                            contentPadding: EdgeInsets.all(0.0),
                            hintStyle: TextStyle(
                              color: Color(0xFFCBCDD5),
                              fontSize: 13.0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isShowClear = value.isNotEmpty;
                            });
                          },
                          onSubmitted: (value) async { //点击搜索
                            if (value.isNotEmpty) {
                              showToast(value);
                              MusicSearchHotKeyHotkey data = new MusicSearchHotKeyHotkey(k: value, n: 1);
                              await MusicSearchHistoryDao().saveData(data);
                              addHistoryData(data);
                            }
                          },
                        ),
                      ),
                      Offstage(
                        offstage: !isShowClear,
                        child: GestureDetector(
                          child: Image.asset(Util.getImgPath("ico_clear"), width: 17.0, height: 17.0, fit: BoxFit.fill,),
                          onTap: (){
                            setState(() {
                              _textEditingController.clear();
                              isShowClear = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.only(left: 15.0, right: 10.0, bottom: 15.0),
              children: <Widget>[
                Offstage(
                  offstage: historyKey == null || historyKey.isEmpty,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0, top: 10.0,),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "搜索历史",
                          style: TextStyle(
                            color: MyColors.title_color,
                            fontSize: 15.0,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Image.asset(Util.getImgPath("ico_history_clear"), width: 20.0,),
                              onTap: () async {
                                await MusicSearchHistoryDao().removeAll();
                                setState(() {
                                  historyKey.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                historyKey == null || historyKey.isEmpty ? Container() : Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: historyKey.map((item){
                    return GestureDetector(
                      onTap: () async {
                        _textEditingController.text = item.k;
                        await MusicSearchHistoryDao().saveData(item);
                        addHistoryData(item);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 4.5),
                        decoration: BoxDecoration(
                          color: MyColors.search_bg_color,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: Text(
                          item.k,
                          style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 12.0
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                Offstage(
                  offstage: hotKey == null || hotKey.isEmpty,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0, top: 15.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "热门搜索",
                      style: TextStyle(
                        color: MyColors.title_color,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                hotKey == null || hotKey.isEmpty ? Container() : Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: hotKey.map((item){
                    return GestureDetector(
                      onTap: () async {
                        _textEditingController.text = item.k;
                        await MusicSearchHistoryDao().saveData(item);
                        addHistoryData(item);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 4.5),
                        decoration: BoxDecoration(
                          color: MyColors.search_bg_color,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: Text(
                          item.k,
                          style: TextStyle(
                              color: MyColors.text_normal,
                              fontSize: 12.0
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addHistoryData(MusicSearchHotKeyHotkey data) {
    bool has = false;
    historyKey.forEach((item){
      if (item.k == data.k) {
        has = true;
      }
    });
    if (!has) {
      setState(() {
        historyKey.add(data);
      });
    }
  }
}
