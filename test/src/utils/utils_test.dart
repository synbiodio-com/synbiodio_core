import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/utils/utils.dart';

void main() {
  group('String utils', () {
    test(
      'test randomString',
      () {
        final results = <String>[];
        const count = 1000;

        for (var i = 0; i < count; i++) {
          final randomString = StringUtils.randomString();
          expect(results.contains(randomString), false);
          results.add(randomString);
        }
      },
    );
  });

  group('Num utils', () {
    test(
      'test randomInt',
      () {
        const count = 1000;
        for (var i = 0; i < count; i++) {
          final randomInt = NumUtils.randomInt(maxValue: 1000);
          expect(randomInt >= 0 && randomInt < 1000, true);
        }
      },
    );
  });
}
