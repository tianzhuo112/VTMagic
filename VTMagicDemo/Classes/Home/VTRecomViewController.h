//
//  RecomViewController.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-13.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuInfo;
@interface VTRecomViewController : UITableViewController

/**
 *  菜单信息
 */
@property (nonatomic, strong) MenuInfo *menuInfo;

@end
