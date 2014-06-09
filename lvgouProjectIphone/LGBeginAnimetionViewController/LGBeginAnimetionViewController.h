//
//  LGBeginAnimetionViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-10.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGMainViewController;

@interface LGBeginAnimetionViewController : UIViewController

@property (assign, nonatomic) LGMainViewController *mainViewController;

#pragma mark - 从推送启动 -
/**
 *  从推送启动
 */
- (void)openViewFromPush;

@end
