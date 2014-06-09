//
//  LGMainViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-2.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGMainViewController.h"
#import "LGTabBarView.h"
#import "SKUIUtils.h"
#import "LGModel_mainData.h"
#import "JDScrollView.h"

#import "LGKnowledgeView.h"
#import "LGMyCenterView.h"
#import "CRNavigationBar.h"
#import "LGFirstRequestViewController.h"
#import "LGNetworking.h"
#import "UIImageView+WebCache.h"
#import "LGMainContentViewController.h"
#import "LGDataBase.h"
#import "LGRqusetViewController.h"

#import "UIButton+WebCache.h"

#import <MapKit/MKMapView.h>

@interface LGMainViewController ()

@end

@implementation LGMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _int_tag = 1;
        
        UIView *view_current = [[UIView alloc] initWithFrame:self.view.frame];
        [view_current setBackgroundColor:RGB(246, 246, 246)];
        _view_two = view_current;
        [self.view insertSubview:_view_two atIndex:1];
        [self installTitleView_main];
        [self installTabBarView_main];
        [self.view setBackgroundColor:RGB(246, 246, 246)];
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [LGNetworking data_requestForMain:nil];
                           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(installTableData_main:) name:@"Notification_mainData" object:nil];
                           // code to be executed on the main queue after delay
                       });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController_return_z setCanDragBack:YES];
    if(_button_select)
    {
        [_button_select setBackgroundColor:[UIColor clearColor]];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SKUIUtils showHUDWithContent:@"正在加载中..." inCoverView:_view_two];
    });
}

/**
 初始化tableView
 **/
#pragma mark - 初始化tableView -
- (void)installTableView_main
{
    [SKUIUtils dismissCurrentHUD];
    
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [tabelView_body setBackgroundColor:[UIColor clearColor]];
    [tabelView_body setDelegate:self];
    [tabelView_body setDataSource:self];
    [_view_two insertSubview:tabelView_body atIndex:0];
    [tabelView_body setBackgroundColor:RGB(246, 246, 246)];
    [tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self initCellAnimationValue];
    //IOS7(tabelView_body);
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return _array_data.count - 5 + 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"scrollCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: 	UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSMutableArray *array_data = [NSMutableArray arrayWithCapacity:5];
            for (int i = 0; i < 5; i++)
            {
                [array_data addObject:[_array_data objectAtIndex:i]];
            }
            //[self installScrollViewData];
            JDScrollView *scroll_title = [[JDScrollView alloc] initWithModel:array_data];
            [cell addSubview:scroll_title];
        }
        return cell;
    }

    static NSString *CellIdentifier = @"mainCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: 	UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIButton *button_main = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_main setFrame:CGRectMake(8, 4, 304, 112)];
        //[SKUIUtils didLoadImageNotCached:@"mainButtonBack.png" inButton:button_main withState:UIControlStateNormal];
        [button_main.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        [button_main.layer setBorderWidth:1.0]; //边框宽度
        CGColorRef colorref = RGB(199, 199, 199).CGColor;
        [button_main.layer setBorderColor:colorref];//边框颜色
        [button_main addTarget:self action:@selector(didClickButton_detail:) forControlEvents:UIControlEventTouchUpInside];
        [button_main setTag:10];
        [cell addSubview:button_main];
    
        UIImageView *imageView_main = [[UIImageView alloc] initWithFrame:CGRectMake(15, 38, 97, 63)];
        [button_main addSubview:imageView_main];
        [imageView_main setTag:11];
        
        UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(imageView_main.frame.origin.x, 2, 225, 30)];
        [label_title setTextAlignment:NSTextAlignmentLeft];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextColor:[UIColor blackColor]];
        [button_main addSubview:label_title];
        [label_title setTag:12];
        [label_title setFont:[UIFont systemFontOfSize:18.0f]];
        
        UILabel *label_content = [[UILabel alloc] initWithFrame:CGRectMake(125, 29, 170, 80)];
        [label_content setBackgroundColor:[UIColor clearColor]];
        [label_content setTextColor:[UIColor blackColor]];
        [label_content setTag:13];
        [label_content setNumberOfLines:4];
        [button_main addSubview:label_content];
        [label_content setFont:[UIFont systemFontOfSize:14.0f]];
    }
    
    UIButton *button_main = (UIButton *)[cell viewWithTag:10];
    UIImageView *imageView_main = (UIImageView *)[button_main viewWithTag:11];
    UILabel *label_main = (UILabel *)[button_main viewWithTag:12];
    UILabel *label_content = (UILabel *)[button_main viewWithTag:13];
    
    if(_array_data.count == indexPath.row + 5)
    {
        [label_main setText:nil];
        [label_content setText:nil];
        [imageView_main setImage:nil];
        [button_main setHidden:YES];
    }
    else
    {
        [button_main setHidden:NO];
        LGModel_mainData *model_main = [_array_data objectAtIndex:indexPath.row + 5];
        [imageView_main setImageWithURL:[NSURL URLWithString:model_main.string_imageUrl] placeholderImage:nil];
        //[SKUIUtils didLoadImageNotCached:model_main.string_imageUrl inImageView:imageView_main];
        [label_main setText:model_main.string_title];
        [label_content setText:model_main.string_description];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 220.f;
    }
    else
    {
        if(indexPath.row + 5 == _array_data.count)
        {
            return 49.0f;
        }
        else
        {
            return 120.0f;
        }
    }
}

- (void)didClickButton_detail:(UIButton *)button_cell
{
    UITableViewCell *cell = [self reciveSuperViewCellWithView:button_cell];
    UITableView *tableView = [self reciveSuperViewTableWithView:cell];
    NSIndexPath *index = [tableView indexPathForCell:cell];
    
    if(_button_select)
    {
        [_button_select setBackgroundColor:[UIColor whiteColor]];
    }
    _button_select = button_cell;
    [button_cell setBackgroundColor:[UIColor grayColor]];
    
    LGModel_mainData *tmp = [_array_data objectAtIndex:index.row + 5];
    LGMainContentViewController *mainContent = [[LGMainContentViewController alloc] initWithIDString:tmp.string_articleId];
    mainContent.navigationController_return_z = self.navigationController_return_z;
    [self pushViewController:mainContent];
    
    //NSLog(@"%d",index.row);
}

- (UITableViewCell *)reciveSuperViewCellWithView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell class]])
        {
            return (UITableViewCell *)nextResponder;
        }
    }
    return nil;
}

- (UITableView *)reciveSuperViewTableWithView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]])
        {
            return (UITableView *)nextResponder;
        }
    }
    return nil;
}

/**
 初始化title
 **/
#pragma mark - 初始化title -
- (void)installTitleView_main
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    if(IOS7_VERSION)
    {
        [view_title setBackgroundColor:[UIColor clearColor]];
        CRNavigationBar *bar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(view_title.frame.origin.x, 0, view_title.frame.size.width, view_title.frame.size.height)];
        [view_title addSubview:bar];
        UIColor *tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        bar.barTintColor = tintColor;
    }
    else
    {
        [view_title setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    }
    
    [_view_two insertSubview:view_title atIndex:1];
    IOS7(view_title);
    
    UIButton *button_ask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_ask setFrame:CGRectMake(view_title.frame.size.width - 64, 0, 64, 64)];
    [SKUIUtils didLoadImageNotCached:@"button_ask.png" inButton:button_ask withState:UIControlStateNormal];
    [button_ask addTarget:self action:@selector(didClickButton_ask) forControlEvents:UIControlEventTouchUpInside];
    [view_title addSubview:button_ask];
    
    UIButton *button_other = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_other setFrame:CGRectMake(0, 10, view_title.frame.size.width - 64, 64)];
    [button_other setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_other setTitle:@"我想问律师" forState:UIControlStateNormal];
    [button_other setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button_other setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 100)];
    [button_other addTarget:self action:@selector(didClickButton_ask) forControlEvents:UIControlEventTouchUpInside];
    [button_other.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22.0f]];
    [view_title addSubview:button_other];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        //Check whether Settings page is openable (iOS 5.1 not allows Settings page to be opened via openURL:)
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enable location service,Turn on location service to allow \"YourApp\" to determine your location" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
            [alert show];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enable location service" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:General&path=DATE_AND_TIME"]];
    }
    
}

/**
 点击问律师按钮
 **/
#pragma mark - 点击问律师按钮 -
- (void)didClickButton_ask
{
    NSString *string_userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if(!string_userId || [string_userId length] == 0)
    {
        LGFirstRequestViewController *firstRequest = [[LGFirstRequestViewController alloc] initWithNavigationZController:self.navigationController_return_z];
        [self pushViewController:firstRequest];
    }
    else
    {
        LGRqusetViewController *requestController = [[LGRqusetViewController alloc] initWithNavigationZController:self.navigationController_return_z];
        [self pushViewController:requestController];
    }
}

/**
 初始化TabBar
 **/
#pragma mark - 初始化TabBar -
- (void)installTabBarView_main
{
    LGTabBarView *tabBar = [[LGTabBarView alloc] init];
    [tabBar setTag:100];
    [self.view insertSubview:tabBar atIndex:2];
    [tabBar setDelegate:self];
}

- (void)delegate_didClickButton_tab:(NSInteger)tag
{
    switch (tag)
    {
        case 0:
        {
            switch (_int_tag)
            {
                case 0:
                {
                    
                }break;
                case 1:
                {
                    if(_view_one)
                    {
                        
                    }
                    else
                    {
                        LGKnowledgeView *view_know = [[LGKnowledgeView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        _view_one = view_know;
                        [self.view insertSubview:_view_one atIndex:0];
                    }
                    
                    [self animationForViewChangeFrom:_view_two toView:_view_one];
                    
                }break;
                case 2:
                {
                    if(_view_one)
                    {
                        
                    }
                    else
                    {
                        LGKnowledgeView *view_know = [[LGKnowledgeView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        _view_one = view_know;
                        [self.view insertSubview:_view_one atIndex:0];
                    }
                    
                    [self animationForViewChangeFrom:_view_three toView:_view_one];
                    
                }break;
                default:
                    break;
            }
        }break;
        case 1:
        {
            switch (_int_tag)
            {
                case 0:
                {
                    [self animationForViewChangeFrom:_view_one toView:_view_two];
                }break;
                case 1:
                {
                    
                }break;
                case 2:
                {
                    [self animationForViewChangeFrom:_view_three toView:_view_two];
                }break;
                default:
                    break;
            }
            
        }break;
        case 2:
        {
            switch (_int_tag)
            {
                case 0:
                {
                    if(_view_three)
                    {
                        //[(LGMyCenterView *)_view_three reloadDataList];
                        LGMyCenterView *view_myCenter = [[LGMyCenterView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        [view_myCenter setBackgroundHeight:250.0f];
                        _view_three = view_myCenter;
                        [self.view insertSubview:_view_three atIndex:0];
                    }
                    else
                    {
                        LGMyCenterView *view_myCenter = [[LGMyCenterView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        [view_myCenter setBackgroundHeight:250.0f];
                        _view_three = view_myCenter;
                        [self.view insertSubview:_view_three atIndex:0];
                    }
                    
                    [self animationForViewChangeFrom:_view_one toView:_view_three];
                    
                }break;
                case 1:
                {
                    if(_view_three)
                    {
                        //[(LGMyCenterView *)_view_three reloadDataList];
                        [_view_three removeFromSuperview];
                        _view_three = nil;
                        LGMyCenterView *view_myCenter = [[LGMyCenterView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        [view_myCenter setBackgroundHeight:250.0f];
                        _view_three = view_myCenter;
                        [self.view insertSubview:_view_three atIndex:0];
                    }
                    else
                    {
                        LGMyCenterView *view_myCenter = [[LGMyCenterView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x - 320, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) andNavigatonControllerZ:self.navigationController_return_z];
                        [view_myCenter setBackgroundHeight:250.0f];
                        _view_three = view_myCenter;
                        [self.view insertSubview:_view_three atIndex:0];
                    }
                    
                    [self animationForViewChangeFrom:_view_two toView:_view_three];
                    
                }break;
                case 2:
                {
                    
                }break;
                default:
                    break;
            }

        }
        default:
            break;
    }
    _int_tag = tag;
}


- (void)animationForViewChangeFrom:(UIView *)view_before toView:(UIView *)view_now
{
    
    [UIView animateWithDuration:0.2f animations:
     ^{
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationDuration:0.2f];
         [UIView setAnimationRepeatCount:1];
         [UIView setAnimationBeginsFromCurrentState:YES];
         [view_now setCenter:CGPointMake(view_now.center.x + 320, view_now.center.y)];
         [UIView commitAnimations];
     }completion:^(BOOL finish){

         //NSLog(@"1");
     }];
    
    [UIView animateWithDuration:0.2f animations:
     ^{
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationDuration:0.3f];
         [UIView setAnimationRepeatCount:1];
         [UIView setAnimationBeginsFromCurrentState:YES];
         [view_before setCenter:CGPointMake(view_before.center.x - 320, view_before.center.y)];
         [UIView commitAnimations];
     }completion:^(BOOL finish){
         double delayInSeconds = 0.5;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                        {
                            [self.view insertSubview:view_now aboveSubview:view_before];
                            //NSLog(@"2");
                            // code to be executed on the main queue after delay
                        });
   

     }];
}


/**
 初始化table数据
 **/
#pragma mark - 初始化table数据 -
- (void)installTableData_main:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_mainData" object:nil];
    if([[notification object] isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray *array_data = [NSMutableArray arrayWithArray:[notification object]];
        _array_data = array_data;
        
        [self installTableView_main];
    }
    else
    {
        [SKUIUtils dismissCurrentHUD];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [SKUIUtils showAlterView:@"请求失败" afterTime:1.5];
                           // code to be executed on the main queue after delay
                       });
    }
}

#pragma mark - cell动画 -
/**
 初始化cell动画参数
 **/
- (void)initCellAnimationValue
{
    self.cellZoomXScaleFactor = 1.35;   ///默认1.35
    self.cellZoomYScaleFactor = 1.35;
    self.cellZoomXOffset = 0.0;
    self.cellZoomYOffset = 0.0;
    self.cellZoomAnimationDuration = 0.55; ///默认0.65
    self.cellZoomInitialAlpha = 0.3;
}

/**
 加载新数据时调用,重置动画起始
 **/
-(void)resetViewedCells
{
    self.currentMaxDisplayedSection = 0;
    self.currentMaxDisplayedCell = 0;
}

/**
 cell加载动画
 **/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((indexPath.section == 0 && self.currentMaxDisplayedCell == 0) || indexPath.section > self.currentMaxDisplayedSection)
    {
        self.currentMaxDisplayedCell = -1;
    }
    
    if (indexPath.section >= self.currentMaxDisplayedSection && indexPath.row > self.currentMaxDisplayedCell)
    {
        cell.alpha = self.cellZoomInitialAlpha;
        CGAffineTransform transformScale = CGAffineTransformMakeScale(self.cellZoomXScaleFactor, self.cellZoomYScaleFactor);
        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset, self.cellZoomYOffset);
        cell.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        [tableView bringSubviewToFront:cell];
        [UIView animateWithDuration:self.cellZoomAnimationDuration animations:^{
        cell.alpha = 1;
        cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finish){
            
        }];
        self.currentMaxDisplayedCell = indexPath.row;
        self.currentMaxDisplayedSection = indexPath.section;
    }
}

#pragma mark - 推送开开启程序 -
/**
 *  推送开开启程序
 */
- (void)pushMessageToMain
{
    LGTabBarView *bar = (LGTabBarView *)[self.view viewWithTag:100];
    [bar pushMessageToBar];
}


@end
