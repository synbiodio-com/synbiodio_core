import 'dart:math';

/// 树节点
abstract class TreeNode<E extends TreeNode<E>> {
  ///
  TreeNode({List<E>? children}) : _children = children;

  List<E>? _children;

  /// 父节点
  E? get parent => _parent;
  E? _parent;

  /// 前一个节点
  E? get previous => _previous;
  E? _previous;

  /// 后一个节点
  E? get next => _next;
  E? _next;

  /// 根节点
  E get root => _parent == null ? this as E : _parent!.root;

  /// 获取子节点列表
  List<E>? get children => _children;

  /// 是否为第一个节点
  bool get isHead => previous == null;

  /// 是否为最后一个节点
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
    if (_previous != null) {
      _previous!._next = element;
      element._previous = _previous;
      _previous = null;
    }
    if (_next != null) {
      _next!._previous = element;
      element._next = _next;
      _next = null;
    }
    if (skipChildren) {
      element._children = _children;
      _children = null;
    }
  }

  /// 把自己替换为一个新元素
  ///
  /// [skipChildren] 是否略过element的children。如果为true，element的children会被忽略
  void replaceBy(E element, {bool skipChildren = true}) {
    _replace(element, skipChildren: skipChildren);
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
