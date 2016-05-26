//
//  VTHeaderView.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTHeaderView;
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
 *  单个item
 */
@property (nonatomic, strong) UIButton *headerItem;
/**
 *  代理
 */
@property (nonatomic, weak) id <VTHeaderDelegate> headerDelegate;

/**
 *  根据索引获取当前页面显示的item，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的item
 */
- (UIButton *)itemWithIndex:(NSInteger)index;

@end
