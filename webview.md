## webview_flutter 官方组件

- 功能齐全
- 路由拦截等
- ios支持手势返回
- **缺点** ： 仍然处于预览版 聚焦键盘弹出的重大问题 在部分机型仍现、 第一次加载webview有时会出现闪屏 流畅性不如plugin

## flutter_webview_plugin 社区组件

- 功能较为齐全
- ios不支持手势返回
- 全局仅有一个实例，不支持打开多个webview
- 不存在于flutter widget 树中 不存在 键盘等问题
- 只能覆盖 flutter 视图，flutter 无法翟盖它
- 最为流畅

## flutterinappwebview

- 可以自由嵌入flutter 视图
- 有浏览器模式
- 有后台运行模式
- 流畅性能最差，也存在部分键盘bug

## overlay_webview

- 实现方式类似flutter_webview_plugin
- 原生界面性能流畅
- 只能覆盖 flutter 视图
- 没有实现页面切换动画

-fork后地址： <https://github.com/yanqiqi1996/overlay_webview>
