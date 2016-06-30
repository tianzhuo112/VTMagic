//
//  GridViewController.h
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuInfo;
@interface VTGridViewController : UICollectionViewController

/**
 *  菜单信息
 */
@property (nonatomic, strong) MenuInfo *menuInfo;

@end
