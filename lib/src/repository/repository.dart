import 'package:synbiodio_core/src/logger/logger.dart';

/// 仓库基类
abstract class BaseRepository {
  /// base constructor
  BaseRepository() : _logger = Logger();

  /// 日志器
  Logger get logger => _logger;
  final Logger _logger;
}
