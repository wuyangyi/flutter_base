import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_info_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/widgets.dart';

class BookItem extends StatelessWidget {
  final RankBeanRankingBook data;
  Function onTap;
  int index;
  final BuildContext parentContext;

  BookItem(this.data, {Key key, this.onTap, this.index = -1, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          onTap: (){
            if (onTap != null) {
              onTap();
            } else {
              NavigatorUtil.pushPageByRoute(parentContext ?? context, BookInfoRoute(data.sId));
            }
          },
          child: Container(
            width: double.infinity,
            height: 120.0,
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: CachedNetworkImage(
                    height: double.infinity,
                    imageUrl: AppConfig.READ_BOOK_BASE_URL_USE+data.cover,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => new ProgressView(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${index < 0 ? "" : "${index + 1}."}${data.title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.title_color,
                          fontSize: 15.0
                        ),
                      ),
                      Gaps.vGap10,
                      Text(
                        data.shortIntro,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColors.text_normal,
                          fontSize: 12.0,
                        ),
                      ),
                      Gaps.vGap10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: MyColors.text_normal,
                            size: 11.0,
                          ),
                          Gaps.hGap5,
                          Expanded(
                            flex: 1,
                            child: Text(
                              data.author,
                              maxLines: 1,
                              style: TextStyle(
                                color: MyColors.text_normal,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                            decoration: BoxDecoration(
                              color: MyColors.home_body_bg,
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            child: Text(
                              data.majorCate,
                              style: TextStyle(
                                fontSize: 10.0,
                                color: MyColors.text_normal,
                              ),
                            ),
                          ),
                          Gaps.hGap5,
                          Container(
                            padding: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                            decoration: BoxDecoration(
                              color: Color(0xAAFF9E80),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            child: Text(
                              getPeopleNumber(data.latelyFollower),
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getPeopleNumber(int number) {
    String people;
    if(number > 10000) {
      double p = number / 10000;
      people = "${p.toStringAsFixed(1)}万人气";
    } else {
      people = "$number人气";
    }
    return people;
  }
}
