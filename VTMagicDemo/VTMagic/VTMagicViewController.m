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
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        } else if ([self respondsToSelector:@selector(setWantsFullScreenLayout:)]) {
            [self setValue:@YES forKey:@"wantsFullScreenLayout"];
        }
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:self.magicView];
    } else {
        self.view = self.magicView;
    }
}

- (VTMagicView *)magicView
{
    if (!_magicView) {
        _magicView = [[VTMagicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _magicView.magicViewController = self;
        _magicView.delegate = self;
        _magicView.dataSource = self;
    }
    return _magicView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 刷新数据
//    [_magicView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - 禁止自动触发appearance methods
- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark - obtain view controller with index & switch to specified page
- (UIViewController *)viewControllerWithIndex:(NSUInteger)index
{
    return [self.magicView viewControllerWithIndex:index];
}

- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated
{
    [self.magicView switchToPage:pageIndex animated:animated];
}

#pragma mark - VTMagicViewDataSource & VTMagicViewDelegate
- (NSArray *)categoryNamesForMagicView:(VTMagicView *)magicView
{
    return nil;
}

- (UIButton *)magicView:(VTMagicView *)magicView categoryItemForIndex:(NSUInteger)index
{
    return nil;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerForIndex:(NSUInteger)index
{
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidAppeare:(UIViewController *)viewController index:(NSUInteger)index
{
    VTLog(@"index:%ld viewControllerDidAppeare:%@",(long)index, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewControllerDidDisappeare:(UIViewController *)viewController index:(NSUInteger)index
{
    VTLog(@"index:%ld viewControllerDidDisappeare:%@",(long)index, viewController.view);
}

@end