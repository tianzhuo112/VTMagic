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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.magicView.headerItem = button;
    self.magicView.navigationColor = RGBCOLOR(239, 239, 239);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self integrateComponents];
    [self generateTempData];
    [self generateColors];
    [self.magicView reloadData];
}

#pragma mark - magic view delegate & data source
- (NSArray *)headersForMagicView:(VTMagicView *)magicView
{
    return _headerList;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index
{
    if (0 == index) {
        static NSString *playerID = @"playerIdentifier";
        RecomViewController *playerViewController = [magicView dequeueReusableViewControllerWithIdentifier:playerID];
        if (!playerViewController) {
            playerViewController = [[RecomViewController alloc] init];
        }
        return playerViewController;
    }
    
    static NSString *ID = @"magicIdentifier";
    ListViewController *viewController = [magicView dequeueReusableViewControllerWithIdentifier:ID];
    if (!viewController) {
        viewController = [[ListViewController alloc] init];
    }
    
    viewController.view.backgroundColor = _colorList[index];
    [viewController updatePageInfo:index];
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
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    leftButton.center = self.view.center;
    [leftButton setTitle:@"左侧" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.magicView.leftHeaderView = leftButton;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightButton.center = self.view.center;
    [rightButton setTitle:@"右侧" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.magicView.rightHeaderView = rightButton;
}

@end
