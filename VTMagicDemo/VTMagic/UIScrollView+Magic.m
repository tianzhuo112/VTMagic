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
    CGFloat referenceMinX = self.contentOffset.x;
    CGFloat referenceMaxX = referenceMinX + self.frame.size.width;
    CGFloat viewMinX = frame.origin.x;
    CGFloat viewMaxX = viewMinX + frame.size.width;
    BOOL isLeftBorderOnScreen = referenceMinX <= viewMinX && viewMinX <= referenceMaxX;
    BOOL isRightBorderOnScreen = referenceMinX <= viewMaxX && viewMaxX <= referenceMaxX;
    BOOL isOnScreen = isLeftBorderOnScreen || isRightBorderOnScreen;
    return isOnScreen;
}

@end
