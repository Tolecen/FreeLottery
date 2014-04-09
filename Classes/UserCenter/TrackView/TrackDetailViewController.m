//
//  TrackDetailViewController.m
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrackDetailViewController.h"
#import "RYCImageNamed.h"
#import "SeeDetailTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "OnlyHaveTextViewTableCell.h"
#import "HistoryTrackDetailtableViewCell.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define ButtonStartTag   (301)

@implementation TrackDetailViewController

@synthesize contentArray = m_contentArray;
@synthesize myTableView = m_myTableView;
@synthesize trackId = m_trackId;
@synthesize titleButtonState = m_titleButtonState;
@synthesize dataArray = m_dataArray;
@synthesize isCanStopTrack;
@synthesize stopIdNo;

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    [m_contentArray release], m_contentArray = nil;
    [m_titleButtonState release], m_titleButtonState = nil;
    [m_dataArray release], m_dataArray = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHistoryTrackOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopTrackNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelTrackOK" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHistoryTrackOK:) name:@"queryHistoryTrackOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StopTrackNotification:) name:@"StopTrackNotification" object:nil];   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTrackOK:) name:@"cancelTrackOK" object:nil];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    m_titleButtonState = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"0", nil];
    m_dataArray = [[NSMutableArray alloc] initWithCapacity:1];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20) style:UITableViewStyleGrouped];
    m_myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
//    [self setUpTopView];
}

- (void)setUpTopView
{
    UIImageView  *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topImage.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:topImage];
    
    UILabel* titltLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titltLabel.textAlignment = UITextAlignmentCenter;
    titltLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titltLabel.textColor = [UIColor brownColor];
    titltLabel.backgroundColor = [UIColor clearColor];
    if([self.contentArray count] > 0)
        titltLabel.text = [self.contentArray objectAtIndex:0];
    [topImage addSubview:titltLabel];
    [titltLabel release];
    [topImage release];
    
    UIImageView*  bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 361, 320, 60)];
    bottomImage.image = RYCImageNamed(@"bottom_redbg.png");
    [self.view addSubview:bottomImage];
    [bottomImage release];
    
    UIButton* buyButton = [[UIButton alloc] initWithFrame:CGRectMake(99, 371, 123, 38)];
    [buyButton setTitle:@"追期详情" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [buyButton setTitleColor:[UIColor colorWithRed:49.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"bottombtn_normal.png") forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"bottombtn_click.png") forState:UIControlStateHighlighted];
    [buyButton addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    [buyButton release];
}

- (void)detailButtonClick:(id)sender
{
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_HISTORY_TRACK;
    [[RuYiCaiNetworkManager sharedManager] queryHistoryTrackDetail:self.trackId];
}

- (void)queryHistoryTrackOK:(NSNotification*)notification
{
//    [self setHidesBottomBarWhenPushed:YES];
//    HistoryTrackDetailViewController*  viewController = [[HistoryTrackDetailViewController alloc] init];
//    viewController.navigationItem.title = @"追期历史详情";
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [self.dataArray removeAllObjects];
    NSArray* resultArr = [parserDict objectForKey:@"result"];
    [self.dataArray addObjectsFromArray:resultArr];
    
    [self.myTableView reloadData];
}

- (void)StopTrackNotification:(NSNotification*)notification
{
    [[RuYiCaiNetworkManager sharedManager] cancelTrack:self.stopIdNo];
}

- (void)cancelTrackOK:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTrackOK" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTrackOK" object:nil];

}

- (void)pressTitle:(id)sender
{
	UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag - ButtonStartTag;
    if ([self.titleButtonState objectAtIndex:temptag] == @"0")
    {
        [self.titleButtonState replaceObjectAtIndex:temptag withObject:@"1"];     
        
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
    }
    else if([self.titleButtonState objectAtIndex:temptag] == @"1"){
        [self.titleButtonState replaceObjectAtIndex:temptag withObject:@"0"];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateHighlighted];
    }
    if(temptag == 2)//追号详情
    {
        if ([self.titleButtonState objectAtIndex:temptag] == @"1")//展开
        {
            if([self.dataArray count] == 0)//没有数据，联网获取
            {
                [self.myTableView reloadData]; 
                [self detailButtonClick:nil];
            }
            else
            {
                [self.myTableView reloadData]; 
            }
        }
        else
            [self.myTableView reloadData]; 
    }
    else
        [self.myTableView reloadData];
}

#pragma mark UITableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = ButtonStartTag + section;
    
    //0 隐藏 1-- 展开
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    else
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 25, 0, 0);
    switch (section)
    {
        case 0:
            [button setTitle:@"方案详情" forState:UIControlStateNormal];
            break;
        case 1:
            [button setTitle:@"方案内容" forState:UIControlStateNormal];
            break;
        case 2:
            [button setTitle:@"追号详情" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        if(0 == section)
        {
            return ([self.contentArray count] - 1)/2;
        }
        else if(2 == section)
        {
            return [self.dataArray count];
        }
        else
            return 1;
    }
    else
        return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (1 == section)
//        return @"投注内容";
//    else
//        return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 135;
    }
    else if(indexPath.section == 2)
    {
        if([self.dataArray count] > 0)
        {
            if([[[self.dataArray objectAtIndex:0] objectForKey:@"desc"]  isEqualToString:@""])
            {
                return 80;
            }
            else
                return 120;
        }
        else
            return 40;

    }
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if([indexPath section] == 0)
    {
        static NSString *myIdentifier = @"MyIdentifier";
        SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(0 == indexPath.row)
        {
            UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
            writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
            [cell addSubview:writeImage];
            [writeImage release];
        }
        NSUInteger rowIndex = [indexPath row];
        NSUInteger arrIndex = rowIndex * 2;
        cell.cellTitle = (NSString*)[self.contentArray objectAtIndex:arrIndex];
        cell.cellDetailTitle = (NSString*)[self.contentArray objectAtIndex:(arrIndex + 1)];
        cell.isTextView = NO;
        if(6 == indexPath.row)
        {
            cell.isRedText = YES;
        }
        else
            cell.isRedText = NO;

        if(9 == indexPath.row)
        {
            if(isCanStopTrack)
            {
              cell.hasButton = ZHUIHAO_STOP_TRACK;
            }
        }
        else
            cell.hasButton = NONE_BUTTON;
        [cell refreshCell];
        return cell;
    }
    else if ([indexPath section] == 1)
    {
        static NSString *CellIdentifiers = @"TableCells";
        OnlyHaveTextViewTableCell *cell = (OnlyHaveTextViewTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
        if (cell == nil) {
            cell = [[[OnlyHaveTextViewTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        [cell addSubview:writeImage];
        [writeImage release];
        
        cell.textString = (NSString*)[self.contentArray lastObject];
        
        [cell refreshCell];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        HistoryTrackDetailtableViewCell *cell = (HistoryTrackDetailtableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[HistoryTrackDetailtableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(0 == indexPath.row)
        {
            UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 7)];
            writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
            [cell addSubview:writeImage];
            [writeImage release];
        }
        /*"batchCode":"2012071201","lotMulti":"1","amount":"200","winCode":"","state":"1","stateMemo":"已完成","prizeAmt":"0","desc":"2_4_200.00%"*/
        cell.batchCodeStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"batchCode"];
        cell.lotMultiStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"lotMulti"];
        cell.amountStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"amount"];
        cell.winCodeStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"winCode"];
        cell.stateStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"stateMemo"];
        cell.winAccountStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"prizeAmt"];
        cell.planStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"desc"];
        
        [cell refreshCell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
