//
//  LGModel_mainData.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-19.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 主页模型
 **/
@interface LGModel_mainData : NSObject

/**
 信息Id
 **/
@property (retain, nonatomic) NSString *string_Id;

/**
 文章Id
 **/
@property (retain, nonatomic) NSString *string_articleId;

/**
 文章类型
 **/
@property (retain, nonatomic) NSString *string_type;

/**
 更新时间
 **/
@property (retain, nonatomic) NSString *string_updateTime;

/**
 缩略图片Url
 **/
@property (retain, nonatomic) NSString *string_imageUrl;

/*
 详情Url
 */
@property (retain, nonatomic) NSString *string_imageDetailUrl;

/**
 标题title
 **/
@property (retain, nonatomic) NSString *string_title;

/**
 内容
 **/
@property (retain, nonatomic) NSString *string_content;

/*
 文章简述
 */
@property (retain, nonatomic) NSString *string_description;


@end
