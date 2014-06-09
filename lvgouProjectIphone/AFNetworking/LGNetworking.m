//
//  LGNetworking.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-24.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGNetworking.h"
#import "MKNetworkKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "LGJson.h"
#import "LGModel_mainData.h"
#import "LGModel_addQuestion.h"


@implementation LGNetworking

/*
 加密:按键排序,拼接值
 */

#pragma mark - 加密过程 -
/*
 加密过程
 */
+ (NSString *)getGetKeyStringWithKeyArray:(NSMutableArray *)array_sort andValueArray:(NSMutableArray *)array_value
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:array_value forKeys:array_sort];
    /**加密部分**/
    //NSMutableArray *array_tmp = [NSMutableArray arrayWithObjects:@"test",@"sss",nil];
    [array_sort sortUsingSelector:@selector(compare:)];
    NSString *string_count = [NSString string];
    for (int i = 0; i < [array_sort count]; i++)
    {
        string_count = [string_count stringByAppendingString:[dictionary objectForKey:[array_sort objectAtIndex:i]]];
    }

    string_count = [string_count stringByAppendingString:Key];
    NSString *string_result = [self md5HexDigest:string_count];
    NSString *string_result_post = [NSString stringWithFormat:@"?version=1.0&platform=2&signature=%@",string_result];
    for (int i = 0; i< [array_sort count]; i++ )
    {
        string_result_post = [string_result_post stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[array_sort objectAtIndex:i],[dictionary objectForKey:[array_sort objectAtIndex:i]]]];
    }
    return string_result_post;
}

#pragma mark - 加密过程 -
/*
 加密过程
 */
+ (NSString *)getPostKeyStringWithKeyArray:(NSMutableArray *)array_sort andValueArray:(NSMutableArray *)array_value
{
    [array_sort addObject:@"send"];
    [array_value addObject:@"send"];
    /**加密部分**/
    //NSMutableArray *array_tmp = [NSMutableArray arrayWithObjects:@"test",@"sss",nil];
    [array_value sortUsingSelector:@selector(compare:)];
    NSString *string_count = [NSString string];
    for (int i = 0; i < [array_sort count]; i++)
    {
        string_count = [string_count stringByAppendingString:[array_value objectAtIndex:i]];
    }
    string_count = [string_count stringByAppendingString:Key];
    NSString *string_result = [self md5HexDigest:string_count];
    NSString *string_result_post = [NSString stringWithFormat:@"?version=1.0&platform=2&signature=%@&send=send",string_result];
    return string_result_post;
}


#pragma mark - 32位md5加密 -
/*
 32位md5加密
 */
+ (NSString *)md5HexDigest:(NSString*)input
{
    if(input)
    {
        const char* str = [input UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(str, strlen(str), result);
        NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
        for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
        {
            [ret appendFormat:@"%02x",result[i]];
        }
        return ret;
    }
    else
    {
        return nil;
    }
}

#pragma mark - 获取主页信息 -
/**
 获取主页信息
 **/
+ (BOOL)data_requestForMain:(NSMutableArray *)array_sort
{
    NSString *string_result_post = [URL_mainInformation stringByAppendingString:[self getPostKeyStringWithKeyArray:[NSMutableArray arrayWithObject:@""] andValueArray:[NSMutableArray arrayWithObject:@""]]];
    //NSLog(@"%@",string_result_post);
    __block BOOL success;
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:nil httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         success = YES;
         //NSLog(@"%@",[operation responseString]);
         [LGJson mainPageDataFromJsonString:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         success = NO;
         //NSLog(@"http request error: %@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_mainData" object:@"0"];
     }];
    [engine enqueueOperation:request];
    return success;
}

#pragma mark - 获取内容详情 -
/**
 获取内容详情
 **/
+ (void)getDetail_fromRequestMainWith:(NSString *)string_Id
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_Id,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"id",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_detailMainInformation stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    NSLog(@"%@",string_result_post);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         //NSLog(@"%@",[operation responseString]);
         [LGJson mainPageDetailDataFromJsonString:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取一级类表内容 -
/**
 获取一级类表内容
 **/
+ (void)getKindFirst_fromRquest
{
    NSString *string_result_post = [URL_kindInformationFirst stringByAppendingString:[self getPostKeyStringWithKeyArray:[NSMutableArray arrayWithObject:@""] andValueArray:[NSMutableArray arrayWithObject:@""]]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:nil httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson kindInformationFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取咨询列表 -
/**
 获取咨询列表
 **/
+ (void)getKindContentListWithID:(NSString *)string_id andPage:(NSString *)string_page
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_id,string_page,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"classid",@"page",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_kindInformationList stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    NSLog(@"%@",string_result_post);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson kindContentListFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 搜索资讯文章 -
/**
 搜索资讯文章
 **/
+ (void)searchInformationWithKeyWord:(NSString *)string_keyword
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_keyword,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"keyword",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    NSString *string_result_post = [URL_searchInformation stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson kindContentListFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取验证码 -
/**
 获取验证码
 **/
+ (void)sendPhoneNumber:(NSString *)string_number
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_number,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"mobile",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    NSString *string_result_post = [URL_sendPhoneNumber stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson sendPhoneToService:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendPhone" object:@"网络问题"];
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}


#pragma mark - 验证手机验证码 -
/**
 验证手机验证码
 **/
+ (void)verifyPhoneNumberWithDataArray:(NSMutableArray *)array_data
{
    NSString *string_phone = [array_data objectAtIndex:0];
    NSString *string_code = [array_data objectAtIndex:1];
    NSString *string_baiduUid = [array_data objectAtIndex:2];
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_phone,string_code,string_baiduUid,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"mobile",@"code",@"baiduuserid",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    NSString *string_result_post = [URL_verifyPhone stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson verifyPhoneInService:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendPhone" object:@"网络问题"];
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 提交订单 -
/**
 提交订单
 **/
+ (void)sendMessageToService:(LGModel_userOrder *)model_userOrder
{
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"uid",@"mobile",@"productid",@"province",@"city",@"description",nil];
    NSString *string_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSString *string_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_uid,string_phone,@"9",model_userOrder.string_province,model_userOrder.string_city,model_userOrder.string_description,nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_sendOrder stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson sendQuestResponseFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_sendQuestion" object:@"0"];
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取地理位置 -
/**
 获取地理位置
 **/
+ (void)reciveLocation
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:URL_location customHeaderFields:nil];
    //NSLog(@"%@",URL_kindInformationList(string_id,string_page));
    MKNetworkOperation *request = [engine operationWithPath:nil params:nil httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         //NSLog(@"%@",[operation responseString]);
         [LGJson getLocation:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取订单列表 -
/**
 获取订单列表
 **/
+ (void)getOrderListWithID:(NSString *)string_id andPage:(NSString *)string_page
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_id,string_page,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"uid",@"page",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_orderList stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    //NSLog(@"%@",string_result_post);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson orderListFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 获取订单详情 -
/**
 获取订单列表
 **/
+ (void)getOrderDetailWithNo:(NSString *)string_no
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:string_no,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"orderno",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_orderDetail stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    NSLog(@"%@",string_result_post);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson orderDetailFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
    
}

#pragma mark - 发送追问 -
/**
 *  发送追问
 *
 *  @param model_addQuestion 追问模型
 */
+ (void)sendAddQusetionToService:(LGModel_addQuestion *)model_addQuestion
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:model_addQuestion.string_toid,model_addQuestion.string_memberid,model_addQuestion.string_orderid,model_addQuestion.string_content,nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"toid",@"memberid",@"orderno",@"content",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_addQuestion stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
        [LGJson addQuestResponseFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 发送icon条数 -
/**
 *  发送icon条数
 */
+ (void)sendIconCountToService:(NSMutableArray *)array_data
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObjects:[array_data objectAtIndex:1],[array_data objectAtIndex:0],nil];
    NSMutableArray *array_key = [NSMutableArray arrayWithObjects:@"uid",@"badge",nil];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    
    NSString *string_result_post = [URL_iconCount stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson addQuestResponseFromJsonData:[operation responseData]];
     }
                     errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

#pragma mark - 从服务器获取icon条数 -
/**
 *  从服务器获取icon条数
 */
+ (void)getIconCountFromService:(NSString *)string_userID
{
    NSMutableArray *array_value = [NSMutableArray arrayWithObject:string_userID];
    NSMutableArray *array_key = [NSMutableArray arrayWithObject:@"uid"];
    NSDictionary *dic_value = [NSDictionary dictionaryWithObjects:array_value forKeys:array_key];
    NSString *string_result_post = [URL_getIconCount stringByAppendingString:[self getPostKeyStringWithKeyArray:array_key andValueArray:array_value]];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:string_result_post customHeaderFields:nil];
    MKNetworkOperation *request = [engine operationWithPath:nil params:dic_value httpMethod:@"POST"];
    [request addCompletionHandler:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@",[operation responseString]);
         [LGJson getIconCountFromJsonData:[operation responseData]];
     }
         errorHandler:^(MKNetworkOperation *operation,NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_getIconCount" object:@"error"];
         NSLog(@"http request error: %@", error);
     }];
    [engine enqueueOperation:request];
}

@end
