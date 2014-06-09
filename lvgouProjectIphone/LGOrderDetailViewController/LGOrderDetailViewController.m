//
//  LGOrderDetailViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-15.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGOrderDetailViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGNetworking.h"
#import "LGModel_lawyer.h"
#import "LGModel_order.h"
#import "SKUIUtils.h"
#import "UIButton+WebCache.h"
#import "LGAddQusetionViewController.h"
#import "LGDataBase.h"

@interface LGOrderDetailViewController ()

@end

@implementation LGOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 初始化订单详情 -
/**
 初始化订单详情
 **/
- (id)initOrderDetailWithOrder:(LGModel_order *)model_order andNavigationControllerZ:(LGZmlNavigationController *)navigationController
{
    self.navigationController_return_z = navigationController;
    self = [super init];
    if(self)
    {
        [self.view setBackgroundColor:RGB(246, 246, 246)];
        LGModel_addQuestion *model_quesTion = [[LGModel_addQuestion alloc] init];
        _model_addQuestion = model_quesTion;
        
        _model_order = model_order;
    }
    return self;
}


- (void)viewDidLoad
{
    [super didReceiveMemoryWarning];
    [self installTitleView_orderDetail];
    [SKUIUtils showHUD:@"正在努力加载..." afterTime:60.0f];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDetailDataFromNetwork:) name:@"Notification_getOrderDetail" object:nil];
    [LGNetworking getOrderDetailWithNo:_model_order.string_orderno];
}


- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}


#pragma mark - 接受详情信息回调 -
/**
 接受详情信息回调
 **/
- (void)didReceiveDetailDataFromNetwork:(NSNotification *)notification
{
    [SKUIUtils dismissCurrentHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_getOrderDetail" object:nil];
    if([[notification object] isKindOfClass:[NSString class]])
    {
        //NSLog(@"%@",[notification object]);
    }
    else if([[notification object] isKindOfClass:[NSMutableArray class]])
    {
        _array_dataDetail = (NSMutableArray *)[notification object];
        [self installTableView_orderDetail];
    }
    
    NSString *count_before = [LGDataBase selectOrderCount:_model_order.string_orderno];
    int count = [_model_order.string_replycount intValue] - [count_before intValue];
    NSMutableArray *array_count = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%d",count]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notifacation_getIconCount" object:array_count];
    [LGDataBase upLoadOrderCount:_model_order.string_replycount andOrderNo:_model_order.string_orderno];
}


#pragma mark - 初始化title - 
/**
 初始化title
 **/
- (void)installTitleView_orderDetail
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    [self.view insertSubview:view_title atIndex:1];
    IOS7(view_title);
    
    if(IOS7_VERSION)
    {
        [view_title setBackgroundColor:[UIColor grayColor]];
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
    [label_title setText:@"查看详情"];
    [view_title addSubview:label_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_orderDetail) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
    
    UIButton *button_continue = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_continue setFrame:CGRectMake(260, 30, 50, 21)];
    [button_continue setTitle:@"追问" forState:UIControlStateNormal];
    [button_continue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_continue addTarget:self action:@selector(didClickButtonContinue_orderDetail) forControlEvents:UIControlEventTouchUpInside];
    [view_title addSubview:button_continue];
}

#pragma mark - 点击追问按钮 -
/**
 *  点击追问按钮
 */
- (void)didClickButtonContinue_orderDetail
{
    if(_model_addQuestion.string_toid)
    {
        LGAddQusetionViewController *addQusetion = [[LGAddQusetionViewController alloc] initWithNavigationZController:self.navigationController_return_z andQuestion:_model_addQuestion];
        [self pushViewController:addQusetion];
    }
    else
    {
        [SKUIUtils showAlterView:@"尚无律师接单" afterTime:1.0f];
    }
}

#pragma mark - 返回按钮回调 -
/**
 返回按钮回调
 */
- (void)didClickButtonBack_orderDetail
{
    [self popViewController];
}

#pragma mark - 初始化列表 -
/**
 初始化列表
 **/
- (void)installTableView_orderDetail
{
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [tabelView_body setDelegate:self];
    [tabelView_body setDataSource:self];
    [self.view insertSubview:tabelView_body atIndex:0];
    [tabelView_body setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    [tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - tableView回调 -
/**
 *  tableView回调
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array_dataDetail count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier_order = @"orderCellOne";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier_order];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_order];
            [cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView_orderTitle = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 308, 29)];
            [SKUIUtils didLoadImageNotCached:@"imageView_orderTitle.png" inImageView:imageView_orderTitle];
            [imageView_orderTitle setTag:10];
            [cell addSubview:imageView_orderTitle];
            imageView_orderTitle.frame = CGRectMake(imageView_orderTitle.frame.origin.x, imageView_orderTitle.frame.origin.y + 100, imageView_orderTitle.frame.size.width, imageView_orderTitle.frame.size.height);
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 20)];
            [label_title setTextColor:RGB(54, 171, 70)];
            [label_title setFont:[UIFont systemFontOfSize:12.0f]];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setTag:11];
            [imageView_orderTitle addSubview:label_title];
            
            UIButton *button_content = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_content setFrame:CGRectMake(imageView_orderTitle.frame.origin.x, imageView_orderTitle.frame.origin.y + imageView_orderTitle.frame.size.height, 308, 157)];
            [button_content setTag:12];
            [button_content.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [button_content.titleLabel setNumberOfLines:20];
            [button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 200)];
            [cell addSubview:button_content];
        }
        LGModel_order *order = [_array_dataDetail objectAtIndex:indexPath.row];
        if(!_model_addQuestion.string_orderid)
        {
            _model_addQuestion.string_orderid = order.string_orderno;
            _model_addQuestion.string_memberid = order.string_memberid;
        }
        
        UIImageView *imageView_title = (UIImageView *)[cell viewWithTag:10];
        UILabel *label_title = (UILabel *)[cell viewWithTag:11];

        [label_title setText:[SKUIUtils getTimeFromTimeStamp:order.string_updatetime]];
        
        UIButton *button_content = (UIButton *)[cell viewWithTag:12];
        CGSize button_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        [button_content setTitle:order.string_description forState:UIControlStateNormal];
        [button_content setFrame:CGRectMake(button_content.frame.origin.x, imageView_title.frame.origin.y + imageView_title.frame.size.height, button_content.frame.size.width, button_size.height + 41)];
        [button_content setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button_content setUserInteractionEnabled:NO];

        [SKUIUtils didLoadImageNotCached:@"imageVIew_orderContent.png" inButton:button_content withState:UIControlStateNormal];
        [button_content setTitle:order.string_description forState:UIControlStateNormal];
        
        return cell;
    }
    
    id object = [_array_dataDetail objectAtIndex:indexPath.row];
    //order
    if([object isKindOfClass:[LGModel_order class]])
    {
        static NSString *CellIdentifier_order = @"orderCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier_order];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_order];
            [cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView_orderTitle = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 308, 29)];
            [SKUIUtils didLoadImageNotCached:@"imageView_orderTitle.png" inImageView:imageView_orderTitle];
            [imageView_orderTitle setTag:10];
            [cell addSubview:imageView_orderTitle];
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 20)];
            [label_title setTextColor:RGB(54, 171, 70)];
            [label_title setFont:[UIFont systemFontOfSize:12.0f]];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setTag:11];
            [imageView_orderTitle addSubview:label_title];
    
            UIButton *button_content = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_content setFrame:CGRectMake(imageView_orderTitle.frame.origin.x, imageView_orderTitle.frame.origin.y + imageView_orderTitle.frame.size.height, 308, 157)];
            [button_content setTag:12];
            [button_content.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [button_content.titleLabel setNumberOfLines:20];
            [button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 200)];
            [cell addSubview:button_content];
        }
        LGModel_order *order = [_array_dataDetail objectAtIndex:indexPath.row];
        if(!_model_addQuestion.string_orderid)
        {
            _model_addQuestion.string_orderid = order.string_orderno;
            _model_addQuestion.string_memberid = order.string_memberid;
        }
        
        UIImageView *imageView_title = (UIImageView *)[cell viewWithTag:10];
        UILabel *label_title = (UILabel *)[cell viewWithTag:11];
        
        
        if(indexPath.row == 0)
        {
            imageView_title.frame = CGRectMake(imageView_title.frame.origin.x, imageView_title.frame.origin.y + 100, imageView_title.frame.size.width, imageView_title.frame.size.height);
        }
        else
        {
            imageView_title.frame = CGRectMake(imageView_title.frame.origin.x, 5, imageView_title.frame.size.width, imageView_title.frame.size.height);
            
        }
        [label_title setText:[SKUIUtils getTimeFromTimeStamp:order.string_updatetime]];
        
        UIButton *button_content = (UIButton *)[cell viewWithTag:12];
        CGSize button_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        [button_content setTitle:order.string_description forState:UIControlStateNormal];
        [button_content setFrame:CGRectMake(button_content.frame.origin.x, imageView_title.frame.origin.y + imageView_title.frame.size.height, button_content.frame.size.width, button_size.height + 41)];
        [button_content setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button_content setUserInteractionEnabled:NO];
        
        //if(button_content.frame.size.height > 58)
        //{
            //[button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        //}
        //else
        //{
            //[button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 200)];
        //}
  
        [SKUIUtils didLoadImageNotCached:@"imageVIew_orderContent.png" inButton:button_content withState:UIControlStateNormal];
        [button_content setTitle:order.string_description forState:UIControlStateNormal];
        
        return cell;
    }
    //lawyer
    else
    {
        static NSString *CellIdentifier_lawyer = @"lawyerCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier_lawyer];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_lawyer];
            [cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView_lawyerTitle = [[UIImageView alloc] initWithFrame:CGRectMake(6, 5, 308, 89)];
            [SKUIUtils didLoadImageNotCached:@"imageVIew_lawyerTitle.png" inImageView:imageView_lawyerTitle];
            [imageView_lawyerTitle setTag:10];
            [cell addSubview:imageView_lawyerTitle];
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 20)];
            [label_title setTextColor:RGB(54, 171, 70)];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setFont:[UIFont systemFontOfSize:12.0f]];
            [label_title setTag:11];
            [imageView_lawyerTitle addSubview:label_title];
            
            UIButton *button_portrait = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_portrait setFrame:CGRectMake(18, 37, 40, 40)];
            [button_portrait setBackgroundColor:[UIColor redColor]];
            [button_portrait setTag:20];
            [imageView_lawyerTitle addSubview:button_portrait];
            
            UILabel *label_lawyerName = [[UILabel alloc] initWithFrame:CGRectMake(button_portrait.frame.origin.x + button_portrait.frame.size.width + 15, button_portrait.frame.origin.y, 200, 20)];
            [label_lawyerName setBackgroundColor:[UIColor clearColor]];
            [label_lawyerName setTextColor:[UIColor blackColor]];
            [label_lawyerName setTag:21];
            [label_lawyerName setFont:[UIFont systemFontOfSize:16.0]];
            [imageView_lawyerTitle addSubview:label_lawyerName];
            
            UILabel *label_lawyerNumber = [[UILabel alloc] initWithFrame:CGRectMake(label_lawyerName.frame.origin.x, label_lawyerName.frame.origin.y + label_lawyerName.frame.size.height + 2, 250, 20)];
            [label_lawyerNumber setBackgroundColor:[UIColor clearColor]];
            [label_lawyerNumber setTextColor:[UIColor blackColor]];
            [label_lawyerNumber setFont:[UIFont systemFontOfSize:13.0]];
            [label_lawyerNumber setTag:22];
            [imageView_lawyerTitle addSubview:label_lawyerNumber];
            
            UIButton *button_content = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_content setFrame:CGRectMake(imageView_lawyerTitle.frame.origin.x, imageView_lawyerTitle.frame.origin.y + imageView_lawyerTitle.frame.size.height, 308, 184)];
            [button_content setTag:12];
            [button_content.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [button_content.titleLabel setNumberOfLines:99];
            [button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 200)];
            [button_content setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell addSubview:button_content];
            [button_content setUserInteractionEnabled:NO];
        }
        
        LGModel_lawyer *lawyer = [_array_dataDetail objectAtIndex:indexPath.row];
        if(!_model_addQuestion.string_toid)
        {
            _model_addQuestion.string_toid = lawyer.string_memberid;
        }
        UILabel *label_title = (UILabel *)[cell viewWithTag:11];
        [label_title setText:[SKUIUtils getTimeFromTimeStamp:lawyer.string_createtime]];
        
        UIButton *button_content = (UIButton *)[cell viewWithTag:12];
        CGSize button_size = [lawyer.string_content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        [button_content setTitle:lawyer.string_content forState:UIControlStateNormal];
        CGRect button_rect = button_content.frame;
        button_rect.size = button_size;
        [button_content setFrame:CGRectMake(button_content.frame.origin.x, button_content.frame.origin.y, button_content.frame.size.width, button_rect.size.height + 41)];
        [SKUIUtils didLoadImageNotCached:@"imageVIew_orderContent.png" inButton:button_content withState:UIControlStateNormal];
        [button_content setTitle:lawyer.string_content forState:UIControlStateNormal];
     
        if(button_content.frame.size.height > 58)
        {
            [button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        else
        {
            [button_content setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 200)];
        }
        
        UIButton *button_portrait = (UIButton *)[cell viewWithTag:20];
        [button_portrait setImageWithURL:[NSURL URLWithString:lawyer.string_jobpic ] forState:UIControlStateNormal];
        
        UILabel *label_lawyerName = (UILabel *)[cell viewWithTag:21];
        label_lawyerName.text = lawyer.string_username;
        
        UILabel *label_lawyerNumber = (UILabel *)[cell viewWithTag:22];
        label_lawyerNumber.text = [NSString stringWithFormat:@"执业证号 : %@", lawyer.string_jobno];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cell_size;
    if(indexPath.row == 0)
    {
        LGModel_order *order = [_array_dataDetail objectAtIndex:indexPath.row];
        cell_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        return cell_size.height + 190;
    }
    
    id object = [_array_dataDetail objectAtIndex:indexPath.row];
    if([object isKindOfClass:[LGModel_order class]])
    {
        LGModel_order *order = [_array_dataDetail objectAtIndex:indexPath.row];
        cell_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        return cell_size.height + 40 + 50;
    }
    else
    {
        LGModel_lawyer *lawyer = [_array_dataDetail objectAtIndex:indexPath.row];
        cell_size = [lawyer.string_content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
        return cell_size.height + 40 + 110;
    }
}

@end
