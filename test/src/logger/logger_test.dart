import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/core/environment.dart';
import 'package:synbiodio_core/src/core/module.dart';
import 'package:synbiodio_core/src/logger/logger.dart';

void main() async {
  group('logger.dart', () {
    test('Logger', () {
      LoggerFactory.init(
        environment: Environment(envType: EnvType.dev),
      );
      final logger1 = Logger(options: const LoggerOptions())
        ..verbose('verbose')
        ..debug('debug')
        ..info('info')
        ..warn('warning')
        ..error('error')
        ..wtf('wtf');
      final logger2 = Logger(options: const LoggerOptions());

      expect(logger1 == logger2, true);
      expect(logger1.hashCode == logger2.hashCode, true);
    });

    test('Logger allowFilter', () {
      LoggerFactory.init(
        environment: Environment(envType: EnvType.dev),
        allowFilter: AllowFilter(
          allowList: [
            const Module(name: 'a/b'),
          ],
        ),
      );
      final aLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a')),
      );
      final abcLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a/b/c')),
      );
      final abcdLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a/b/c/d')),
      );
      final commonLogger = Logger(options: const LoggerOptions());
      aLogger.verbose('byebye');
      abcLogger.verbose('hello synbiodio');
      abcdLogger.verbose('hello synbiodio');
      commonLogger.error(
        '上面应该有两个 verbose 级别的"hello synbiodio"， 分别是a/b/c模块和a/b/c/d模块的， 不应该有a模块的"byebye"',
      );
    });

    test('Logger ForbiddenFilter', () {
      LoggerFactory.init(
        environment: Environment(envType: EnvType.dev),
        forbiddenFilter: ForbiddenFilter(
          forbiddenList: [
            const Module(name: 'a/b'),
          ],
        ),
      );
      final aLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a')),
      );
      final abcLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a/b/c')),
      );
      final abcdLogger = Logger(
        options: const LoggerOptions(module: Module(name: 'a/b/c/d')),
      );
      final commonLogger = Logger(options: const LoggerOptions());
      aLogger.verbose('I will be back');
      abcLogger.verbose('hello synbiodio');
      abcdLogger.verbose('hello synbiodio');

      commonLogger.error('上面应该只有一行a模块的"I will be back"');
    });
  });
}
