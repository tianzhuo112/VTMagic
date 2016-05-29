//
//  UIScrollView+Magic.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Magic)

/**
 *  判断指定的frame是否在当前屏幕的可视范围内
 */
- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame;

@end
