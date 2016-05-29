//
//  ViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "ViewController.h"
#import "RecomViewController.h"
#import "ListViewController.h"
#import "VTCommon.h"

@interface ViewController ()

@property (nonatomic, strong)  NSArray *headerList;
@property (nonatomic, strong) NSMutableArray *colorList; // temp

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.magicView.headerHidden = NO;
    self.magicView.navigationHeight = 40;
//    self.magicView.forbiddenSwitching = YES;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self integrateComponents];
    [self generateTempData];
    [self generateColors];
    [self.magicView reloadData];
}

#pragma mark - magic view delegate & data source
- (NSArray *)categoryNamesForMagicView:(VTMagicView *)magicView
{
    return _headerList;
}

- (UIButton *)magicView:(VTMagicView *)magicView categoryItemForIndex:(NSInteger)index
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *headerItem = [magicView dequeueReusableViewControllerWithIdentifier:itemIdentifier];
    if (!headerItem) {
        headerItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [headerItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        headerItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    NSString *title = _headerList[index];
    [headerItem setTitle:title forState:UIControlStateNormal];
    return headerItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index
{
    if (0 == index) {
        static NSString *playerId = @"playerIdentifier";
        RecomViewController *playerViewController = [magicView dequeueReusableViewControllerWithIdentifier:playerId];
        if (!playerViewController) {
            playerViewController = [[RecomViewController alloc] init];
        }
        return playerViewController;
    }
    
    static NSString *listId = @"magicIdentifier";
    ListViewController *viewController = [magicView dequeueReusableViewControllerWithIdentifier:listId];
    if (!viewController) {
        viewController = [[ListViewController alloc] init];
    }
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSInteger)index
{
    NSLog(@"index:%ld viewControllerDidAppeare:%@",index, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSInteger)index
{
    NSLog(@"index:%ld viewControllerDidDisappeare:%@",index, viewController.view);
}

#pragma mark - actions
- (void)subscribeAction
{
    NSLog(@"subscribeAction");
}

#pragma mark - functional methods
- (void)generateTempData
{
    NSMutableArray *headerList = [[NSMutableArray alloc] initWithCapacity:24];
    NSString *header = @"测试";
    for (int index = 0; index < 20; index++) {
        [headerList addObject:[NSString stringWithFormat:@"%@%d",header,index]];
    }
    _headerList = headerList;
}

- (void)generateColors
{
    if (_colorList.count) return;
    UIColor *backgroundColor = nil;
    _colorList = [[NSMutableArray alloc] initWithCapacity:_headerList.count];
    for (NSInteger i = 0; i < _headerList.count; i++) {
        backgroundColor = RGBCOLOR(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [_colorList addObject:backgroundColor];
    }
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
    self.magicView.rightHeaderView = rightButton;
}

@end
