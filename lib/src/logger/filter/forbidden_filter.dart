import 'package:logger/logger.dart';
import 'package:synbiodio_core/src/core/module.dart';

/// 禁止的过滤器
class ForbiddenFilter extends LogFilter {
  /// 禁止的过滤器
  ForbiddenFilter({required this.forbiddenList});

  /// 禁止的模块
  final List<Module> forbiddenList;

  @override
  bool shouldLog(LogEvent event) {
    final messageString = event.message as String;
    final moduleName = messageString.split(' ')[0];
    final eventModule = Module(name: moduleName);
    final isUnder = forbiddenList.any(eventModule.isUnderOrEqual);
    return !isUnder;
  }
}
