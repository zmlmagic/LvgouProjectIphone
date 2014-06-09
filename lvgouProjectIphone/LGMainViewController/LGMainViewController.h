//
//  LGMainViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-2.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGViewController.h"
#import "LGTabBarView.h"

@interface LGMainViewController : LGViewController<LGTabBarViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *array_data;
@property (assign, nonatomic) UIButton *button_select;

@property (assign, nonatomic) UIView *view_one;
@property (assign, nonatomic) UIView *view_two;
@property (assign, nonatomic) UIView *view_three;

@property (assign, nonatomic) NSInteger int_tag;

/**
 cell加载动画
 **/
@property (assign, nonatomic) NSInteger currentMaxDisplayedCell;
@property (assign, nonatomic) NSInteger currentMaxDisplayedSection;
@property (assign, nonatomic) float cellZoomXScaleFactor;
@property (assign, nonatomic) float cellZoomYScaleFactor;
@property (assign, nonatomic) float cellZoomXOffset;
@property (assign, nonatomic) float cellZoomYOffset;
@property (assign, nonatomic) float cellZoomInitialAlpha;
@property (assign, nonatomic) float cellZoomAnimationDuration;

#pragma mark - 推送开开启程序 -
/**
 *  推送开开启程序
 */
- (void)pushMessageToMain;


@end
