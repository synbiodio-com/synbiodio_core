import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/core/module.dart';

void main() {
  group('test module', () {
    test('test isUnder', () {
      const moduleA = Module(name: 'A');
      const moduleB = Module(name: 'B');
      const moduleAC = Module(name: 'A/C');

      const otherModuleA = Module(name: 'A');

      expect(moduleA.isUnderOrEqual(moduleB), false);
      expect(moduleB.isUnderOrEqual(moduleA), false);
      expect(moduleA.isUnderOrEqual(moduleAC), false);
      expect(moduleAC.isUnderOrEqual(moduleA), true);
      expect(moduleA.isUnderOrEqual(otherModuleA), true);
    });
  });
}
