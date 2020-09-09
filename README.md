# wxb

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 项目打包

```shell
flutter build apk --target-platform android-arm,android-arm64 --build-number xxx --build-name x.xx
# --split-per-abi 代表分包，可不加
# 优化体积可只选择android-arm或arm64,arm兼容arm64的手机
```
