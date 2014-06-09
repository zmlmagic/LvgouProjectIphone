//
//  LGKnowledgeView.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-23.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGZmlNavigationController.h"

@interface LGKnowledgeView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (retain, nonatomic) NSMutableArray *array_data;
@property (assign, nonatomic) LGZmlNavigationController *navigationController_z;
/*
 被选行
 */
@property (retain, nonatomic) NSIndexPath *selectIndex;

/*
 上个select
 */
@property (retain, nonatomic) NSIndexPath *selectBeforeIndex;

@property (assign, nonatomic) BOOL bool_isOpen;

@property (assign, nonatomic) UITableView *table_body;

- (id)initWithFrame:(CGRect)frame andNavigatonControllerZ:(LGZmlNavigationController *)navigationController_return;

@end
