//
//  VTContentView.h
//  VTMagicView
//
//  Created by tianzhuo on 14/12/29.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTCommon.h"

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class VTContentView;
/**
 *  数据源
 */
@protocol VTContentViewDataSource <NSObject>
/**
 *  根据索引获取对应的控制器
 *
 *  @param content self
 *  @param index   索引
 *
 *  @return 当前索引对应的控制器
 */
- (UIViewController *)contentView:(VTContentView *)content viewControllerForIndex:(NSInteger)index;

@end

@interface VTContentView : UIScrollView
/**
 *  数据源
 */
@property (nonatomic, weak) id <VTContentViewDataSource> dataSource;
/**
 *  页面数量
 */
@property (nonatomic, assign) NSInteger dataCount;
/**
 *  屏幕上可见的控制器
 */
@property (nonatomic, strong) NSMutableArray *visibleList;

/**
 *  刷新数据
 */
- (void)reloadData;
/**
 *  横竖屏切换适配，设备旋转时调用
 */
- (void)layoutSubviewsWhenRotated;
/**
 *  重置frame，横竖屏切换时调用
 */
- (void)resetFrames;
/**
 *  根据缓存标识查询可重用的视图控制器
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的视图控制器
 */
- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier;

@end
