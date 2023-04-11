import 'dart:math';

import 'package:uuid/uuid.dart';

/// 字符串工具
class StringUtils {
  /// 随机字符串
  static String randomString() {
    const uuid = Uuid();
    return uuid.v4();
    // final random = Random.secure();
    // final values = List<int>.generate(16, (i) => random.nextInt(255));
    // return base64UrlEncode(values);
  }
}

/// 数字工具
class NumUtils {
  /// 随机一个整数
  ///
  /// [maxValue] 最大值
  /// [minValue] 最小值
  static int randomInt({
    required int maxValue,
    int minValue = 0,
  }) {
    return Random().nextInt(maxValue - minValue) + minValue;
  }
}
