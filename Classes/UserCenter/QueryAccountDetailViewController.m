//
//  QueryAccountDetailViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryAccountDetailViewController.h"
#import "RYCImageNamed.h"
#import "AccountDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight  (50)

@interface QueryAccountDetailViewController (internal)

- (void)setNavigationBackButton;
- (void)refreshMySubViews;
- (void)pageUpClick:(id)sender;
- (void)pageDownClick:(id)sender;
- (void)queryAccountDetailOK:(NSNotification *)notification;
- (void)segmentedChangeValue;
- (void)viewBack:(id)sender;

@end

@implementation QueryAccountDetailViewController
@synthesize segmentView = _segmentView;

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryAccountDetailOK" object:nil];
}

- (void)dealloc 
{
    [_segmentView release];
    [m_pageIndexLabel release];
    [m_segmented release];
    [m_allAmountLabel release];
    [allCountBg release];
    
    for (int i = 0; i < 50; i++)
        [m_subViewsArray[i] release], m_subViewsArray[i] = nil;
    for (int i = 0; i < 5; i++)
        [m_scrollViewArray[i] release];
    
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [self setNavigationBackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryAccountDetailOK:) name:@"queryAccountDetailOK" object:nil];

    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;

    for (int i = 0; i < 5; i++)
    {
        m_scrollViewArray[i] = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height - 173)];
        m_scrollViewArray[i].scrollEnabled = YES;
        m_scrollViewArray[i].hidden = YES;
        [self.view addSubview:m_scrollViewArray[i]];
        
        for (int j = i * 10; j < (i + 1) * 10; j++)
        {
            m_subViewsArray[j] = [[AccountDetailView alloc] initWithFrame:CGRectZero];
            m_subViewsArray[j].hidden = YES;
            [m_scrollViewArray[i] addSubview:m_subViewsArray[j]];
        }
    }
    m_scrollViewArray[0].frame = CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height - 143);
    m_scrollViewArray[0].hidden = NO;
    
    allCountBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 143, 320, 29)];
    allCountBg.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:allCountBg];
    
    m_allAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 300, 29)];
    m_allAmountLabel.textColor = [UIColor redColor];
    m_allAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    m_allAmountLabel.backgroundColor = [UIColor clearColor];
    [allCountBg addSubview:m_allAmountLabel];
    allCountBg.hidden = YES;
    
//    NSArray *buttonNames = [NSArray arrayWithObjects:@"全部", @"充值", @"支付", @"派奖", @"提现", nil];
//    m_segmented = [[UISegmentedControl alloc] initWithItems:buttonNames];
//    m_segmented.segmentedControlStyle = UISegmentedControlStyleBar;
//    [m_segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:m_segmented];
//    [m_segmented setFrame:CGRectMake(-6, 0, 332, 30)];
//    m_segmented.selectedSegmentIndex = 0;
    
    self.segmentView = [[[CustomSegmentedControl alloc]
                         initWithFrame:CGRectMake(5, 5, 310, 30)
                         andNormalImages:[NSArray arrayWithObjects:
                                          @"zhmx_qb_normal.png",
                                          @"zhmx_cz_normal.png",
                                          @"zhmx_zf_normal.png",
                                          @"zhmx_pj_normal.png",
                                          @"zhmx_tx_normal.png",nil]
                         andHighlightedImages:[NSArray arrayWithObjects:
                                               @"zhmx_qb_normal.png",
                                               @"zhmx_cz_normal.png",
                                               @"zhmx_zf_normal.png",
                                               @"zhmx_pj_normal.png",
                                               @"zhmx_tx_normal.png",nil]
                         andSelectImage:[NSArray arrayWithObjects:
                                         @"zhmx_qb_click.png",
                                         @"zhmx_cz_cilck.png",
                                         @"zhmx_zf_click.png",
                                         @"zhmx_pj_click.png",
                                         @"zhmx_tx_click.png",nil]]autorelease];
    self.segmentView.delegate = self;
    [self.view addSubview:_segmentView];
    
    UIImageView* bottomBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 113, 320, 50)];
    bottomBarImageView.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:bottomBarImageView];
    [bottomBarImageView release];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
    leftButton.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);
    [leftButton setTitle:@"上一页" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
    [leftButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];  
    [leftButton addTarget:self action: @selector(pageUpClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
    rightButton.frame = CGRectMake(240, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);  
    [rightButton setTitle:@"下一页" forState:UIControlStateNormal];  
    [rightButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
    [rightButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];  
    [rightButton addTarget:self action: @selector(pageDownClick:) forControlEvents:UIControlEventTouchUpInside];  
    [self.view addSubview:rightButton];
    
    m_pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height - 103, 160, 30)];
    m_pageIndexLabel.text = @"第0页 共0页";
    m_pageIndexLabel.textAlignment = UITextAlignmentCenter;
    m_pageIndexLabel.backgroundColor = [UIColor clearColor];
    m_pageIndexLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:m_pageIndexLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

- (void)setNavigationBackButton
{
//    UILabel *label = [[[UILabel alloc] init] autorelease];
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease]; //消掉系统的按钮
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];

}


- (void)refreshMySubViews
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* totalPage = [parserDict objectForKey:@"totalPage"];
    m_totalPageCount = [totalPage intValue];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    int nCurCount = [dict count];
    m_curPageSize = nCurCount;
    
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        int index = self.segmentView.segmentedIndex * 10 + i;
        m_subViewsArray[index].amt = KISDictionaryHaveKey(subDict, @"amt");
//        [subDict objectForKey:@"amt"];
        m_subViewsArray[index].drawAmt = KISDictionaryHaveKey(subDict, @"drawAmt");
        m_subViewsArray[index].blsign = KISDictionaryHaveKey(subDict, @"blsign");
        m_subViewsArray[index].ttransactionType = KISDictionaryHaveKey(subDict, @"ttransactionType");
        m_subViewsArray[index].memo = KISDictionaryHaveKey(subDict, @"memo");
        m_subViewsArray[index].balance = KISDictionaryHaveKey(subDict, @"balance");
        m_subViewsArray[index].drawamtBalance = KISDictionaryHaveKey(subDict, @"drawamtBalance");
        m_subViewsArray[index].platTime = KISDictionaryHaveKey(subDict, @"platTime");
        
        m_subViewsArray[index].hidden = NO;
        m_subViewsArray[index].frame = CGRectMake(0, i * kLotWinDetailViewHeight, 320, kLotWinDetailViewHeight);
        [m_subViewsArray[index] refreshView];
    }
    m_scrollViewArray[self.segmentView.segmentedIndex].contentSize = CGSizeMake(320, kLotWinDetailViewHeight * 10);
    
    if(self.segmentView.segmentedIndex == 0)
    {
        allCountBg.hidden = YES;
    }
    else
    {
        NSString* titleStr;
        if(self.segmentView.segmentedIndex == 1)
        {
             titleStr = @"充值总金额：";
        }
        else if(self.segmentView.segmentedIndex == 2)
        {
             titleStr = @"投注总金额：";
        }
        else if(self.segmentView.segmentedIndex == 3)
        {
             titleStr = @"中奖总金额：";
        }
        else 
        {
             titleStr = @"提现总金额：";
        }
        allCountBg.hidden = NO;
        m_allAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f元", titleStr,[[parserDict objectForKey:@"totalAmt"] longLongValue]/100.0];
    }
    
    if (m_totalPageCount > 0)
        m_pageIndexLabel.text = [NSString stringWithFormat:@"第%d页 共%d页", m_curPageIndex + 1, m_totalPageCount];
    else
        m_pageIndexLabel.text = [NSString stringWithFormat:@"第0页 共0页"];
}

- (void)pageUpClick:(id)sender
{
    if (m_curPageIndex > 0)
    {
        m_curPageIndex--;
        [[RuYiCaiNetworkManager sharedManager] queryAccountDetailOfPage:m_curPageIndex transactionType:self.segmentView.segmentedIndex];
    }
}

- (void)pageDownClick:(id)sender
{
    if ((m_totalPageCount > 1) && (m_curPageIndex < (m_totalPageCount - 1)))
    {
        m_curPageIndex++;
        [[RuYiCaiNetworkManager sharedManager] queryAccountDetailOfPage:m_curPageIndex transactionType:self.segmentView.segmentedIndex];
    }
}

- (void)queryAccountDetailOK:(NSNotification *)notification
{
    [self refreshMySubViews];
	[m_scrollViewArray[self.segmentView.segmentedIndex] setContentOffset:CGPointMake(0, 0)];
}

- (void)segmentedChangeValue
{
    m_pageIndexLabel.text = [NSString stringWithFormat:@"第0页 共0页"];
    m_curPageIndex = 0;
    NSUInteger index = m_segmented.selectedSegmentIndex;
    for (int i = 0; i < 5; i++)
    {
        if (i != index)
            m_scrollViewArray[i].hidden = YES;
        else
            m_scrollViewArray[i].hidden = NO;
    }
    [[RuYiCaiNetworkManager sharedManager] queryAccountDetailOfPage:m_curPageIndex transactionType:index];
}

#pragma mark - customSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    m_pageIndexLabel.text = [NSString stringWithFormat:@"第0页 共0页"];
    m_curPageIndex = 0;
    for (int i = 0; i < 5; i++)
    {
        if (i != index)
            m_scrollViewArray[i].hidden = YES;
        else
            m_scrollViewArray[i].hidden = NO;
    }
    [[RuYiCaiNetworkManager sharedManager] queryAccountDetailOfPage:m_curPageIndex transactionType:index];
}


- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
