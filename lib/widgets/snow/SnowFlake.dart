import 'package:flutter/material.dart';

import 'dart:math';

import 'SnowRandomGenerator.dart';
/*
 * 雪花的类, 移动, 移出屏幕会重新设置位置.
 */
class SnowFlake {
// 雪花的角度
  static const double ANGE_RANGE = 0.1; // 角度范围
  static const double HALF_ANGLE_RANGE = ANGE_RANGE / 2; // 一般的角度
  static const double HALF_PI = pi / 2; // 半PI
  static const double ANGLE_SEED = 25.0; // 角度随机种子
  static const double ANGLE_DIVISOR = 10000.0; // 角度的分母

  // 雪花的移动速度
  static double INCREMENT_LOWER = 1;
  static double INCREMENT_UPPER = 3;

  // 雪花的大小
  static double FLAKE_SIZE_LOWER = 1;
  static double FLAKE_SIZE_UPPER = 3;

  final SnowRandomGenerator mRandom; // 随机控制器
  Offset mPosition; // 雪花位置
  double mAngle; // 角度
  final double mIncrement; // 雪花的速度
  final double mFlakeSize; // 雪花的大小
  final Paint mPaint; // 画笔

  SnowFlake(this.mRandom, this.mPosition, this.mAngle, this.mIncrement, this.mFlakeSize, this.mPaint, );

  static SnowFlake create(double width, double height, Paint paint) {
    SnowRandomGenerator random = new SnowRandomGenerator();
    double x = random.getRandomDouble(width);
    double y = random.getRandomDouble(height);
    Offset position = new Offset(x, y);
    double angle = random.getRandomDouble(ANGLE_SEED) / ANGLE_SEED * ANGE_RANGE + HALF_PI - HALF_ANGLE_RANGE;
    double increment = random.getRandom(INCREMENT_LOWER, INCREMENT_UPPER);
    double flakeSize = random.getRandom(FLAKE_SIZE_LOWER, FLAKE_SIZE_UPPER);
    return new SnowFlake(random, position, angle, increment, flakeSize, paint);
  }

  // 绘制雪花
  void draw(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    move(width, height);
    canvas.drawCircle(Offset(mPosition.dx, mPosition.dy), mFlakeSize, mPaint);
  }

  // 移动雪花
  void move(double width, double height) {
    double x = mPosition.dx + (mIncrement * cos(mAngle));
    double y = mPosition.dy + (mIncrement * sin(mAngle));

    mAngle += mRandom.getRandom(-ANGLE_SEED, ANGLE_SEED) / ANGLE_DIVISOR; // 随机晃动

    mPosition = new Offset(x, y);

    // 移除屏幕, 重新开始
    if (!isInside(width, height)) {
      reset(width);
    }
  }

  // 判断是否在其中
  bool isInside(double width, double height) {
    double x = mPosition.dx;
    double y = mPosition.dy;
    return x >= -mFlakeSize - 1 && x + mFlakeSize <= width && y >= -mFlakeSize - 1 && y - mFlakeSize < height;
  }

  // 重置雪花
  void reset(double width) {
    mPosition = Offset(mRandom.getRandomDouble(width), (-mFlakeSize - 1));// 最上面
    mAngle = mRandom.getRandomDouble(ANGLE_SEED) / ANGLE_SEED * ANGE_RANGE + HALF_PI - HALF_ANGLE_RANGE;
  }

}