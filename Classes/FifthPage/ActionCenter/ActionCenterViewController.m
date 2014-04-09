//
//  ActionCenterViewController.m
//  RuYiCai
//
//  Created by  on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActionCenterViewController.h"
#import "RYCImageNamed.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "PullUpRefreshView.h"
#import "ActionCenterDetailViewController.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@interface ActionCenterViewController (internal)

- (void)setOneAction;
- (void)GetActivityTitleOK:(NSNotification*)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
- (void)buttonClick:(UIButton*)button;

@end

@implementation ActionCenterViewController

@synthesize  titleDataArray = m_titleDataArray;
@synthesize  activityTimesArr = m_activityTimesArr;
@synthesize  activityIdArr = m_activityIdArr;
@synthesize detileStr   = m_detileStr;

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetActivityTitleOK" object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [m_detileStr release];
    [activeConductImageView release];
    [m_titleDataArray release], m_titleDataArray = nil;
    [m_scrollView release];
    
    [m_activityTimesArr release], m_activityTimesArr = nil;
    [m_activityIdArr release], m_activityIdArr = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetActivityTitleOK:) name:@"GetActivityTitleOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];

    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#fff9f4"];

    self.detileStr = [[[NSString alloc] init] autorelease];
    m_curIndex = 0;
    m_startY = 0;
    m_centerY = 0;
    m_curPageIndex = 1;
    m_index = 0;
    
    m_titleDataArray = [[NSMutableArray alloc] initWithCapacity:10];
    m_activityTimesArr = [[NSMutableArray alloc] initWithCapacity:1];
    m_activityIdArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    m_scrollView.delegate = self;
    m_scrollView.scrollEnabled = YES;
    [self.view addSubview:m_scrollView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64, 320, REFRESH_HEADER_HEIGHT)];
    [m_scrollView addSubview:refreshView];
    refreshView.myScrollView = m_scrollView;
    [refreshView stopLoading:NO];
    
    [[RuYiCaiNetworkManager sharedManager] getActivityTitle:1];
}

- (void)setOneAction
{
    
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + m_startY, 320,42)];
    image_topbg.image = RYCImageNamed(@"active_top_bg.png");
    [m_scrollView addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 13 + m_startY, 10, 14)];
    accessoryImageView.image = RYCImageNamed(@"accessory_c_normal.png");
    [m_scrollView addSubview:accessoryImageView];
    [accessoryImageView release];
    
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
    image_middlebg.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:image_middlebg];

    NSString *titleStr = [[self.titleDataArray objectAtIndex:m_index] objectForKey:@"title"];
//    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(292, 200) lineBreakMode:UILineBreakModeTailTruncation]; 
//    
    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 280, 30)];
    m_titleLabel.text = titleStr;
    m_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
//    m_titleLabel.numberOfLines = titleSize.height/19;
    [m_titleLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0]];
    m_titleLabel.textAlignment = UITextAlignmentLeft;
    m_titleLabel.backgroundColor = [UIColor clearColor];
    m_titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [image_topbg addSubview:m_titleLabel];
    [m_titleLabel release];
    
    NSString *introStr =[NSString stringWithFormat:@"活动介绍：%@", [[self.titleDataArray objectAtIndex:m_index] objectForKey:@"introduce"]];
    CGSize introSize = [introStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(260, 300) lineBreakMode:UILineBreakModeTailTruncation]; 
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + 30, 280, introSize.height)];
    introLabel.text = introStr;
    introLabel.lineBreakMode = UILineBreakModeTailTruncation;
    introLabel.numberOfLines = introSize.height/13;
    [introLabel setTextColor:[UIColor blackColor]];
    introLabel.textAlignment = UITextAlignmentLeft;
    introLabel.backgroundColor = [UIColor clearColor];
    introLabel.font = [UIFont systemFontOfSize:13];
    [image_middlebg addSubview:introLabel];
    
    activeConductImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250,introLabel.frame.origin.y+introLabel.frame.size.height-35 , 60, 55)];
    activeConductImageView.image = [UIImage imageNamed:@"active_jinxing_log.png"];
    [image_middlebg addSubview:activeConductImageView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 280, 20)];
    NSString *detilStr;
    if([[[self.titleDataArray objectAtIndex:m_index] objectForKey:@"isEnd"] isEqualToString:@"0"])
    {
        [m_titleLabel setTextColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
        [timeLabel setTextColor:[ColorUtils parseColorFromRGB:@"#c5945b"]];
        timeLabel.text = [NSString stringWithFormat:@"活动时间：%@", [[self.titleDataArray objectAtIndex:m_index] objectForKey:@"activityTime"]];
        [activeConductImageView setHidden:NO];
        self.detileStr  = [NSString stringWithFormat:@"%@(进行中)",timeLabel.text];
    }
    else
    {
        [m_titleLabel setTextColor:[ColorUtils parseColorFromRGB:@"#787878"]];
        [timeLabel setTextColor:[ColorUtils parseColorFromRGB:@"#a1a1a1"]];
        timeLabel.text = [NSString stringWithFormat:@"活动时间：%@(已结束)", [[self.titleDataArray objectAtIndex:m_index] objectForKey:@"activityTime"]];
        [activeConductImageView setHidden:YES];
        self.detileStr  = timeLabel.text;
    }
    timeLabel.textAlignment = UITextAlignmentLeft;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    [image_middlebg addSubview:timeLabel];
    
    [self.activityTimesArr addObject:self.detileStr];
    
    [introLabel release];
    [timeLabel release];
    
    image_middlebg.frame = CGRectMake(9, 22 + m_startY, 302, introLabel.frame.origin.y + introLabel.frame.size.height);
       
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9,image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, 12)];
    image_bottombg.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:image_bottombg];
    
    
//    if([[[self.titleDataArray objectAtIndex:m_index] objectForKey:@"isEnd"] isEqualToString:@"1"])
//    {
//        //UIImageView *image_isend = [[UIImageView alloc] initWithFrame:CGRectMake(190,image_linebg.frame.origin.y + 3, 79, 68)];
//        UIImageView *image_isend = [[UIImageView alloc] initWithFrame:CGRectMake(190,m_startY + 21 +2, 79, 68)];
//        image_isend.image = RYCImageNamed(@"action_isend.png");
//        image_isend.alpha = 0.9;
//        //[image_middlebg addSubview:image_isend];
//        [m_scrollView addSubview:image_isend];
//
//        [image_isend release];
//    }
    
    UIButton*  button_detail = [UIButton buttonWithType:UIButtonTypeCustom];
    button_detail.frame = CGRectMake(9, m_startY + 12 + 5, 302, (image_middlebg.frame.size.height - 5 + 20));
    [button_detail addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //button_detail.tag = [[[self.titleDataArray objectAtIndex:m_index] objectForKey:@"activityId"] intValue];
    button_detail.tag = m_index;
    [m_scrollView addSubview:button_detail];
    
        
    [self.activityIdArr addObject:[[self.titleDataArray objectAtIndex:m_index] objectForKey:@"activityId"]];
    
    m_startY = (int)(image_bottombg.frame.origin.y + image_bottombg.frame.size.height);
    
    [image_bottombg release];
    [image_middlebg release];
    
    m_scrollView.contentSize = CGSizeMake(320, m_startY);
    m_centerY = m_scrollView.contentSize.height - m_scrollView.frame.size.height;
}

- (void)buttonClick:(UIButton*)button
{
    NSTrace();
    [self setHidesBottomBarWhenPushed:YES];
    
    ActionCenterDetailViewController *viewController = [[ActionCenterDetailViewController alloc] init];
    viewController.navigationItem.title = @"活动内容";
    viewController.pushType = @"HIDTYPE";
    viewController.activityId = [self.activityIdArr objectAtIndex:button.tag];
    viewController.activityTime = [self.activityTimesArr objectAtIndex: button.tag];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)GetActivityTitleOK:(NSNotification*)notification
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].activityTitleStr];
    [jsonParser release];
    
    [self.titleDataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    m_totalPage = [[parserDict objectForKey:@"totalPage"]intValue];
    
    for(int i = 0; i < [[parserDict objectForKey:@"result"] count]; i++)
    {
       [self setOneAction];
        m_curIndex++;
        m_index++;
    }
    
    m_curIndex = 0;
    m_curPageIndex++;
    if(m_curPageIndex == (m_totalPage + 1))
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [refreshView setRefreshViewFrame];
    
}

#pragma make  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(m_curPageIndex == 1)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = m_centerY;
    }
    [refreshView viewdidScroll:scrollView];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex <= m_totalPage)
    {
        [[RuYiCaiNetworkManager sharedManager] getActivityTitle:m_curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
