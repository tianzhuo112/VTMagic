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
#import "VTBubbleViewController.h"
#import "VTDataViewController.h"

@implementation VTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VTHomeViewController *homeVC = [[VTHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNav.navigationBarHidden = YES;
    UITabBarItem *homeItem = [self creatTabBarItemWithTitle:@"首页"];
    homeNav.tabBarItem = homeItem;
    
    VTBubbleViewController *bubbleVC = [[VTBubbleViewController alloc] init];
    UINavigationController *bubbleNav = [[UINavigationController alloc]initWithRootViewController:bubbleVC];
//    bubbleNav.navigationBarHidden = YES;
    UITabBarItem *bubbleItem = [self creatTabBarItemWithTitle:@"气泡"];
    bubbleNav.tabBarItem = bubbleItem;
    
    VTCenterViewController *centerVC = [[VTCenterViewController alloc] init];
    UINavigationController *centerNav = [[UINavigationController alloc]initWithRootViewController:centerVC];
    centerNav.navigationBarHidden = YES;
    UITabBarItem *centerItem = [self creatTabBarItemWithTitle:@"居中"];
    centerNav.tabBarItem = centerItem;
    
    VTDivideViewController *divideVC = [[VTDivideViewController alloc] init];
    UINavigationController *divideNav = [[UINavigationController alloc]initWithRootViewController:divideVC];
    divideNav.navigationBarHidden = YES;
    UITabBarItem *divideItem = [self creatTabBarItemWithTitle:@"平分"];
    divideNav.tabBarItem = divideItem;
    
    VTDataViewController*dataVC = [[VTDataViewController alloc] init];
    UINavigationController *dataNav = [[UINavigationController alloc]initWithRootViewController:dataVC];
    dataNav.navigationBarHidden = YES;
    UITabBarItem *dataItem = [self creatTabBarItemWithTitle:@"webview"];
    dataNav.tabBarItem = dataItem;
    
    self.viewControllers = @[homeNav, bubbleNav, centerNav, divideNav, dataNav];
    
    [[UITabBar appearance] setBarTintColor:RGBCOLOR(239, 239, 239)];
    [[UITabBar appearance] setAlpha:0.75];
}

- (UITabBarItem *)creatTabBarItemWithTitle:(NSString*)title {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(169, 37, 37)}  forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
//    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return item;
}

@end
