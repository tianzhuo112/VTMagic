//
//  VTChatViewController.h
//  VTMagic
//
//  Created by tianzhuo on 7/8/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTChatViewController;
@protocol VTChatViewControllerDelegate <NSObject>

@optional
/**
 *  聊天室接到新消息时触发
 *
 *  @param chatViewController self
 */
- (void)chatViewControllerDidReciveNewMessages:(VTChatViewController *)chatViewController;

@end

@interface VTChatViewController : UITableViewController

/**
 *  菜单信息
 */
@property (nonatomic, strong) MenuInfo *menuInfo;
/**
 *  代理
 */
@property (nonatomic, weak) id<VTChatViewControllerDelegate> delegate;

/**
 *  销毁定时器
 */
- (void)invalidateTimer;

@end
