//
//  LGLocationViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-9.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGLocationViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGDataBase.h"
#import "LGModel_location.h"

@interface LGLocationViewController ()

@end

@implementation LGLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:RGB(244, 244, 244)];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self installTitleView_location];
    [SKUIUtils showHUD:@"正在努力加载..." afterTime:60.0f];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self installTableViewData_location];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self installbodyView_location];
        });  
    });
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化标题栏 -
/*
 初始化标题栏
 */
- (void)installTitleView_location
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
    [label_title setText:@"选择所在地"];
    [view_title addSubview:label_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_location) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

/**
 返回按钮回调
 **/
#pragma mark - 返回按钮回调 -
- (void)didClickButtonBack_location
{
    [self popViewController];
}

/*
 初始化列表数据
 */
- (void)installTableViewData_location
{
    self.array_data = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    _array_tableData = [LGDataBase getLoactionDataBaseWithArray:_array_data];
}


- (void)installbodyView_location
{
    [SKUIUtils dismissCurrentHUD];
    
    UITableView *tableView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [tableView_body setBackgroundColor:[UIColor clearColor]];
    [tableView_body setDelegate:self];
    [tableView_body setDataSource:self];
    [self.view insertSubview:tableView_body atIndex:0];
    [tableView_body setBackgroundColor:RGB(246, 246, 246)];
    if(IOS7_VERSION)
    {
        //[tableView_body setSectionIndexColor:[UIColor darkGrayColor]];
        [tableView_body setSectionIndexBackgroundColor:[UIColor clearColor]];
    }
    //[tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_array_tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextColor:[UIColor blackColor]];
        [label_title setTag:5];
        [cell addSubview:label_title];
    }
    UILabel *label_title = (UILabel *)[cell viewWithTag:5];
    
    LGModel_location *location = [[_array_tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSLog(@"%@",location.string_title);
    
    [label_title setText:location.string_title];
    
    return cell;
}

/*
 隐藏空数据栏
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *array_tmp = [_array_tableData objectAtIndex:section];
    if([array_tmp count] == 0)
    {
        return 0;
    }
    else
    {
        return 23;
    }
}

/*
 分类数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_array_data count];
}

/*
 滚动位置显示
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSMutableArray *array_check = [_array_tableData objectAtIndex:index];
    if([array_check count] == 0)
    {
        NSMutableArray *array_tmp;
        for (int i = index-1; i<index; i--)
        {
            array_tmp = [_array_tableData objectAtIndex:i];
            if([array_tmp count] != 0)
            {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                return i;
            }
        }
    }
    else
    {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        return index;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = RGB(233, 233, 233);
    [myView setAlpha:0.8];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [_array_data objectAtIndex:section];
    [myView addSubview:titleLabel];
    return myView;
}

/*
 标题栏
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _array_data;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGModel_location *location = [[_array_tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSMutableArray *array_send = [NSMutableArray arrayWithObjects:location.string_title, nil];
    __block __weak NSString *string_province;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        string_province = [LGDataBase getProvinceFromDataBaseWithString:location.string_superId];
        //NSLog(@"%@",string_province);
        if(string_province)
        {
            [array_send addObject:string_province];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_locationContent" object:array_send];
            [self popViewController];
        });
    });
}

@end
