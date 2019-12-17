import 'dart:math' as Math;

import 'package:flutter/material.dart';

/*
 * 随机生成器
 */
class SnowRandomGenerator {
  static final Math.Random RANDOM = new Math.Random();

  // 区间随机
  double getRandom(double lower, double upper) {
    double min = Math.min(lower, upper);
    double max = Math.max(lower, upper);
    return getRandomDouble(max - min) + min;
  }

  // 上界随机
  double getRandomDouble(double upper) {
    return RANDOM.nextDouble() * upper;
  }

  // 上界随机
  int getRandomInt(int upper) {
    return RANDOM.nextInt(upper);
  }
}