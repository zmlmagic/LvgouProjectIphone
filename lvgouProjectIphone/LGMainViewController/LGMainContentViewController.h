//
//  LGMainContentViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-6.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGViewController.h"

@class LGModel_mainData;

@interface LGMainContentViewController : LGViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) LGModel_mainData *mainContent;

- (id)initWithIDString:(NSString *)string_id;

@end
