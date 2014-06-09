//
//  LGKonwledgeListViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-11.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGViewController.h"


@interface LGKonwledgeListViewController : LGViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *array_data;

@property (assign, nonatomic) UIButton *button_select;

@property (assign, nonatomic) NSInteger integer_page;
@property (assign, nonatomic) NSString *string_id;
@property (assign, nonatomic) NSString *string_key;

- (id)initWithStringID:(NSString *)string_id;
- (id)initWithSearchKey:(NSString *)string_key;

@end
