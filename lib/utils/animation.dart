import 'dart:ui';

import 'package:flutter/animation.dart';

class CircularTween extends RectTween {
  final Rect? begin;
  final Rect? end;

  CircularTween({
    required this.begin,
    required this.end,
  });

  @override
  Rect lerp(double t) {
    double startWidthCenter = begin!.left + (begin!.width / 2);
    double startHeightCenter = begin!.top + (begin!.height / 2);
    return Rect.fromCircle(
      center: Offset(startWidthCenter, startHeightCenter),
      radius: 50,
    );
  }
}