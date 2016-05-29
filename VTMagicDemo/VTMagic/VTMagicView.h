//
//  VTMagicView.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTExtensionProtocal.h"
#import "VTEnumType.h"

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
- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSUInteger)index;

/**
 *  视图控制器从屏幕上消失时触发
 *
 *  @param magicView      self
 *  @param viewController 消失的视图控制器
 *  @param index          当前控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSUInteger)index;

/**
 *  选中导航分类item时触发
 *
 *  @param magicView self
 *  @param itemIndex 分类索引
 */
- (void)magicView:(VTMagicView *)magicView didSelectedItemAtIndex:(NSUInteger)itemIndex;

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
- (NSArray<__kindof NSString *> *)categoryNamesForMagicView:(VTMagicView *)magicView;

/**
 *  根据index获取对应索引的category item
 *
 *  @param magicView self
 *  @param index     当前索引
 *
 *  @return 当前索引对应的按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView categoryItemForIndex:(NSUInteger)index;

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

#pragma mark - public method
/**************************************public method**************************************/

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
- (__kindof UIButton *)dequeueReusableCatItemWithIdentifier:(NSString *)identifier;

/**
 *  根据缓存标识获取可重用的tableViewController
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的tableViewController
 */
- (__kindof UIViewController *)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier;

/**
 *  根据索引获取当前页面显示的item，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)categoryItemWithIndex:(NSUInteger)index;

/**
 *  获取索引对应的ViewController
 *  若index超出范围或对应控制器不可见，则返回nil
 *
 *  @param index 索引
 *
 *  @return UIViewController对象
 */
- (__kindof UIViewController *)viewControllerWithIndex:(NSUInteger)index;

/**
 *  切换到指定页面
 *
 *  @param pageIndex 页面索引
 *  @param animated  是否需要动画执行
 */
- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated;

/**
 *  处理UIPanGestureRecognizer手势，用于解决页面内嵌UIWebView时无法响应手势问题
 *
 *  @param recognizer 手势
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;

/**
 *  更新导航分类名，但不重新加载页面
 *  仅限于分类顺序和页数不改变的情况下
 *  一般情况下建议使用reloadData方法
 */
- (void)updateCategoryNames;

#pragma mark - basic configurations
/****************************************basic configurations****************************************/

/**
 *  数据源
 */
@property (nonatomic, weak) id<VTMagicViewDataSource> dataSource;

/**
 *  代理
 *  若delegate为UIViewController并且实现了VTExtensionProtocal协议，
 *  则主控制器(mainViewController)默认与其相同
 */
@property (nonatomic, weak) id<VTMagicViewDelegate> delegate;

/**
 *  主控制器，若delegate遵循协议VTExtensionProtocal，则默认与其相同
 *  注：若继承自VTMagicViewController，则不需要设置该属性
 */
@property (nonatomic, weak) UIViewController<VTExtensionProtocal> *magicViewController;

/**
 *  切换样式，默认是VTSwitchStyleDefault
 */
@property (nonatomic, assign) VTSwitchStyle switchStyle;

/**
 *  导航菜单布局样式
 */
@property (nonatomic, assign) VTLayoutStyle layoutStyle;

#pragma mark - subviews
/****************************************subviews****************************************/

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

/**
 *  屏幕上可见的控制器
 */
@property (nonatomic, strong, readonly) NSArray<__kindof UIViewController *> *viewControllers;

#pragma mark - bool configurations
/****************************************bool configurations****************************************/

/**
 *  导航分类的item是否需要自动平分导航宽度，默认NO
 *  需要注意的是，当autoResizing为YES时，itemBorder会失效
 */
@property (nonatomic, assign) BOOL autoResizing;

/**
 *  是否允许页面左右滑动，默认YES
 */
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

/**
 *  是否允许导航左右滑动，默认YES
 */
@property (nonatomic, assign, getter= isNaviScrollEnabled) BOOL naviScrollEnabled;

/**
 *  是否允许切换，包括左右滑动和点击切换，默认YES
 *  若禁止，则所有切换事件全部无响应，非特殊情况不应修改本属性
 */
@property (nonatomic, assign, getter=isSwitchEnabled) BOOL switchEnabled;

/**
 *  点击导航分类切换页面时是否需要动画，默认YES
 */
@property (nonatomic, assign, getter=isSwitchAnimated) BOOL switchAnimated;

/**
 *  隐藏滑块
 */
@property (nonatomic, assign) BOOL hideSlider;

/**
 *  隐藏导航分割线
 */
@property (nonatomic, assign) BOOL hideSeparator;

/**
 *  左右两侧是否需要反弹效果，默认NO
 */
@property (nonatomic, assign) BOOL needBounces;

/**
 *  底部是否需要扩展一个tabbar的高度，设置毛玻璃效果时或许有用，默认NO
 */
@property (nonatomic, assign) BOOL needExtendedBottom;

/**
 *  顶部导航栏是否紧贴系统状态栏，即是否需要为状态栏留出20个点的区域，默认NO
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
 */
@property (nonatomic, assign, getter=isHeaderHidden) BOOL headerHidden;
/**
 *  是否动画显示或隐藏头部组件
 *
 *  @param dependStatusBar 隐藏或显示
 *  @param animated        是否动画执行
 */
- (void)setHeaderHidden:(BOOL)headerHidden animated:(BOOL)animated;

#pragma mark - color & size configurations
/**************************************color & size**************************************/

/**
 *  顶部导航栏背景色
 */
@property (nonatomic, strong) UIColor *navigationColor;

/**
 *  顶部导航栏底部分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  导航栏分割线高度，默认0.5个点
 */
@property (nonatomic, assign) CGFloat separatorHeight;

/**
 *  顶部导航栏滑块颜色
 */
@property (nonatomic, strong) UIColor *sliderColor;

/**
 *  顶部导航栏滑块高度，默认2
 */
@property (nonatomic, assign) CGFloat sliderHeight;

/**
 *  顶部导航栏滑块宽度，默认与item宽度一致
 */
@property (nonatomic, assign) CGFloat sliderWidth;

/**
 *  顶部导航栏滑块相对导航底部的偏移量，默认0，上偏为负
 */
@property (nonatomic, assign) CGFloat sliderOffset;

/**
 *  头部组件的高度，默认64
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  顶部导航条的高度，默认是44
 *  默认情况下修改导航高度会同步修改item的高度
 *  若不希望两者高度保持一致，建议item的高度在导航之后修改
 */
@property (nonatomic, assign) CGFloat naviHeight;

/**
 *  自定义item宽度，仅VTLayoutStyleCustom样式下有效
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  两个导航分类item文本之间的间距，默认是25
 *  如果分类item包含图片，则实际间距可能会更小
 */
@property (nonatomic, assign) CGFloat itemBorder;

/**
 *  导航分类条的inset，对leftHeaderView和rightHeaderView无效
 */
@property (nonatomic, assign) UIEdgeInsets navigationInset;

#pragma mark - other properties
/**************************************other properties**************************************/

/**
 *  页面切换事件，用于行为统计
 */
@property (nonatomic, assign, readonly) VTSwitchEvent switchEvent;

/**
 *  导航分类item的预览数，默认1
 */
@property (nonatomic, assign) NSUInteger previewItems;

@end
