//
//  LGAddQusetionViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGViewController.h"
#import "LGModel_addQuestion.h"

@interface LGAddQusetionViewController : LGViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

#pragma mark - 追问数据 -
/**
 *  追问数据
 */
@property (nonatomic, retain) LGModel_addQuestion *model_addQuestion;

@property (assign, nonatomic) UITextView *textView_content;

#pragma mark - 追问初始化 -
/**
 *  追问初始化
 *
 *  @param navigationController_return_z 控制器
 *  @param model_addQuestion             追问模型
 *
 *  @return self
 */
- (id)initWithNavigationZController:(LGZmlNavigationController *)navigationController_return_z
                        andQuestion:(LGModel_addQuestion *)model_addQuestion;

@end
