//
//  UIViewController+VTMagic.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTMagicProtocol.h"

@interface UIViewController (VTMagic)<VTMagicReuseProtocol>

/**
 *  缓存重用标识
 */
@property (nonatomic, copy) NSString *reuseIdentifier;

/**
 *  主控制器
 */
@property (nonatomic, weak, readonly) UIViewController<VTMagicProtocol> *magicController;

/**
 *  当前控制器的页面索引，仅当前显示的和预加载的控制器有相应索引，
 *  若没有找到相应索引则返回NSNotFound
 *
 *  @return 页面索引
 */
- (NSInteger)vtm_pageIndex;

@end
