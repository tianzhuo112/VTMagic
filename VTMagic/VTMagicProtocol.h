//
//  VTMagicProtocol.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/11.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VTMagicView;
@protocol VTMagicProtocol <NSObject>

@required
/**
 *  当前页面索引
 */
- (NSInteger)currentPage;
/**
 *  当前页面索引的setter方法，外部禁止直接修改
 */
- (void)setCurrentPage:(NSInteger)currentPage;

/**
 *  当前页面控制器
 */
- (__kindof UIViewController *)currentViewController;
/**
 *  当前页面控制器的setter方法
 *
 *  @param currentViewController 当前页面控制器，外部禁止直接修改
 */
- (void)setCurrentViewController:(UIViewController *)currentViewController;

@optional
/**
 *  任何magicController默认都会有对应的magicView
 */
- (VTMagicView *)magicView;

/**
 *  magicController是否已经显示
 */
- (BOOL)magicHasAppeared;
/**
 *  magicController是否已经显示，外部禁止直接修改
 */
- (void)setMagicAppeared:(BOOL)magicAppeared;

@end
