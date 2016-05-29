//
//  UIViewController+Magic.m
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "UIViewController+Magic.h"
#import <objc/runtime.h>

static const void *kVTReuseIdentifier = &kVTReuseIdentifier;

@implementation UIViewController (Magic)

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    objc_setAssociatedObject(self, kVTReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)reuseIdentifier
{
    return objc_getAssociatedObject(self, kVTReuseIdentifier);
}

- (UIViewController<VTExtensionProtocal> *)magicViewController
{
    UIViewController *viewController = self.parentViewController;
    while (viewController) {
        if ([viewController conformsToProtocol:@protocol(VTExtensionProtocal)]) break;
        viewController = viewController.parentViewController;
    }
    return (UIViewController<VTExtensionProtocal> *)viewController;
}

@end
