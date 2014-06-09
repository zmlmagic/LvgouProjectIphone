//
//  LGLocationViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-9.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGViewController.h"

@interface LGLocationViewController : LGViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSArray *array_data;

@property (retain, nonatomic) NSMutableArray *array_tableData;

@end
