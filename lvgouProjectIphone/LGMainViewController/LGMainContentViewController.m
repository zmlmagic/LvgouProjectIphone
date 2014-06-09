//
//  LGMainContentViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 14-1-6.
//  Copyright (c) 2014年 lvgou. All rights reserved.
//

#import "LGMainContentViewController.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGModel_mainData.h"
#import "LGNetworking.h"
#import "UIImageView+WebCache.h"
#import "LGDataBase.h"
#import "UIButton+WebCache.h"


@interface LGMainContentViewController ()

@end

@implementation LGMainContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithIDString:(NSString *)string_id
{
    self = [super init];
    if(self)
    {
        [self.view setBackgroundColor:RGB(246, 246, 246)];
        [LGNetworking getDetail_fromRequestMainWith:string_id];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveDetailData_mainContent:) name:@"Notification_mainDetailData" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SKUIUtils showHUDWithContent:@"正在努力加载..." inCoverView:self.view];
    [self installTitleView_mainContent];
    //[SKUIUtils showHUD:@"正在努力加载..." afterTime:60.0f];
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
- (void)installTitleView_mainContent
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
    [label_title setText:@"详情"];
    [view_title addSubview:label_title];
    
    UIButton *button_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_back setFrame:CGRectMake(7, 30, 41, 21)];
    [button_back addTarget:self action:@selector(didClickButtonBack_mainContent) forControlEvents:UIControlEventTouchUpInside];
    [SKUIUtils didLoadImageNotCached:@"buttonBack_icon.png" inButton:button_back withState:UIControlStateNormal];
    [view_title addSubview:button_back];
}

#pragma mark - 返回按钮回调 -
/**
 返回按钮回调
 **/
- (void)didClickButtonBack_mainContent
{
    [SKUIUtils dismissCurrentHUD];
    [self popViewController];
}


#pragma mark - 数据请求消息回调 -
/*
 数据请求消息回调
 */
- (void)didReciveDetailData_mainContent:(NSNotification *)notification
{
    [SKUIUtils dismissCurrentHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_mainDetailData" object:nil];
    LGModel_mainData *detail = [notification object];
    _mainContent = detail;
    
    [self installbodyView_mainContent];
}

#pragma mark - 初始化列表 -
/*
 初始化列表
 */
- (void)installbodyView_mainContent
{
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [tabelView_body setBackgroundColor:[UIColor clearColor]];
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mainContent_cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *string_title = [NSString stringWithFormat:@"<p>&nbsp;</p><p>&nbsp;</p><p style=\"text-align:center;\" class=\"MsoNormal\"><span style=\"font-family:SimSun;color:black;font-size:18px;\">%@</span></p>",_mainContent.string_title];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImageWithURL:[NSURL URLWithString:@"http://img.itxinwen.com/2011/0501/20110501090727642.jpg"] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            NSString *string_key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:@"http://img.itxinwen.com/2011/0501/20110501090727642.jpg"]];
            NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:string_key];
            NSLog(@"%@",path);
        }];
       
        //NSString *imageFile = @"file:///Users/lvgou/Library/Application Support/iPhone Simulator/7.0.3/Applications/70ADD2F5-7859-45FA-AC12-D40079BFF3EA/Library/Caches/com.hackemist.SDWebImageCache.default/644624c75372d358dde7c7580f19cc87.png";
        
        //NSString *imageFile = [[NSString alloc]initWithFormat:@"file://%@/%@", [[NSBundle mainBundle] bundlePath],@"tmp2.png"];
        //NSLog(@"%@",imageFile);
        //_mainContent.string_imageUrl = imageFile;
        
        if([_mainContent.string_imageUrl length] != 0)
        {
            NSString *string_path = [NSString stringWithFormat:@"<img src= \"%@\" alt=\"\" border=\"\" style=\"max-width:295px\"/>",_mainContent.string_imageUrl];
            if([_mainContent.string_content length] != 0)
            {
                _mainContent.string_content = [string_path stringByAppendingString:_mainContent.string_content];
            }
            else
            {
                _mainContent.string_content = string_path;
            }
        }
        NSLog(@"%@",_mainContent.string_content);
        /*
         去白块
         */
        _mainContent.string_content =[_mainContent.string_content stringByReplacingOccurrencesOfString:@"white" withString:@""];
        _mainContent.string_content =[_mainContent.string_content stringByReplacingOccurrencesOfString:@"#ffffff" withString:@""];
        _mainContent.string_content =[_mainContent.string_content stringByReplacingOccurrencesOfString:@"#FFFFFF" withString:@""];
        _mainContent.string_content =[_mainContent.string_content stringByReplacingOccurrencesOfString:@"#333333" withString:@""];
        
        NSString *string_content = [string_title stringByAppendingString:_mainContent.string_content];
        
        UIWebView *webContent = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, 310, self.view.frame.size.height)];
        for (UIView *aView in [webContent subviews])
        {
            if ([aView isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
                
                for (UIView *shadowView in aView.subviews)
                {
                    
                    if ([shadowView isKindOfClass:[UIImageView class]])
                    {
                        shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                    } 
                } 
            } 
        }
        [webContent setBackgroundColor:[UIColor clearColor]];
        [webContent loadHTMLString:string_content baseURL:nil];
        NSString *js = @"window.onload = function(){document.body.style.backgroundColor = 'F4F4F4';}";
        [webContent stringByEvaluatingJavaScriptFromString:js];
        [cell addSubview:webContent];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height;
}

@end
