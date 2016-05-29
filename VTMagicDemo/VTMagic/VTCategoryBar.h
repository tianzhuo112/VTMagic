//
//  VTCategoryBar.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//  分类栏

#import <UIKit/UIKit.h>

@class VTCategoryBar;
@protocol VTCategoryBarDatasource <NSObject>
/**
 *  根据index获取对应索引的category item
 *
 *  @param catBar self
 *  @param index      当前索引
 *
 *  @return 当前按钮
 */
- (UIButton *)categoryBar:(VTCategoryBar *)catBar categoryItemForIndex:(NSUInteger)index;

@end

@protocol VTCagetoryBarDelegate <NSObject>

@optional
/**
 *  item被点击时触发
 *
 *  @param categoryBar self
 *  @param itemBtn    被选中的按钮
 */
- (void)categoryBar:(VTCategoryBar *)catBar didSelectedItemAtIndex:(NSUInteger)itemIndex;

@end

@interface VTCategoryBar : UIScrollView

/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  重置所有item的frame
 */
- (void)resetFrames;

/**
 *  更新选中按钮
 */
- (void)updateSelectedItem;

/**
 *  根据索引获取对应item对应的frame
 *
 *  @param index 索引
 *
 *  @return 当前索引对应item的frame
 */
- (CGRect)itemFrameWithIndex:(NSUInteger)index;

/**
 *  根据索引获取当前页面显示的item，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)itemWithIndex:(NSUInteger)index;

/**
 *  根据索引生成对应的item，若对应item已经存在，则直接返回
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)createItemWithIndex:(NSUInteger)index;

/**
 *  根据重用标识查询可重用的category item
 *
 *  @param identifier 重用标识
 *
 *  @return 缓存池中取出的category item
 */
- (id)dequeueReusableCatItemWithIdentifier:(NSString *)identifier;

/**
 *  数据源
 */
@property (nonatomic, weak) id <VTCategoryBarDatasource> datasource;

/**
 *  代理
 */
@property (nonatomic, weak) id <VTCagetoryBarDelegate> catDelegate;

/**
 *  分类名数组，字符串类型
 */
@property (nonatomic, strong) NSArray *catNames;

/**
 *  导航分类的item是否需要自适应宽度，默认NO
 */
@property (nonatomic, assign) BOOL autoResizing;

/**
 *  当前选中item对应的索引
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/**
 *  当前被选中的item
 */
@property (nonatomic, strong) UIButton *selectedItem;

/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemBorder;

@end
