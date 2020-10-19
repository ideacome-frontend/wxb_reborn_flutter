# Flutter 内嵌webview 方案

## 主要工作

1. 搭建flutter项目,集成以下
    - 封装网络请求dio（类axios）
    - 屏幕适配，主要根据屏幕宽度，按照UI在设计稿的比例，实现适配配
    - mobx状态管理、permission_handler权限管理等常用库
    - 命名路由、常用路由方法
    - qa、test 等环境配置
2. 对比并尝试了主流的几个webview库，找出性能好，并能实现js与flutter通信的库
3. js端参考wxb_bridge端实现flutter_bridge
4. flutter定义接收js端的command方法，实现以下方法  
    - hostInfo
    - openNewWebView
    - setNavBarVisibility
    - closeWebView
    - gotoAppSettings
    - saveImage

## webview与jsbrigde 原理

JS端通过postMessage 向 webview 发送 命令，传递uid 等，并将失败与成功的回调方法存储
flutter 端约定好常用的命令，并作出相应的操作后，通过执行js的方法与uid调用js_bridge 的回调方法

## 难点

难点主要在 选择合适的webview 库上（第一次使用webview_plugin加webview_flutter 后改为 overlay_webview）
用flutter引擎显示原生界面，在android上性能开销比较大
 <https://flutter.cn/docs/development/platform-integration/platform-views>
 <https://www.jianshu.com/p/ecebaaea0dd1>
 
原因是 flutter 在1.22(10正式月发布)之前，只有虚拟显示这一种显示原生界面的方法
虚拟显示： 将原生渲染的界面信息 Texture 通过texureID 进行映射，并由Flutter 图形引擎渲染，性能开销大。由于不是直接显示原生视图，存在键盘显示等bug

1.22 只后 增加混合合成实现。 可以将原生视图独立呈现，并与flutter 视图混合展示，在 Android 10 以下 存在性能问题

基于platform view 实现的 webview_flutter 与 flutterinappwebview 不适合以webview 为主的 混合应用

## 项目优劣与技术替代方案可行性

1. 可以将引入wxb等其他web项目url，实现高性能的webview 与flutter混合的app
2. bridge方法实现完全一致，只需替换wxb_brigde为flutter_bridge,项目重构代码更改量非常小  
3. 实现原生功能时更简单,只需引入相应的库，调用方法即可
4. app体积相对增加，（android端arm与arm-64打包后11.2M，仅arm打包后5.6M ）
5. 新打开webview实例时，暂未实现页面切换动画
6. 未来有纯flutter 项目也可以参考复制此项目搭建
