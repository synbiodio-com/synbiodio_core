import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart' as logger;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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

  /// Log a message at level [logger.Level.trace].
  void trace(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.debug].
  void debug(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.info].
  void info(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.warning].
  void warn(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.error].
  void error(String message, [dynamic error, StackTrace? stackTrace]);

  /// Log a message at level [logger.Level.fatal].
  void fatal(String message, [dynamic error, StackTrace? stackTrace]);
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

  /// 日志文件所在目录
  Directory? _logFileDirectory;

  File? _logFile;

  logger.LogOutput? _output;
  logger.LogPrinter? _printer;

  /// 初始化
  static Future<void> init({
    required Environment environment,
    AllowFilter? allowFilter,
    ForbiddenFilter? forbiddenFilter,
  }) async {
    assert(
      allowFilter == null || forbiddenFilter == null,
      'At least one of allowFilter and forbiddenFilter should be empty!',
    );

    _instance._allowFilter ??= allowFilter;
    _instance._forbiddenFilter ??= forbiddenFilter;
    _instance._environment ??= environment;

    var createLogFile = true;
    // ignore: prefer_asserts_with_message
    assert(() {
      createLogFile = false;
      return true;
    }());

    if (createLogFile) {
      final directory = await getApplicationDocumentsDirectory();
      try {
        final logFileListPath = path.join(directory.path, 'logs');
        _instance._logFileDirectory = Directory(logFileListPath);
        final now = DateTime.now();
        final fileName = '${DateFormat('yyyyMMdd_HHmmss').format(now)}.log';
        final file = File(path.join(logFileListPath, fileName));
        _instance._logFile = await file.create(recursive: true);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  /// 日志文件所在目录
  static Directory? get logFileDirectory => _instance._logFileDirectory;

  /// log 文件
  static File? get logFile => _instance._logFile;

  /// 获取一个logger实例
  logger.Logger getLogger(LoggerOptions? options) {
    final effectiveOptions = options ?? const LoggerOptions();
    return _map.putIfAbsent(
      effectiveOptions,
      () => _buildWithOptions(effectiveOptions),
    );
  }

  logger.Logger _buildWithOptions(LoggerOptions options) {
    if (_logFile != null) {
      _printer ??= logger.SimplePrinter(printTime: true, colors: false);
      _output ??= logger.FileOutput(file: _logFile!);
    } else {
      _printer ??= logger.PrettyPrinter(
        stackTraceBeginIndex: options.stackTraceTranslate,
        methodCount: options.stackTraceTranslate + options.methodCount,
        colors: false,
      );
      _output ??= logger.ConsoleOutput();
    }

    logger.LogFilter? filter;
    if (_allowFilter != null && _logFile == null) {
      filter = _allowFilter;
    } else if (_forbiddenFilter != null && _logFile == null) {
      filter = _forbiddenFilter;
    } else {
      filter = logger.ProductionFilter()
        ..level = kReleaseMode ? logger.Level.info : logger.Level.debug;
    }

    return logger.Logger(printer: _printer, filter: filter, output: _output);
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
  void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void warn(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(
      '[${module.name}] $message',
      error: error,
      stackTrace: stackTrace,
    );
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
