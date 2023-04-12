// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synbiodio_core/src/collections/tree.dart';

void main() {
  group('TestTree', () {
    test('can be instantiated', () {
      final treeTest = TreeTest(name: 'treeTest');

      expect(treeTest, isNotNull);
    });

    test('basic', () {
      final node111 = TreeTest(name: 'node11');
      final node112 = TreeTest(name: 'node112');
      final node113 = TreeTest(name: 'node113');
      final node11 =
          TreeTest(name: 'node11', children: [node111, node112, node113]);
      final node1 = TreeTest(name: 'node1', children: [node11]);
      final root = TreeTest(name: 'root', children: [node1]);

      expect(node111.root, root);
      expect(node111.leafCount, 1);
      expect(root.leafCount, 3);
      expect(root.maxDeep, 3);

      final node2 = TreeTest(name: 'node2');
      root.add(node2);

      expect(node111.root, root);
      expect(node111.leafCount, 1);
      expect(root.leafCount, 4);
      expect(root.maxDeep, 3);

      expect(node11.isMyAncestor(node1), isTrue);
      expect(node11.isMyAncestor(node2), isFalse);

      final where1 = node11.where((element) => element.name == 'node112');
      expect(listEquals(where1, [node112]), true);

      final where2 = node11.where((element) => element.name == 'root');
      expect(where2?.isEmpty ?? false, true);

      final where3 =
          node11.where((element) => RegExp('^node').hasMatch(element.name));

      expect(where3, unorderedMatches([node11, node111, node112, node113]));
    });

    test('link list is ok', () {
      final treeTestFirst = TreeTest(name: 'treeTestFirst');
      final treeTestSecond = TreeTest(name: 'treeTestSecond');
      final treeTestThird = TreeTest(name: 'treeTestThird');
      final root = TreeTest(
        name: 'root',
        children: [treeTestFirst, treeTestSecond, treeTestThird],
      );

      expect(root.children?.length, 3);

      expect(treeTestFirst.next, treeTestSecond);
      expect(treeTestSecond.next, treeTestThird);

      expect(treeTestThird.previous, treeTestSecond);
      expect(treeTestSecond.previous, treeTestFirst);

      expect(treeTestFirst.isHead, true);
      expect(treeTestSecond.isHead, false);
      expect(treeTestThird.isHead, false);

      expect(treeTestFirst.isTail, false);
      expect(treeTestSecond.isTail, false);
      expect(treeTestThird.isTail, true);
    });

    test('replaceBy', () {
      final node11 = TreeTest(name: 'node11');
      final node12 = TreeTest(name: 'node12');
      final node1 = TreeTest(name: 'node1', children: [node11, node12]);
      final node2 = TreeTest(
        name: 'node2',
      );
      final node3 = TreeTest(
        name: 'node3',
      );
      final root = TreeTest(name: 'root', children: [node1, node2, node3]);

      final newNode1 = TreeTest(name: 'newNode1');
      node1.replaceBy(newNode1);

      expect(root.children?.first, newNode1);
    });

    test('replaceBy2', () {
      final node111 = TreeTest(name: 'node11');
      final node112 = TreeTest(name: 'node112');
      final node113 = TreeTest(name: 'node113');
      final node11 =
          TreeTest(name: 'node11', children: [node111, node112, node113]);
      final node1 = TreeTest(name: 'node1', children: [node11]);
      final root = TreeTest(name: 'root', children: [node1]);

      final newNode1 = TreeTest(name: 'newNode1');
      node1.replaceBy(newNode1);

      expect(root.children?.first, newNode1);
      expect(newNode1.children?.first, node11);
      expect(newNode1.children?.first.children?.length, 3);

      expect(newNode1.parent, root);
      expect(node11.parent, newNode1);

      expect(root.floor, 0);
      expect(newNode1.floor, 1);
      expect(node11.floor, 2);
      expect(node111.floor, 3);
    });
  });
}

class TreeTest extends TreeNode<TreeTest> {
  TreeTest({
    required this.name,
    super.children,
  });

  final String name;

  @override
  String toString() {
    return 'TreeTest($name)';
  }
}
