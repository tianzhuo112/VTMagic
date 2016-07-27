//
//  DataManager.m
//  VTMagic
//
//  Created by tianzhuo on 7/21/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong) NSMutableDictionary *dataInfo;

@end

@implementation DataManager

+ (instancetype)sharedInstance {
    static DataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.dataInfo = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

- (void)savePageInfo:(NSArray *)infoList menuId:(NSString *)menuId {
    if (menuId) {
        [_dataInfo setObject:[NSArray arrayWithArray:infoList] forKey:menuId];
    }
}

- (NSArray *)pageInfoWithMenuId:(NSString *)menuId {
    return [_dataInfo objectForKey:menuId];
}

@end
