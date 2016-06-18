//
//  VTDivideViewController.m
//  VTMagic
//
//  Created by tianzhuo on 6/1/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTDivideViewController.h"
#import "VTGridViewController.h"
#import <VTMagic/VTMagic.h>

@interface VTDivideViewController()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong)  NSArray *menuList;

@end

@implementation VTDivideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = RGBCOLOR(169, 37, 37);
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.againstStatusBar = YES;
    self.magicView.navigationHeight = 40.f;
    self.magicView.sliderExtension = 10.0;
    [self integrateComponents];
    
    [self generateTestData];
    [self.magicView reloadData];
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
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *gridId = @"grid.identifier";
    VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTGridViewController alloc] init];
    }
    return viewController;
}

#pragma mark - actions
- (void)subscribeAction
{
    NSLog(@"取消／恢复菜单栏选中状态");
    // select/deselect menu item
    if (self.magicView.isDeselected) {
        [self.magicView reselectMenuItem];
        self.magicView.sliderHidden = NO;
    } else {
        [self.magicView deselectMenuItem];
        self.magicView.sliderHidden = YES;
    }
}

#pragma mark - functional methods
- (void)generateTestData
{
    _menuList = @[@"国内", @"国外", @"港澳", @"台湾"];
}

- (void)integrateComponents
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

@end
