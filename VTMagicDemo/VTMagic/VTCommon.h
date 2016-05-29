//
//  VTCommon.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#ifndef VTMagicView_VTCommon_h
#define VTMagicView_VTCommon_h

#import "UIViewController+Magic.h"

/** 自定义Log  */
#ifdef DEBUG
#define VTLog(...) NSLog(__VA_ARGS__)
#else
#define VTLog(...)
#endif

// weakSelf
#define __DEFINE_WEAK_SELF__ __weak __typeof(&*self) weakSelf = self;

// 打印当前方法名
#define VTPRINT_METHOD VTLog(@"==Running %@:%p '%@'==", self.class, self, NSStringFromSelector(_cmd));

// 打印方法运行时间
#define TIME_BEGIN NSDate * startTime = [NSDate date];
#define TIME_END NSLog(@"time interval: %f", -[startTime timeIntervalSinceNow]);

// 设置RGBA颜色值
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(1.f)]

// 判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS5_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")
#define iOS6_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define iOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define iOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define iOS9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

/**
 *  tabbar高度
 */
#define TABBAR_HEIGHT_VT 49

#endif
