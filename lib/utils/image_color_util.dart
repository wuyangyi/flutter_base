import 'dart:math' as math;
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:quantize_dart/quantize_dart.dart';

///图片信息获取


_min(List<num> list) {
  return list.reduce((a, b) {
    return math.min(a, b);
  });
}

_max(List<num> list) {
  return list.reduce((a, b) {
    return math.max(a, b);
  });
}

/// retruns HSVColor, represented as [H,S,V]
///
/// `list` - RGBColor, represented as [R,G,B]
///
/// `R,G,B`'s range is [0,255], `H`'s range is [0,360], `S,V`'s range is [0,100]
///
/// RGB 转换为 HSV
List<int> fromRGBtoHSV(List<int> list) {
  assert(list.length == 3);

  var r = list[0] / 255;
  var g = list[1] / 255;
  var b = list[2] / 255;
  var h,s,v;
  var min = _min([r, g, b]);
  var max = v = _max([r, g, b]);
  var difference = max - min;

  if (max == min){
    h = 0;
  } else {
    if (max == r) {
      h = (g - b) / difference + (g < b ? 6 : 0);
    } else if (max == g) {
      h = 2.0 + (b - r) / difference;
    } else if (max == b) {
      h = 4.0 + (r - g) / difference;
    }
    h = (h * 60).round();
  }
  if (max == 0) {
    s = 0;
  } else {
    s = 1 - min / max;
  }
  s = (s * 100).round();
  v = (v * 100).round();

  return [h, s, v];
}

/// retruns RGBColor, represented as [R,G,B]
///
/// `list` - HSVColor, represented as [H,S,V]
///
/// `H`'s range is [0,360], `S,V`'s range is [0,100], `R,G,B`'s range is [0,255]
/// HSV 转换为 RGB
List<int> fromHSVtoRGB(List<int> list) {
  assert(list.length == 3);

  var h = list[0];
  var s = list[1] / 100;
  var v = list[2] / 100;
  var h1 = (h ~/ 60) % 6;
  var f = h / 60 - h1;
  var p = v * (1 - s);
  var q = v * (1 - f *s );
  var t = v * (1 - (1 - f) * s);
  var r, g, b;

  switch (h1) {
    case 0:
      r = v; g = t; b = p;
      break;
    case 1:
      r = q; g = v; b = p;
      break;
    case 2:
      r = p; g = v; b = t;
      break;
    case 3:
      r = p; g = q; b = v;
      break;
    case 4:
      r = t; g = p; b = v;
      break;
    case 5:
      r = v; g = p; b = q;
      break;
  }

  return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
}



_createPixelArray(Uint8List imgData, int pixelCount, int quality) {
  final pixels = imgData;
  List<List<int>> pixelArray = [];

  for (var i = 0, offset, r, g, b, a; i < pixelCount; i = i + quality) {
    offset = i * 4;
    r = pixels[offset + 0];
    g = pixels[offset + 1];
    b = pixels[offset + 2];
    a = pixels[offset + 3];

    if (a == null || a >= 125) {
      if (!(r > 250 && g > 250 && b > 250)) {
        pixelArray.add([r, g, b]);
      }
    }
  }
  return pixelArray;
}

_validateOptions(int colorCount, int quality) {
  if (colorCount == null || colorCount.runtimeType != int) {
    colorCount = 10;
  } else {
    colorCount = max(colorCount, 2);
    colorCount = min(colorCount, 20);
  }
  if (quality == null || quality.runtimeType != int) {
    quality = 10;
  } else if (quality < 1) {
    quality = 10;
  }
  return [colorCount, quality];
}

/// returns the real Image of ImageProvider
///
/// `imageProvider` - ImageProvider
/// 提取 ImageProvider 的实际图片
Future<Image> getImageFromProvider(ImageProvider imageProvider) async {
  final ImageStream stream = imageProvider.resolve(
    ImageConfiguration(devicePixelRatio: 1.0),
  );
  final Completer<Image> imageCompleter = Completer<Image>();
  ImageStreamListener listener;
  listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
    stream.removeListener(listener);
    imageCompleter.complete(info.image);
  });
  stream.addListener(listener);
  final image = await imageCompleter.future;
  return image;
}

/// returns the Image from url
///
/// `url` - url to image
/// 提取网络图片的实际图片
Future<Image> getImageFromUrl(String url) async {
  final ImageProvider imageProvider = NetworkImage(url);
  final image = await getImageFromProvider(imageProvider);
  return image;
}

/// returns a list that contains the reduced color palette, represented as [[R,G,B]]
///
/// `image` - Image
///
/// `colorCount` - Between 2 and 256. The maximum number of colours allowed in the reduced palette
///
/// `quality` - Between 1 and 10. There is a trade-off between quality and speed. The bigger the number, the faster the palette generation but the greater the likelihood that colors will be missed.
/// 从图片提取调色板
Future getPaletteFromImage(Image image, [int colorCount, int quality]) async {
  final options = _validateOptions(colorCount, quality);
  colorCount = options[0];
  quality = options[1];

  final imageData  = await image.toByteData(format: ImageByteFormat.rawRgba).then((val) => Uint8List.view((val.buffer)));
  final pixelCount = image.width * image.height;

  final pixelArray = _createPixelArray(imageData, pixelCount, quality);

  final cmap = quantize(pixelArray, colorCount);
  final palette = cmap == null ? null : cmap.palette();

  return palette;
}

/// returns a list that contains the reduced color palette, represented as [[R,G,B]]
///
/// `url` - url to image
///
/// `colorCount` - Between 2 and 256. The maximum number of colours allowed in the reduced palette
///
/// `quality` - Between 1 and 10. There is a trade-off between quality and speed. The bigger the number, the faster the palette generation but the greater the likelihood that colors will be missed.
/// 提取网络图片调色板
Future getPaletteFromUrl(String url, [int colorCount, int quality]) async {
  final image = await getImageFromUrl(url);
  final palette = await getPaletteFromImage(image, colorCount, quality);
  return palette;
}

/// returns the base color from the largest cluster, represented as [R,G,B]
///
/// `image` - Image
///
/// `quality` - Between 1 and 10. There is a trade-off between quality and speed. The bigger the number, the faster the palette generation but the greater the likelihood that colors will be missed.
/// 从图片提取主要颜色
Future getColorFromImage(Image image, [int quality = 10]) async {
  final palette = await getPaletteFromImage(image, 5, quality);
  if (palette == null) {
    return null;
  }
  final dominantColor = palette[0];
  return dominantColor;
}

/// returns the base color from the largest cluster, represented as [R,G,B]
///
/// `url` - url to image
///
/// `quality` - Between 1 and 10. There is a trade-off between quality and speed. The bigger the number, the faster the palette generation but the greater the likelihood that colors will be missed.
/// // 提取网络图片的主要颜色
Future getColorFromUrl(String url, [int quality]) async {
  final image = await getImageFromUrl(url);
  final dominantColor = await getColorFromImage(image, quality);
  return dominantColor;
}