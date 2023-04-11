import 'dart:html' as html;

/// 判断当前用户的操作系统是否为 Windows
/// 此时kIsWeb为true
bool isWindows() {
  return html.window.navigator.userAgent.contains('Win');
}

/// 判断当前用户的操作系统是否为 Mac OS
/// 此时kIsWeb为true
bool isMacOS() {
  return html.window.navigator.userAgent.contains('Mac OS');
}

/// 判断当前用户的操作系统是否为 Linux
/// 此时kIsWeb为true
bool isLinux() {
  return html.window.navigator.userAgent.contains('Linux');
}