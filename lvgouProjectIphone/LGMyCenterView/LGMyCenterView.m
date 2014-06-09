//
//  LGMyCenterView.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-25.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGMyCenterView.h"
#import "SKUIUtils.h"
#import "CRNavigationBar.h"
#import "LGNetworking.h"
#import "LGModel_order.h"
#import "LGOrderDetailViewController.h"
#import "LGDataBase.h"

/**
 露出背景高度
 **/
static CGFloat const SKParallaxViewDefaultHeight = 138.0f;

/**
 可拉伸程度
 **/
static CGFloat const LGTableMinHeight = 110.0f;


@interface LGMyCenterView () <UIScrollViewDelegate>
@property (nonatomic, assign) UIView *backgroundView;
@property (nonatomic, assign) UIView *foregroundView;
@property (nonatomic, assign) UIScrollView *backgroundScrollView;
@property (nonatomic, assign) UIScrollView *foregroundScrollView;
- (void)updateBackgroundFrame;
- (void)updateForegroundFrame;
- (void)updateContentOffset;
@end


@implementation LGMyCenterView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame andNavigatonControllerZ:(LGZmlNavigationController *)navigationController_return
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [SKUIUtils showHUD:@"正在加载中..." afterTime:60.0f];
        _navigationController_z = navigationController_return;
        [self installView_body];
        [self installViewTitle_center];
        
        NSString *string_userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if(!string_userID || [string_userID length] == 0)
        {
            [SKUIUtils dismissCurrentHUD];
        }
        else
        {
            [self install_dataFromNetworkWithPage:@"1"];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Object Lifecycle
- (void)installViewTitle_center
{
    UIView *view_title = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.frame.size.width, 64)];
    //[view_title setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self addSubview:view_title];
    IOS7(view_title);
    
    if(IOS7_VERSION)
    {
        [view_title setBackgroundColor:[UIColor clearColor]];
        CRNavigationBar *bar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(view_title.frame.origin.x, 0, view_title.frame.size.width, view_title.frame.size.height)];
        [view_title addSubview:bar];
        UIColor *tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        bar.barTintColor = tintColor;
    }
    else
    {
        [view_title setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    }
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, 30)];
    [label_title setBackgroundColor:[UIColor clearColor]];
    [label_title setTextColor:[UIColor whiteColor]];
    [label_title setTextAlignment:NSTextAlignmentCenter];
    [label_title setFont:[UIFont systemFontOfSize:20.0f]];
    [view_title addSubview:label_title];
    [label_title setText:@"我的咨询"];
}

#pragma mark - 获取订单列表 -
/**
 获取订单列表
 **/
- (void)install_dataFromNetworkWithPage:(NSString *)string_page
{
    NSString *string_userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if(string_userID)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataFromNetwork:) name:@"Notification_getOrderList" object:nil];
        [LGNetworking getOrderListWithID:string_userID andPage:string_page];
    }
    else
    {
        
    }
}

#pragma mark - 列表数据回调 -
/**
 列表数据回调
 **/
- (void)didReceiveDataFromNetwork:(NSNotification *)notification
{
    [SKUIUtils dismissCurrentHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_getOrderList" object:nil];
    if([[notification object] isKindOfClass:[NSString class]])
    {
        NSLog(@"%@",[notification object]);
    }
    else if([[notification object] isKindOfClass:[NSMutableArray class]])
    {
        _array_data = (NSMutableArray *)[notification object];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            float height = 0.0;
            for (int i = 0; i < [_array_data count]; i++)
            {
                LGModel_order *order = [_array_data objectAtIndex:i];
                CGSize cell_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
                height = height + cell_size.height + 35;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_foregroundView setFrame:CGRectMake(_foregroundView.frame.origin.x, _foregroundView.frame.origin.y, _foregroundView.frame.size.width, _foregroundView.frame.size.height + height )];
                //[self updateForegroundFrame];
                self.foregroundScrollView.contentSize =
                CGSizeMake(self.foregroundView.frame.size.width,
                           self.foregroundView.frame.size.height + self.backgroundHeight - LGTableMinHeight);
                [(UITableView *)_foregroundView reloadData];
 
            });  
        });
    }
}


#pragma mark - 初始化body -
/**
 初始化body
 **/
- (void)installView_body
{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    [SKUIUtils didLoadImageNotCached:@"image_myCenterBack.png" inImageView:backgroundImageView];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITableView *table_info = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568 - SKParallaxViewDefaultHeight) style:UITableViewStylePlain];
    [table_info setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [table_info setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [table_info setScrollEnabled:NO];
    table_info.delegate = self;
    table_info.dataSource = self;
    _foregroundView = table_info;
    _backgroundView = backgroundImageView;
    
    UIScrollView *scrollView_background  = [[UIScrollView alloc] init];
    _backgroundScrollView = scrollView_background;
    _backgroundScrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.showsVerticalScrollIndicator = NO;
    [_backgroundScrollView addSubview:_backgroundView];
    [self addSubview:_backgroundScrollView];
    
    UIScrollView *scrollView_foreground = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    _foregroundScrollView = scrollView_foreground;
    _foregroundScrollView.backgroundColor = [UIColor clearColor];
    _foregroundScrollView.delegate = self;
    _foregroundScrollView.showsHorizontalScrollIndicator = NO;
    _foregroundScrollView.showsVerticalScrollIndicator = NO;
    [_foregroundScrollView addSubview:_foregroundView];
    [self addSubview:_foregroundScrollView];
    [self install_backgroundView];
    
    _foregroundScrollView.contentSize = CGSizeMake(self.bounds.size.width, 660);
}

#pragma mark - 初始化用户部分 -
/**
 初始化用户部分
 **/
-(void)install_backgroundView
{
    UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(22, 73, 276, 60)];
    if(!IOS7_VERSION)
    {
        [view_back setFrame:CGRectMake(view_back.frame.origin.x, view_back.frame.origin.y - 10, view_back.frame.size.width, view_back.frame.size.height)];
    }
    [view_back setBackgroundColor:[UIColor whiteColor]];
    [_foregroundScrollView addSubview:view_back];
    
    UILabel *label_without = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, view_back.frame.size.width, 30)];
    [label_without setBackgroundColor:[UIColor clearColor]];
    [label_without setTextColor:[UIColor blackColor]];
    [label_without setTextAlignment:NSTextAlignmentCenter];
    [label_without setFont:[UIFont systemFontOfSize:15.0f]];
    NSString *string_userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    if(!string_userPhone || [string_userPhone length] == 0)
    {
        [label_without setText:@"尚未提问"];
    }
    else
    {
        UIImageView *imageView_portrait = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [SKUIUtils didLoadImageNotCached:@"image_portait.png" inImageView:imageView_portrait];
        [view_back addSubview:imageView_portrait];
        label_without.text = [NSString stringWithFormat:@"用户名: %@",string_userPhone];
    }
    [view_back addSubview:label_without];
    
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view_header = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 5, 320, 60)];
        view_header.backgroundColor = [UIColor clearColor];
		view_header.delegate = self;
		[_foregroundScrollView addSubview:view_header];
		_refreshHeaderView = view_header;
	}
	//  update the last update date
	//
    //[_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark NSObject Overrides
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.scrollViewDelegate respondsToSelector:[anInvocation selector]])
    {
        [anInvocation invokeWithTarget:self.scrollViewDelegate];
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([super respondsToSelector:aSelector] ||
            [self.scrollViewDelegate respondsToSelector:aSelector]);
}


#pragma mark - UIView Overrides

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateBackgroundFrame];
    [self updateForegroundFrame];
    [self updateContentOffset];
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask
{
    [super setAutoresizingMask:autoresizingMask];
    self.backgroundView.autoresizingMask = autoresizingMask;
    self.backgroundScrollView.autoresizingMask = autoresizingMask;
    self.foregroundView.autoresizingMask = autoresizingMask;
    self.foregroundScrollView.autoresizingMask = autoresizingMask;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Protocol Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    [self updateContentOffset];
    if ([self.scrollViewDelegate respondsToSelector:_cmd])
    {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}


- (void)uploadCellForHeight:(CGFloat)_float
{
    _foregroundView.frame = CGRectMake(_foregroundView.frame.origin.x, _foregroundView.frame.origin.y, _foregroundView.frame.size.width, _foregroundView.frame.size.height + _float);
    
    self.foregroundScrollView.contentSize =
    CGSizeMake(self.foregroundView.frame.size.width,
               self.foregroundView.frame.size.height + self.backgroundHeight);
}

#pragma mark -
#pragma mark Public Interface
- (UIScrollView *)scrollView
{
    return self.foregroundScrollView;
}

- (void)setBackgroundHeight:(CGFloat)backgroundHeight
{
    _backgroundHeight = backgroundHeight;
    [self updateBackgroundFrame];
    [self updateForegroundFrame];
    [self updateContentOffset];
}

#pragma mark -
#pragma mark Internal Methods
- (void)updateBackgroundFrame
{
    self.backgroundScrollView.frame = CGRectMake(0.0f,
                                                 -1.0f,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
    self.backgroundScrollView.contentSize = CGSizeMake(self.frame.size.width,
                                                       self.frame.size.height);
    self.backgroundScrollView.contentOffset	= CGPointZero;
    self.backgroundView.frame =
    CGRectMake(0.0f,
               floorf((self.backgroundHeight - self.backgroundView.frame.size.height)/2),
               self.frame.size.width,
               self.backgroundView.frame.size.height);
}

- (void)updateForegroundFrame
{
    self.foregroundView.frame = CGRectMake(0.0f,
                                           SKParallaxViewDefaultHeight,
                                           self.foregroundView.frame.size.width,
                                           self.foregroundView.frame.size.height);
    self.foregroundScrollView.frame = self.bounds;
    self.foregroundScrollView.contentSize =
    CGSizeMake(self.foregroundView.frame.size.width,
               self.foregroundView.frame.size.height + self.backgroundHeight - LGTableMinHeight);
}

/** 双scroll叠层 视觉差效果调节**/
- (void)updateContentOffset
{
    CGFloat offsetY   = self.foregroundScrollView.contentOffset.y;
    CGFloat threshold = self.backgroundView.frame.size.height - self.backgroundHeight;
    
    if (-offsetY > threshold && offsetY < 0.0f)
    {
        _backgroundView.frame = CGRectMake(0 + offsetY, 25 + offsetY, 320 - offsetY * 2, 201 - offsetY * 2);
        self.backgroundScrollView.contentOffset = CGPointMake(0.0f, floorf(offsetY/2));
    }
    else if (offsetY < 0.0f)
    {
        _backgroundView.frame = CGRectMake(0 + offsetY,  25 + offsetY, 320 - offsetY * 2, 201 - offsetY * 2);
        self.backgroundScrollView.contentOffset = CGPointMake(0.0f, offsetY + floorf(threshold/2));
    }
    else
    {   /** 上推视觉差**/
        self.backgroundScrollView.contentOffset = CGPointMake(0.0f,floorf(offsetY/3.7));
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_array_data)
    {
        return 1;
    }
    return [_array_data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCenterCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *string_userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if(!string_userID || [string_userID length] == 0)
        {
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
            [label_title setTextColor:[UIColor grayColor]];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setTextAlignment:NSTextAlignmentCenter];
            [label_title setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
            [label_title setTag:20];
            [cell addSubview:label_title];
            [label_title setText:@"提问后,律师的回复会出现在这里"];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [tableView setBackgroundColor:[UIColor whiteColor]];
            return cell;
        }
        
        UIButton *button_detail = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_detail setContentEdgeInsets:UIEdgeInsetsMake(1, 10, 25, 220)];
        [button_detail setFrame:CGRectMake(8, 10, 304, 160)];
        [button_detail.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button_detail.titleLabel setNumberOfLines:20];
        [button_detail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[button_detail addTarget:self action:@selector(didClickButton_detail:) forControlEvents:UIControlEventTouchUpInside];
        [button_detail setTag:10];
        [cell addSubview:button_detail];
        
        UIButton *button_time = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_time setTag:11];
        button_time.backgroundColor = [UIColor clearColor];
        [button_time.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button_time.titleLabel setNumberOfLines:99];
        [button_time setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [cell addSubview:button_time];
        
        UIButton *button_recive = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_recive.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [button_recive.titleLabel setNumberOfLines:20];
        [button_recive setTag:12];
        [button_recive addTarget:self action:@selector(didClickLookDetail:) forControlEvents:UIControlEventTouchUpInside];
        [button_recive setTitleColor:RGB(54, 171, 70) forState:UIControlStateNormal];
        [button_recive setTitle:@"查看详情" forState:UIControlStateNormal];
        [cell addSubview:button_recive];
        
        UIImageView *imageView_count = [[UIImageView alloc] initWithFrame:CGRectMake(125, 8, 20, 20)];
        [SKUIUtils didLoadImageNotCached:@"image_count.png" inImageView:imageView_count];
        [imageView_count setTag:13];
        [button_time addSubview:imageView_count];
        
        UILabel *label_count = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 20, 20)];
        [label_count setTextAlignment:NSTextAlignmentCenter];
        [label_count setBackgroundColor:[UIColor clearColor]];
        [imageView_count addSubview:label_count];
        [label_count setFont:[UIFont systemFontOfSize:12.0f]];
        [label_count setTextColor:[UIColor whiteColor]];
        [label_count setTag:14];
    }
    
    LGModel_order *order = [_array_data objectAtIndex:indexPath.row];
    UIButton *button_detail = (UIButton *)[cell viewWithTag:10];
    CGSize button_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
    [button_detail setTitle:order.string_description forState:UIControlStateNormal];
    CGRect button_rect = button_detail.frame;
    button_rect.size = button_size;
    [button_detail setFrame:CGRectMake(button_detail.frame.origin.x, button_detail.frame.origin.y, button_detail.frame.size.width, button_rect.size.height + 41)];

    [SKUIUtils didLoadImageNotCached:@"center_detail.png" inButton:button_detail withState:UIControlStateNormal];
    
    UIButton *button_time = (UIButton *)[cell viewWithTag:11];
    [button_time setFrame:CGRectMake(button_detail.frame.origin.x, button_detail.frame.origin.y + button_detail.frame.size.height - 1, button_detail.frame.size.width/2, 36)];
    [SKUIUtils didLoadImageNotCached:@"center_time.png" inButton:button_time withState:UIControlStateNormal];
    if([order.string_state isEqualToString:@"90"])
    {
        [button_time setTitleColor:RGB(54, 171, 70) forState:UIControlStateNormal];
        NSString *string_time = [SKUIUtils getTimeFromTimeStamp:order.string_updatetime];
        [button_time setTitle:[NSString stringWithFormat:@"律师已回复\n%@",string_time] forState:UIControlStateNormal];
    }
    else
    {
        [button_time setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        NSString *string_time = [SKUIUtils getTimeFromTimeStamp:order.string_updatetime];
        [button_time setTitle:[NSString stringWithFormat:@"等待律师回复\n%@",string_time] forState:UIControlStateNormal];
    }
    //button_time.backgroundColor = [UIColor clearColor];
    button_time.titleLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *button_receive = (UIButton *)[cell viewWithTag:12];
    [button_receive setFrame:CGRectMake(button_time.frame.origin.x + button_time.frame.size.width, button_detail.frame.origin.y + button_detail.frame.size.height - 1, button_detail.frame.size.width/2, 36)];
    [SKUIUtils didLoadImageNotCached:@"center_recive.png" inButton:button_receive withState:UIControlStateNormal];
    
    UIImageView *imageView_count = (UIImageView *)[button_time viewWithTag:13];
    UILabel *label_count = (UILabel *)[imageView_count viewWithTag:14];
    
    NSString *string_localCount = [LGDataBase selectOrderCount:order.string_orderno];
    int count = [order.string_replycount intValue] - [string_localCount intValue];
    if(count == 0)
    {
        imageView_count.hidden = YES;
    }
    else
    {
        imageView_count.hidden = NO;
        label_count.text = [NSString stringWithFormat:@"%d",count];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LGModel_order *order = [_array_data objectAtIndex:indexPath.row];
    CGSize cell_size = [order.string_description sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(300.0f, 600.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return cell_size.height + 85;
}

#pragma mark - 点击查看详情 -
/**
 点击查看详情
 **/
- (void)didClickLookDetail:(UIButton *)button_click
{
    UITableViewCell *cell = [self reciveSuperViewCellWithView:button_click];
    UITableView *tableView = [self reciveSuperViewTableWithView:cell];
    NSIndexPath *index = [tableView indexPathForCell:cell];
    
    LGModel_order *order = [_array_data objectAtIndex:index.row];
    LGOrderDetailViewController *detailController = [[LGOrderDetailViewController alloc] initOrderDetailWithOrder:order andNavigationControllerZ:_navigationController_z];
    [_navigationController_z pushViewController:detailController animated:YES];
    
    UIButton *button_time = (UIButton *)[cell viewWithTag:11];
    UIImageView *imageView_count = (UIImageView *)[button_time viewWithTag:13];
    imageView_count.hidden = YES;
}

- (UITableViewCell *)reciveSuperViewCellWithView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell class]])
        {
            return (UITableViewCell *)nextResponder;
        }
    }
    return nil;
}

- (UITableView *)reciveSuperViewTableWithView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]])
        {
            return (UITableView *)nextResponder;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
/**
 EGORefreshTableHeaderDelegate Methods
 **/
/**
 执行刷新操作
 **/
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self reloadTableViewDataSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doneLoadingTableViewData];
            });
        });
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    //
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Data Source Loading / Reloading Methods -
/**
 Data Source Loading / Reloading Methods
 **/
- (void)reloadTableViewDataSource{
    [self install_dataFromNetworkWithPage:@"0"];
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_foregroundScrollView];

    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _backgroundView.frame = CGRectMake(0, 0, 320, 250);
    });
}

#pragma mark - 刷新数据 -
/**
 *  刷新数据
 */
- (void)reloadDataList
{
    [SKUIUtils showHUD:@"努力加载中..." afterTime:8.0f];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self install_dataFromNetworkWithPage:@"0"];
    });
}

@end
