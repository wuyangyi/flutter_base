import 'dart:math';

import 'package:flutter/material.dart';

import 'Line.dart';
import 'RainRandomGenerator.dart';

/*
 * 雨滴的类, 移动, 移出屏幕会重新设置位置.
 */
class RainFlake {
// 雨滴的移动速度
  static double INCREMENT_LOWER = 3;
  static double INCREMENT_UPPER = 5;

  // 雨滴的大小
  static double FLAKE_SIZE_LOWER = 0.5;
  static double FLAKE_SIZE_UPPER = 1;

  final double mIncrement; // 雨滴的速度
  final double mFlakeSize; // 雨滴的大小
  Paint mPaint; // 画笔

  Line mLine; // 雨滴

  RainRandomGenerator mRandom;

  RainFlake(this.mRandom, this.mLine, this.mIncrement, this.mFlakeSize, this.mPaint);

  //生成雨滴
  static RainFlake create(double width, double height, Paint paint) {
    RainRandomGenerator random = new RainRandomGenerator();
    List<double> nline;
    nline = random.getLine(width, height, true);

    Line line = new Line(nline[0], nline[1], nline[2], nline[3]);
    double increment = random.getRandom(INCREMENT_LOWER, INCREMENT_UPPER);
    double flakeSize = random.getRandom(FLAKE_SIZE_LOWER, FLAKE_SIZE_UPPER);
    return new RainFlake(random,line, increment, flakeSize, paint);
  }

  // 绘制雨滴
  void draw(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    drawLine(canvas, width, height);
  }

  /*
   * 线条，类似于雨滴效果
   * @param canvas
   * @param width
   * @param height
   */
  void drawLine(Canvas canvas, double width, double height) {
    mPaint.strokeWidth = mFlakeSize; //线宽

    //y是竖直方向，就是下落
    double y1 = mLine.y1 + (mIncrement * sin(1.5));
    double y2 = mLine.y2 + (mIncrement * sin(1.5));

    //这个是设置雨滴位置，如果在很短时间内刷新一次，就是连起来的动画效果
    mLine.set(mLine.x1, y1, mLine.x2, y2);

    if (!isInsideLine(height)) {
      resetLine(width, height);
    }

    canvas.drawLine(Offset(mLine.x1, mLine.y1), Offset(mLine.x2, mLine.y2), mPaint);
  }

  // 判断是否在其中
  bool isInsideLine(double height) {
    return mLine.y1 < height && mLine.y2 < height;
  }

  // 重置雨滴
  void resetLine(double width, double height) {
    List<double> nline;
    nline = mRandom.getLine(width, height, false);
    mLine.x1 = nline[0];
    mLine.y1 = nline[1];
    mLine.x2 = nline[2];
    mLine.y2 = nline[3];
  }
}