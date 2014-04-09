//
//  LotteryAwardInfoViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PkSScLotteryAwardInfoVC.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "LotteryInfoTableViewCell.h"
#import "LotteryAwardInfoTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "TrendView.h"
#import "PullUpRefreshView.h"
#import "WinNoView.h"
#import "LotteryDetailView.h"
#import "LotteryDetailBigView.h"
#import "HistoryLotDetailViewController.h"
#import "ShareSendViewController.h"
#import "TengXunSendViewController.h"
#import "BlockActionSheet.h"

#import "SSQ_PickNumberViewController.h"
#import "FC3D_PickNumberViewController.h"
#import "DLT_PickNumberViewController.h"
#import "QLC_PickNumberViewController.h"
#import "PLS_PickNumberViewController.h"
#import "PLW_PickNumberViewController.h"
#import "QXC_PickNumberViewController.h"
#import "X22_5PickNumberViewController.h"
#import "ColorUtils.h"
#import "BackBarButtonItemUtils.h"
#import "ShareRightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define batchCodeLabelWidth (80)
#define ballHeigth (20)

#define REFRESH_HEADER_HEIGHT 52.0f
#define ScrollViewMaxY        (305)

#define degreesToRadians(x) (M_PI*(x)/180.0)//弧度

#define detailViewTag  (102)

#define topTitleButtonTag  (103)

@interface PkSScLotteryAwardInfoVC (internal)

- (void)setNavigationBackButton;
- (void)viewBack:(id)sender;

- (void)setDetailView;
- (void)buildTopButton;
- (void)setTopButton;
- (void)setRedTrendInterface;
- (void)setBlueTrendInterface;
- (void)setlotteryInterface;

- (void)detailButtonClick;

- (void)updateLotteryList:(NSNotification*)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
- (void)GetLotteryArardInfoDetailOK:(NSNotification*)notification;
- (void)updateLottery:(NSNotification*)notification;//走势图开奖号码

- (void)forceShuPing;
- (void)orientationDidChange:(NSNotification*)notification;//设备方向更改
- (void)setViewShuFrame;
- (void)setViewHengFrame;

- (void)setShareButton;
- (void)shareButtonClick:(id)sender;
- (void)sinaButtonClick:(id)sender;
- (void)tengXunButtonClick:(id)sender;
- (void)weiXinButtonClick:(id)sender;


- (void)goLotteryButtonClick:(id)sender;

@end

@implementation PkSScLotteryAwardInfoVC

@synthesize detailScroll = m_detailScroll;
@synthesize lotTitle = m_lotTitle;
@synthesize lotNo = m_lotNo;
@synthesize batchCode = m_batchCode;
@synthesize myTableView = m_myTableView;

@synthesize trendDataArray = m_trendDataArray;
@synthesize trendButton = m_trendButton;
@synthesize lotteryButton = m_lotteryButton;
@synthesize detailButton = m_detailButton;
@synthesize scrollView = m_scrollView;
@synthesize trendView = m_trendView;
@synthesize blueTrendView = m_blueTrendView;
@synthesize VRednumber, VBluenumber;
@synthesize lotteryDataArray= m_lotteryDataArray;
@synthesize isGoLottery = m_isGoLottery;
@synthesize detailView = m_detailView;
@synthesize delegate = _delegate;
@synthesize isPushShow = m_isPushShow;

- (void)dealloc
{
    [m_detailScroll release];
    
    [m_myTableView release], m_myTableView = nil;
    [m_trendDataArray release], m_trendDataArray = nil;
    [m_trendButton release];
    [m_lotteryButton release];

    [m_scrollView release];
    [m_blueTrendView release];
    [m_lotteryDataArray release], m_lotteryDataArray = nil;
    
    [refreshView release];
    
    [m_goLotteryButton release];
    
    if(m_shareButton != nil)
        [m_shareButton release];
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetLotteryArardInfoDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self setNavigationBackButton];
    
    btnIndex = 0;
    isBlue = YES;
    
    m_curPageIndex = 0;
    isRefreshList = YES;//历史开奖
    
    
    self.isGoLottery = YES;
    
    [self buildTopButton];

    
    m_trendDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    UIView *imageBg = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 139-25, 480, 62)];
    imageBg.backgroundColor = [ColorUtils parseColorFromRGB:@"#F5F5F5"];
    [m_detailView addSubview:imageBg];
    [imageBg release];
    
    m_goLotteryButton = [[UIButton alloc] initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height - 134-10, 200, 35)];
    [m_goLotteryButton setBackgroundImage:RYCImageNamed(@"qtz_btn.png") forState:UIControlStateNormal];
    [m_goLotteryButton setBackgroundImage:RYCImageNamed(@"qtz_hover_btn.png") forState:UIControlStateHighlighted];
    [m_goLotteryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_goLotteryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [m_goLotteryButton setTitle:[NSString stringWithFormat:@"去%@投注", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo]]  forState:UIControlStateNormal];
    [m_goLotteryButton addTarget:self action:@selector(goLotteryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    m_goLotteryButton.enabled = YES;
    [m_detailView addSubview:m_goLotteryButton];
    
    if(VRednumber == 0 && VBluenumber == 0)
    {
        UIButton *TopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [TopButton setBackgroundColor:[UIColor clearColor]];
        [TopButton setBackgroundImage:RYCImageNamed(@"kjhm_btn") forState:UIControlStateNormal];
        [TopButton setTitle:@"开奖号码" forState:UIControlStateNormal];
        [TopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        TopButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        TopButton.enabled = NO;
        TopButton.tag = topTitleButtonTag;
        [self.view addSubview:TopButton];
        [TopButton release];
        [self setlotteryInterface];
    }
    else
    {
        if(![[CommonRecordStatus commonRecordStatusManager] isHeighLotTitle:self.lotTitle])
        {
            //            [[RuYiCaiNetworkManager sharedManager] getLotteryDetailInfo:self.lotNo batchCode:self.batchCode];//获得开奖详情
            [[RuYiCaiNetworkManager sharedManager] getLotteryAwardInfoDetailInfo:self.lotNo batchCode:self.batchCode];
            //            [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"50" lotno:self.lotNo];
        }
        else//高频彩走势图 80 期
        {
            //            [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"80" lotno:self.lotNo];
            [self trendButtonClick];
        }
        [self setTopButton];
        [self setlotteryInterface];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLotteryList:) name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLotteryArardInfoDetailOK:) name:@"GetLotteryArardInfoDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];
    
}

- (void)setNavigationBackButton
{
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 52, 30)];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //    backButton.showsTouchWhenHighlighted = YES;
	[backButton addTarget:self action:@selector(viewBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    [backButton release];
    
}

- (void)viewBack:(id)sender
{
    [self forceShuPing];
    if (m_isPushShow)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToBack
{
    if (m_isPushShow)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setDetailView
{
    //    self.detailScroll.hidden = NO;
    //    m_shareButton.hidden = NO;
    
    LotteryDetailBigView*  detailView = [[LotteryDetailBigView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-150)];
    detailView.winLotTitle = self.lotTitle;
    [detailView setDetailView];
    detailView.tag = detailViewTag;
    detailView.caizhongLable.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo];
    
    
    [m_detailView addSubview:detailView];
    [detailView release];
    
    [self setShareButton];
}

- (void)buildTopButton
{
    
    m_lotteryButton = [[UIButton alloc] initWithFrame:CGRectMake(201, 0, 99, 31)];
    [m_lotteryButton setBackgroundColor:[UIColor clearColor]];
    [m_lotteryButton setBackgroundImage:RYCImageNamed(@"kjhm_btn.png") forState:UIControlStateNormal];
    [m_lotteryButton setBackgroundImage:RYCImageNamed(@"kjhm_btn_click.png") forState:UIControlStateHighlighted];
    [m_lotteryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_lotteryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_lotteryButton addTarget:self action:@selector(lotteryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
   
}

- (void)setRedTrendInterface
{
    for (int i = 0; i < m_cellCount; i++)
    {
        NSDictionary *diction = (NSDictionary*)[self.trendDataArray objectAtIndex:i];
        [self.trendView.batchCodeArray insertObject:KISDictionaryNullValue(diction,@"batchCode") atIndex:i];
        [self.trendView.winNoArray insertObject:KISDictionaryNullValue(diction,@"winCode") atIndex:i];
    }
    
    NSInteger startNum = 0;
    NSInteger endNum = 0;
    NSInteger weiNum = 0;//蓝色球位数
    if ([self.lotTitle isEqualToString:kLotTitlePK10]|| [self.lotTitle isEqualToString:kLotTitleJXSSC])
    {
        startNum = 0;
        endNum = 9;
        weiNum = 2;
    }
    [m_trendView setBallShow:self.lotTitle isRed:YES];
    [m_trendView setNumberList:startNum  endNum:endNum  blueNum:weiNum type:self.lotTitle];
    
    [m_trendView setBetCodeList];
    [m_trendView setWinNoListView:self.lotTitle];
}

- (void)setBlueTrendInterface
{
    for (int i = 0; i < m_cellCount; i++)
    {
        NSDictionary *diction = (NSDictionary*)[self.trendDataArray objectAtIndex:i];
        //        [m_blueTrendView.batchCodeArray insertObject:[diction objectForKey:@"batchCode"] atIndex:i];
        //        [m_blueTrendView.winNoArray insertObject:[diction objectForKey:@"winCode"] atIndex:i];
        [m_blueTrendView.batchCodeArray insertObject:KISDictionaryNullValue(diction,@"batchCode") atIndex:i];
        [m_blueTrendView.winNoArray insertObject:KISDictionaryNullValue(diction,@"winCode") atIndex:i];
    }
    
    NSInteger startNum = 0;
    NSInteger endNum = 0;
    if ([self.lotTitle isEqualToString:kLotTitleSSQ])
    {
        startNum = 1;
        endNum = 16;
    }
    
    else if ([self.lotTitle isEqualToString:kLotTitleDLT])
    {
        startNum = 1;
        endNum = 12;
    }
    else if ([self.lotTitle isEqualToString:kLotTitleQLC])
    {
        startNum = 1;
        endNum = 30;
    }
    
    m_blueTrendView.isRedView = NO;
    [m_blueTrendView setBallShow:self.lotTitle isRed:NO];
    [m_blueTrendView setBlueNumberList:startNum  endNum:endNum];
}

- (void)setlotteryInterface
{
    m_lotteryDataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, (int)[UIScreen mainScreen].bounds.size.height - 95-20)];
	[self.myTableView setRowHeight:90];
	[self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    [self.view addSubview:m_myTableView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 95, 320, REFRESH_HEADER_HEIGHT)];
    [self.myTableView addSubview:refreshView];
    refreshView.myScrollView = self.myTableView;
    [refreshView stopLoading:NO];
    m_myTableView.hidden = YES;
}




#pragma mark 消息处理
- (void)updateLottery:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].lotteryInformation];
    [jsonParser release];
    
    //    if(buttonIndex != 3)
    //    {
    //        self.detailScroll.hidden = YES;
    //        m_shareButton.hidden = YES;
    //        self.myTableView.hidden = YES;
    //    }
    
    [self.trendDataArray removeAllObjects];
    [self.trendDataArray addObjectsFromArray:(NSArray*)[parserDict objectForKey:@"result"]];
    m_cellCount = [self.trendDataArray count];
    
    m_trendView = [[TrendView alloc] initWithFrame:CGRectMake(0, 0,winNoLabelWidth +  batchCodeLabelWidth +VRednumber * ballHeigth, m_cellCount * ballHeigth + ballHeigth + 40)];
    m_trendView.Vnumber = VRednumber;
    m_trendView.Hnumber = m_cellCount;
    [m_scrollView addSubview:m_trendView];
    
    m_blueTrendView = [[TrendView alloc] initWithFrame:CGRectMake(m_trendView.frame.size.width, 0, VBluenumber*ballHeigth, m_cellCount * ballHeigth + ballHeigth + 40)];
    m_blueTrendView.Vnumber = VBluenumber;
    m_blueTrendView.Hnumber = m_cellCount;
    [m_scrollView addSubview:m_blueTrendView];
    //    m_blueTrendView.hidden = YES;
    
    [self setRedTrendInterface];
    [self setBlueTrendInterface];
    self.scrollView.contentSize = CGSizeMake(m_trendView.frame.size.width + m_blueTrendView.frame.size.width, m_cellCount * ballHeigth + ballHeigth + 40);
}

- (void)GetLotteryArardInfoDetailOK:(NSNotification*)notification
{
    [self setDetailView];
    //    [self orientationDidChange:nil];
}

- (void)updateLotteryList:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].lotteryInfoList];
    [jsonParser release];
    
    //    self.detailScroll.hidden = YES;
    //    m_shareButton.hidden = YES;
    //    self.scrollView.hidden = YES;
    
    m_totalPageCount = [[parserDict objectForKey:@"totalPage"] intValue];
    
    [self.lotteryDataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    m_curPageIndex++;
    [self.myTableView reloadData];
    
    if(m_curPageIndex == m_totalPageCount)
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [refreshView setRefreshViewFrame];
}

- (void)refreshLotteryAwardInfo
{
    self.navigationItem.title = [[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo] stringByAppendingString:@"开奖中心"];
}

#pragma mark 微信分享
-(void) onCancelText
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) onCompleteText:(NSString*)nsText
{
    [self dismissModalViewControllerAnimated:YES];
    m_nsLastText = nsText;
    if (_delegate)
    {
        [_delegate sendTextContent:m_nsLastText] ;
    }
}


#pragma mark -
#pragma mark 显示微博界面的代理方法
- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


#pragma mark 短信分享

- (void)phoneMessage:(id)sender
{
    //    [MobClick event:@"openPage_share_tengxun"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    
    [self sendsms:[NSString stringWithFormat:@"@博雅彩，%@第%@期的开奖号码为：%@。下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"],[parserDict objectForKey:@"winNo"],KAppWapDoload]];
    
}

- (void)displaySMS:(NSString*)message
{
    MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate=self;
    //    picker.navigationBar.tintColor= [UIColor redColor];
    [picker.navigationController.navigationBar setBackground];
    picker.body= message;// 默认信息内容
    
    // 默认收件人(可多个)
    //    NSArray *numArray = [m_numTextView.text componentsSeparatedByString:@","];
    //    picker.recipients = numArray;
    //    picker.recipients = [NSArray arrayWithObjects:@"13161962673", nil];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}



- (void)sendsms:(NSString*)message
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    NSLog(@"can send SMS [%d]", [messageClass canSendText]);
    NSLog(@"infor:%@",message);
    if(messageClass !=nil)
    {
        if([messageClass canSendText])
        {
            [self displaySMS:message];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"设备没有短信功能!" withTitle:@"提示" buttonTitle:@"确定"];
        }
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"iOS版本过低，iOS4.0以上才支持程序内发送短信" withTitle:@"提示" buttonTitle:@"确定"];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"tel:::: %@", controller.recipients);
    NSString* msg;
    switch(result) {
        case MessageComposeResultCancelled:
            msg =@"发送取消";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        case MessageComposeResultSent:
            msg =@"已发送";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        case MessageComposeResultFailed:
            msg =@"发送失败";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}
#pragma mark 跳转到选球页面
- (void)goLotteryButtonClick:(id)sender
{
    [self forceShuPing];
    //    if (m_backButton)
    //    {
    //        [m_backButton removeFromSuperview];
    //        [m_backButton release];
    //    }
    //    [MobClick event:@"openPage_go_bet"];
    
    if(!self.isGoLottery)
    {
        if (m_isPushShow)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

}

#pragma mark -
#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.lotteryDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    LotteryAwardInfoTableViewCell *cell = (LotteryAwardInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
        cell = [[[LotteryAwardInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    
    NSDictionary* subDict = (NSDictionary*)[self.lotteryDataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",subDict);
    cell.lotTitle = self.lotTitle;
    cell.batchCode = [subDict objectForKey:@"batchCode"];
    cell.winNo = [subDict objectForKey:@"winCode"];
    cell.dateStr = [subDict objectForKey:@"openTime"];
 

    
    if([cell.lotTitle isEqual: kLotTitleFC3D])
    {
        cell.tryCode = [subDict objectForKey:@"tryCode"];
    }
    [cell refresh];
    
    if([[CommonRecordStatus commonRecordStatusManager] isHeighLotTitle:self.lotTitle] || [self.lotTitle isEqualToString:kLotTitleSFC] || [self.lotTitle isEqualToString:kLotTitleRX9] || [self.lotTitle isEqualToString:kLotTitle6CB] || [self.lotTitle isEqualToString:kLotTitleJQC] || [self.lotTitle isEqualToString:kLotTitleJCLQ] || [self.lotTitle isEqualToString:kLotTitleJCZQ])
    {
        [cell.accessoryBtn setHidden:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        isHasDetailView = NO;
    }
    else
    {
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.accessoryBtn setHidden:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        isHasDetailView = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isHasDetailView)
    {
        //        if(m_backButton)
        //        {
        //            [m_backButton removeFromSuperview];
        //            [m_backButton release];
        //        }
        [self setHidesBottomBarWhenPushed:YES];
        
        NSDictionary* subDict = (NSDictionary*)[self.lotteryDataArray objectAtIndex:indexPath.row];
        HistoryLotDetailViewController*   viewController = [[HistoryLotDetailViewController alloc] init];
        viewController.title = @"开奖详情";
        viewController.delegate = self;
        viewController.lotNo = self.lotNo;
        viewController.lotTitle = self.lotTitle;
        viewController.batchCode = [subDict objectForKey:@"batchCode"];
        
        //        [self forceShuPing];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.myTableView)
    {
        NSLog(@"%f", scrollView.contentOffset.y);
        if(m_curPageIndex == 0)
        {
            refreshView.viewMaxY = 0;
        }
        else
        {
            if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeRight)//倒屏
            {
                refreshView.viewMaxY = 476 + (self.myTableView.rowHeight) * 10 * (m_curPageIndex - 1);
            }
            else
                refreshView.viewMaxY = m_myTableView.contentSize.height - m_myTableView.frame.size.height;
        }
        [refreshView viewdidScroll:scrollView];
    }
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.myTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == self.myTableView)
    {
        //        if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeRight)//倒屏
        //        {
        //            refreshView.viewMaxY = 476 + (self.myTableView.rowHeight) * 10 * (m_curPageIndex - 1);
        //        }
        [refreshView didEndDragging:scrollView];
    }
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex <= m_totalPageCount)//从1开始记录页码
    {
        [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:[NSString stringWithFormat:@"%d", (m_curPageIndex + 1)] lotNo:self.lotNo];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}


- (void)orientationDidChange:(NSNotification*)notification//设备方向更改
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)//系统版本
    {
        return;
    }
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeLeft)
    {
        //旋转状态栏：
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        
        //旋转视图
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.navigationController.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        //        self.navigationController.view.bounds = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.height, 320.0);
        
        [UIView commitAnimations];
        [self setViewHengFrame];
    }
    else if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeRight)
    {////////左
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        //旋转视图
        
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.navigationController.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        //        self.navigationController.view.bounds = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.height, 320.0);
        //        self.navigationController.wantsFullScreenLayout = YES;
        
        [UIView commitAnimations];
        [self setViewHengFrame];
    }
    else if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait||[[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {/////////上下
        //旋转状态栏：
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        //旋转视图
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.navigationController.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        //        self.navigationController.view.bounds = CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height);
        
        [UIView commitAnimations];
        [self setViewShuFrame];
    }
    [refreshView setRefreshViewFrame];
}
@end
