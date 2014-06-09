//
//  LGTabBarView.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-18.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGTabBarView.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGNetworking.h"

@implementation LGTabBarView

#pragma mark - 初始化Tab -
/**
 *  初始化Tab
 *
 *  @param frame 位置信息
 *
 *  @return 无
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (IOS7_VERSION)
        {
            CRNavigationBar *bar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
            [self addSubview:bar];
            UIColor *tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
            bar.barTintColor = tintColor;
        }
        
        if([UIScreen mainScreen].currentMode.size.width == 320)
        {
            [self setFrame:CGRectMake(0, [UIScreen mainScreen].currentMode.size.height - 69, [UIScreen mainScreen].currentMode.size.width, 49)];
        }
        else
        {
            [self setFrame:CGRectMake(0, [UIScreen mainScreen].currentMode.size.height/2 - 69, [UIScreen mainScreen].currentMode.size.width/2, 49)];
        }
        IOS7(self);
        
        UIImageView *imageView_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if(IOS7_VERSION)
        {
            [imageView_background setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            [imageView_background setBackgroundColor:[UIColor colorWithWhite:0.05 alpha:0.8]];
        }
        [self addSubview:imageView_background];
        
        UIButton *button_first = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *button_two = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *button_three = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button_first setFrame:CGRectMake(0, 0, 106, self.frame.size.height)];
        [button_two setFrame:CGRectMake(button_first.frame.origin.x + button_first.frame.size.width, button_first.frame.origin.y, button_first.frame.size.width, button_first.frame.size.height)];
        [button_three setFrame:CGRectMake(button_two.frame.origin.x + button_two.frame.size.width, button_two.frame.origin.y, button_first.frame.size.width, button_two.frame.size.height)];
        
        [SKUIUtils didLoadImageNotCached:@"image10.png" inButton:button_first withState:UIControlStateNormal];
        [SKUIUtils didLoadImageNotCached:@"image10pressed.png" inButton:button_first withState:UIControlStateHighlighted];
        [SKUIUtils didLoadImageNotCached:@"image11pressed.png" inButton:button_two withState:UIControlStateNormal];
        [SKUIUtils didLoadImageNotCached:@"image11.png" inButton:button_two withState:UIControlStateHighlighted];
        [SKUIUtils didLoadImageNotCached:@"image12.png" inButton:button_three withState:UIControlStateNormal];
        [SKUIUtils didLoadImageNotCached:@"image12pressed.png" inButton:button_three withState:UIControlStateHighlighted];
        
        //[button_first setShowsTouchWhenHighlighted:YES];
        //[button_two setShowsTouchWhenHighlighted:YES];
        //[button_three setShowsTouchWhenHighlighted:YES];
        
        [button_first setTag:10];
        [button_two setTag:11];
        [button_three setTag:12];
        _integer_before = button_two.tag;
        
        
        UIImageView *imageView_animation = [[UIImageView alloc] initWithFrame:button_two.frame];
        [SKUIUtils didLoadImageNotCached:@"animetionRound.png" inImageView:imageView_animation];
        [imageView_animation setTag:20];
        [self addSubview:imageView_animation];
        
        [button_first addTarget:self action:@selector(didClickButton_tab:) forControlEvents:UIControlEventTouchUpInside];
        [button_two addTarget:self action:@selector(didClickButton_tab:) forControlEvents:UIControlEventTouchUpInside];
        [button_three addTarget:self action:@selector(didClickButton_tab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button_first];
        [self addSubview:button_two];
        [self addSubview:button_three];
        
        UIImageView *imageView_count = [[UIImageView alloc] initWithFrame:CGRectMake(58, 4, 15, 15)];
        [SKUIUtils didLoadImageNotCached:@"image_count.png" inImageView:imageView_count];
        [imageView_count setTag:30];
        [button_three addSubview:imageView_count];
        [imageView_count setHidden:YES];
        
        UILabel *label_count = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 15, 15)];
        [label_count setTextAlignment:NSTextAlignmentCenter];
        [label_count setBackgroundColor:[UIColor clearColor]];
        [imageView_count addSubview:label_count];
        [label_count setFont:[UIFont systemFontOfSize:11.0f]];
        [label_count setTextColor:[UIColor whiteColor]];
        [label_count setTag:31];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTabCountNotification:) name:@"Notifacation_getIconCount" object:nil];
        NSString *string_useId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if(string_useId)
        {
            [LGNetworking getIconCountFromService:string_useId];
        }
        else
        {
            [imageView_count setHidden:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageToBar) name:@"Notifacation_sendMessageWhenOnline" object:nil];
        
        // Initialization code
    }
    return self;
}

#pragma mark - 点击Tab -
/**
 *  点击Tab
 *
 *  @param button_tag 标签值
 */
- (void)didClickButton_tab:(UIButton *)button_tag
{
    _integer_now = button_tag.tag;
    UIImageView *imageView_animetion = (UIImageView *)[self viewWithTag:20];
    //imageView_animetion.alpha = 1.0;
    UIButton *button_before = (UIButton *)[self viewWithTag:_integer_before];
    [SKUIUtils didLoadImageNotCached:[NSString stringWithFormat:@"image%d.png",_integer_before] inButton:button_before withState:UIControlStateNormal];
    [SKUIUtils didLoadImageNotCached:[NSString stringWithFormat:@"image%dpressed.png",_integer_before] inButton:button_before withState:UIControlStateHighlighted];
    
    [SKUIUtils didLoadImageNotCached:[NSString stringWithFormat:@"image%dpressed.png",_integer_now] inButton:button_tag withState:UIControlStateNormal];
    [SKUIUtils didLoadImageNotCached:[NSString stringWithFormat:@"image%d.png",_integer_now] inButton:button_tag withState:UIControlStateHighlighted];
    
    [UIView animateWithDuration:0.2f animations:
     ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [imageView_animetion setCenter:button_tag.center];
        [UIView commitAnimations];
     }completion:^(BOOL finish){if(finish){
         [UIView animateWithDuration:1.5f animations:^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self cache:NO];
                imageView_animetion.alpha = 0.0;
                imageView_animetion.frame = CGRectMake(imageView_animetion.frame.origin.x- 40, imageView_animetion.frame.origin.y - 15, imageView_animetion.frame.size.width + 85 , imageView_animetion.frame.size.height + 40);
              [UIView commitAnimations];
         } completion:^(BOOL finish)
         {
             [UIView animateWithDuration:0.5 animations:^{
                 imageView_animetion.alpha = 1.0;
                 imageView_animetion.frame = CGRectMake(imageView_animetion.frame.origin.x + 41, imageView_animetion.frame.origin.y + 15, imageView_animetion.frame.size.width - 85, imageView_animetion.frame.size.height - 40);}];
         }];
        }}];
   
    _integer_before = _integer_now;
    [_delegate delegate_didClickButton_tab:_integer_now - 10];
    //NSLog(@"%d",button_tag.tag);
}

#pragma mark - 条数通知 -
/**
 *  条数通知
 *
 *  @param notification 通知信息
 */
- (void)receiveTabCountNotification:(NSNotification *)notification
{
    NSString *string_count;
    if([[notification object] isKindOfClass:[NSMutableArray class]])
    {
        NSString *count_object = [(NSMutableArray *)[notification object] objectAtIndex:0];
        UILabel *label_count = (UILabel *)[self viewWithTag:31];
        int count = [label_count.text intValue] - [count_object intValue];
        string_count = [NSString stringWithFormat:@"%d",count];
    }
    else
    {
        string_count = (NSString *)[notification object];
    }
    
    if([string_count isEqualToString:@"error"])
    {
        if([string_count isEqualToString:@"0"])
        {
            UIImageView *imageView_count = (UIImageView *)[self viewWithTag:30];
            [imageView_count setHidden:YES];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
    else
    {
        if([string_count isEqualToString:@"0"])
        {
            UIImageView *imageView_count = (UIImageView *)[self viewWithTag:30];
            [imageView_count setHidden:YES];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        else
        {
            if([string_count intValue] < 0)
            {
                UIImageView *imageView_count = (UIImageView *)[self viewWithTag:30];
                [imageView_count setHidden:YES];
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
            else
            {
                UIImageView *imageView_count = (UIImageView *)[self viewWithTag:30];
                [imageView_count setHidden:NO];
                UILabel *label_count = (UILabel *)[self viewWithTag:31];
                [label_count setText:string_count];
                [UIApplication sharedApplication].applicationIconBadgeNumber = [string_count    intValue];
            }
        }

        if([string_count intValue] >= 0)
        {
            NSString *string_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            [LGNetworking sendIconCountToService:[NSMutableArray arrayWithObjects:string_count,string_uid,nil]];
        }
    }
}

#pragma mark - 推送开开启程序 -
/**
 *  推送开开启程序
 */
- (void)pushMessageToBar
{
    UIButton *button_three = (UIButton *)[self viewWithTag:12];
    [button_three setTag:12];
    [self didClickButton_tab:button_three];
}



@end
