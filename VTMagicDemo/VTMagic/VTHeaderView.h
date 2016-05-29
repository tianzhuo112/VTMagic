//
//  VTHeaderView.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTHeaderView;
@protocol VTHeaderDatasource <NSObject>
/**
 *  根据index获取对应索引的header item
 *
 *  @param headerView self
 *  @param index      当前索引
 *
 *  @return 当前按钮
 */
- (UIButton *)headerView:(VTHeaderView *)headerView headerItemForIndex:(NSInteger)index;

@end

@protocol VTHeaderDelegate <NSObject>

@optional
/**
 *  item被点击时触发
 *
 *  @param headerView self
 *  @param itemBtn    被选中的按钮
 */
- (void)headerView:(VTHeaderView *)headerView didSelectedItem:(UIButton *)itemBtn;

@end

@interface VTHeaderView : UIScrollView
/**
 *  header字符串数组
 */
@property (nonatomic, strong) NSArray *headerList;
/**
 *  顶部正常item的字体
 */
@property (nonatomic, strong) UIFont *normalFont;
/**
 *  被选中的item的字体
 */
@property (nonatomic, strong) UIFont *selectedFont;
/**
 *  当前选中item对应的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  当前被选中的item
 */
@property (nonatomic, strong) UIButton *selectedItem;
/**
 *  item按钮文字的内边距（文字距离两侧边框的距离），默认是25
 */
@property (nonatomic, assign) CGFloat itemBorder;
/**
 *  数据源
 */
@property (nonatomic, weak) id <VTHeaderDatasource> datasource;
/**
 *  代理
 */
@property (nonatomic, weak) id <VTHeaderDelegate> headerDelegate;

/**
 *  刷新数据
 */
- (void)reloadData;
/**
 *  根据索引获取当前页面显示的item，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)itemWithIndex:(NSInteger)index;
/**
 *  根据重用标识查询可重用的headerItem
 *
 *  @param identifier 重用标识
 *
 *  @return 缓存池中取出的headerItem
 */
- (id)dequeueReusableHeaderItemWithIdentifier:(NSString *)identifier;

@end
