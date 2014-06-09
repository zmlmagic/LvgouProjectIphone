//
//  LGAddQusetionViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-20.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGAddQusetionViewController.h"
#import "LGZmlNavigationController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGNetworking.h"


@interface LGAddQusetionViewController ()

@end

@implementation LGAddQusetionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
                        andQuestion:(LGModel_addQuestion *)model_addQuestion
{
    self = [super init];
    if(self)
    {
        self.navigationController_return_z = navigationController_return_z;
        //LGModel_addQuestion *model_addQuestion = [[LGModel_addQuestion alloc] init];
        _model_addQuestion = model_addQuestion;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(248, 248, 248)];
    [self installBodyView_addRequest];
    [self installTitleView_addRequest];
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


#pragma mark - 初始化titleView -
/**
 *  初始化titleView
 */
- (void)installTitleView_addRequest
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
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 120, 21)];
    [label_title setBackgroundColor:[UIColor clearColor]];
    [label_title setTextColor:[UIColor whiteColor]];
    [label_title setTextAlignment:NSTextAlignmentCenter];
    [label_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
    [label_title setText:@"追问"];
    [view_title addSubview:label_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_addRequest) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

#pragma mark - 点击返回回调 -
/**
 *  点击返回回调
 */
- (void)didClickButtonBack_addRequest
{
    [self popViewController];
}

#pragma mark - 初始化列表 -
/**
 *  初始化列表
 */
- (void)installBodyView_addRequest
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
    static NSString *CellIdentifier = @"addRequest_cell";
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
        [text_Content setText:@"请输入您的问题。"];
        text_Content.autocorrectionType = UITextAutocorrectionTypeNo;
        text_Content.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [cell addSubview:text_Content];
        [text_Content setDelegate:self];
        _textView_content = text_Content;
        
        UIButton *button_finish = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_finish setFrame:CGRectMake(6, 185 + 45, 308, 33)];
        [SKUIUtils didLoadImageNotCached:@"button_addquestFinish.png" inButton:button_finish withState:UIControlStateNormal];
        [button_finish addTarget:self action:@selector(didClickbuttonFinish_addQuest) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button_finish];
        
        /*double delayInSeconds = 0.5;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
         {
         [text_Content becomeFirstResponder];
         // code to be executed on the main queue after delay
         });*/
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 40;
}

#pragma mark - 输入框回调 -
/**
 *  输入框回调
 *
 *  @param textView 输入框对象
 *  @param range    位置长度变化
 *  @param text     输入
 *
 *  @return bool
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([textView.text length] == 0 && [text length] == 0)
    {
        [textView setText:@"请输入您的问题。。"];
    }
    else if([textView.text isEqualToString:@"请输入您的问题。"])
    {
        [textView setText:nil];
    }
    return YES;
}


#pragma mark - 点击追问 -
/**
 *  点击追问
 */
- (void)didClickbuttonFinish_addQuest
{
    [SKUIUtils showAlterView:@"正在发送中..." afterTime:99];
    //Notification_addQuestion
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification_addQuestion:) name:@"Notification_addQuestion" object:nil];
    _model_addQuestion.string_content = _textView_content.text;
    [LGNetworking sendAddQusetionToService:_model_addQuestion];
    //[LGNetworking sendMessageToService:_model_order];
}

#pragma mark - 追问消息回调 -
/**
 *  追问消息回调
 *
 *  @param notification 返回消息
 */
- (void)receiveNotification_addQuestion:(NSNotification *)notification
{
    [SKUIUtils dismissCurrentHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_addQuestion" object:nil];
    NSString *string_result = (NSString *)[notification object];
    if([string_result isEqualToString:@"1"])
    {
        [SKUIUtils showAlterView:@"追问成功" afterTime:1.0];
        [self.navigationController_return_z popToRootViewControllerAnimated:YES];
    }
    else
    {
        [SKUIUtils showAlterView:@"追问失败" afterTime:1.0];
    }
}


@end
