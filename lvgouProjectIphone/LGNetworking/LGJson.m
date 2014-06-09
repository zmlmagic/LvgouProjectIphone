//
//  LGJson.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-2.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGJson.h"
#import "LGModel_mainData.h"
#import "LGModel_kindData.h"
#import "LGModel_location.h"
#import "LGDataBase.h"
#import "LGModel_order.h"
#import "LGModel_lawyer.h"

@implementation LGJson

#pragma mark - 主页信息json解析 -
/**
 主页信息json解析
 **/
+ (void)mainPageDataFromJsonString:(NSData *)jsonData
{
    NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *newsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:[newsDic count] - 2];
    NSNumber *number_code = [newsDic objectForKey:@"code"];
    NSString *string_message = [newsDic objectForKey:@"msg"];
    if([number_code intValue] == 1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < [newsDic count] - 2; i++)
            {
                NSDictionary *dic = [newsDic objectForKey:[NSString stringWithFormat:@"%d",i]];
                
                LGModel_mainData *main_model = [[LGModel_mainData alloc] init];
                if(![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_Id:[dic objectForKey:@"id"]];
                }
                else
                {
                    [main_model setString_Id:@""];
                }
                if(![[dic objectForKey:@"article_id"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_articleId:[dic objectForKey:@"article_id"]];
                }
                else
                {
                    [main_model setString_articleId:@""];
                }
                if(![[dic objectForKey:@"type"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_type:[dic objectForKey:@"type"]];
                }
                else
                {
                    [main_model setString_type:@""];
                }
                if(![[dic objectForKey:@"updatetime"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_updateTime:[dic objectForKey:@"updatetime"]];
                }
                else
                {
                    [main_model setString_updateTime:@""];
                }
                if(![[dic objectForKey:@"title"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_title:[dic objectForKey:@"title"]];
                }
                else
                {
                    [main_model setString_title:@""];
                }
                if(![[dic objectForKey:@"picurl"] isKindOfClass:[NSNull class]])
                {
                    [main_model setString_imageUrl:[dic objectForKey:@"picurl"]];
                }
                else
                {
                    [main_model setString_imageUrl:@""];
                }
                if([main_model.string_type integerValue] == 2)
                {
                    if(![[dic objectForKey:@"description"] isKindOfClass:[NSNull class]])
                    {
                        [main_model setString_description:[dic objectForKey:@"description"]];
                    }
                    else
                    {
                        [main_model setString_description:@""];
                    }
                }
                [array_data addObject:main_model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_mainData" object:array_data];
            });
        });
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_mainData" object:string_message];
    }
}

#pragma mark - 主页信息详情解析 -
/**
 主页信息详情解析
 **/
+ (void)mainPageDetailDataFromJsonString:(NSData *)jsonData
{
    NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *detailDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LGModel_mainData *detail = [[LGModel_mainData alloc] init];
        if(![[detailDic objectForKey:@"id"] isKindOfClass:[NSNull class]])
        {
            [detail setString_Id:[detailDic objectForKey:@"id"]];
        }
        else
        {
            [detail setString_Id:@""];
        }
        if(![[detailDic objectForKey:@"title"] isKindOfClass:[NSNull class]])
        {
            [detail setString_title:[detailDic objectForKey:@"title"]];
        }
        else
        {
            [detail setString_title:@""];
        }
        if(![[detailDic objectForKey:@"createtime"] isKindOfClass:[NSNull class]])
        {
            [detail setString_updateTime:[detailDic objectForKey:@"createtime"]];
        }
        else
        {
            [detail setString_updateTime:@""];
        }
        if(![[detailDic objectForKey:@"content"] isKindOfClass:[NSNull class]])
        {
            [detail setString_content:[detailDic objectForKey:@"content"]];
        }
        else
        {
            [detail setString_content:@""];
        }
        if(![[detailDic objectForKey:@"picurl"] isKindOfClass:[NSNull class]])
        {
            [detail setString_imageDetailUrl:[detailDic objectForKey:@"picurl"]];
        }
        else
        {
            [detail setString_imageUrl:@""];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_mainDetailData" object:detail];
        });
    });
}

#pragma mark - 资讯一级列表 -
/**
 资讯一级列表
 **/
+ (void)kindInformationFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *kindDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:[kindDic count] - 2];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < [kindDic count] - 2; i++)
        {
            NSDictionary *dic = [kindDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            LGModel_kindData *model_kind = [[LGModel_kindData alloc] init];
            [model_kind setString_Id:[dic objectForKey:@"id"]];
            [model_kind setString_pId:[dic objectForKey:@"pid"]];
            [model_kind setString_title:[dic objectForKey:@"name"]];
            [model_kind setString_deleted:[dic objectForKey:@"deleted"]];
            [model_kind setString_articleCount:[dic objectForKey:@"articlecount"]];
            [array_data addObject:model_kind];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_kindFirst" object:array_data];
        });
    });
}

#pragma mark - 获取资讯文章列表 -
/**
 获取资讯文章列表
 **/
+ (void)kindContentListFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:[ListDic count] - 2];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < [ListDic count] - 2; i++)
        {
            NSDictionary *dic = [ListDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            LGModel_mainData *model_content = [[LGModel_mainData alloc] init];
            [model_content setString_Id:[dic objectForKey:@"id"]];
            [model_content setString_title:[dic objectForKey:@"title"]];
            [model_content setString_content:[dic objectForKey:@"description"]];
            [model_content setString_imageUrl:[dic objectForKey:@"picurl"]];
            [array_data addObject:model_content];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_kindList" object:array_data];
        });
    });
}

#pragma mark - 获取地理位置 -
/**
 获取地理位置
 **/
+ (void)getLocation:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *locationDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:[locationDic count]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0, q = 0; i < [locationDic count] + q; i++)
        {
            NSDictionary *dic = [locationDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            {
                if([dic count] == 0)
                {
                    q++;
                }
                else
                {
                    for (int j = 0, k = 0; j < [dic count] + k; j++)
                    {
                        NSString *string_content = [dic objectForKey:[NSString stringWithFormat:@"%d",j]];
                        if(!string_content)
                        {
                            k++;
                        }
                        else
                        {
                            LGModel_location *location = [[LGModel_location alloc] init];
                            [location setString_superId:[NSString stringWithFormat:@"%d",i]];
                            [location setString_id:[NSString stringWithFormat:@"%d",j]];
                            [location setString_title:string_content];
                            [array_data addObject:location];
                        }
                    }
                }
            }
            
            if([array_data count] == 3302)
            {
                LGModel_location *location = [array_data objectAtIndex:3301];
                NSLog(@"%@",location.string_id);
            }
            ///3301
            NSLog(@"%d",[array_data count]);
        }
        [LGDataBase saveDataWithArray:array_data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_kindFirst" object:array_data];
        });
    });
}


#pragma mark - 获取订单列表 -
/**
 获取订单列表
 **/
+ (void)orderListFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:[ListDic count] - 2];
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    if([number_code intValue] == 1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < [ListDic count] - 2; i++)
            {
                NSDictionary *dic = [ListDic objectForKey:[NSString stringWithFormat:@"%d",i]];
                LGModel_order *model_content = [[LGModel_order alloc] init];
                model_content.string_id = [dic objectForKey:@"id"];
                model_content.string_orderno = [dic objectForKey:@"orderno"];
                model_content.string_state = [dic objectForKey:@"state"];
                model_content.string_productid = [dic objectForKey:@"productid"];
                model_content.string_memberid = [dic objectForKey:@"memberid"];
                model_content.string_updatetime = [dic objectForKey:@"updatetime"];
                model_content.string_description = [dic objectForKey:@"description"];
                model_content.string_replycount = [dic objectForKey:@"replycount"];
                [array_data addObject:model_content];
            }
            [LGDataBase saveOrderCount:array_data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_getOrderList" object:array_data];
            });
        });
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_getOrderList" object:string_message];
    }
}


#pragma mark - 获取订单详情 -
/**
 获取订单详情
 **/
+ (void)orderDetailFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *array_data = [NSMutableArray array];
    
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    NSArray *array_lawyer = [ListDic objectForKey:@"lawyerList"];
    NSDictionary *dic_lawyer;
    if([array_lawyer count] == 0)
    {
        dic_lawyer = nil;
    }
    else
    {
        dic_lawyer = [array_lawyer objectAtIndex:0];
    }
    
    NSDictionary *dic_order = [ListDic objectForKey:@"orderinfo"];
    NSArray *array_question = [ListDic objectForKey:@"questionlist"];
    if([number_code intValue] == 1)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            LGModel_order *model_order = [[LGModel_order alloc] init];
            model_order.string_orderno = [dic_order objectForKey:@"orderno"];
            model_order.string_memberid = [dic_order objectForKey:@"memberid"];
            model_order.string_description = [dic_order objectForKey:@"description"];
            model_order.string_updatetime = [dic_order objectForKey:@"createtime"];
            [array_data addObject:model_order];
            
            if([array_question isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                for (int i = 0; i<[array_question count]; i++)
                {
                    NSDictionary *dic_question = [array_question objectAtIndex:i];
                    NSString *string_replysource = [dic_question objectForKey:@"replysource"];
                    switch ([string_replysource intValue])
                    {
                        case 0:
                        {
                            LGModel_order *model_order = [[LGModel_order alloc] init];
                            //model_order.string_description = [dic_question objectForKey:@"fromid"];
                            model_order.string_description = [dic_question objectForKey:@"content"];
                            model_order.string_updatetime = [dic_question objectForKey:@"createtime"];
                            [array_data addObject:model_order];
                        }break;
                        case 1:
                        {
                            LGModel_lawyer *model_lawyer = [[LGModel_lawyer alloc] init];
                            model_lawyer.string_memberid = [dic_lawyer objectForKey:@"memberid"];
                            model_lawyer.string_jobpic = [dic_lawyer objectForKey:@"jobpic"];
                            model_lawyer.string_jobno = [dic_lawyer objectForKey:@"jobno"];
                            model_lawyer.string_username = [NSString stringWithFormat:@"%@律师",[dic_lawyer objectForKey:@"realname"]];
                            model_lawyer.string_fromid = [dic_question objectForKey:@"fromid"];
                            model_lawyer.string_content = [dic_question objectForKey:@"content"];
                            model_lawyer.string_createtime = [dic_question objectForKey:@"createtime"];
                            [array_data addObject:model_lawyer];
                            
                            
                        }break;
                        default:
                            break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_getOrderDetail" object:array_data];
            });
        });
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_getOrderDetail" object:string_message];
    }
}

#pragma mark - 发送订单 -
/**
 *  发送订单
 *
 *  @param void 发送订单
 */
+ (void)sendQuestResponseFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    
    if([number_code intValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_sendQuestion" object:@"1"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_sendQuestion" object:string_message];
    }
}

#pragma mark - 追问返回值 -
/**
 追问返回值
 **/
+ (void)addQuestResponseFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
  
    if([number_code intValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_addQuestion" object:@"1"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_addQuestion" object:string_message];
    }
}

#pragma mark - 发送icon条数消息回调 -
/**
 *  发送icon条数消息回调
 */
+ (void)sendIconResponseFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    
    if([number_code intValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendIconCount" object:@"1"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendIconCount" object:string_message];
    }
}

#pragma mark - 获取验证码 -
/**
 获取验证码
 **/
+ (void)sendPhoneToService:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    if([number_code intValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendPhone" object:@"1"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_sendPhone" object:string_message];
    }
}

#pragma mark - 验证手机 -
/**
 验证手机
 **/
+ (void)verifyPhoneInService:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_message = [ListDic objectForKey:@"msg"];
    NSDictionary *dic_data = [ListDic objectForKey:@"data"];
    if([number_code intValue] == 1)
    {
        NSString *string_id = [dic_data objectForKey:@"id"];
        //NSString *string_password = [dic_data objectForKey:@"password"];
        NSString *string_mobile = [dic_data objectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults] setObject:string_mobile forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] setObject:string_id forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_verifyPhone" object:@"1"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_verifyPhone" object:string_message];
    }
}

#pragma mark - 获取条数 -
/**
 *  获取条数
 *
 *  @param jsonData 获取条数
 */
+ (void)getIconCountFromJsonData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *ListDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSNumber *number_code = [ListDic objectForKey:@"code"];
    NSString *string_badge = [ListDic objectForKey:@"badge"];
    if([number_code intValue] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_getIconCount" object:string_badge];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_getIconCount" object:@"error"];
    }
}

@end
