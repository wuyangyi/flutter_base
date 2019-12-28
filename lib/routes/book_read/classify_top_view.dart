import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';

class ClassifyTopView extends StatefulWidget {
  final List<String> data;
  String nowItem;
  Function callBack;

  ClassifyTopView(this.data, this.nowItem, {this.callBack});

  @override
  _ClassifyTopViewState createState() => _ClassifyTopViewState(nowItem);
}

class _ClassifyTopViewState extends State<ClassifyTopView> {

  String nowItem;

  _ClassifyTopViewState(this.nowItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 5.0,
        alignment: WrapAlignment.start,
        children: widget.data.map((String item){
          return GestureDetector(
            onTap: (){
              if (item != nowItem) {
                setState(() {
                  nowItem = item;
                  widget.nowItem = item;
                });
                if (widget.callBack != null) {
                  widget.callBack(nowItem);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 2.5, 8.0, 2.5),
              decoration: BoxDecoration(
                color: item == nowItem ? Color(0xA0B388FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: item == nowItem ? MyColors.main_color : MyColors.title_color,
                  fontSize: 13.0,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
