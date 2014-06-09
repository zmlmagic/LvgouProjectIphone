//
//  LGModel_lawyer.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-16.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 律师模型
 **/
@interface LGModel_lawyer : NSObject

/**
 律师id
 **/
@property (retain, nonatomic) NSString *string_memberid;

/**
 律师姓名
 **/
@property (retain, nonatomic) NSString *string_username;

/**
 律师执照
 **/
@property (retain, nonatomic) NSString *string_jobno;

/**
 律师头像
 **/
@property (retain, nonatomic) NSString *string_jobpic;

/**
 回复时间
 **/
@property (retain, nonatomic) NSString *string_createtime;

/**
 回复内容
 **/
@property (retain, nonatomic) NSString *string_content;

/**
 回复订单编号
 **/
@property (retain, nonatomic) NSString *string_fromid;

@end
