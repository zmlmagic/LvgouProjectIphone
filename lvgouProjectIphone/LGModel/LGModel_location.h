//
//  LGModel_location.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-3.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGModel_location : NSObject

/*
 父类省会ID
 */
@property (retain, nonatomic) NSString *string_superId;

/*
 自己ID
 */
@property (retain, nonatomic) NSString *string_id;

/*
 名称
 */
@property (retain, nonatomic) NSString *string_title;

/*
 拼音缩写
 */
@property (retain, nonatomic) NSString *string_pinYin_sort;

/*
 拼音全写
 */
@property (retain, nonatomic) NSString *string_pinYin_long;

@end
