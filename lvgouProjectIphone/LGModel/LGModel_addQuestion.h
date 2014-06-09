//
//  LGModel_addQuestion.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 追问模型 -
/**
 *  追问模型
 */
@interface LGModel_addQuestion : NSObject

#pragma mark - 律师ID -
/**
 *  律师ID
 */
@property (retain, nonatomic) NSString *string_toid;

#pragma mark - 用户ID -
/**
 *  用户ID
 */
@property (retain, nonatomic) NSString *string_memberid;

#pragma mark - 订单ID -
/**
 *  订单ID
 */
@property (retain, nonatomic) NSString *string_orderid;

#pragma mark - 追问内容 -
/**
 *  追问内容
 */
@property (retain, nonatomic) NSString *string_content;

@end
