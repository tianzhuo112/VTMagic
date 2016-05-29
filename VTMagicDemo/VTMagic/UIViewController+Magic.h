//
//  UIViewController+Magic.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTExtensionProtocal.h"

@interface UIViewController (Magic)

/**
 *  缓存重用标识
 */
@property (nonatomic, copy) NSString *reuseIdentifier;

/**
 *  主控制器
 */
@property (nonatomic, weak, readonly) UIViewController<VTExtensionProtocal> *magicController;

@end
