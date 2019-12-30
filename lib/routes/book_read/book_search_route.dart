import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/read_book/ReadBookSearchHistoryDao.dart';
import 'package:flutter_base/bean/read_book/hot_search_bean_entity.dart';
import 'package:flutter_base/bean/read_book/search_book_bean_entity.dart';
import 'package:flutter_base/net/network.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/search_book_item.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';

class BookSearchRoute extends BaseRoute {
  @override
  _BookSearchRouteState createState() => _BookSearchRouteState();
}

class _BookSearchRouteState extends BaseRouteState<BookSearchRoute> {

  _BookSearchRouteState(){
    needAppBar = false;
    resizeToAvoidBottomInset = false;
  }

  bool isShowClear = false; //是否显示清除
  bool showAssociateSearch = false;//显示联想搜索词
  bool showBook = false; //显示搜索后的书

  TextEditingController _textEditingController = new TextEditingController();
  List<HotSearchBeanSearchhotword> hotKey = [];
  List<HotSearchBeanSearchhotword> historyKey = [];
  List<String> autoSearch = []; // 搜索自动补充
  List<SearchBookBeanBook> searchBook = []; //模糊搜索到的书
  int status = Status.success;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    await NetClickUtil().getHotSearch(callBack: (data){
      setState(() {
        hotKey = data;
      });
    });
    await ReadBookSearchHistoryDao().findAllData(callBack: (data){
      setState(() {
        historyKey = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void addHistoryData(HotSearchBeanSearchhotword data) {
    bool has = false;
    historyKey.forEach((item){
      if (item.word == data.word) {
        has = true;
      }
    });
    if (!has) {
      setState(() {
        historyKey.add(data);
      });
    }
  }

  void doGetAutoSearch(String value) async {
    autoSearch.clear();
    NetClickUtil().getSearchAutoComplete(value, callBack: (List<String> data){
      setState(() {
        autoSearch.addAll(data);
        if (autoSearch.isNotEmpty) {
          showAssociateSearch = true;
        } else {
          showAssociateSearch = false;
        }
      });
    });
  }

  //搜索书
  void doSearchBook(String value) async {
    hideSoftInput();
    setState(() {
      status = Status.loading;
    });
    searchBook.clear();
    NetClickUtil().getSearchBook(value, callBack: (SearchBookBeanEntity data){
      searchBook.addAll(data.books);
      setState(() {
        showBook = true;
        if (searchBook.isEmpty) {
          status = Status.empty;
        } else {
          status = Status.success;
        }
      });
    });
  }

  @override
  void onLeftButtonClick() {
    if (showBook) {
      hideSoftInput();
      setState(() {
        showBook = false;
      });
    } else {
      super.onLeftButtonClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showBook) {
          hideSoftInput();
          setState(() {
            showBook = false;
          });
          return false;
        }
        return true;
      },
      child: buildBody(context,
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
                                showBook = false;
                              });
                              doGetAutoSearch(value);
                            },
                            onSubmitted: (value) async { //点击搜索
                              if (value.isNotEmpty) {
                                HotSearchBeanSearchhotword data = new HotSearchBeanSearchhotword(word: value, times: 1, isNew: 0, soaring: 0);
                                await ReadBookSearchHistoryDao().saveData(data);
                                addHistoryData(data);
                                doSearchBook(value);
                                showAssociateSearch = false;
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
                                showBook = false;
                                showAssociateSearch = false;
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
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
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
                                        await ReadBookSearchHistoryDao().removeAll();
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
                                _textEditingController.text = item.word;
                                await ReadBookSearchHistoryDao().saveData(item);
                                addHistoryData(item);
                                setState(() {
                                  isShowClear = true;
                                });
                                doSearchBook(item.word);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 4.5),
                                decoration: BoxDecoration(
                                  color: MyColors.search_bg_color,
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Text(
                                  item.word,
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
                                _textEditingController.text = item.word;
                                await ReadBookSearchHistoryDao().saveData(item);
                                addHistoryData(item);
                                setState(() {
                                  isShowClear = true;
                                });
                                doSearchBook(item.word);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 4.5),
                                decoration: BoxDecoration(
                                  color: MyColors.search_bg_color,
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Text(
                                  item.word,
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

                  //联想搜索
                  Offstage(
                    offstage: !showAssociateSearch,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: ListView.separated(
                        padding: EdgeInsets.all(0.0),
                        separatorBuilder: (context, index){
                          return Container(
                            width: double.infinity,
                            height: 0.5,
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            color: MyColors.loginDriverColor,
                          );
                        },
                        itemCount: autoSearch.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            onTap: () async {
                              _textEditingController.text = autoSearch[index];
                              HotSearchBeanSearchhotword hotSearch = HotSearchBeanSearchhotword(
                                word: autoSearch[index],
                                times: 0,
                                soaring: 0,
                                isNew: 0,
                              );
                              await ReadBookSearchHistoryDao().saveData(hotSearch);
                              addHistoryData(hotSearch);
                              setState(() {
                                isShowClear = true;
                                showAssociateSearch = false;
                              });
                              doSearchBook(autoSearch[index]);
                            },
                            title: Text(
                              autoSearch[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: MyColors.title_color,
                                fontSize: 14.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 10.0),
                          );
                        },
                      ),
                    ),
                  ),

                  //搜索后的结果
                  Offstage(
                    offstage: !showBook,
                    child: status != Status.success ? StatusView(
                      status: status,
                      enableEmptyClick: false,
                    ) : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        physics: BouncingScrollPhysics(),
                        itemCount: searchBook.length + 1,
                        itemBuilder: (context, index){
                          return index < searchBook.length ? SearchBookItem(searchBook[index]) : ListBottomLine();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
