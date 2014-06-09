//
//  LGRqusetViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-3.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGRqusetViewController.h"
#import "CRNavigationBar.h"
#import "LGZmlNavigationController.h"
#import "SKUIUtils.h"
#import "LGLocationViewController.h"
#import "LGModel_userOrder.h"
#import "LGNetworking.h"

@interface LGRqusetViewController ()

@end

@implementation LGRqusetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        LGModel_userOrder *model_userOrder = [[LGModel_userOrder alloc] init];
        _model_order = model_userOrder;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(248, 248, 248)];
    [self installBodyView_request];
    [self installTitleView_request];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
   [_textView_content becomeFirstResponder];
}

/**
 初始化titleView
 **/
#pragma mark - titleView -
- (void)installTitleView_request
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    [self.view addSubview:view_title];
    [self.navigationController_return_z setCanDragBack:NO];
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
    
    UIImageView *imageView_title = [[UIImageView alloc] initWithFrame:CGRectMake(195/2, 30, 125, 21)];
    [view_title addSubview:imageView_title];
    [SKUIUtils didLoadImageNotCached:@"lvgouWen_image.png" inImageView:imageView_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_request) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

/**
 点击返回按钮
 **/
#pragma mark - 点击返回按钮 -
- (void)didClickButtonBack_request
{
    [self.navigationController_return_z popToRootViewControllerAnimated:YES];
    NSString *string_useId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    [LGNetworking getIconCountFromService:string_useId];
}

#pragma mark - 初始化列表 -
/**
 *  初始化列表
 */
- (void)installBodyView_request
{
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [tabelView_body setBackgroundColor:[UIColor clearColor]];
    [tabelView_body setDelegate:self];
    [tabelView_body setDataSource:self];
    [self.view addSubview:tabelView_body];
    [tabelView_body setBackgroundColor:RGB(246, 246, 246)];
    [tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FirstRequest_cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *imageView_back = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10 + 40, 310, 170)];
        [SKUIUtils didLoadImageNotCached:@"imageBack_request.png" inImageView:imageView_back];
        [cell addSubview:imageView_back];
        
        UITextView *text_Content = [[UITextView alloc] initWithFrame:CGRectMake(10 ,10 + 40, 300, 170)];
        [text_Content setBackgroundColor:[UIColor clearColor]];
        [text_Content setTextColor:[UIColor grayColor]];
        [text_Content setTintColor:[UIColor blackColor]];
        [text_Content setFont:[UIFont systemFontOfSize:15.0f]];
        [text_Content setText:@"请详细描述事件经过，以及你想咨询的具体问题。"];
        text_Content.autocorrectionType = UITextAutocorrectionTypeNo;
        text_Content.autocapitalizationType = UIKeyboardAppearanceDefault;
        text_Content.keyboardAppearance = UIKeyboardAppearanceDefault;
        [cell addSubview:text_Content];
        [text_Content setDelegate:self];
        _textView_content = text_Content;
        
        UIButton *button_next = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_next setFrame:CGRectMake(10, 185 + 40, 295, 31)];
        [SKUIUtils didLoadImageNotCached:@"button_local.png" inButton:button_next withState:UIControlStateNormal];
        [button_next addTarget:self action:@selector(didClickbuttonLocal_request) forControlEvents:UIControlEventTouchUpInside];
        [button_next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:button_next];
        _button_location = button_next;
        
        UIButton *button_finish = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_finish setFrame:CGRectMake(10, button_next.frame.origin.y + button_next.frame.size.height, 300, 33)];
        [SKUIUtils didLoadImageNotCached:@"button_requestFinish.png" inButton:button_finish withState:UIControlStateNormal];
        [button_finish addTarget:self action:@selector(didClickbuttonFinish_request) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button_finish];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 40;
}

/*
 输入框回调
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([textView.text length] == 0 && [text length] == 0)
    {
        [textView setText:@"请详细描述事件经过，以及你想咨询的具体问题。。"];
    }
    else if([textView.text isEqualToString:@"请详细描述事件经过，以及你想咨询的具体问题。"])
    {
        [textView setText:nil];
    }
    return YES;
}

/**
 点击地理位置
 **/
#pragma mark - 点击地理位置 -
- (void)didClickbuttonLocal_request
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveLocationInformation:) name:@"Notification_locationContent" object:nil];
    
    LGLocationViewController *locationViewController = [[LGLocationViewController alloc] initWithNavigationZController:self.navigationController_return_z];
    [self pushViewController:locationViewController];
    //NSLog(@"OK");
}

/*
 接受地理位置回传
 */
- (void)reciveLocationInformation:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_locationContent" object:nil];
    NSMutableArray *array = (NSMutableArray *)[notification object];
    NSString *location;
    if([array count] == 2)
    {
        location = [NSString stringWithFormat:@"%@,%@",[array objectAtIndex:1],[array objectAtIndex:0]];
        _model_order.string_city = [array objectAtIndex:0];
        _model_order.string_province = [array objectAtIndex:1];
    }
    else
    {
        location = [array objectAtIndex:0];
        _model_order.string_city = [array objectAtIndex:0];
        _model_order.string_province = @"";
    }
    [_button_location setBackgroundColor:[UIColor whiteColor]];
    [_button_location setBackgroundImage:nil forState:UIControlStateNormal];
    [_button_location setTitle:location forState:UIControlStateNormal];
}

- (void)didClickbuttonFinish_request
{
    if(!_textView_content.text || [_textView_content.text length] == 0 || [_textView_content.text isEqualToString:@"请详细描述事件经过，以及你想咨询的具体问题。"])
    {
        [SKUIUtils showAlterView:@"内容不能为空" afterTime:1.0f];
        return;
    }
    if(!_model_order.string_city || [_model_order.string_city length] == 0)
    {
        [SKUIUtils showAlterView:@"请选择地区" afterTime:1.0f];
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification_sendQuestion:) name:@"Notifacation_sendQuestion" object:nil];
    _model_order.string_description = _textView_content.text;
    [LGNetworking sendMessageToService:_model_order];
}

#pragma mark - 接收提问回调 -
/**
 *  接收提问回调
 */
- (void)receiveNotification_sendQuestion:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notifacation_sendQuestion" object:nil];
    NSString *string_code = (NSString *)[notification object];
    if([string_code isEqualToString:@"1"])
    {
        [SKUIUtils showAlterView:@"提问成功" afterTime:1.0];
        [self.navigationController_return_z popToRootViewControllerAnimated:YES];
    }
    else
    {
        [SKUIUtils showAlterView:@"发送失败" afterTime:1.0];
    }
}

@end
