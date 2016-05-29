//
//  VTMagicView.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTExtensionProtocal.h"

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
 *  获取所有分类名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray *)categoryNamesForMagicView:(VTMagicView *)magicView;
/**
 *  根据index获取对应索引的category item
 *
 *  @param magicView self
 *  @param index     当前索引
 *
 *  @return 当前索引对应的按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView categoryItemForIndex:(NSInteger)index;
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
/****************************************sub views****************************************/
/**
 *  最顶部的头部组件，默认隐藏
 */
@property (nonatomic, strong, readonly) UIView *headerView;
/**
 *  顶部导航视图
 */
@property (nonatomic, strong, readonly) UIView *navigationView;
/**
 *  顶部导航栏左侧视图
 */
@property (nonatomic, strong) UIView *leftHeaderView;
/**
 *  顶部导航栏右侧视图
 */
@property (nonatomic, strong) UIView *rightHeaderView;

/**************************************configurations**************************************/
/**
 *  顶部正常item的字体
 */
@property (nonatomic, strong) UIFont *normalFont;
/**
 *  顶部被选中的item的字体
 */
@property (nonatomic, strong) UIFont *selectedFont;
/**
 *  顶部导航栏背景色
 */
@property (nonatomic, strong) UIColor *navigationColor;
/**
 *  顶部导航栏底部分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;
/**
 *  顶部导航栏下划线颜色
 */
@property (nonatomic, strong) UIColor *slideColor;
/**
 *  头部组件的高度，默认64
 */
@property (nonatomic, assign) CGFloat headerHeight;
/**
 *  顶部导航条的高度，默认是44
 *  默认情况下修改导航高度会同步修改item的高度
 *  若不希望两者高度保持一致，建议item的高度在导航之后修改
 */
@property (nonatomic, assign) CGFloat navigationHeight;
/**
 *  导航分类item的高度，默认与导航高度相等
 */
@property (nonatomic, assign) CGFloat itemHeight;
/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemBorder;
/**
 *  底部是否需要扩展一个tabbar的高度，设置毛玻璃效果时或许有用，默认NO
 */
@property (nonatomic, assign) BOOL needExtendedBottom;
/**
 *  禁止切换，默认NO
 */
@property (nonatomic, assign) BOOL forbiddenSwitching;
/**
 *  顶部导航栏是否紧贴系统状态栏，即是否需要为状态栏留出20个点的区域，默认YES
 *  修改该属性本质上是调用方法setDependStatusBar:animated:，默认无动画
 */
@property (nonatomic, assign, getter=isDependStatusBar) BOOL dependStatusBar;
/**
 *  是否动画显示或隐藏顶部导航20点的区域
 *
 *  @param dependStatusBar 隐藏或显示
 *  @param animated        是否动画执行
 */
- (void)setDependStatusBar:(BOOL)dependStatusBar animated:(BOOL)animated;
/**
 *  是否隐藏头部组件，默认YES
 *  修改该属性本质上是调用方法setHeaderHidden:animated:，默认无动画
 */
@property (nonatomic, assign, getter=isHeaderHidden) BOOL headerHidden;
/**
 *  是否动画显示或隐藏头部组件
 *
 *  @param dependStatusBar 隐藏或显示
 *  @param animated        是否动画执行
 */
- (void)setHeaderHidden:(BOOL)headerHidden animated:(BOOL)animated;

/**
 *  代理
 */
@property (weak, nonatomic) id<VTMagicViewDelegate, VTExtensionProtocal> delegate;
/**
 *  数据源
 */
@property (weak, nonatomic) id<VTMagicViewDataSource> dataSource;

/**
 *  刷新数据
 */
- (void)reloadData;
/**
 *  查询可重用category item
 *
 *  @param identifier 重用标识
 *
 *  @return 可重用的category item
 */
- (id)dequeueReusableCatItemWithIdentifier:(NSString *)identifier;
/**
 *  根据缓存标识获取可重用的tableViewController
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的tableViewController
 */
- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier;

@end
