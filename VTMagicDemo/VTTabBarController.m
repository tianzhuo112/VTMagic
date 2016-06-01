//
//  VTTabBarController.m
//  VTMagic
//
//  Created by tianzhuo on 6/1/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTTabBarController.h"
#import "VTHomeViewController.h"
#import "VTCenterViewController.h"
#import "VTDivideViewController.h"
#import "VTDataViewController.h"

@implementation VTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VTHomeViewController *homeVC = [[VTHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNav.navigationBarHidden = YES;
    UITabBarItem *homeItem = [self creatTabBarItemWithTitle:@"首页"];
    homeNav.tabBarItem = homeItem;
    
    VTDivideViewController *divideVC = [[VTDivideViewController alloc] init];
    UINavigationController *divideNav = [[UINavigationController alloc]initWithRootViewController:divideVC];
    divideNav.navigationBarHidden = YES;
    UITabBarItem *divideItem = [self creatTabBarItemWithTitle:@"平分"];
    divideNav.tabBarItem = divideItem;
    
    VTCenterViewController *centerVC = [[VTCenterViewController alloc] init];
    UINavigationController *centerNav = [[UINavigationController alloc]initWithRootViewController:centerVC];
    centerNav.navigationBarHidden = YES;
    UITabBarItem *centerItem = [self creatTabBarItemWithTitle:@"居中"];
    centerNav.tabBarItem = centerItem;
    
    VTDataViewController*dataVC = [[VTDataViewController alloc] init];
    UINavigationController *dataNav = [[UINavigationController alloc]initWithRootViewController:dataVC];
    dataNav.navigationBarHidden = YES;
    UITabBarItem *dataItem = [self creatTabBarItemWithTitle:@"webview"];
    dataNav.tabBarItem = dataItem;
    
    self.viewControllers = @[homeNav, divideNav, centerNav, dataNav];
    
    self.tabBar.barTintColor = RGBCOLOR(239, 239, 239);
    self.tabBar.alpha = 0.97;
}

- (UITabBarItem *)creatTabBarItemWithTitle:(NSString*)title
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(169, 37, 37)}  forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
//    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return item;
}

@end
