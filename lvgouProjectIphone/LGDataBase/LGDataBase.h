//
//  LGDataBase.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-6.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

//@import Foundation;
#import <Foundation/Foundation.h>
#import "LGModel_order.h"

@interface LGDataBase : NSObject

/*
 录入地区信息
 */
+ (void)saveDataWithArray:(NSMutableArray *)array_data;

/*
 缓存主页新闻
 */
+ (void)saveMainInformationDataWithModel:(NSMutableArray *)array_data;

/*
 获取市信息
 */
+ (NSMutableArray *)getLoactionDataBaseWithArray:(NSArray *)array_from;

/*
 获取省信息
 */
+ (NSString *)getProvinceFromDataBaseWithString:(NSString *)string_id;

#pragma mark - 缓存一级列表 -
/*
 缓存一级列表
 */
+ (void)saveKindInformationDataWithModel:(NSMutableArray *)array_data;

/*
 获取资讯列表
 */
+ (NSMutableArray *)getKindListDataFirstFromDataBase;

/**
 存推送条数
 **/
+ (void)saveOrderCount:(NSMutableArray *)array_order;

#pragma mark - 查询推送条数 -
/**
 *  查询推送条数
 */
+ (NSString *)selectOrderCount:(NSString *)string_order;

#pragma mark - 更新已读条数 -
/**
 *  更新已读条数
 */
+ (void)upLoadOrderCount:(NSString *)string_count andOrderNo:(NSString *)string_no;

@end
