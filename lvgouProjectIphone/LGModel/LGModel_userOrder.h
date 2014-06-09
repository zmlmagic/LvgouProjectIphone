//
//  LGModel_userOrder.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-9.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGModel_userOrder : NSObject

/*
 uid用户id
 */
@property (retain, nonatomic) NSString *string_uId;

/*
 电话号码
 */
@property (retain, nonatomic) NSString *string_mobile;

/*
  productid询问产品类型
 */
@property (retain, nonatomic) NSString *string_productId;

/*
  province省会
 */
@property (retain, nonatomic) NSString *string_province;

/*
 city市名
 */
@property (retain, nonatomic) NSString *string_city;

/*
 description提问
 */
@property (retain, nonatomic) NSString *string_description;


@end
