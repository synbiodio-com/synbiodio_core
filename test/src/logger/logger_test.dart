import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/core/environment.dart';
import 'package:synbiodio_core/src/logger/logger.dart';

void main() async {
  group('logger.dart', () {
    test('Logger', () {
      LoggerFactory.init(environment: Environment(envType: EnvType.dev));
      final logger1 = Logger(scene: LoggerScene.complete)
        ..info('info')
        ..warn('warning')
        ..error('error')
        ..debug('debug');
      final logger2 = Logger(scene: LoggerScene.complete);

      expect(logger1 == logger2, true);
    });
  });
}