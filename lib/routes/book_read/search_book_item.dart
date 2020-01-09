import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/bean/read_book/rank_bean_entity.dart';
import 'package:flutter_base/bean/read_book/search_book_bean_entity.dart';
import 'package:flutter_base/config/app_config.dart';
import 'package:flutter_base/res/index.dart';
import 'package:flutter_base/routes/book_read/book_info_route.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/widgets/widgets.dart';

class SearchBookItem extends StatelessWidget {
  final SearchBookBeanBook data;
  Function onTap;

  SearchBookItem(this.data, {Key key, this.onTap}) : super(key: key);

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
              NavigatorUtil.pushPageByRoute(context, BookInfoRoute(data.sId));
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
                  child: AspectRatio(
                    aspectRatio: 136 / 190,
                    child: CachedNetworkImage(
                      height: double.infinity,
                      imageUrl: AppConfig.READ_BOOK_BASE_URL_USE+data.cover,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => new ProgressView(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ),
                ),
                Gaps.hGap10,
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: data.title.runes.map((rune){
                            String item = new String.fromCharCode(rune);
                            bool need = false;
                            if (data?.highlight?.title != null) {
                              data.highlight.title.forEach((title){
                                if (item == title) {
                                  need = true;
                                }
                              });
                            }
                            return TextSpan(
                              text: item,
                              style: TextStyle(
                                color: need ? MyColors.main_color : MyColors.title_color,
                                fontSize: 15.0
                              ),
                            );
                          }).toList(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                          Expanded(
                            flex: 1,
                            child: Text.rich(
                              TextSpan(
                                children: data.author.runes.map((rune){
                                  String item = new String.fromCharCode(rune);
                                  bool need = false;
                                  if (data?.highlight?.author != null) {
                                    data.highlight.author.forEach((title){
                                      if (item == title) {
                                        need = true;
                                      }
                                    });
                                  }
                                  return TextSpan(
                                    text: item,
                                    style: TextStyle(
                                        color: need ? MyColors.main_color : MyColors.title_color,
                                        fontSize: 11.0
                                    ),
                                  );
                                }).toList(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(width: 0.6, color: MyColors.text_normal),
                            ),
                            child: Text(
                              data.cat,
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
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(width: 0.6, color: MyColors.text_normal),
                            ),
                            child: Text(
                              getPeopleNumber(data.latelyFollower),
                              style: TextStyle(
                                fontSize: 10.0,
                                color: MyColors.text_normal,
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
