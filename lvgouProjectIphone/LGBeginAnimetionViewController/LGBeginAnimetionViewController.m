//
//  LGBeginAnimetionViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-10.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGBeginAnimetionViewController.h"
#import "SKUIUtils.h"
#import "UIViewController+RECurtainViewController.h"
#import "LGZmlNavigationController.h"
//#import "LGParallaxViewController.h"
#import "LGMainViewController.h"
#import "CRNavigationBar.h"

@interface LGBeginAnimetionViewController ()

@end

@implementation LGBeginAnimetionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        IOS7_STATEBAR;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self installBeginView];
    //[self installBeginView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 状态栏控制 -
/**状态栏控制**/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

/**
 初始化启动页
 **/
#pragma mark - 初始化启动页 -
- (void)installBeginView
{
    UIImageView *splashView;
    if(IOS7_VERSION)
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    }
    
    if([UIScreen mainScreen].currentMode.size.width == 320)
    {
        splashView.image = [SKUIUtils didLoadImageNotCached:@"Default@2x.png"];
    }
    else
    {
        splashView.image = [SKUIUtils didLoadImageNotCached:@"Default-568h@2x.png"];
    }
    [self pushViewControllerWith:splashView];
}

- (void)pushViewControllerWith:(UIView *)view_portrait
{
    LGMainViewController *mainViewController = [[LGMainViewController alloc] init];
    //LGParallaxViewController *parallaxViewController = [[LGParallaxViewController alloc] init];
    LGZmlNavigationController *navigationController_root_z = [[LGZmlNavigationController alloc] initWithRootViewController:mainViewController];
    [mainViewController setNavigationController_return_z:navigationController_root_z];
    
    [self curtainRevealViewController:navigationController_root_z transitionStyle:RECurtainTransitionHorizontal withView:view_portrait];
    
    _mainViewController = mainViewController;
}

#pragma mark - 从推送启动 -
/**
 *  从推送启动
 */
- (void)openViewFromPush
{
    [_mainViewController pushMessageToMain];
}



@end
