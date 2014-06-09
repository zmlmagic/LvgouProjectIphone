//
//  LGNetworking.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-24.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGModel_userOrder.h"
#import "LGModel_addQuestion.h"

#define IP_URL @"test.lvgou.com"  //www.lvgoutest.com
#define Key    @"9e304d4e8df1b74cfa009913198428ab"

/**
 主界面列表
 **/
#define URL_mainInformation IP_URL @"/mobile/Customer/recommend"

/**
 内容详情
 **/
#define URL_detailMainInformation IP_URL @"/mobile/customer/getarticle"

/**
 资讯一级列表
 **/
#define URL_kindInformationFirst IP_URL @"/mobile/customer/getclass"

/**
 资讯文章列表
 **/
//#define URL_kindInformationList(id,page) [NSString stringWithFormat:IP_URL @"/mobile/customer/getarticlelist?classid=%@&page=%@",id,page]
#define URL_kindInformationList IP_URL @"/mobile/customer/getarticlelist"

/**
 资讯搜索
 **/
//#define URL_searchInformation(keyword) [NSString stringWithFormat:IP_URL @"/mobile/customer/search?keyword=%@",keyword]
#define URL_searchInformation IP_URL @"/mobile/customer/search"

/**
 发送手机号获取验证码
 **/
#define URL_sendPhoneNumber IP_URL @"/mobile/customer/verifycode"

/**
 验证手机验证码
 **/
#define URL_verifyPhone IP_URL @"/mobile/customer/checkcode"

/**
 提交订单
 **/
#define URL_sendOrder IP_URL @"/mobile/customer/order"

/**
 地理位置
 **/
#define URL_location IP_URL @"/mobile/Customer/test"

/**
 提交订单
 **/
#define URL_sendOrder IP_URL @"/mobile/customer/order"

/**
 订单列表
 **/
#define URL_orderList IP_URL @"/mobile/customer/orderlist"

/**
 订单详情
 **/
#define URL_orderDetail IP_URL @"/mobile/customer/showorder"

/**
 追问
 **/
#define URL_addQuestion IP_URL @"/mobile/customer/questioned"

/**
 icon上的数字标示发送服务器
 **/
#define URL_iconCount IP_URL @"/mobile/customer/setbadge"

/**
 从服务器获取icon数字
 **/
#define URL_getIconCount IP_URL @"/mobile/customer/getbadge"


/*通知
 @"Notification_mainData"               主页信息
 @"Notification_mainDetailData"         主页信息详情
 @"Notification_kindFirst"              资讯一级列表
 @"Notification_kindList"               资讯文章列表
 @"Notification_sendPhone"              发送手机获取验证码
 @"Notification_verifyPhone"            验证手机验证码
 @"Notification_locationContent"        省会信息
 @"Notification_getOrderList"           获取订单列表
 @"Notification_getOrderDetail"         获取订单详情
 @"Notification_addQuestion"            追问
 @"Notification_sendIconCount"          发送icon条数
 @"Notifacation_getIconCount"           从服务器获取icon条数
 @"Notifacation_sendQuestion"           发送订单回调
 @"Notifacation_sendMessageWhenOnline"  用户在线时接到推送
 */

/**
 网络交互类
 **/
@interface LGNetworking : NSObject

#pragma mark - 获取主页信息 -
/**
 获取主页信息
 **/
+ (BOOL)data_requestForMain:(NSMutableArray *)array_sort;

#pragma mark - 获取内容详情 -
/**
 获取内容详情
 **/
+ (void)getDetail_fromRequestMainWith:(NSString *)string_Id;

#pragma mark - 获取一级类表内容 -
/**
 获取一级类表内容
 **/
+ (void)getKindFirst_fromRquest;

#pragma mark - 获取验证码 -
/**
 获取验证码
 **/
+ (void)sendPhoneNumber:(NSString *)string_number;

#pragma mark - 获取咨询列表 -
/**
 获取咨询列表
 **/
+ (void)getKindContentListWithID:(NSString *)string_id andPage:(NSString *)string_page;

#pragma mark - 搜索 -
/**
 搜索
 **/
+ (void)searchInformationWithKeyWord:(NSString *)string_keyword;

#pragma mark - 验证手机号 -
/**
 验证手机号
 **/
+ (void)verifyPhoneNumberWithDataArray:(NSMutableArray *)array_data;

#pragma mark - 提交订单 -
/**
 提交订单
 **/
+ (void)sendMessageToService:(LGModel_userOrder *)model_userOrder;

#pragma mark - 获取地区表 -
/**
 获取地区表
 **/
+ (void)reciveLocation;

#pragma mark - 获取订单列表 -
/**
 获取订单列表
 **/
+ (void)getOrderListWithID:(NSString *)string_id andPage:(NSString *)string_page;

#pragma mark - 获取订单详情 -
/**
 获取订单列表
 **/
+ (void)getOrderDetailWithNo:(NSString *)string_no;

#pragma mark - 发送追问 -
/**
 *  发送追问
 *
 *  @param model_addQuestion 追问模型
 */
+ (void)sendAddQusetionToService:(LGModel_addQuestion *)model_addQuestion;

#pragma mark - 发送icon条数 -
/**
 *  发送icon条数
 */
+ (void)sendIconCountToService:(NSMutableArray *)array_data;

#pragma mark - 从服务器获取icon条数 -
/**
 *  从服务器获取icon条数
 */
+ (void)getIconCountFromService:(NSString *)string_userID;


@end
