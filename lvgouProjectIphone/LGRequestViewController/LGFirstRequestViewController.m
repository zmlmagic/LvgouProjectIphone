//
//  LGFirstRequestViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-30.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGFirstRequestViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGVerifyPhoneViewController.h"
#import "LGZmlNavigationController.h"
#import "LGNetworking.h"

@interface LGFirstRequestViewController ()

@end

@implementation LGFirstRequestViewController

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
    [self installbodyView_requestFirst];
    [self installTitleView_resquestFirst];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController_return_z setCanDragBack:NO];
    [_textField_phone becomeFirstResponder];
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
- (void)installTitleView_resquestFirst
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
    [button_back addTarget:self action:@selector(didClickButtonBack_firstRequest) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

/**
 返回按钮回调
 **/
#pragma mark - 返回按钮回调 -
- (void)didClickButtonBack_firstRequest
{
    [self popViewController];
}

- (void)installbodyView_requestFirst
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
        
        UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, self.view.frame.size.width - 20, 60)];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextColor:[UIColor grayColor]];
        [label_title setNumberOfLines:2];
        [label_title setFont:[UIFont systemFontOfSize:15.0f]];
        [label_title setTextAlignment:NSTextAlignmentLeft];
        [label_title setText:@"为了保证服务质量，首次提问的用户需要验证手机号。"];
        [cell addSubview:label_title];
        
        UITextField *textNumber = [[UITextField alloc] initWithFrame:CGRectMake(10 ,label_title.frame.origin.y + label_title.frame.size.height + 5, 220, 36)];
        [textNumber setBackgroundColor:[UIColor whiteColor]];
        [textNumber setTextColor:[UIColor blackColor]];
        [textNumber setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textNumber setFont:[UIFont systemFontOfSize:15.0f]];
        [textNumber setPlaceholder:@" 请输入您的手机号"];
        textNumber.autocorrectionType = UITextAutocorrectionTypeNo;
        textNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textNumber setKeyboardType:UIKeyboardTypeNumberPad];
        [textNumber setTag:50];
        [cell addSubview:textNumber];
        _textField_phone = textNumber;
        
        UIButton *button_next = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_next setFrame:CGRectMake(textNumber.frame.origin.x + textNumber.frame.size.width + 5, textNumber.frame.origin.y, 80, 36)];
        [SKUIUtils didLoadImageNotCached:@"button_next.png" inButton:button_next withState:UIControlStateNormal];
        [button_next addTarget:self action:@selector(didClickbuttonNext_firstRequest) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button_next];
        
        /*double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [textNumber becomeFirstResponder];
                           // code to be executed on the main queue after delay
                       });*/
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 20;
}

- (void)didClickbuttonNext_firstRequest
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:50];
    if([self validateMobile:textField.text])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifacation_sendPhone:) name:@"Notification_sendPhone" object:nil];
        [LGNetworking sendPhoneNumber:textField.text];
    }
    else
    {
        [SKUIUtils showAlterView:@"电话号码无效" afterTime:1.0f];
        [textField becomeFirstResponder];
    }
}

#pragma mark - 接收发送手机号消息 -
/**
 *  接收发送手机号消息
 *
 *  @param notification 消息回调
 */
- (void)receiveNotifacation_sendPhone:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_sendPhone" object:nil];
    NSString *string_message = (NSString *)[notification object];
    if([string_message isEqualToString:@"1"])
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:50];
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"tmpPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LGVerifyPhoneViewController *verifyPhoneView = [[LGVerifyPhoneViewController alloc] initWithNavigationZController:self.navigationController_return_z];
        [self pushViewController:verifyPhoneView];
    }
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"发送失败,请重新发送"
                                                        message:string_message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alter show];
    }
}




/**
 正则验证手机号码
 **/
- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
