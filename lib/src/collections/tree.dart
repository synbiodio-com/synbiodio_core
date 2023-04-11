import 'dart:math';

/// 树节点
abstract class TreeNode<E extends TreeNode<E>> {
  ///
  TreeNode({List<E>? children}) : _children = children {
    _children?.forEach((e) {
      e._parent = this as E;
    });
  }

  /// 父节点
  E? get parent => _parent;
  E? _parent;

  /// 获取子节点列表
  List<E>? get children => _children;
  List<E>? _children;

  /// 获取当前节点的上一个节点
  E? get previous {
    if (_parent == null) {
      return null;
    }
    return _parent!._nodeBefore(this as E);
  }

  /// 获取当前节点的下一个节点
  E? get next {
    if (_parent == null) {
      return null;
    }
    return _parent!._nodeAfter(this as E);
  }

  /// 获取本树结构的根节点
  E get root => _parent == null ? this as E : _parent!.root;

  /// 当前节点是否为兄弟节点中的第一个节点
  bool get isHead => previous == null;

  /// 当前节点是否为兄弟节点中的最后一个节点
  bool get isTail => next == null;

  /// 叶子节点的个数
  int get leafCount {
    if (children == null || children!.isEmpty) {
      return 1;
    }
    return children!.map((e) => e.leafCount).reduce(
          (value, element) => value + element,
        );
  }

  /// 从根节点开始算，第几层
  ///
  /// 根节点为0，根节点的子节点为1
  int get floor => _parent == null ? 0 : _parent!.floor + 1;

  /// 从当前节点开始算，子节点最多的层数
  ///
  /// 当该节点无children时，为0
  int get maxDeep => (children?.isEmpty ?? true)
      ? 0
      : children!
              .map(
                (e) => e.maxDeep,
              )
              .maxValue +
          1;

  ///
  void add(E e) {
    _children ??= [];
    _children!.add(e);
    e._parent = this as E;
  }

  /// 在children上查找child节点，并返回child节点的后一个节点
  E? _nodeAfter(E child) {
    if (_children?.isEmpty ?? true) {
      return null;
    }

    final targetIndex = _children!.indexOf(child);
    if (targetIndex == -1 || targetIndex == _children!.length - 1) {
      return null;
    }
    return _children![targetIndex + 1];
  }

  /// 在children上查找child节点，并返回child节点的前一个节点
  E? _nodeBefore(E child) {
    if (_children?.isEmpty ?? true) {
      return null;
    }

    final targetIndex = _children!.indexOf(child);
    if (targetIndex == -1 || targetIndex == 0) {
      return null;
    }
    return _children![targetIndex - 1];
  }

  /// 判断e是否为自己的祖先
  bool isMyAncestor(E e) {
    var parent = _parent;
    while (parent != null) {
      if (parent == e) {
        return true;
      }
      parent = parent._parent;
    }
    return false;
  }

  void _replace(E element, {bool skipChildren = true}) {
    if (_parent != null) {
      final parent = _parent!;
      final indexWhere = parent.children!.indexWhere(
        (element) => element == this,
      );
      parent.children!.replaceRange(indexWhere, indexWhere + 1, [element]);
      element._parent = _parent;
      _parent = null;
    }
    if (skipChildren) {
      element._children = _children;
      element._children?.forEach((child) {
        child._parent = element;
      });
      _children = null;
    }
  }

  /// 把自己替换为一个新元素
  ///
  /// [skipChildren] 是否略过element的children。如果为true，element的children会被忽略
  void replaceBy(E element, {bool skipChildren = true}) {
    _replace(element, skipChildren: skipChildren);
  }

  /// 查找指定元素
  List<E>? where(bool Function(E element) test) {
    return _where(root, test);
  }

  List<E>? _where(E currentElement, bool Function(E element) test) {
    final result = <E>[];
    final testResult = test(currentElement);
    if (testResult) {
      result.add(currentElement);
    }

    if (currentElement.children != null) {
      final childResult = currentElement.children!.fold<List<E>>(<E>[], (
          previousValue,
          element,
          ) {
        final childWhereResult = _where(element, test);
        if (childWhereResult != null) {
          previousValue.addAll(childWhereResult);
        }
        return previousValue;
      });
      result.addAll(childResult);
    }
    return result;
  }
}

///
extension TreeList on Iterable<int> {
  /// 获取元素中最大的那个值
  int get maxValue {
    var result = 0;
    final ite = iterator;
    while (ite.moveNext()) {
      result = max(result, ite.current);
    }
    return result;
  }
}
