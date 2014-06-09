//
//  LGModel_knowledge.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-23.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 主页模型
 **/
@interface LGModel_knowledge : NSObject

/**
 图片地址
 **/
@property (retain, nonatomic) NSString *string_imagePath;

/**
 标题title
 **/
@property (retain, nonatomic) NSString *string_title;

/**
 内容
 **/
@property (retain, nonatomic) NSString *string_content;

@end
