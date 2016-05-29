//
//  VTEnumType.h
//  VTMagic
//
//  Created by tianzhuo on 1/17/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#ifndef VTEnumType_h
#define VTEnumType_h

/** 页面滑动切换样式 */
typedef enum : NSUInteger {
    /** 默认样式，切换时有颜色渐变效果 */
    VTSwitchStyleDefault,
    /** 延迟响应切换 */
    VTSwitchStyleStiff,
    /** ？？？ */
    VTSwitchStyleUnknown,
} VTSwitchStyle;

/** 页面切换事件 */
typedef enum : NSUInteger {
    /** 加载 */
    VTSwitchEventLoad,
    /** 滑动 */
    VTSwitchEventScroll,
    /** 点击 */
    VTSwitchEventClick,
    /** 未知 */
    VTSwitchEventUnkown,
} VTSwitchEvent;

/** 导航条布局样式 */
typedef enum : NSUInteger {
    /** 默认样式，自适应文本宽度，间距由itemBorder决定 */
    VTLayoutStyleDefault,
    /** 自动等分导航条宽度，常用于item数不超过四个时 */
    VTLayoutStyleAutoDivide,
    /** 自定义item宽度(itemWidth) */
    VTLayoutStyleCustom,
} VTLayoutStyle;

#endif /* VTEnumType_h */
