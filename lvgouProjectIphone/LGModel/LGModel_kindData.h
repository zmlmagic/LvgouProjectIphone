//
//  LGModel_kindData.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-2.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 资讯模型
 */
@interface LGModel_kindData : NSObject

/*
 层级id
 */
@property (retain, nonatomic) NSString *string_Id;

/*
 父id
 */
@property (retain, nonatomic) NSString *string_pId;

/*
 标题title
 */
@property (retain, nonatomic) NSString *string_title;

/*
 附加字段
 */
@property (retain, nonatomic) NSString *string_deleted;

/*
 该分类信息条数
 */
@property (retain, nonatomic) NSString *string_articleCount;

/*
 一级图片
 */
@property (retain, nonatomic) NSString *string_picUrl;

/*
 二级内容
 */
@property (retain, nonatomic) NSString *string_description;

@end
