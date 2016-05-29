//
//  VTMagicView.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTExtensionProtocal.h"

typedef enum : NSUInteger {
    VTSwitchStyleDefault,   // 默认模式，切换时有颜色渐变效果
    VTSwitchStyleStiff,     // 延迟响应切换
    VTSwitchStyleUnknown,   // ？？？
} VTSwitchStyle;

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

@end

@interface VTMagicView : UIView

/**
 *  切换模式，默认是VTSwitchStyleDefault
 */
@property (nonatomic, assign) VTSwitchStyle style;

/**
 *  数据源
 */
@property (weak, nonatomic) id<VTMagicViewDataSource> dataSource;

/**
 *  代理
 */
@property (weak, nonatomic) id<VTMagicViewDelegate, VTExtensionProtocal> delegate;

/****************************************sub views****************************************/
/**
 *  最顶部的头部组件，默认隐藏
 *  若需显示请通过属性headerHidden设置
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
 *  顶部导航栏背景色
 */
@property (nonatomic, strong) UIColor *navigationColor;

/**
 *  顶部导航栏底部分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  顶部导航栏滑块颜色
 */
@property (nonatomic, strong) UIColor *sliderColor;

/**
 *  顶部导航栏滑块宽度
 */
@property (nonatomic, assign) CGFloat sliderWidth;

/**
 *  头部组件的高度，默认64
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  顶部导航条的高度，默认是44
 *  默认情况下修改导航高度会同步修改item的高度
 *  若不希望两者高度保持一致，建议item的高度在导航之后修改
 */
@property (nonatomic, assign) CGFloat navHeight;

/**
 *  导航分类item的高度，默认与导航高度相等
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemBorder;

/**
 *  导航分类的item是否需要自适应宽度，默认NO
 *  需要注意的是，当autoResizing为YES时，itemBorder会失效
 */
@property (nonatomic, assign) BOOL autoResizing;

/**
 *  左右两侧是否需要反弹效果，默认NO
 */
@property (nonatomic, assign) BOOL needBounces;

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
 *  需要注意的是，直接修改该属性值页面不会立即会重新布局
 *  若希望立即生效，建议使用方法setDependStatusBar:animated:
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

/**************************************method**************************************/
/**
 *  重新加载所有数据
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

/**
 *  获取索引对应的ViewController
 *  若index超出范围或对应控制器不可见，则返回nil
 *
 *  @param index 索引
 *
 *  @return UIViewController对象
 */
- (UIViewController *)viewControllerWithIndex:(NSInteger)index;

/**
 *  切换到指定页面
 *
 *  @param pageIndex 页面索引
 *  @param animated  是否需要动画执行
 */
- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated;

@end
