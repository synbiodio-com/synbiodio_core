import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger;
import 'package:synbiodio_core/src/core/core.dart';
import 'package:synbiodio_core/src/logger/filter/allow_filter.dart';
import 'package:synbiodio_core/src/logger/filter/forbidden_filter.dart';

export 'filter/allow_filter.dart';
export 'filter/forbidden_filter.dart';

/// Logger
@immutable
abstract class Logger {
  ///
  factory Logger({LoggerOptions? options}) => _Logger._(options: options);

  const Logger._();

  /// Log a message at level [logger.Level.verbose].
  void verbose(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.debug].
  void debug(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.info].
  void info(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.warning].
  void warn(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.error].
  void error(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.wtf].
  void wtf(String message, [dynamic error, StackTrace? stackTrace]);
}

/// 日志工厂
class LoggerFactory {
  LoggerFactory._internal() : _map = <LoggerOptions, logger.Logger>{};

  final Map<LoggerOptions, logger.Logger> _map;

  static final LoggerFactory _instance = LoggerFactory._internal();

  /// 环境信息
  Environment? _environment;

  /// 白名单
  AllowFilter? _allowFilter;

  /// 黑名单
  ForbiddenFilter? _forbiddenFilter;

  /// 初始化
  static void init({
    required Environment environment,
    AllowFilter? allowFilter,
    ForbiddenFilter? forbiddenFilter,
  }) {
    assert(
      allowFilter == null || forbiddenFilter == null,
      'At least one of allowFilter and forbiddenFilter should be empty!',
    );

    _instance._allowFilter ??= allowFilter;
    _instance._forbiddenFilter ??= forbiddenFilter;
    _instance._environment ??= environment;
  }

  /// 获取一个logger实例
  logger.Logger getLogger(LoggerOptions? options) {
    final effectiveOptions = options ?? const LoggerOptions();
    return _map.putIfAbsent(
      effectiveOptions,
      () => _buildWithOptions(effectiveOptions),
    );
  }

  logger.Logger _buildWithOptions(LoggerOptions options) {
    final printer = logger.PrettyPrinter(
      stackTraceBeginIndex: options.stackTraceTranslate,
      methodCount: options.stackTraceTranslate + options.methodCount,
    );

    logger.LogFilter? filter;
    if (_allowFilter != null) {
      filter = _allowFilter;
    } else if (_forbiddenFilter != null) {
      filter = _forbiddenFilter;
    } else {
      filter = null;
    }

    return logger.Logger(printer: printer, filter: filter);
  }
}

class _Logger extends Logger {
  _Logger._({LoggerOptions? options})
      : _logger = LoggerFactory._instance.getLogger(options),
        module = options?.module ?? Module.common,
        super._();

  final logger.Logger _logger;

  final Module module;

  @override
  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v('${module.name} $message', error, stackTrace);
  }

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d('${module.name} $message', error, stackTrace);
  }

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('${module.name} $message', error, stackTrace);
  }

  @override
  void warn(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w('${module.name} $message', error, stackTrace);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('${module.name} $message', error, stackTrace);
  }

  @override
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf('${module.name} $message', error, stackTrace);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _Logger && _logger == other._logger;
  }

  @override
  int get hashCode => _logger.hashCode;
}

/// 日志的参数
@immutable
class LoggerOptions {
  ///
  const LoggerOptions({
    this.methodCount = 2,
    this.stackTraceTranslate = 1,
    this.module,
  });

  /// 堆栈开始的偏移量
  final int stackTraceTranslate;

  /// 记录调用方法层级
  final int methodCount;

  /// 模块
  final Module? module;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoggerOptions &&
        other.methodCount == methodCount &&
        other.stackTraceTranslate == stackTraceTranslate &&
        other.module == module;
  }

  @override
  int get hashCode => Object.hash(methodCount, stackTraceTranslate, module);
}
