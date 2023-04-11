
import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/repository/repository.dart';

void main() {
  group('test BaseRepository', () {
    test('test init', () {
      final repository1 = TestRepository();
      final repository2 = TestRepository();
      expect(repository1.logger == repository2.logger, true);
    });
  });
}

class TestRepository extends BaseRepository {}
