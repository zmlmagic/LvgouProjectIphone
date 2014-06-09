//
//  LGRqusetViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-3.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGViewController.h"
#import "LGModel_addQuestion.h"

@class LGModel_userOrder;

@interface LGRqusetViewController : LGViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (retain, nonatomic) LGModel_userOrder *model_order;

@property (assign, nonatomic) UIButton *button_location;

@property (assign, nonatomic) UITextView *textView_content;


@end
