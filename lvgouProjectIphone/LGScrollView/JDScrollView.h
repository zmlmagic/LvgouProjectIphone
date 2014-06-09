//
//  JDScrollView.h
//  JDKaLa
//
//  Created by zhangminglei on 11/12/13.
//  Copyright (c) 2013 张明磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGModel_mainData.h"

@interface JDScrollView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView_body;
@property (weak, nonatomic) NSMutableArray *array_scroll;
@property (weak ,nonatomic) UIPageControl *pageControl_scroll;

- (id)initWithModel:(NSMutableArray *)array_data;

@end
