//
//  LGViewController.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-2.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGViewController.h"
#import "SKSlideNavigationViewController.h"
#import "LGZmlNavigationController.h"

@interface LGViewController ()

@end

@implementation LGViewController



- (id)initWithNavigationController:(SKSlideNavigationViewController *)navigationController_return
{
    self = [super init];
    if(self)
    {
        _navigationController_return = navigationController_return;
        //UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _navigationController_return.navigationBar.frame.size.height)];
        //[view_title setBackgroundColor:[UIColor blueColor]];
        //[self.view addSubview:view_title];
    }
    return self;
}

- (id)initWithNavigationZController:(LGZmlNavigationController *)navigationController_return_z
{
    self = [super init];
    if(self)
    {
        _navigationController_return_z = navigationController_return_z;
        //UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _navigationController_return.navigationBar.frame.size.height)];
        //[view_title setBackgroundColor:[UIColor blueColor]];
        //[self.view addSubview:view_title];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        IOS7_STATEBAR;
        [self.view setBackgroundColor:[UIColor blackColor]];
        // Custom initialization
    }
    return self;
}

- (void)setTitleView
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _navigationController_return.navigationBar.frame.size.height)];
    if(IOS7_VERSION)
    {
        [view_title setFrame:CGRectMake(0, 0, self.view.frame.size.width, _navigationController_return.navigationBar.frame.size.height)];
    }
    [view_title setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:view_title];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController
{
    if(_navigationController_return_z)
    {
        [_navigationController_return_z pushViewController:viewController animated:YES];
    }
    else
    {
        [_navigationController_return pushViewController:viewController animated:YES];
    }
}

- (void)popViewController
{
    if(_navigationController_return_z)
    {
        [_navigationController_return_z popViewControllerAnimated:YES];
    }
    else
    {
        [_navigationController_return popViewControllerAnimated:YES];
    }
}



@end
