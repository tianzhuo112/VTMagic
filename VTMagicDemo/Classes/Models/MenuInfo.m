//
//  MenuInfo.m
//  VTMagic
//
//  Created by tianzhuo on 6/30/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "MenuInfo.h"

@implementation MenuInfo

+ (instancetype)menuInfoWithTitl:(NSString *)title {
    MenuInfo *menu = [[MenuInfo alloc] init];
    menu.menuId = [NSString stringWithFormat:@"%d", arc4random_uniform(100000)];
    menu.title = title;
    return menu;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title: %@ menuId: %@>", [self class], self, _title, _menuId];
}

@end
