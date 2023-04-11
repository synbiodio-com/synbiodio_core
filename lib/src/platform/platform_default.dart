import 'dart:io';

/// 判断当前用户的操作系统是否为 Windows
/// 并非本flutter平台
bool isWindows() {
  return Platform.isWindows;
}

/// 判断当前用户的操作系统是否为 Mac OS
/// 并非本flutter平台
bool isMacOS() {
  return Platform.isMacOS;
}

/// 判断当前用户的操作系统是否为 Linux
/// 并非本flutter平台
bool isLinux() {
  return Platform.isLinux;
}
