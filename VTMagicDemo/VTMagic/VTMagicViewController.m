//
//  VTMagicViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicViewController.h"
#import "VTMagicView.h"

#define NOTICENTER [NSNotificationCenter defaultCenter]
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

@interface VTMagicViewController ()

@property (nonatomic, assign) BOOL isDeviceChange;

@end

@implementation VTMagicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        } else if ([self respondsToSelector:@selector(setWantsFullScreenLayout:)]) {
            self.wantsFullScreenLayout = YES;
        }
        
        _magicView = [[VTMagicView alloc] init];
        _magicView.delegate = self;
        _magicView.dataSource = self;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _magicView.frame = self.view.frame;
    self.view = _magicView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 刷新数据
    [_magicView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - VTMagicViewDataSource & VTMagicViewDelegate
- (NSArray *)categoryNamesForMagicView:(VTMagicView *)magicView
{
    return nil;
}

- (UIButton *)magicView:(VTMagicView *)magicView categoryItemForIndex:(NSInteger)index
{
    return nil;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index
{
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSInteger)index
{
    VTLog(@"index:%ld viewControllerDidAppeare:%@",(long)index, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSInteger)index
{
    VTLog(@"index:%ld viewControllerDidDisappeare:%@",(long)index, viewController.view);
}

@end