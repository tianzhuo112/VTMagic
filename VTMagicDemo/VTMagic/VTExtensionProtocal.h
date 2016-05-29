//
//  VTExtensionProtocal.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/11.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//  私有协议，子类禁止重写

#import <Foundation/Foundation.h>

@protocol VTExtensionProtocal <NSObject>

@required
/**
 *  当前显示的页面控制器已发生改变
 *  私有协议，仅允许在VTMagicViewController内部实现，子类禁止重写父类实现
 *
 *  @param viewController 当前显示的页面控制器
 */
- (void)displayViewControllerDidChanged:(UIViewController *)viewController index:(NSUInteger)index;

/**
 *  控制器即将添加到页面上时触发
 *  私有协议，仅允许在VTMagicViewController内部实现，子类禁止重写父类实现
 *
 *  @param viewController 控制器
 *  @param index          当前控制器的索引
 */
- (void)viewControllerWillAddToContentView:(UIViewController *)viewController index:(NSUInteger)index;

@end
