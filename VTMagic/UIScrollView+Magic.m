//
//  UIScrollView+Magic.m
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "UIScrollView+Magic.h"

@implementation UIScrollView (Magic)

- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame
{
    CGRect visibleRect = (CGRect){CGPointMake(self.contentOffset.x, 0), self.frame.size};
    CGRect intersectRegion = CGRectIntersection(frame, visibleRect);
    BOOL isOnScreen =  !CGRectIsNull(intersectRegion) || !CGRectIsEmpty(intersectRegion);
    return isOnScreen;
}

@end
