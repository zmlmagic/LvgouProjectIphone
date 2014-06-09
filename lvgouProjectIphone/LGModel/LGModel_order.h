//
//  LGModel_order.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-15.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 订单模型
 **/
@interface LGModel_order : NSObject

/**
 订单id
 **/
@property (retain, nonatomic) NSString *string_id;

/**
 订单编号
 **/
@property (retain, nonatomic) NSString *string_orderno;

/**
 订单详情
 **/
@property (retain, nonatomic) NSString *string_description;

/**
 用户id
 **/
@property (retain, nonatomic) NSString *string_memberid;

/**
 订单类型—免费9
 **/
@property (retain, nonatomic) NSString *string_productid;

/**
 订单状态
 **/
@property (retain, nonatomic) NSString *string_state;

/**
 订单时间
 **/
@property (retain, nonatomic) NSString *string_updatetime;

/**
 订单回复数
 **/
@property (retain, nonatomic) NSString *string_replycount;

@end
