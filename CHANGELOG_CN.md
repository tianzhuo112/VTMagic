#变更日志
所有关于这个项目的重要修改都会记录在这个文件中。

--- 

## [1.2.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.2)
发布于2016年六月29日，周三

### 更新
- 新增方法reloadDataToPage:，支持刷新数据时直接定位到指定页面，简化逻辑；
- 优化生命周期逻辑，修复多次调用viewDidAppear:等方法的问题，完善了多级嵌套VTMagic时，生命周期方法触发异常的问题；
- 调整VTMagicViewDelegate代理方法名，viewDidAppeare:改为viewDidAppear:，viewDidDisappeare:改为viewDidDisappear:。


## [1.2.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.1)
发布于2016年六月19日，周日

### 更新
- 优化菜单栏显示逻辑，以便menuItem消失时更加自然；
- 新增属性`itemScale`，以使menuItem在切换时能有放大缩小的效果。


## [1.2.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.0)
发布于2016年六月13日，周一

### 更新
- 新增属性`sliderExtension`，以确保滑块两侧相对菜单文本的延长量始终一致；
- 优化VTMagicView内部子视图布局逻辑。


## [1.1.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.1.0)
发布于2016年六月4日，周六

### 更新
- 新增属性`sliderStyle`，同时增加气泡样式`VTSliderStyleBubble`；
- demo中新增**气泡**模块。


## [1.0.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.2)
发布于2016年六月2日，周四

### 更新
- 导航栏新增了居中布局样式`VTLayoutStyleCenter`；
- 优化了`headerView`的隐藏和显示逻辑；
- demo中新增**居中**、**平分**、**webview**等模块。

## [1.0.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.1)
发布于2016年六月1日，周三

### 更新
- 调整了VTMagic在Pods中显示的文件结构。


## [1.0.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.0)
初始版发布于2016年五月31日，周二

### 特性概要
- 每个页面都是一个完整独立的控制器，友好支持个性化自定义；
- 页面切换时能准确触发相应的生命周期方法（`viewWillAppear:`等），便于管理各自页面的数据加载和其它逻辑处理；
- 导航栏支持多种布局样式，包括自适应文本宽度、自动平分、居中布局以及自定义宽度等；
- 导航菜单项（menuItem）支持自定义，menuItem不止能显示文本，还可显示图片；
- 可以在任意子控制器中，通过`self.magicController`获取最近的上层主控制器，方便跨层级处理逻辑；
- 支持内嵌webview，若滑动手势无法响应，可以通过`handlePanGesture:`解决；
- 支持页面重用和横竖屏切换;
- 更多特性请参见`VTMagicView.h`文件。