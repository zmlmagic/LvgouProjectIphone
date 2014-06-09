//
//  LGVerifyPhoneViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-31.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGViewController.h"

@interface LGVerifyPhoneViewController : LGViewController<UITableViewDataSource,UITableViewDelegate>

/*
 递减数
 */
@property (assign, nonatomic) NSInteger time_countDown;

/*
 计时器
 */
@property (assign, nonatomic) NSTimer *timer_countDown;

/*
 计时label
 */
@property (assign, nonatomic) UILabel *label_countDown;

/*
 重新发送label
 */
@property (assign, nonatomic) UILabel *label_recive;

/**
 重新发送button
 **/
@property (assign, nonatomic) UIButton *button_recive;

/*
 验证码控件
 */
@property (assign, nonatomic) UITextField *textField_verify;

@end
