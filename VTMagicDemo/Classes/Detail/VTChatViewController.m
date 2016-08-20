//
//  VTChatViewController.m
//  VTMagic
//
//  Created by tianzhuo on 7/8/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTChatViewController.h"
#import <VTMagic/VTMagic.h>

@interface VTChatViewController()

@property (nonatomic, strong) NSTimer *chatTimer;

@end

@implementation VTChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fireChatTimer];
}

#pragma mark - functional methods
- (void)fireChatTimer {
    if (_chatTimer) {
        return;
    }
    _chatTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(notifyReciveMessages) userInfo:nil repeats:YES];
}

- (void)invalidateTimer {
    if ([_chatTimer isValid]) {
        [_chatTimer invalidate];
    }
    _chatTimer = nil;
}

- (void)notifyReciveMessages {
    BOOL isDisplayed = [self.magicController.currentViewController isEqual:self];
    if (!isDisplayed && [_delegate respondsToSelector:@selector(chatViewControllerDidReciveNewMessages:)]) {
        [_delegate chatViewControllerDidReciveNewMessages:self];
    }
}

@end
