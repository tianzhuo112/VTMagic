//
//  ViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "ViewController.h"
#import "RecomViewController.h"
#import "GridViewController.h"
#import "VTCommon.h"

@interface ViewController ()

@property (nonatomic, strong)  NSArray *menuList;

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.magicView.bounces = YES;
//    self.magicView.headerHidden = NO;
//    self.magicView.itemSpacing = 20.f;
//    self.magicView.switchEnabled = YES;
//    self.magicView.separatorHidden = NO;
    self.magicView.navigationHeight = 40;
    self.magicView.againstStatusBar = YES;
//    self.magicView.switchStyle = VTSwitchStyleStiff;
//    self.magicView.navigationInset = UIEdgeInsetsMake(0, 50, 0, 50);
    self.magicView.layoutStyle = kiPhoneDevice ? VTLayoutStyleDefault : VTLayoutStyleDivide;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self integrateComponents];
    
    [self addNotification];
    [self generateTempData];
    [self.magicView reloadData];
    [self.magicView switchToPage:2 animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)addNotification
{
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    // 默认会自动完成赋值
//    NSString *title = _menuList[itemIndex];
//    [menuItem setTitle:title forState:UIControlStateNormal];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (0 == pageIndex) {
        static NSString *recomId = @"recom.identifier";
        RecomViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
        if (!recomViewController) {
            recomViewController = [[RecomViewController alloc] init];
        }
        return recomViewController;
    }
    
    static NSString *gridId = @"grid.identifier";
    GridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[GridViewController alloc] init];
    }
    return viewController;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
//    NSLog(@"index:%ld viewDidAppeare:%@",pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
//    NSLog(@"index:%ld viewDidDisappeare:%@",pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
//    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - actions
- (void)subscribeAction
{
    NSLog(@"subscribeAction");
    // select/deselect menu item
    if (self.magicView.isDeselected) {
        [self.magicView reselectMenuItem];
        self.magicView.sliderHidden = NO;
    } else {
        [self.magicView deselectMenuItem];
        self.magicView.sliderHidden = YES;
    }
    
    // against status bar or not
    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [UIView animateWithDuration:0.35 animations:^{
        [self.magicView layoutIfNeeded];
    }];
}

#pragma mark - functional methods
- (void)generateTempData
{
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    [menuList addObject:@"推荐"];
    NSString *title = @"测试";
    for (int index = 0; index < 10; index++) {
        [menuList addObject:[NSString stringWithFormat:@"%@%d",title,index]];
    }
    _menuList = menuList;
}

- (void)integrateComponents
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateHighlighted];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

@end
