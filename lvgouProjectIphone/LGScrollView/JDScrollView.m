//
//  JDScrollView.m
//  JDKaLa
//
//  Created by zhangminglei on 11/12/13.
//  Copyright (c) 2013 张明磊. All rights reserved.
//

#import "JDScrollView.h"
#import "SKUIUtils.h"
#import "UIButton+WebCache.h"


@implementation JDScrollView


- (id)initWithModel:(NSMutableArray *)array_data
{
    self = [super init];
    {
        [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        /// 初始化 scrollview
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scrollView.bounces = YES;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView_body = scrollView;
        
        /// 初始化 数组 并添加四张图片
        //NSMutableArray *array_scroll = [NSMutableArray arrayWithObjects:@"page1.png",@"page2.png",@"page3.png",@"image4.png",nil];
        _array_scroll = array_data;
        
        /// 初始化 pagecontrol
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(225, 130, 20, 18)];
        if(IOS7_VERSION)
        {
            //[pageControl setCurrentPageIndicatorTintColor:RGB(232, 108, 154)];
            //[pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        }
        pageControl.numberOfPages = [_array_scroll count];
        pageControl.currentPage = 0;
        //[pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
        /// 触摸mypagecontrol触发change这个方法事件
        [self addSubview:pageControl];
        [pageControl setHidden:YES];
        _pageControl_scroll = pageControl;
        
        /// 创建四个图片 imageview
        for (int i = 0;i<[_array_scroll count];i++)
        {
            LGModel_mainData *model = [_array_scroll objectAtIndex:i];
            UIButton *button_Con = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_Con setFrame:CGRectMake((self.frame.size.width * i) + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [button_Con setBackgroundImageWithURL:[NSURL URLWithString:model.string_imageUrl] forState:UIControlStateNormal];
            //[SKUIUtils didLoadImageNotCached:model.string_imageUrl inButton:button_Con withState:UIControlStateNormal];
            [button_Con setTag:i];
            [button_Con addTarget:self action:@selector(didClickButton_scroll:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
            [label_title setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7]];
            [label_title setFont:[UIFont systemFontOfSize:14.0f]];
            [label_title setTextAlignment:NSTextAlignmentCenter];
            [label_title setTextColor:[UIColor whiteColor]];
            [label_title setText:model.string_title];
            [button_Con addSubview:label_title];
            
            /*UIImageView *imageViewCon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width * i) + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];*/
            //[SKUIUtils didLoadImageNotCached:model.string_imageUrl inImageView:imageViewCon];
            [_scrollView_body addSubview:button_Con];
        }
        /// 取数组最后一张图片 放在第0页
        
        LGModel_mainData *model_begin = [_array_scroll objectAtIndex:([_array_scroll count]-1)];
        UIButton *button_begin = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_begin setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [SKUIUtils didLoadImageNotCached:model_begin.string_imageUrl inButton:button_begin withState:UIControlStateNormal];
        [button_begin setTag:[_array_scroll count]-1];
        [button_begin addTarget:self action:@selector(didClickButton_scroll:) forControlEvents:UIControlEventTouchUpInside];
        //UIImageView *imageView_begin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //[SKUIUtils didLoadImageNotCached:[model_begin string_imageUrl] inImageView:imageView_begin];
        /// 添加最后1页在首页 循环
        [_scrollView_body addSubview:button_begin];
        
        UILabel *label_title_begin = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
        [label_title_begin setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7]];
        [label_title_begin setFont:[UIFont systemFontOfSize:14.0f]];
        [label_title_begin setTextAlignment:NSTextAlignmentCenter];
        [label_title_begin setTextColor:[UIColor whiteColor]];
        [label_title_begin setText:model_begin.string_title];
        [button_begin addSubview:label_title_begin];
        
        
        /// 取数组第一张图片 放在最后1页
        LGModel_mainData *model_end = [_array_scroll objectAtIndex:0];
        UIButton *button_end = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_end setFrame:CGRectMake((self.frame.size.width * ([_array_scroll count] + 1)) , 0, self.frame.size.width, self.frame.size.height)];
        [SKUIUtils didLoadImageNotCached:model_end.string_imageUrl inButton:button_end withState:UIControlStateNormal];
        [button_end setTag:0];
        [button_end addTarget:self action:@selector(didClickButton_scroll:) forControlEvents:UIControlEventTouchUpInside];
        //UIImageView *imageView_end = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width * ([_array_scroll count] + 1)) , 0, self.frame.size.width, self.frame.size.height)];
        //[SKUIUtils didLoadImageNotCached:model_end.string_imageUrl inImageView:imageView_end];
        [_scrollView_body addSubview:button_end];
        
        UILabel *label_title_end = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
        [label_title_end setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7]];
        [label_title_end setFont:[UIFont systemFontOfSize:15.0f]];
        [label_title_end setTextAlignment:NSTextAlignmentCenter];
        [label_title_end setTextColor:[UIColor whiteColor]];
        [label_title_end setText:model_end.string_title];
        [button_end addSubview:label_title_end];
        
        /// +上第1页和第4页  原理：4-[1-2-3-4]-1
        [_scrollView_body setContentSize:CGSizeMake(self.frame.size.width * ([_array_scroll count] + 2), self.frame.size.height)];
        [_scrollView_body setContentOffset:CGPointMake(0, 0)];
        [_scrollView_body scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, 320, 220)];
    }
    return self;
}

#pragma mark - scrollview委托函数 -
/**
 scrollview委托函数
 **/
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scrollView_body.frame.size.width;
    int page = floor((_scrollView_body.contentOffset.x - pagewidth/([_array_scroll count]+ 2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    _pageControl_scroll.currentPage = page;
}

/**
 scrollview 委托函数
 **/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = _scrollView_body.frame.size.width;
    int currentPage = floor((_scrollView_body.contentOffset.x - pagewidth/ ([_array_scroll count]+2)) / pagewidth) + 1;

    if (currentPage == 0)
    {
        [_scrollView_body scrollRectToVisible:CGRectMake(scrollView.frame.size.width * 5,0,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    
    else if (currentPage == ([_array_scroll count]+1))
    {
        [_scrollView_body scrollRectToVisible:CGRectMake(scrollView.frame.size.width,0,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];
    }
}

/**
 定时器绑定的方法
 **/
- (void)runTimePage
{
    NSInteger page = _pageControl_scroll.currentPage;
    page++;
    page = page > 4 ? 0 : page ;
    [_scrollView_body scrollRectToVisible:CGRectMake(_scrollView_body.frame.size.width*(page + 1),0,_scrollView_body.frame.size.width,_scrollView_body.frame.size.height) animated:YES];
}


- (void)didClickButton_scroll:(UIButton *)button
{
    NSLog(@"%d",button.tag);
}

@end
