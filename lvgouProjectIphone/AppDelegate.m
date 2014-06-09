//
//  AppDelegate.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-2.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "AppDelegate.h"
#import "SKSlideNavigationViewController.h"
#import "LGViewController.h"
#import "LGZmlNavigationController.h"
#import "SKUIUtils.h"
#import "LGBeginAnimetionViewController.h"
#import "LGNetworking.h"
#import "LGModel_mainData.h"
#import "LGModel_kindData.h"
#import "SDImageCache.h"
#import "LGModel_userOrder.h"
#import "LGDataBase.h"
#import "BPush.h"
#import <sys/utsname.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    LGBeginAnimetionViewController *beginViewController = [[LGBeginAnimetionViewController alloc] init];
    [_window setRootViewController:beginViewController];
    [self.window makeKeyAndVisible];
    
    //NSMutableArray *array_tmp = [NSMutableArray arrayWithObjects:@"3",@"89",nil];
    //[LGNetworking sendIconCountToService:array_tmp];
    
    /**注册消息通知设备**/
    [BPush setupChannel:launchOptions];
    [self installPushConfigureWithApplication:application];
    
    //[self playAnimationDurationInBegin];
    //[beginViewController openViewFromPush];
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            [beginViewController openViewFromPush];
            //[beginViewController ]
            /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知"
             message:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容"
             delegate:nil
             cancelButtonTitle:@"知道了"
             otherButtonTitles:nil, nil];
             [alert show];*/
        }
    }
  
    return YES;
}


/**
 播放启动页动画
 **/
#pragma mark - 播放启动页动画 -
- (void)playAnimationDurationInBegin
{
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].currentMode.size.width/2, [UIScreen mainScreen].currentMode.size.height/2)];
    if(iPhone5)
    {
        splashView.image = [SKUIUtils didLoadImageNotCached:@"Default-568h@2x.png"];
    }
    else
    {
        splashView.image = [SKUIUtils didLoadImageNotCached:@"Default@2x.png"];
    }
    
    //splashView.image = [UIImage imageNamed:@"Default.png"];
    //[self.window addSubview:splashView];
    //[self.window bringSubviewToFront:splashView];
    
    /*[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-160, -281, 640, 1136);
    [UIView commitAnimations];*/
}

/**
 获取页面view
 **/
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //NSString *string_pushCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushCount"];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString *string_useId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if(string_useId)
    {
        [LGNetworking getIconCountFromService:string_useId];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 注册推送
 **/
#pragma mark - 注册推送 -
- (void)installPushConfigureWithApplication:(UIApplication *)application
{
    [BPush setDelegate:self];
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|
      UIRemoteNotificationTypeSound|
      UIRemoteNotificationTypeAlert)];
}

/**
 获取令牌
 **/
- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //NSLog(@"设备令牌:%@",deviceToken);
    NSString *tokeStr = [NSString stringWithFormat:@"%@",deviceToken];
    if ([tokeStr length] == 0)
    {
        NSLog(@"获取token为空");
        return;
    }
    else
    {
        NSString *string_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        if(!string_token || [string_token length] == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:tokeStr forKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [BPush registerDeviceToken:deviceToken];
            [BPush bindChannel];
            NSLog(@"未绑定设备,绑定百度。。。");
        }
        else
        {
            if([string_token isEqualToString:tokeStr])
            {
                NSLog(@"未变化");
            }
            else
            {
                NSLog(@"token发生变化,重新绑定百度。。。");
                [BPush registerDeviceToken:deviceToken];
                [BPush bindChannel];
            }
        }
    }
}

- (void)application:(UIApplication*)application
didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"获得令牌失败: %@", error);
}

/**
 查看推送消息
 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notifacation_sendMessageWhenOnline" object:nil];
}

/*
 百度回调
 可以在其它时机调用,只有在该方法返回(通过 onMethod:response:
 回调)绑定成功时,app 才能接收到 Push 消息。一个 app 绑定成功至少一次即可(如 果 access token 变更请重新绑定)。
 */
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        if(!userid || [userid length] == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceToken"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"baiduUserid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
