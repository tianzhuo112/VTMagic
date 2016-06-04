//
//  VTMenuBar.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//  分类栏

#import <UIKit/UIKit.h>
#import "VTEnumType.h"

@class VTMenuBar;
@protocol VTMenuBarDatasource <NSObject>
/**
 *  根据index获取对应索引的menuItem
 *
 *  @param menuBar self
 *  @param index   需要加载的menuItem对应的索引
 *
 *  @return 当前索引对应的按钮
 */
- (UIButton *)menuBar:(VTMenuBar *)menuBar menuItemAtIndex:(NSUInteger)index;

@end

@protocol VTMenuBarDelegate <NSObject>

@optional
/**
 *  导航菜单item被点击时触发
 *
 *  @param menuBar   self
 *  @param itemIndex 被选中的按钮索引
 */
- (void)menuBar:(VTMenuBar *)menuBar didSelectItemAtIndex:(NSUInteger)itemIndex;

@end

@interface VTMenuBar : UIScrollView

/**
 *  数据源
 */
@property (nonatomic, weak) id <VTMenuBarDatasource> datasource;

/**
 *  代理
 */
@property (nonatomic, weak) id <VTMenuBarDelegate> menuDelegate;

/**
 *  分类名数组，字符串类型
 */
@property (nonatomic, strong) NSArray<__kindof NSString *> *menuTitles;

/**
 *  导航菜单布局样式
 */
@property (nonatomic, assign) VTLayoutStyle layoutStyle;

/**
 *  当前选中item对应的索引
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/**
 *  当前被选中的item
 */
@property (nonatomic, strong, readonly) UIButton *selectedItem;

/**
 *  导航菜单item的选中状态是否已被取消，默认NO
 */
@property (nonatomic, assign, getter=isDeselected) BOOL deselected;

/**
 *  自定义item宽度，仅VTLayoutStyleCustom样式下有效
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 *  导航菜单的inset，对leftHeaderView和rightHeaderView无效
 */
@property (nonatomic, assign) UIEdgeInsets menuInset;

/**
 *  气泡相对menuItem文本的edgeInsets，默认(2, 5, 2, 5)
 */
@property (nonatomic, assign) UIEdgeInsets bubbleInset;

#pragma mark - public methods
/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  重置所有item的frame
 */
- (void)resetItemFrames;

/**
 *  更新选中按钮
 */
- (void)updateSelectedItem;

/**
 *  取消导航菜单item的选中状态
 */
- (void)deselectMenuItem;

/**
 *  恢复导航菜单item的选中状态
 */
- (void)reselectMenuItem;

/**
 *  根据索引获取对应item对应的frame
 *
 *  @param index 索引
 *
 *  @return 当前索引对应item的frame
 */
- (CGRect)itemFrameAtIndex:(NSUInteger)index;

/**
 *  根据索引获取对应item的气泡大小
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的气泡大小
 */
- (CGRect)bubbleFrameAtIndex:(NSUInteger)index;

/**
 *  根据索引获取当前页面显示的item，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)itemAtIndex:(NSUInteger)index;

/**
 *  根据索引生成对应的item，若对应item已经存在，则直接返回
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)createItemAtIndex:(NSUInteger)index;

/**
 *  根据重用标识查询可重用的category item
 *
 *  @param identifier 重用标识
 *
 *  @return 缓存池中取出的category item
 */
- (__kindof UIButton *)dequeueReusableItemWithIdentifier:(NSString *)identifier;

@end
