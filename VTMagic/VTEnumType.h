//
//  VTEnumType.h
//  VTMagic
//
//  Created by tianzhuo on 1/17/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#ifndef VTEnumType_h
#define VTEnumType_h

/** 导航栏布局样式 */
typedef NS_ENUM(NSUInteger, VTLayoutStyle) {
    /** 默认样式，item自适应文本宽度，间距由itemSpacing决定 */
    VTLayoutStyleDefault,
    /** items等分导航条宽度，常用于item数较少时 */
    VTLayoutStyleDivide,
    /** 导航栏居中布局，间距由itemSpacing决定 */
    VTLayoutStyleCenter,
    /** 自定义item宽度(itemWidth) */
    VTLayoutStyleCustom,
};

/** 页面滑动切换样式 */
typedef NS_ENUM(NSUInteger, VTSwitchStyle) {
    /** 默认样式，切换时有颜色渐变效果 */
    VTSwitchStyleDefault,
    /** 延迟响应切换 */
    VTSwitchStyleStiff,
    /** ？？？ */
    VTSwitchStyleUnknown,
};

/** 页面切换事件 */
typedef NS_ENUM(NSUInteger, VTSwitchEvent) {
    /** 加载 */
    VTSwitchEventLoad,
    /** 滑动 */
    VTSwitchEventScroll,
    /** 点击 */
    VTSwitchEventClick,
    /** 未知 */
    VTSwitchEventUnkown,
};

/** 导航栏滑块样式 */
typedef NS_ENUM(NSUInteger, VTSliderStyle) {
    /** 默认显示下划线 */
    VTSliderStyleDefault,
    /** 气泡样式，该样式下需结合bubbleInset和bubbleRadius使用 */
    VTSliderStyleBubble,
};

/** UIPanGestureRecognizer手势方向 */
typedef NS_ENUM(NSUInteger, VTPanRecognizerDirection) {
    VTPanRecognizerDirectionUndefined,  // 初始
    VTPanRecognizerDirectionVertical,   // 垂直
    VTPanRecognizerDirectionHorizontal, // 水平
};

#endif /* VTEnumType_h */
