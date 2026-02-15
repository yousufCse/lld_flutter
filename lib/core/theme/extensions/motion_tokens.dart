import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class MotionTokens extends ThemeExtension<MotionTokens> {
  final Duration fast;
  final Duration normal;
  final Duration slow;

  const MotionTokens({
    required this.fast,
    required this.normal,
    required this.slow,
  });

  @override
  MotionTokens copyWith({Duration? fast, Duration? normal, Duration? slow}) {
    return MotionTokens(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
    );
  }

  @override
  MotionTokens lerp(ThemeExtension<MotionTokens>? other, double t) {
    if (other is! MotionTokens) return this;
    return MotionTokens(
      fast: Duration(
        milliseconds: lerpDouble(
          fast.inMilliseconds.toDouble(),
          other.fast.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
      normal: Duration(
        milliseconds: lerpDouble(
          normal.inMilliseconds.toDouble(),
          other.normal.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
      slow: Duration(
        milliseconds: lerpDouble(
          slow.inMilliseconds.toDouble(),
          other.slow.inMilliseconds.toDouble(),
          t,
        )!.toInt(),
      ),
    );
  }

  static const standard = MotionTokens(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 500),
  );
}
