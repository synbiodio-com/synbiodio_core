import 'package:logger/logger.dart';
import 'package:synbiodio_core/src/core/module.dart';

/// 允许的过滤器
class AllowFilter extends LogFilter {
  ///
  AllowFilter({required this.allowList});

  /// 允许的模块
  final List<Module> allowList;

  @override
  bool shouldLog(LogEvent event) {
    final messageString = event.message as String;
    final moduleName = messageString.split(' ')[0];
    final eventModule = Module(name: moduleName);
    return allowList.any(eventModule.isUnderOrEqual);
  }
}
