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

@implementation UIViewController (Magic)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self magic_swizzle:@selector(magic_viewWillAppear:) selector:@selector(viewWillAppear:)];
        [self magic_swizzle:@selector(magic_viewDidAppear:) selector:@selector(viewDidAppear:)];
        [self magic_swizzle:@selector(magic_viewWillDisappear:) selector:@selector(viewWillDisappear:)];
        [self magic_swizzle:@selector(magic_viewDidDisappear:) selector:@selector(viewDidDisappear:)];
    });
}

#pragma mark - Method Swizzle
+ (void)magic_swizzle:(SEL)swizzledSelector selector:(SEL)originalSelector
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

- (void)magic_viewWillAppear:(BOOL)animated
{
    [self magic_viewWillAppear:animated];
    if ([self conformsToProtocol:@protocol(VTExtensionProtocal)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTExtensionProtocal> *)self currentViewController];
        [currentViewController beginAppearanceTransition:YES animated:animated];
        [self setMagic_willAppear:currentViewController ? YES : NO];
    }
}

- (void)magic_viewDidAppear:(BOOL)animated
{
    [self magic_viewDidAppear:animated];
    if ([self conformsToProtocol:@protocol(VTExtensionProtocal)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        if (![self magic_willAppear]) return;
        UIViewController *currentViewController = [(UIViewController<VTExtensionProtocal> *)self currentViewController];
        [currentViewController endAppearanceTransition];
    }
}

- (void)magic_viewWillDisappear:(BOOL)animated
{
    [self magic_viewWillDisappear:animated];
    if ([self conformsToProtocol:@protocol(VTExtensionProtocal)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTExtensionProtocal> *)self currentViewController];
        [currentViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)magic_viewDidDisappear:(BOOL)animated
{
    [self magic_viewDidDisappear:animated];
    if ([self conformsToProtocol:@protocol(VTExtensionProtocal)] && ![self shouldAutomaticallyForwardAppearanceMethods]) {
        UIViewController *currentViewController = [(UIViewController<VTExtensionProtocal> *)self currentViewController];
        [currentViewController endAppearanceTransition];
    }
}

#pragma mark - accessors
- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    objc_setAssociatedObject(self, kVTReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)reuseIdentifier
{
    return objc_getAssociatedObject(self, kVTReuseIdentifier);
}

- (void)setMagic_willAppear:(BOOL)magic_willAppear
{
    objc_setAssociatedObject(self, kVTMagicWillAppear, @(magic_willAppear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)magic_willAppear
{
    return [objc_getAssociatedObject(self, kVTMagicWillAppear) boolValue];
}

- (UIViewController<VTExtensionProtocal> *)magicController
{
    UIViewController *viewController = self.parentViewController;
    while (viewController) {
        if ([viewController conformsToProtocol:@protocol(VTExtensionProtocal)]) break;
        viewController = viewController.parentViewController;
    }
    return (UIViewController<VTExtensionProtocal> *)viewController;
}

@end
