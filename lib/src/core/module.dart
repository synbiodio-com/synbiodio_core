import 'package:flutter/foundation.dart';

/// 模块
@immutable
class Module {
  /// 模块
  ///
  /// [name] 是模块名，可以嵌套父模块， 例如：`a/b/c`
  const Module({
    required this.name,
  });

  /// 模块名
  final String name;

  /// 模块列表
  List<String> get names =>
      name.split('/').where((element) => element.isNotEmpty).toList();

  /// 模块深度
  int get moduleDeepLength => names.length;

  /// 判断自己的模块名是否在other之下
  bool isUnderOrEqual(Module other) {
    if (moduleDeepLength < other.moduleDeepLength) {
      return false;
    }
    for (var i = 0; i < moduleDeepLength; i++) {
      if (i > other.moduleDeepLength - 1) {
        break;
      }
      if (names[i] != other.names[i]) {
        return false;
      }
    }
    return true;
  }

  /// 通用模块
  static Module common = const Module(name: 'common');
}
