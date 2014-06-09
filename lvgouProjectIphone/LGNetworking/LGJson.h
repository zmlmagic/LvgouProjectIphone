//
//  LGJson.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-2.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGJson : NSObject

#pragma mark - 首页信息json解析 -
/**
 首页信息json解析
 **/
+ (void)mainPageDataFromJsonString:(NSData *)jsonData;

#pragma mark - 点击进入详情 -
/**
 点击进入详情
 **/
+ (void)mainPageDetailDataFromJsonString:(NSData *)jsonData;

#pragma mark - 资讯一级列表 -
/**
 资讯一级列表
 **/
+ (void)kindInformationFromJsonData:(NSData *)jsonData;

#pragma mark - 资讯内容列表 -
/**
 资讯内容列表
 **/
+ (void)kindContentListFromJsonData:(NSData *)jsonData;

#pragma mark - 获取地理位置 -
/**
 获取地理位置
 **/
+ (void)getLocation:(NSData *)jsonData;

#pragma mark - 获取订单列表 -
/**
 获取订单列表
 **/
+ (void)orderListFromJsonData:(NSData *)jsonData;

#pragma mark - 获取订单详情 -
/**
 获取订单详情
 **/
+ (void)orderDetailFromJsonData:(NSData *)jsonData;

#pragma mark - 发送订单 -
/**
 *  发送订单
 *
 *  @param void 发送订单
 */
+ (void)sendQuestResponseFromJsonData:(NSData *)jsonData;

#pragma mark - 追问返回值 -
/**
 追问返回值
 **/
+ (void)addQuestResponseFromJsonData:(NSData *)jsonData;

#pragma mark - 获取验证码 -
/**
 获取验证码
 **/
+ (void)sendPhoneToService:(NSData *)jsonData;

#pragma mark - 验证手机 -
/**
 验证手机
 **/
+ (void)verifyPhoneInService:(NSData *)jsonData;

#pragma mark - 获取条数 -
/**
 *  获取条数
 *
 *  @param jsonData 获取条数
 */
+ (void)getIconCountFromJsonData:(NSData *)jsonData;

@end
