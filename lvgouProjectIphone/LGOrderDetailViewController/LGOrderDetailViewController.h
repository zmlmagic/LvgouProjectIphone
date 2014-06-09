//
//  LGOrderDetailViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-15.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGViewController.h"
#import "LGModel_addQuestion.h"

@class LGModel_order;

@interface LGOrderDetailViewController : LGViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *array_dataDetail;

@property (nonatomic, retain) LGModel_addQuestion *model_addQuestion;
@property (nonatomic, assign) LGModel_order *model_order;


- (id)initOrderDetailWithOrder:(LGModel_order *)model_order andNavigationControllerZ:(LGZmlNavigationController *)navigationController;

@end
