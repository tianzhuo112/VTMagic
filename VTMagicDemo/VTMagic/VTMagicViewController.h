//
//  VTMagicViewController.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTMagicView.h"
#import "VTCommon.h"

@interface VTMagicViewController : UIViewController<VTMagicViewDelegate,VTMagicViewDataSource>

/**
 *  magic view，等同于self.view
 */
@property (nonatomic, strong) VTMagicView *magicView;

/**
 *  当前页面对应的索引
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 *  当前显示的控制器
 */
@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@end
