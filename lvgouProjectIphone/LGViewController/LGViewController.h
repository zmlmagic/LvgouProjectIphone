//
//  LGViewController.h
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-2.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKSlideNavigationViewController;
@class LGZmlNavigationController;

@interface LGViewController : UIViewController

@property (assign , nonatomic) SKSlideNavigationViewController *navigationController_return;
@property (assign , nonatomic) LGZmlNavigationController *navigationController_return_z;

- (id)initWithNavigationController:(SKSlideNavigationViewController *)navigationController_return;
- (id)initWithNavigationZController:(LGZmlNavigationController *)navigationController_return_z;

- (void)setTitleView;

- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

@end
