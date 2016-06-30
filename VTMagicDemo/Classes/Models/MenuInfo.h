//
//  MenuInfo.h
//  VTMagic
//
//  Created by tianzhuo on 6/30/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfo : NSObject

/**
 *  菜单标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  菜单id
 */
@property (nonatomic, copy) NSString *menuId;
/**
 *  最近一次刷新时间，自动刷新时间间隔为1h
 */
@property (nonatomic, assign) NSTimeInterval lastTime;

/**
 *  根据标题自动生成相应menu
 *
 *  @param title 标题
 *
 *  @return MenuInfo对象
 */
+ (instancetype)menuInfoWithTitl:(NSString *)title;

@end
