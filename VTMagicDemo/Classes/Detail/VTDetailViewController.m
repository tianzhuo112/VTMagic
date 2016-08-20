//
//  VTDetailViewController.m
//  VTMagic
//
//  Created by tianzhuo on 7/7/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTDetailViewController.h"
#import "VTRelateViewController.h"
#import "VTChatViewController.h"
#import <VTMagic/VTMagic.h>
#import "VTMenuItem.h"

@interface VTDetailViewController()<VTMagicViewDataSource, VTMagicViewDelegate, VTChatViewControllerDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) VTChatViewController *chatViewController;
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, assign)  BOOL dotHidden;

@end

@implementation VTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    
    _menuList = @[@"详情", @"热门", @"相关", @"聊天"];
    [_magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_chatViewController invalidateTimer];
}

- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    VTMenuItem *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [VTMenuItem buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    menuItem.dotHidden = (_menuList.count - 1 == itemIndex) ? _dotHidden : YES;
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (_menuList.count - 1 == pageIndex) {
        return self.chatViewController;
    }
    
    static NSString *gridId = @"relate.identifier";
    VTRelateViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTRelateViewController alloc] init];
    }
    viewController.menuInfo = _menuList[pageIndex];
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    if ([viewController isEqual:_chatViewController]) {
        _dotHidden = YES;
        [magicView reloadMenuTitles];
    }
}

#pragma mark - VTChatViewControllerDelegate
- (void)chatViewControllerDidReciveNewMessages:(VTChatViewController *)chatViewController {
    _dotHidden = NO;
    [_magicController.magicView reloadMenuTitles];
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (VTChatViewController *)chatViewController {
    if (!_chatViewController) {
        _chatViewController = [[VTChatViewController alloc] init];
        _chatViewController.delegate = self;
    }
    return _chatViewController;
}

@end
