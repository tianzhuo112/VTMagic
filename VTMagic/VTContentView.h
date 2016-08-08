//
//  VTContentView.h
//  VTMagicView
//
//  Created by tianzhuo on 14/12/29.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//  内容页

#import <UIKit/UIKit.h>
#import "VTMagicMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class VTContentView;
/**
 *  数据源协议
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
- (UIViewController *)contentView:(VTContentView *)contentView viewControllerAtPage:(NSUInteger)pageIndex;

@end

@interface VTContentView : UIScrollView

/**
 *  数据源
 */
@property (nonatomic, weak, nullable) id <VTContentViewDataSource> dataSource;

/**
 *  页面数量
 */
@property (nonatomic, assign) NSUInteger pageCount;

/**
 *  当前页面索引
 */
@property (nonatomic, assign) NSUInteger currentPage;

/**
 *  是否需要预加载下一页，默认YES
 */
@property (nonatomic, assign) BOOL needPreloading;

/**
 *  当前屏幕上已加载的控制器
 */
@property (nonatomic, strong, readonly) NSArray *visibleList;

#pragma mark - public methods
/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  重置所有内容页的frame
 */
- (void)resetPageFrames;

/**
 *  清除所有缓存的页面
 */
- (void)clearMemoryCache;

/**
 *  根据控制器获取对应的页面索引，仅当前显示的和预加载的控制器有相应索引，
 *  若没有找到相应索引则返回NSNotFound
 *
 *  @param viewController 页面控制器
 *
 *  @return 页面索引
 */
- (NSInteger)pageIndexForViewController:(nullable UIViewController *)viewController;

/**
 *  根据页面索引获取对应页面的frame
 *
 *  @param pageIndex 页面索引
 *
 *  @return 页面索引
 */
- (CGRect)frameOfViewControllerAtPage:(NSUInteger)pageIndex;

/**
 *  获取索引对应的ViewController
 *  若index超出范围或对应控制器不可见，则返回nil
 *
 *  @param index 索引
 *
 *  @return UIViewController对象
 */
- (nullable UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex;

/**
 *  根据索引生成对应的ViewController，若对应ViewController已经存在，则直接返回
 *
 *  @param index 索引
 *
 *  @return UIViewController对象
 */
- (nullable UIViewController *)creatViewControllerAtPage:(NSUInteger)pageIndex;

/**
 *  获取索引对应的ViewController，当ViewController为nil时，根据autoCreate的值决定是否创建
 *
 *  @param index      索引
 *  @param autoCreate 是否需要自动创建新的ViewController
 *
 *  @return UIViewController对象
 */
- (nullable UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex autoCreate:(BOOL)autoCreate;

/**
 *  根据缓存标识查询可重用的UIViewController
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的视图控制器
 */
- (nullable __kindof UIViewController *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END