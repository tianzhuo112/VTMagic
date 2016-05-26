//
//  VTMagicViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VTMagicView.h"

#define NOTICENTER [NSNotificationCenter defaultCenter]
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

@interface VTMagicViewController ()

@property (nonatomic, assign) BOOL isDeviceChange;
@property (nonatomic, assign) BOOL isBackground;

@end

@implementation VTMagicViewController

- (void)loadView
{
    [super loadView];
    
    _magicView = [[VTMagicView alloc] initWithFrame:self.view.frame];
    _magicView.delegate = self;
    _magicView.dataSource = self;
    self.view = _magicView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - set 方法
- (void)setLeftHeaderView:(UIView *)leftHeaderView
{
    _leftHeaderView = leftHeaderView;
    
}

- (void)setRightHeaderView:(UIView *)rightHeaderView
{
    _rightHeaderView = rightHeaderView;
    
}

#pragma mark - magic view delegate & data source
- (NSArray *)headersForMagicView:(VTMagicView *)magicView
{
    return nil;
}

- (NSInteger)numberOfViewControllersInMagicView:(VTMagicView *)magicView
{
    return 0;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index
{
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSInteger)index
{
    NSLog(@"index:%ld viewControllerDidAppeare:%@",index, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSInteger)index
{
    NSLog(@"index:%ld viewControllerDidDisappeare:%@",index, viewController.view);
}

@end