/// 环境信息
class Environment {
  /// 构造函数
  Environment({
    required this.envType,
  });

  /// 环境类型
  final EnvType envType;
}

/// 环境类型
enum EnvType {
  /// 开发环境
  dev,

  /// 测试环境
  test,

  /// 预发布环境
  pre,

  /// 生产环境
  prod,
}
