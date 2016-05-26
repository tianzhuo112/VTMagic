//
//  ChildViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
    button.center = self.view.center;
    [button setTitle:@"测试按钮" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
//    NSLog(@"viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@"viewWillAppear:%@",self);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    NSLog(@"viewWillDisappear:%@",self);
}

@end
