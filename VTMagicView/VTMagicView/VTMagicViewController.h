//
//  VTMagicViewController.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTMagicView.h"

@interface VTMagicViewController : UIViewController<VTMagicViewDelegate,VTMagicViewDataSource>

@property (nonatomic, strong) VTMagicView *magicView;
/**
 *  顶部标签栏左侧视图
 */
@property (nonatomic, strong) UIView *leftHeaderView;
/**
 *  顶部标签栏右侧视图
 */
@property (nonatomic, strong) UIView *rightHeaderView;
/**
 *  当前页面对应的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  当前显示的控制器
 */
@property (nonatomic, strong) UIViewController *currentViewController;

@end
