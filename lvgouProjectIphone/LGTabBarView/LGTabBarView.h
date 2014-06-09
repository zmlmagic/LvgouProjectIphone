//
//  LGTabBarView.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-18.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGTabBarViewDelegate <NSObject>

- (void)delegate_didClickButton_tab:(NSInteger)tag;

@end

@interface LGTabBarView : UIView

@property (assign, nonatomic) NSInteger integer_before;
@property (assign, nonatomic) NSInteger integer_now;
@property (assign, nonatomic) id<LGTabBarViewDelegate>delegate;

#pragma mark - 推送开开启程序 -
/**
 *  推送开开启程序
 */
- (void)pushMessageToBar;

@end
