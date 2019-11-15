import 'package:flutter/material.dart';
import 'package:flutter_base/res/index.dart';

//虚线
class MySeparator extends StatelessWidget {
  final double height; //高度
  final Color color; //颜色
  final double distance; //虚线间隔

  const MySeparator({Key key,
    this.height = 0.5,
    this.color = MyColors.loginDriverColor,
    this.distance = 8.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = distance;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_){
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
