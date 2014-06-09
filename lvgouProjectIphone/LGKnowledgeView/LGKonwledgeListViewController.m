//
//  LGKonwledgeListViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-11.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGKonwledgeListViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGNetworking.h"
#import "LGModel_mainData.h"
#import "UIImageView+WebCache.h"
#import "LGZmlNavigationController.h"
#import "LGMainContentViewController.h"

@interface LGKonwledgeListViewController ()

@end

@implementation LGKonwledgeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 初始化 -
/*
 初始化
 */
- (id)initWithStringID:(NSString *)string_id
{
    self = [super init];
    if (self)
    {
        _integer_page = 1;
        [self installTitleView_knowledgeList];
        [SKUIUtils showHUD:@"正在努力加载..." afterTime:60.0f];
        [self installTableViewData_knowledgeListWithId:string_id andStringPage:@"1"];
        _string_id = string_id;
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self installTableViewData_knowledgeListWithId:string_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self installbodyView_knowledgeList];
            });
        });*/
        [self.view setBackgroundColor:RGB(244, 244, 244)];
        // Custom initialization
    }
    return self;
}

#pragma mark - 搜索初始化 -
/*
 搜索初始化
 */
- (id)initWithSearchKey:(NSString *)string_key
{
    self = [super init];
    if (self)
    {
        [self installTitleView_knowledgeList];
        [SKUIUtils showHUD:@"正在努力搜索..." afterTime:60.0f];
        [self installTableViewData_knowledgeListWithId:string_key andStringPage:@""];
        _string_key = string_key;
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self installTableViewData_knowledgeListWithId:string_id];
         dispatch_async(dispatch_get_main_queue(), ^{
         [self installbodyView_knowledgeList];
         });
         });*/
        [self.view setBackgroundColor:RGB(244, 244, 244)];
        // Custom initialization
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
    if(_button_select)
    {
        [_button_select setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - 初始化标题栏 -
/*
 初始化标题栏
 */
- (void)installTitleView_knowledgeList
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    [self.view insertSubview:view_title atIndex:1];
    IOS7(view_title);
    
    if(IOS7_VERSION)
    {
        [view_title setBackgroundColor:[UIColor clearColor]];
        CRNavigationBar *bar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(view_title.frame.origin.x, 0, view_title.frame.size.width, view_title.frame.size.height)];
        [view_title addSubview:bar];
        UIColor *tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        bar.barTintColor = tintColor;
    }
    else
    {
        [view_title setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    }
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 120, 21)];
    [label_title setBackgroundColor:[UIColor clearColor]];
    [label_title setTextColor:[UIColor whiteColor]];
    [label_title setTextAlignment:NSTextAlignmentCenter];
    [label_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
    [label_title setText:@"法律知识"];
    [view_title addSubview:label_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_knowledgeList) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

#pragma mark - 返回按钮回调 -
/*
返回按钮回调
*/
- (void)didClickButtonBack_knowledgeList
{
    [self popViewController];
}

#pragma mark - 初始化列表数据 -
/*
 初始化列表数据
 */
- (void)installTableViewData_knowledgeListWithId:(NSString *)string_id andStringPage:(NSString *)string_page
{
    if([string_page length] == 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveKindListInfomation:) name:@"Notification_kindList" object:nil];
        [LGNetworking searchInformationWithKeyWord:string_id];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveKindListInfomation:) name:@"Notification_kindList" object:nil];
        [LGNetworking getKindContentListWithID:string_id andPage:string_page];
    }
}

#pragma mark - 初始化数据消息回调 -
/*
 初始化数据消息回调
 */
- (void)reciveKindListInfomation:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_kindList" object:nil];
    NSMutableArray *array_detail = (NSMutableArray *)[notification object];
    
    if([array_detail count] == 0)
    {
        if([_array_data count] != 0)
        {
            [SKUIUtils dismissCurrentHUD];
            [SKUIUtils showAlterView:@"无更多内容" afterTime:1.0f];
        }
        else
        {
            [SKUIUtils dismissCurrentHUD];
            [SKUIUtils showAlterView:@"未搜到结果" afterTime:1.0f];
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self popViewController];
            });
        }
    }
    else
    {
        if([_array_data count] == 0)
        {
            _array_data = array_detail;
            [self installTableView_kindList];
        }
        else
        {
            [SKUIUtils dismissCurrentHUD];
            
            [_array_data addObjectsFromArray:array_detail];
            [self performSelectorOnMainThread:@selector(finishLoadingTableViewData_foot) withObject:nil waitUntilDone:YES];
        }
    }
    //LGModel_mainData *model_main = [array_detail objectAtIndex:0];
}

#pragma mark - 初始化tableView -
/*
 初始化tableView
 */
- (void)installTableView_kindList
{
    [SKUIUtils dismissCurrentHUD];
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    
    [tabelView_body setBackgroundColor:[UIColor clearColor]];
    tabelView_body.tag = 80;
    [tabelView_body setDelegate:self];
    [tabelView_body setDataSource:self];
    [self.view insertSubview:tabelView_body atIndex:0];
    [tabelView_body setBackgroundColor:RGB(246, 246, 246)];
    [tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array_data.count + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"kindList_Cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: 	UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIButton *button_main = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_main setFrame:CGRectMake(8, 4, 304, 112)];
        //[SKUIUtils didLoadImageNotCached:@"mainButtonBack.png" inButton:button_main withState:UIControlStateNormal];
        [button_main setBackgroundColor:[UIColor clearColor]];
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
        
        UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(imageView_main.frame.origin.x, -10, 280, 60)];
        [label_title setTextAlignment:NSTextAlignmentLeft];
        [label_title setNumberOfLines:2];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextColor:[UIColor blackColor]];
        [button_main addSubview:label_title];
        [label_title setTag:12];
        [label_title setFont:[UIFont systemFontOfSize:15.0f]];
        
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
    
    if(indexPath.row == 0)
    {
        [label_main setText:nil];
        [label_content setText:nil];
        [imageView_main setImage:nil];
        [button_main setHidden:YES];
    }
    else if(indexPath.row == [_array_data count] + 1)
    {
        [label_main setText:nil];
        [label_content setText:nil];
        [imageView_main setImage:nil];
        [button_main setHidden:NO];
        button_main.frame = CGRectMake(button_main.frame.origin.x, button_main.frame.origin.y, button_main.frame.size.width, 40);
        [button_main.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [button_main setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button_main setTitle:@"点击加载更多" forState:UIControlStateNormal];
    }
    else
    {
        button_main.frame = CGRectMake(button_main.frame.origin.x, button_main.frame.origin.y, button_main.frame.size.width, 112);
        [button_main setTitle:nil forState:UIControlStateNormal];
        
        [button_main setHidden:NO];
        LGModel_mainData *model_main = [_array_data objectAtIndex:indexPath.row - 1];
        [imageView_main setImageWithURL:[NSURL URLWithString:model_main.string_imageUrl] placeholderImage:nil];
        [label_main setText:model_main.string_title];
        [label_content setText:model_main.string_description];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 95.0f;
    }
    else if(indexPath.row == [_array_data count] + 1)
    {
        return 50.0f;
    }
    else
    {
        return 120.0f;
    }
}

- (void)didClickButton_detail:(UIButton *)button_cell
{
    UITableViewCell *cell = [self reciveSuperViewCellWithView:button_cell];
    UITableView *tableView = [self reciveSuperViewTableWithView:cell];
    NSIndexPath *index = [tableView indexPathForCell:cell];
    
    if(index.row == [_array_data count] + 1)
    {
        [self reciveDataInBackgroundReloadTableView];
        return;
    }
    
    if(_button_select)
    {
        [_button_select setBackgroundColor:[UIColor clearColor]];
        //[_button_select setBackgroundColor:[UIColor whiteColor]];
    }

    _button_select = button_cell;
    [button_cell setBackgroundColor:[UIColor grayColor]];
    
    LGModel_mainData *tmp = [_array_data objectAtIndex:index.row - 1];
    LGMainContentViewController *mainContent = [[LGMainContentViewController alloc] initWithIDString:tmp.string_Id];
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

#pragma mark - 加载更多 -
/**
 *  加载更多
 */
- (void)finishLoadingTableViewData_foot
{
    UITableView *tableView_reload = (UITableView *)[self.view viewWithTag:80];
    [tableView_reload reloadData];
}

- (void)reciveDataInBackgroundReloadTableView
{
    _integer_page = _integer_page + 5;
    
    [SKUIUtils showHUD:@"正在努力加载..." afterTime:60.0f];
    [self installTableViewData_knowledgeListWithId:_string_id andStringPage:[NSString stringWithFormat:@"%d",_integer_page]];
    
}

@end
