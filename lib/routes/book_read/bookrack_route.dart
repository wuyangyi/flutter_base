import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/base/base_route.dart';
import 'package:flutter_base/bean/dao/read_book/BookRackDao.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/config/profilechangenotifier.dart';
import 'package:flutter_base/res/color.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_info_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/status_widget.dart';
import 'package:flutter_base/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BookRackRoute extends BaseRoute {
  final BuildContext parentContext;

  BookRackRoute(this.parentContext);
  @override
  _BookRackRouteState createState() => _BookRackRouteState();
}

class _BookRackRouteState extends BaseRouteState<BookRackRoute> {

  _BookRackRouteState(){
    title = "精品阅读";
    appBarElevation = 2.0;
    titleSize = 18.0;
    leading = Container();
    setRightButtonFromIcon(Icons.access_time);
    bodyColor = MyColors.home_body_bg;
  }

  BookRackModel bookRackModel;

  @override
  void initState() {
    super.initState();
    bookRackModel = Provider.of<BookRackModel>(context, listen: false);
    initData();
  }

  void initData() {
    if(bookRackModel.bookRackList.isEmpty) {
      BookRackDao().findAllData(user.id, callBack: (data){
        bookRackModel.addAll(data);
        setState(() {
          if (bookRackModel.bookRackList.isEmpty) {
            loadStatus = Status.empty;
          } else {
            loadStatus = Status.success;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("loadStatus:$loadStatus");
    return buildBody(context,
      body: bookRackModel.bookRackList.isEmpty ?
      StatusView(
        status: loadStatus,
        enableEmptyClick: false,
      ) :
      ListView(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        children: <Widget>[
          Gaps.vGap10,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.only(left: 20.0),
                  color: MyColors.lineColor,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 0.5, color: MyColors.lineColor),
                ),
                child: Text(
                  "我的书架",
                  style: TextStyle(
                    color: MyColors.text_normal,
                    fontSize: 11.0,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.only(right: 20.0),
                  color: MyColors.lineColor,
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(20.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 30.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 5 / 8,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: bookRackModel.bookRackList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  NavigatorUtil.pushPageByRoute(widget.parentContext, BookInfoRoute(bookRackModel.bookRackList[index].bookId));
                },
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: CachedNetworkImage(
                      imageUrl: AppConfig.READ_BOOK_BASE_URL_USE + bookRackModel.bookRackList[index].cover,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => new ProgressView(),
                      errorWidget: (context, url, error) => Image.asset(Util.getImgPath("ico_logo"), width: double.infinity, fit: BoxFit.cover,),
                    ),
                  ),
                ),
              );
            },
          ),

          ListBottomLine(),
        ],
      ),
    );
  }
}
