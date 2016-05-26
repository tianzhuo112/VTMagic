//
//  VTMagicView.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTMagicView;

/****************************************delegate****************************************/
@protocol VTMagicViewDelegate <NSObject>

@optional
/**
 *  视图控制器显示到当前屏幕上时触发
 *
 *  @param magicView      self
 *  @param viewController 当前页面展示的控制器
 *  @param index          当前控控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSInteger)index;
/**
 *  视图控制器从屏幕上消失时触发
 *
 *  @param magicView      self
 *  @param viewController 消失的视图控制器
 *  @param index          当前控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSInteger)index;

@end

/****************************************data source****************************************/

@protocol VTMagicViewDataSource <NSObject>
/**
 *  顶部header字符串数组
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray *)headersForMagicView:(VTMagicView *)magicView;
/**
 *  当前索引对应的控制器
 *
 *  @param magicView self
 *  @param index     当前索引
 *
 *  @return 控制器
 */
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index;

@optional

@end

@interface VTMagicView : UIView
/**
 *  顶部导航栏item
 */
@property (nonatomic, strong) UIButton *headerItem;
/**
 *  顶部导航栏左侧视图
 */
@property (nonatomic, strong) UIView *leftHeaderView;
/**
 *  顶部导航栏右侧视图
 */
@property (nonatomic, strong) UIView *rightHeaderView;
/**
 *  顶部导航栏背景色
 */
@property (nonatomic, strong) UIColor *navigationColor;
/**
 *  顶部导航栏下划线颜色
 */
@property (nonatomic, strong) UIColor *slideColor;
/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemBorder;
/**
 *  代理
 */
@property (weak, nonatomic) id<VTMagicViewDelegate> delegate;
/**
 *  数据源
 */
@property (weak, nonatomic) id<VTMagicViewDataSource> dataSource;

/**
 *  刷新数据
 */
- (void)reloadData;
/**
 *  根据缓存标识获取可重用的tableViewController
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的tableViewController
 */
- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier;

@end
