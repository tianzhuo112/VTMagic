//
//  ChildViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14/12/30.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
    _button.center = self.view.center;
    [_button setTitle:@"测试按钮" forState:UIControlStateNormal];
    [self.view addSubview:_button];
    
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

#pragma functional methods
- (void)updatePageInfo:(NSInteger)page
{
    [_button setTitle:[NSString stringWithFormat:@"测试按钮%ld",(long)index] forState:UIControlStateNormal];
}

@end
