//
//  LGKnowledgeView.m
//  lvgouProjectIphone
//
//  Created by lvgou on 13-12-23.
//  Copyright (c) 2013年 lvgou. All rights reserved.
//

#import "LGKnowledgeView.h"
#import "SKUIUtils.h"
#import "LGModel_knowledge.h"
#import "CRNavigationBar.h"
#import "LGDataBase.h"
#import "LGModel_kindData.h"
#import "LGKonwledgeListViewController.h"


@implementation LGKnowledgeView

- (id)initWithFrame:(CGRect)frame andNavigatonControllerZ:(LGZmlNavigationController *)navigationController_return
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _navigationController_z = navigationController_return;
        [self setBackgroundColor:RGB(244, 244, 244)];
        // Custom initialization
        [self installViewTitle_knowledge];
        _bool_isOpen = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self installTableData_knowledge];
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self installTableView_knowledge];
                           });
        });
        // Initialization code
    }
    return self;
}

- (void)installViewTitle_knowledge
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
    [label_title setText:@"法律知识"];
}

- (void)installTableData_knowledge
{
    NSMutableArray *array_first = [LGDataBase getKindListDataFirstFromDataBase];
    _array_data = array_first;
}

/**
 初始化tableView
 **/
#pragma mark - 初始化tableView -
- (void)installTableView_knowledge
{
    UITableView *tabelView_body = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [tabelView_body setBackgroundColor:[UIColor clearColor]];
    [tabelView_body setDelegate:self];
    [tabelView_body setDataSource:self];
    [self insertSubview:tabelView_body atIndex:0];
    [tabelView_body setBackgroundColor:RGB(246, 246, 246)];
    [tabelView_body setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _table_body = tabelView_body;
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        if(self.bool_isOpen)
        {
            NSMutableArray *array_count = [_array_data objectAtIndex:section - 1];
            if (self.selectIndex.section == section)
            {
                return [array_count count] + 1;
            }
        }
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_array_data lastObject] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"knowledgeCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: 	UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView_back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 212)];
            [SKUIUtils didLoadImageNotCached:@"knowledge_background.png" inImageView:imageView_back];
            [cell addSubview:imageView_back];
            
            UIImageView *imageView_search = [[UIImageView alloc] initWithFrame:CGRectMake(8, 150, 304, 29)];
            [SKUIUtils didLoadImageNotCached:@"image_searchBar.png" inImageView:imageView_search];
            [cell addSubview:imageView_search];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 270, 29)];
            [textField setDelegate:self];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [textField setFont:[UIFont systemFontOfSize:15.0f]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setBackgroundColor:[UIColor clearColor]];
            [textField setPlaceholder:@"搜索问题"];
            [cell addSubview:textField];
        }
        return cell;
    }
    
    if (self.bool_isOpen && indexPath.row!=0 && indexPath.section == _selectIndex.section)
    {
        static NSString *CellIdentifier = @"KnowledgeChild_mainCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 200, 30)];
            [label_title setTextAlignment:NSTextAlignmentLeft];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setTextColor:[UIColor blackColor]];
            [cell addSubview:label_title];
            [label_title setTag:12];
            [label_title setFont:[UIFont systemFontOfSize:15.0f]];
            
            UIImageView *imageView_line = [[UIImageView alloc] initWithFrame:CGRectMake(85, 49, 210, 0.5)];
            [imageView_line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.75]];
            [cell addSubview:imageView_line];
            
            UIButton *button_count = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_count setFrame:CGRectMake(260, 13, 47, 24)];
            [button_count setUserInteractionEnabled:NO];
            [button_count setTag:13];
            [button_count setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button_count.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [cell addSubview:button_count];
        }
        UILabel *label_title = (UILabel *)[cell viewWithTag:12];
        NSMutableArray *array_title = [_array_data objectAtIndex:indexPath.section - 1];
        LGModel_kindData *model_kind = [array_title objectAtIndex:indexPath.row - 1];
        [label_title setText:model_kind.string_title];
        [cell setBackgroundColor:RGB(237, 237, 237)];
        UIButton *button_count = (UIButton *)[cell viewWithTag:13];
        if([model_kind.string_articleCount intValue] != 0)
        {
            [SKUIUtils didLoadImageNotCached:@"kindCount.png" inButton:button_count withState:UIControlStateNormal];
            [button_count setTitle:[NSString stringWithFormat:@"%@条",model_kind.string_articleCount] forState:UIControlStateNormal];
        }
        else
        {
            [button_count setBackgroundImage:nil forState:UIControlStateNormal];
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Knowledge_mainCell";
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView_main = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
            [cell addSubview:imageView_main];
            [imageView_main setTag:11];
            
            UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(imageView_main.frame.origin.x + imageView_main.frame.size.width + 5, 0, 200, 30)];
            [label_title setTextAlignment:NSTextAlignmentLeft];
            [label_title setBackgroundColor:[UIColor clearColor]];
            [label_title setTextColor:[UIColor blackColor]];
            [cell addSubview:label_title];
            [label_title setTag:12];
            [label_title setFont:[UIFont systemFontOfSize:18.0f]];
            
            UILabel *label_content = [[UILabel alloc] initWithFrame:CGRectMake(label_title.frame.origin.x, 25, 260, 20)];
            [label_content setBackgroundColor:[UIColor clearColor]];
            [label_content setTextColor:[UIColor grayColor]];
            [label_content setTag:13];
            [label_content setNumberOfLines:4];
            [cell addSubview:label_content];
            [label_content setFont:[UIFont systemFontOfSize:11.0f]];
            
            UIImageView *imageView_line = [[UIImageView alloc] initWithFrame:CGRectMake(45, 49, 255, 0.5)];
            [imageView_line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.75]];
            [cell addSubview:imageView_line];
            
            UIImageView *imageView_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(275, 15, 13, 13)];
            [imageView_arrow setTag:14];
            [cell addSubview:imageView_arrow];
        }
        
        UIImageView *imageView_arrow = (UIImageView *)[cell viewWithTag:14];
        if(_selectBeforeIndex.section == indexPath.section)
        {
            if(_bool_isOpen)
            {
                [SKUIUtils didLoadImageNotCached:@"selectArrowDown.png" inImageView:imageView_arrow];
                [cell setBackgroundColor:RGB(237, 237, 237)];
            }
        }
        else
        {
            [SKUIUtils didLoadImageNotCached:@"selectArrowRight.png" inImageView:imageView_arrow];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        //UIImageView *imageView_main = (UIImageView *)[cell viewWithTag:11];
        UILabel *label_main = (UILabel *)[cell viewWithTag:12];
        UILabel *label_content = (UILabel *)[cell viewWithTag:13];
        NSMutableArray *array_title = [_array_data objectAtIndex:[_array_data count] - 1];
        LGModel_kindData *model_kind = [array_title objectAtIndex:indexPath.section - 1];
        [label_main setText:model_kind.string_title];
        [label_content setText:model_kind.string_description];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == [[_array_data lastObject] count])
    {
        return 95.0f;
    }
    
    if(indexPath.section == 0)
    {
        return 213.f;
    }
    else
    {
        return 50.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0 && indexPath.row != 0)
    {
        LGModel_kindData *model_tmp = [[_array_data objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row - 1];
        LGKonwledgeListViewController *knowledgeController = [[LGKonwledgeListViewController alloc] initWithStringID:model_tmp.string_Id];
        knowledgeController.navigationController_return_z = _navigationController_z;
        [_navigationController_z pushViewController:knowledgeController animated:YES];
        
        return;
    }
    
    _selectIndex = indexPath;
    if(_selectIndex.section == _selectBeforeIndex.section)
    {
        if(_bool_isOpen)
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES andIndexPath:_selectIndex];
        }
        else
        {
            [self didSelectCellRowFirstDo:YES nextDo:NO andIndexPath:_selectIndex];
        }
    }
    else
    {
        if(_bool_isOpen)
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES andIndexPath:_selectBeforeIndex];
            [self didSelectCellRowFirstDo:YES nextDo:NO andIndexPath:_selectIndex];
        }
        else
        {
            [self didSelectCellRowFirstDo:YES nextDo:NO andIndexPath:_selectIndex];
        }
    }
    _selectBeforeIndex = indexPath;
}

/*
 收缩列表
 */
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert andIndexPath:(NSIndexPath *)indexPath
{
    self.bool_isOpen = firstDoInsert;
    UITableViewCell *cell = (UITableViewCell *)[_table_body cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:RGB(237, 237, 237)];
    
    UITableViewCell *cell_before = (UITableViewCell *)[_table_body cellForRowAtIndexPath:_selectBeforeIndex];
    [cell_before setBackgroundColor:[UIColor clearColor]];
    
    [self.table_body beginUpdates];
    int section = indexPath.section;
    NSMutableArray *array_count = [_array_data objectAtIndex:indexPath.section - 1];
    int contentCount = [array_count count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++)
    {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [_table_body insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [_table_body deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.table_body endUpdates];
    [self changArrowWithUpInCell:cell withBool:firstDoInsert];
    if (self.bool_isOpen)
    {
        //[_table_body scrollToRowAtIndexPath:_selectIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.table_body scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}


- (void)changArrowWithUpInCell:(UITableViewCell *)_cell withBool:(BOOL)_bool
{
    if(_bool)
    {
        UIImageView *imageView = (UIImageView *)[_cell viewWithTag:14];
        [SKUIUtils didLoadImageNotCached:@"selectArrowDown.png" inImageView:imageView];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[_cell viewWithTag:14];
        [SKUIUtils didLoadImageNotCached:@"selectArrowRight.png" inImageView:imageView];
    }
}

#pragma mark - 搜索 -
/*
 搜索
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if([textField.text length] != 0)
    {
        LGKonwledgeListViewController *knowledgeController = [[LGKonwledgeListViewController alloc] initWithSearchKey:textField.text];
        knowledgeController.navigationController_return_z = _navigationController_z;
        [_navigationController_z pushViewController:knowledgeController animated:YES];
    }
    else
    {
        [SKUIUtils showAlterView:@"输入为空!" afterTime:1.0f];
    }
    return YES;
}

@end
