//
//  LGDataBase.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-6.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGDataBase.h"
#import <sqlite3.h>
#import "LGModel_location.h"
#import "FMDatabase.h"
#import "LGModel_mainData.h"
#import "LGModel_kindData.h"


#define Lvgou @"LvgouDataBase.db"

@implementation LGDataBase

#pragma mark - 获取数据库路径 -
/*
 获取数据库路径
 */
+ (NSString *)reciveDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:Lvgou];
    return path;
}

#pragma mark - 初始化数据库 -
/*
 初始化数据库
 */
+ (void)sqlDataInstall
{
    NSString *dbPath = [self reciveDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL pathExist = [fileManager fileExistsAtPath:dbPath];
    if(!pathExist)
    {
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Lvgou];
        BOOL copySuccess = [fileManager copyItemAtPath:bundleDBPath toPath:dbPath error:&error];
        if(copySuccess)
        {
            NSLog(@"数据库拷贝成功");
        }
        else
        {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    else
    {
        NSLog(@"数据库已存在");
    }
}

#pragma mark - 批量储存数据 -
/*
 批量储存数据
 */
+ (void)saveDataWithArray:(NSMutableArray *)array_data
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for (int i = 0; i < [array_data count]; i++)
    {
        LGModel_location *location = [array_data objectAtIndex:i];
        [db executeUpdate:@"insert into location (Id,superId,content,pinyin_sort,pinyin_long) values (?,?,?,?,?)",location.string_id,location.string_superId,location.string_title,location.string_pinYin_sort,location.string_pinYin_long];
        //NSLog(@"%d",result);
    }
    [db close];
}

#pragma mark - 缓存主页新闻 -
/*
 缓存主页新闻
 */
+ (void)saveMainInformationDataWithModel:(NSMutableArray *)array_data
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for (int i = 0; i < [array_data count]; i++)
    {
        LGModel_mainData *model_main = [array_data objectAtIndex:i];
        [db executeUpdate:@"insert into mainInformation (Id,articleId,type,updateTime,imageUrl,title,description) values (?,?,?,?,?,?,?)",model_main.string_Id,model_main.string_articleId,model_main.string_type,model_main.string_updateTime,model_main.string_imageUrl,model_main.string_title,model_main.string_description];
    }
    [db close];

}

#pragma mark - 缓存一级列表 -
/*
 缓存一级列表
 */
+ (void)saveKindInformationDataWithModel:(NSMutableArray *)array_data
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for (int i = 0; i < [array_data count]; i++)
    {
        LGModel_kindData *model_kind = [array_data objectAtIndex:i];
        [db executeUpdate:@"insert into kindInformation (Id,pid,name,deleted,articlecount) values (?,?,?,?,?)",model_kind.string_Id,model_kind.string_pId,model_kind.string_title,model_kind.string_deleted,model_kind.string_articleCount];
    }
    [db close];
    
}

+ (NSMutableArray *)getLoactionDataBaseWithArray:(NSArray *)array_from
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    NSMutableArray *array_return = [NSMutableArray arrayWithCapacity:[array_from count]];
    [db open];
    for (int i = 0; i<[array_from count]; i++)
    {
        NSMutableArray *array_location = [NSMutableArray arrayWithCapacity:20];
        NSString *string_search = [NSString stringWithFormat:@"select * from location where pinyin_sort like '%@%%%%' and 0 < superId and superId < 35 ",[array_from objectAtIndex:i]];
        FMResultSet *result = [db executeQuery:string_search];
        while ([result next])
        {
            LGModel_location *location = [[LGModel_location alloc] init];
            location.string_id = [result stringForColumn:@"Id"];
            location.string_superId = [result stringForColumn:@"superId"];
            location.string_title = [result stringForColumn:@"content"];
            location.string_pinYin_sort = [result stringForColumn:@"pinyin_sort"];
            [array_location addObject:location];
        }
        [array_return addObject:array_location];
    }
    [db close];
    return array_return;
}

/*+ (NSMutableArray *)getMainDataFromLocalDataBase
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    NSString *sql = @"select * from mainInformation";
    FMResultSet *result = [db executeQuery:sql];
    while ([result next])
    {
        //LGModel_mainData *model_main = [[LGModel_location alloc] init];
       
    }
    [db close];
}*/

/*
 获取省信息
 */
+ (NSString *)getProvinceFromDataBaseWithString:(NSString *)string_id
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    NSString *string_province;
    NSString *string_search = [NSString stringWithFormat:@"select * from location where id = %@",string_id];
    FMResultSet *result = [db executeQuery:string_search];
    while ([result next])
    {
        string_province = [result stringForColumn:@"content"];
    }
    [db close];
    return string_province;
}

/*
 获取资讯列表
 */
+ (NSMutableArray *)getKindListDataFirstFromDataBase
{
    NSMutableArray *array_return = [NSMutableArray array];
    NSMutableArray *array_first = [NSMutableArray array];
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    NSString *string_search = @"select * from kindInformation where pid = 0";
    FMResultSet *result = [db executeQuery:string_search];
    while ([result next])
    {
        LGModel_kindData *model_kind = [[LGModel_kindData alloc] init];
        model_kind.string_Id = [result stringForColumn:@"id"];
        model_kind.string_pId = [result stringForColumn:@"pid"];
        model_kind.string_title = [result stringForColumn:@"name"];
        model_kind.string_deleted = [result stringForColumn:@"deleted"];
        model_kind.string_articleCount = [result stringForColumn:@"articlecount"];
        model_kind.string_description = [result stringForColumn:@"description"];
        [array_first addObject:model_kind];
        
        NSString *string_search_pid = [NSString stringWithFormat:@"select * from kindInformation where pid = %@",model_kind.string_Id];
        NSMutableArray *array_data = [NSMutableArray array];
        FMResultSet *result = [db executeQuery:string_search_pid];
        while ([result next])
        {
            LGModel_kindData *model_kind = [[LGModel_kindData alloc] init];
            model_kind.string_Id = [result stringForColumn:@"id"];
            model_kind.string_pId = [result stringForColumn:@"pid"];
            model_kind.string_title = [result stringForColumn:@"name"];
            model_kind.string_deleted = [result stringForColumn:@"deleted"];
            model_kind.string_articleCount = [result stringForColumn:@"articlecount"];
            [array_data addObject:model_kind];
        }
        [array_return addObject:array_data];
    }
    [array_return addObject:array_first];
    [db close];
    return array_return;
}

/**
 存推送条数
 **/
+ (void)saveOrderCount:(NSMutableArray *)array_order
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    for(int i = 0; i <[array_order count]; i++)
    {
        LGModel_order *model_order = [array_order objectAtIndex:i];
        NSString *string_search = [NSString stringWithFormat:@"select * from orderCount where orderNo = %@",model_order.string_orderno];
        BOOL bool_search = NO;
        FMResultSet *result = [db executeQuery:string_search];
        while ([result next])
        {
            bool_search = YES;
        }
        if(!bool_search)
        {
            [db executeUpdate:@"insert into orderCount (orderNo,readCount) values (?,?)",model_order.string_orderno,@"0"];
        }
    }
    [db close];
}

#pragma mark - 查询推送条数 -
/**
 *  查询推送条数
 */
+ (NSString *)selectOrderCount:(NSString *)string_order
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    NSString *string_count;
    [db open];
    NSString *string_search = [NSString stringWithFormat:@"select * from orderCount where orderNo = %@",string_order];
    FMResultSet *result = [db executeQuery:string_search];
    while ([result next])
    {
        string_count = [result stringForColumn:@"readCount"];
    }
    [db close];
    return string_count;
}


#pragma mark - 更新已读条数 -
/**
 *  更新已读条数
 */
+ (void)upLoadOrderCount:(NSString *)string_count andOrderNo:(NSString *)string_no
{
    [self sqlDataInstall];
    NSString *dbpath = [self reciveDataPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    NSString *string_upload = [NSString stringWithFormat:@"update orderCount set readCount = '%@' where orderNo = '%@'",string_count,string_no];
    //NSLog(@"%@",[NSString stringWithFormat:@"update orderCount set readCount = '%@' where orderNo = '%@'",string_count,string_no]);
    [db executeUpdate:string_upload];
    //NSLog(@"%d",bool_sc);
    [db close];
}


@end
