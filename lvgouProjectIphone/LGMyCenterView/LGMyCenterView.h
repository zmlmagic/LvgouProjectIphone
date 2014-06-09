//
//  LGMyCenterView.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-25.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGZmlNavigationController.h"
#import "EGORefreshTableHeaderView.h"

@interface LGMyCenterView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (retain, nonatomic) NSMutableArray *array_data;
@property (assign, nonatomic) LGZmlNavigationController *navigationController_z;
//@property (assign, nonatomic) UITableView *tableView_reload;

@property (assign, nonatomic) CGFloat float_oldPoint;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic, assign) CGFloat backgroundHeight;

/**
 下拉刷新
 **/
@property (assign, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic) BOOL reloading;

- (id)initWithFrame:(CGRect)frame andNavigatonControllerZ:(LGZmlNavigationController *)navigationController_return;

#pragma mark - 刷新数据 -
/**
 *  刷新数据
 */
- (void)reloadDataList;

@end
