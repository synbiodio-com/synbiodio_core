import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger;
import 'package:synbiodio_core/src/core/core.dart';

/// scene转options的mapper
typedef Scene2OptionsMapper = LoggerOptions Function(LoggerScene scene);

/// Logger
@immutable
abstract class Logger {
  ///
  factory Logger({LoggerScene? scene}) => _Logger._(scene: scene);

  const Logger._();

  /// Log a message at level [logger.Level.verbose].
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.debug].
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.info].
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.warning].
  void warn(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.error].
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]);
}

/// 日志工厂
class LoggerFactory {
  LoggerFactory._internal() : _map = <LoggerScene, logger.Logger>{};

  final Map<LoggerScene, logger.Logger> _map;

  static final LoggerFactory _instance = LoggerFactory._internal();

  /// 环境信息
  Environment? _environment;

  /// scene转options的mapper
  Scene2OptionsMapper? _scene2OptionsMapper;

  /// 初始化
  static void init({
    required Environment environment,
    Scene2OptionsMapper? mapper,
  }) {
    _instance._environment ??= environment;
    _instance._scene2OptionsMapper ??= mapper;
  }

  /// 获取一个logger实例
  logger.Logger getLogger(LoggerScene? scene) {
    final effectiveScene = scene ?? LoggerScene.none;
    final options = (_scene2OptionsMapper ?? _defaultMapper).call(effectiveScene);
    return _map.putIfAbsent(effectiveScene, () => _buildWithOptions(options));
  }

  logger.Logger _buildWithOptions(LoggerOptions options) {
    final printer = logger.PrettyPrinter(
      stackTraceBeginIndex: options.stackTraceTranslate,
      methodCount: options.stackTraceTranslate + options.methodCount,
    );

    return logger.Logger(printer: printer);
  }
}

class _Logger extends Logger {
  _Logger._({LoggerScene? scene})
      : _logger = LoggerFactory._instance.getLogger(scene),
        super._();

  final logger.Logger _logger;

  @override
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  @override
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  @override
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  @override
  void warn(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  @override
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  @override
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _Logger && _logger == other._logger;
  }

  @override
  int get hashCode => _logger.hashCode;
}

/// 日志的参数
class LoggerOptions {
  ///
  LoggerOptions({
    this.methodCount = 2,
    this.stackTraceTranslate = 1,
  });

  /// 堆栈开始的偏移量
  final int stackTraceTranslate;

  /// 记录调用方法层级
  final int methodCount;
}

/// 日志器参数
enum LoggerScene {
  /// 完整的log
  complete,

  /// 没有scene
  none,
}

Scene2OptionsMapper _defaultMapper = (scene) {
  return LoggerOptions();
};
