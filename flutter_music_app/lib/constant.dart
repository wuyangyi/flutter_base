import 'dart:math';

import 'package:flutter/material.dart';

const int min = 0;

const int max = 5;

const swatchList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.teal
];

Color getRandomColor() {
  return swatchList[(min + (Random().nextInt(max - min)))];
}
