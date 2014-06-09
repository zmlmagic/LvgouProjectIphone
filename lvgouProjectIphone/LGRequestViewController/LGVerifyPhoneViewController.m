//
//  LGVerifyPhoneViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-31.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGVerifyPhoneViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGRqusetViewController.h"
#import "LGZmlNavigationController.h"
#import "LGNetworking.h"

@interface LGVerifyPhoneViewController ()

@end

@implementation LGVerifyPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        IOS7_STATEBAR;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    [self installbodyView_verifyPhone];
    [self installTitleView_verifyPhone];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //NSLog(@"dealloc");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimePage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController_return_z setCanDragBack:NO];
    [_textField_verify becomeFirstResponder];
}

#pragma mark - 初始化标题栏 -
/*
 初始化标题栏
 */
- (void)installTitleView_verifyPhone
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    [self.view addSubview:view_title];
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
    [button_back addTarget:self action:@selector(didClickButtonBack_verifyPhone) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

/**
 返回按钮回调
 **/
#pragma mark - 返回按钮回调 -
- (void)didClickButtonBack_verifyPhone
{
    [self popViewController];
}

- (void)installbodyView_verifyPhone
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
        
        UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, self.view.frame.size.width - 10, 60)];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextColor:[UIColor grayColor]];
        [label_title setNumberOfLines:3];
        [label_title setFont:[UIFont systemFontOfSize:15.0f]];
        [label_title setTextAlignment:NSTextAlignmentLeft];
        NSString *string_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpPhone"];
        [label_title setText:[NSString stringWithFormat:@"验证码已通过短信发送至手机:%@，请注意查收。   如果您        内未收到短信,请",string_phone]];
        [cell addSubview:label_title];
        
        UILabel *label_number = [[UILabel alloc] initWithFrame:CGRectMake(160, 29 + 39, 60, 30)];
        [label_number setBackgroundColor:[UIColor clearColor]];
        [label_number setTextColor:RGB(55, 154, 238)];
        [label_number setFont:[UIFont systemFontOfSize:15.0f]];
        [label_number setTextAlignment:NSTextAlignmentLeft];
        [label_number setText:@"30秒"];
        [cell addSubview:label_number];
        _label_countDown = label_number;
        [self startBeginTimeCountDown];
        
        UILabel *label_recive = [[UILabel alloc] initWithFrame:CGRectMake(10, 45 + 39, 100, 30)];
        label_recive.backgroundColor = [UIColor clearColor];
        [label_recive setTextColor:[UIColor grayColor]];
        label_recive.numberOfLines = 3;
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"点击重新发送"]];
        [label_recive setFont:[UIFont systemFontOfSize:15.0f]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        label_recive.attributedText = content;
        [cell addSubview:label_recive];
        _label_recive = label_recive;
        
        UIButton *button_recive = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_recive setFrame:label_recive.frame];
        [button_recive setBackgroundColor:[UIColor clearColor]];
        [button_recive setUserInteractionEnabled:NO];
        [button_recive addTarget:self action:@selector(didClickbuttonRecive_verifyPhone) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button_recive];
        _button_recive = button_recive;
        
        UITextField *textNumber = [[UITextField alloc] initWithFrame:CGRectMake(10 ,label_title.frame.origin.y + label_title.frame.size.height + 10, 220, 36)];
        [textNumber setBackgroundColor:[UIColor whiteColor]];
        [textNumber setTextColor:[UIColor blackColor]];
        [textNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textNumber setFont:[UIFont systemFontOfSize:15.0f]];
        [textNumber setPlaceholder:@" 请输入验证码"];
        textNumber.autocorrectionType = UITextAutocorrectionTypeNo;
        textNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textNumber setKeyboardType:UIKeyboardTypePhonePad];
        [cell addSubview:textNumber];
        _textField_verify = textNumber;
        
        UIButton *button_next = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_next setFrame:CGRectMake(textNumber.frame.origin.x + textNumber.frame.size.width + 5, textNumber.frame.origin.y, 80, 36)];
        [SKUIUtils didLoadImageNotCached:@"button_finish.png" inButton:button_next withState:UIControlStateNormal];
        [button_next addTarget:self action:@selector(didClickbuttonFinish_verifyPhone) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button_next];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [textNumber becomeFirstResponder];
                           // code to be executed on the main queue after delay
                       });
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 20;
}

#pragma mark - 点击重新发送 -
/**
 点击重新发送
 **/
- (void)didClickbuttonRecive_verifyPhone
{
    [_button_recive setUserInteractionEnabled:NO];
    [_label_recive setTextColor:[UIColor grayColor]];
    [self startBeginTimeCountDown];
    
    [SKUIUtils showAlterView:@"已重新发送" afterTime:1.0f];
}

#pragma mark - 开始计时 -
/**
 开始计时
 **/
- (void)startBeginTimeCountDown
{
    _time_countDown = 30;
    NSTimer *timer_count = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    _timer_countDown = timer_count;
}

/**
 开始发送读秒
 **/
#pragma mark - 开始发送读秒 -
- (void)runTimePage
{
    _time_countDown --;
    NSString *string_countDown = [NSString stringWithFormat:@"%d秒",_time_countDown];
    [_label_countDown setText:string_countDown];
    if(_time_countDown == 0)
    {
        [self stopTimePage];
    }
}

#pragma mark - 停止计时器 -
/**
 停止计时器
 **/
- (void)stopTimePage
{
    [_button_recive setUserInteractionEnabled:YES];
    [_label_recive setTextColor:[UIColor blackColor]];
    if(_timer_countDown)
    {
        [_timer_countDown invalidate];
        _timer_countDown = nil;
    }
}

#pragma mark - 验证手机号 -
/**
 *  验证手机号
 */
- (void)didClickbuttonFinish_verifyPhone
{
    if([_textField_verify.text length] != 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyPhoneNotification:) name:@"Notification_verifyPhone" object:nil];
        NSString *string_phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpPhone"];
        NSString *string_code = _textField_verify.text;
        NSString *string_baidu = [[NSUserDefaults standardUserDefaults] objectForKey:@"baiduUserid"];
        NSMutableArray *array_data = [NSMutableArray arrayWithObjects:string_phone,string_code,string_baidu,nil];

        [LGNetworking verifyPhoneNumberWithDataArray:array_data];
    }
    else
    {
        [SKUIUtils showAlterView:@"验证码不能为空" afterTime:1.0f];
        [_textField_verify becomeFirstResponder];
    }
    
}

#pragma mark - 验证手机消息回调 -
/**
 *  验证手机消息回调
 */
- (void)verifyPhoneNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_verifyPhone" object:nil];
    NSString *string_result = (NSString *)[notification object];
    if([string_result isEqualToString:@"1"])
    {
        LGRqusetViewController *request = [[LGRqusetViewController alloc] initWithNavigationZController:self.navigationController_return_z];
        [self pushViewController:request];
    }
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"发送失败,请重新发送" message:string_result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
}


@end
