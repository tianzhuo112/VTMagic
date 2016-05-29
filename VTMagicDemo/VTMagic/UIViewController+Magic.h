//
//  UIViewController+Magic.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Magic)

/**
 *  缓存重用标识
 */
@property (nonatomic, copy) NSString *reuseIdentifier;

@end
