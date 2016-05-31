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
static const void *kVTMagicWillAppear = &kVTMagicWillAppear;
static const void *kVTMagicAppeared = &kVTMagicAppeared;

@implementation UIViewController (Magic)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self vtm_swizzle:@selector(vtm_viewWillAppear:) selector:@selector(viewWillAppear:)];
        [self vtm_swizzle:@selector(vtm_viewDidAppear:) selector:@selector(viewDidAppear:)];
        [self vtm_swizzle:@selector(vtm_viewWillDisappear:) selector:@selector(viewWillDisappear:)];
        [self vtm_swizzle:@selector(vtm_viewDidDisappear:) selector:@selector(viewDidDisappear:)];
    });
}

#pragma mark - Method Swizzle
+ (void)vtm_swizzle:(SEL)swizzledSelector selector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)vtm_viewWillAppear:(BOOL)animated
{
    [self vtm_viewWillAppear:animated];
    if ([self conformsToProtocol:@protocol(VTMagicProtocol)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTMagicProtocol> *)self currentViewController];
        [currentViewController beginAppearanceTransition:YES animated:animated];
        [self setMagicWillAppear:currentViewController ? YES : NO];
    }
}

- (void)vtm_viewDidAppear:(BOOL)animated
{
    [self vtm_viewDidAppear:animated];
    if ([self conformsToProtocol:@protocol(VTMagicProtocol)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        [(UIViewController<VTMagicProtocol> *)self setMagicHasAppeared:YES];
        if (![self magicWillAppear]) return;
        UIViewController *currentViewController = [(UIViewController<VTMagicProtocol> *)self currentViewController];
        [currentViewController endAppearanceTransition];
    }
}

- (void)vtm_viewWillDisappear:(BOOL)animated
{
    [self vtm_viewWillDisappear:animated];
    if ([self conformsToProtocol:@protocol(VTMagicProtocol)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTMagicProtocol> *)self currentViewController];
        [currentViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)vtm_viewDidDisappear:(BOOL)animated
{
    [self vtm_viewDidDisappear:animated];
    if ([self conformsToProtocol:@protocol(VTMagicProtocol)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTMagicProtocol> *)self currentViewController];
        [currentViewController endAppearanceTransition];
        [(UIViewController<VTMagicProtocol> *)self setMagicHasAppeared:NO];
    }
}

#pragma mark - accessor methods
- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    objc_setAssociatedObject(self, kVTReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)reuseIdentifier
{
    return objc_getAssociatedObject(self, kVTReuseIdentifier);
}

- (void)setMagicWillAppear:(BOOL)magicWillAppear
{
    objc_setAssociatedObject(self, kVTMagicWillAppear, @(magicWillAppear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)magicWillAppear
{
    return [objc_getAssociatedObject(self, kVTMagicWillAppear) boolValue];
}

- (void)setMagicHasAppeared:(BOOL)magicHasAppeared
{
    objc_setAssociatedObject(self, kVTMagicAppeared, @(magicHasAppeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)magicHasAppeared
{
    return [objc_getAssociatedObject(self, kVTMagicAppeared) boolValue];
}

- (UIViewController<VTMagicProtocol> *)magicController
{
    UIViewController *viewController = self.parentViewController;
    while (viewController) {
        if ([viewController conformsToProtocol:@protocol(VTMagicProtocol)]) break;
        viewController = viewController.parentViewController;
    }
    return (UIViewController<VTMagicProtocol> *)viewController;
}

@end
