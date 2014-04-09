//
//  LotteryDetailBigView.m
//  RuYiCai
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LotteryDetailBigView.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "WinNoView.h"
#import "LotteryDetailView.h"
#import "ColorUtils.h"
#import "NSLog.h"

#define YellowImgTag  (123)
#define GrayImgTag    (124)
#define TableGrayTag  (125)
#define SecondTitleImgTag  (126)
#define ListLabelTag  (127)
#define DetailTableTag (200)

@implementation LotteryDetailBigView

@synthesize winLotTitle = m_winLotTitle;
@synthesize caizhongLable = m_caizhongLable;

- (void)dealloc
{
    [m_caizhongLable release];
    [m_jiangXianScroll release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

- (void)setDetailView
{    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    UIImageView  *topImage = [[UIImageView alloc] initWithImage:RYCImageNamed(@"kjxq_c_topbg.png")];
    topImage.frame = CGRectMake(10, 0, 300, 160);
    topImage.tag = YellowImgTag;
    [self addSubview:topImage];
    
    
    m_caizhongLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 30)];
    

    [m_caizhongLable setFont:[UIFont systemFontOfSize:15]];
    [m_caizhongLable setTextColor:[UIColor blackColor]];
    m_caizhongLable.backgroundColor = [UIColor clearColor];
    [topImage addSubview:m_caizhongLable];
    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 30)];
    titleLabel.text = [NSString stringWithFormat:@"第%@期", [parserDict objectForKey:@"batchCode"]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor blackColor]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [topImage addSubview:titleLabel];
    [titleLabel release];
    
    

    UILabel  *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40-5, 300, 30)];
    timeLabel.text = [NSString stringWithFormat:@"开奖日期：%@", [parserDict objectForKey:@"openTime"]];
    [timeLabel setFont:[UIFont systemFontOfSize:15]];
    [timeLabel setTextColor:[UIColor blackColor]];
    timeLabel.backgroundColor = [UIColor clearColor];
    [topImage addSubview:timeLabel];
    [timeLabel release];
    WinNoView* winCellView = [[WinNoView alloc] initWithFrame:CGRectZero];
    
    if ([self.winLotTitle isEqualToString:kLotTitleFC3D])
    {
       [winCellView showFC3DWinNo:[parserDict objectForKey:@"winNo"] ofType:self.winLotTitle withTryCode:[parserDict objectForKey:@"tryCode"] withTryCodeBatchCode:[parserDict objectForKey:@"tryCodeBatchCode"]];
    }else
    {
        [winCellView showWinNo:[parserDict objectForKey:@"winNo"] ofType:self.winLotTitle withTryCode:[parserDict objectForKey:@"tryCode"]];
    }
    
    
    CGRect oldFrame = winCellView.frame;
    winCellView.frame = CGRectMake(10, 70, oldFrame.size.width, oldFrame.size.height);
    [topImage addSubview:winCellView];
    [winCellView release];
    
    
//    UIImageView  *midImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 105, 310, 50)];
//    midImage.image = RYCImageNamed(@"gray_bg.png");
//    midImage.tag = GrayImgTag;
//    [self addSubview:midImage];
    
    UILabel  *sellTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 95-5, 300, 30)];
    sellTotalLabel.text = [NSString stringWithFormat:@"本期销量：%llu元", [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100];
    [sellTotalLabel setFont:[UIFont systemFontOfSize:15]];
    [sellTotalLabel setTextColor:[UIColor blackColor]];
    sellTotalLabel.backgroundColor = [UIColor clearColor];
    [topImage addSubview:sellTotalLabel];
    [sellTotalLabel release];
    
    if(kLotTitleSSQ == self.winLotTitle || kLotTitleDLT == self.winLotTitle || kLotTitleFC3D == self.winLotTitle || kLotTitleQLC == self.winLotTitle || kLotTitleQXC == self.winLotTitle || kLotTitle22_5 == self.winLotTitle)
    {
        UILabel  *prizePoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 300, 30)];
        prizePoolLabel.text = [NSString stringWithFormat:@"奖池滚存：%llu元", [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100];
        [prizePoolLabel setFont:[UIFont systemFontOfSize:15]];
        [prizePoolLabel setTextColor:[UIColor blackColor]];
        prizePoolLabel.backgroundColor = [UIColor clearColor];
        [topImage addSubview:prizePoolLabel];
        [prizePoolLabel release];
    }
    [topImage release];
    
//    UIImageView  *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 155, 310, 30)];
//    oneImage.image = RYCImageNamed(@"second_title_bg.png");
//    oneImage.tag = SecondTitleImgTag;
//    [self addSubview:oneImage];
   
    UIView  *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 170-5, 320, 30)];
    oneView.backgroundColor = [ColorUtils parseColorFromRGB:@"#B34848"];
    oneView.tag = SecondTitleImgTag;
    [self addSubview:oneView];
    
    
    UILabel  *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    tLabel.text = @"中奖详细";
    [tLabel setFont:[UIFont systemFontOfSize:15]];
    [tLabel setTextColor:[UIColor whiteColor]];
    tLabel.backgroundColor = [UIColor clearColor];
    [oneView addSubview:tLabel];
    [tLabel release];
    [oneView release];
    
    UIImageView  *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200-5, 320, 27)];
    twoImage.image = RYCImageNamed(@"zjxq_qutou.png");
    twoImage.tag = TableGrayTag;
    [self addSubview:twoImage];
    [twoImage release];
    
//    UILabel  *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 201-5, 320, 35)];
//    listLabel.text = @"   奖项       中奖注数（注）   单注金额（元）";
//    [listLabel setFont:[UIFont systemFontOfSize:15]]; 
//    [listLabel setTextColor:[UIColor blackColor]];
//    listLabel.backgroundColor = [ColorUtils parseColorFromRGB:@"#EFC9C9"];
//    listLabel.tag = ListLabelTag;
//    [self addSubview:listLabel];
//    [listLabel release];
    
    [self setWinTable];
}

- (void)setNewFrame
{
    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeRight)//倒屏
    {
        [self viewWithTag:YellowImgTag].frame = CGRectMake(5, 5, 470, 100);
        [self viewWithTag:GrayImgTag].frame = CGRectMake(5, 105, 470, 50);
        [self viewWithTag:TableGrayTag].frame = CGRectMake(5, 185, 470, 35);
        [self viewWithTag:SecondTitleImgTag].frame = CGRectMake(5, 155, 470, 30);
        [self viewWithTag:ListLabelTag].frame = CGRectMake(10, 185, 460, 35);
        [(UILabel*)[self viewWithTag:ListLabelTag] setText:@"       奖项                      中奖注数（注）                 单注金额（元）"];
    }
    else
    {
        [self viewWithTag:YellowImgTag].frame = CGRectMake(5, 5, 310, 100);
        [self viewWithTag:GrayImgTag].frame = CGRectMake(5, 105, 310, 50);
        [self viewWithTag:TableGrayTag].frame = CGRectMake(5, 185, 310, 35);
        [self viewWithTag:SecondTitleImgTag].frame = CGRectMake(5, 155, 310, 30);
        [self viewWithTag:ListLabelTag].frame = CGRectMake(10, 185, 300, 35);
        [(UILabel*)[self viewWithTag:ListLabelTag] setText:@"   奖项        中奖注数（注）   单注金额（元）"];
    }
    for (int i = 0; i < m_jiangXiangCount; i++)
    {
        [(LotteryDetailView*)[self viewWithTag:DetailTableTag + i] setJXNewFrame];
    }
}

- (void)setWinTable
{
    float  view_heigth = self.frame.size.height;
    m_jiangXianScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 223, 480, view_heigth - 236)];
//    m_jiangXianScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 220, 480, view_heigth - 257)];

    m_jiangXianScroll.directionalLockEnabled = YES;
    m_jiangXianScroll.backgroundColor = [UIColor clearColor];
    m_jiangXianScroll.showsHorizontalScrollIndicator = NO;
    m_jiangXianScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:m_jiangXianScroll];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    //验证网络数据存在
    if (!parserDict) {
        return;
    }
    
    NSMutableArray *jiangXiangArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *zhuShuArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *winAccountArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    if ([self.winLotTitle isEqualToString:kLotTitleSSQ])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"二等奖"];
        [jiangXiangArr addObject: @"三等奖"];
        [jiangXiangArr addObject: @"四等奖"];
        [jiangXiangArr addObject: @"五等奖"];
        [jiangXiangArr addObject: @"六等奖"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fourPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fivePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sixPrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fourPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fivePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sixPrizeAmt"]];
    }
    else if ([self.winLotTitle isEqualToString:kLotTitleFC3D] || [self.winLotTitle isEqualToString:kLotTitlePLS])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"组三"];
        [jiangXiangArr addObject: @"组六"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];
    }
    else if ([self.winLotTitle isEqualToString:kLotTitleDLT])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"二等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"三等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"四等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"五等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"六等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"七等奖"];
        [jiangXiangArr addObject: @"追加"];
        [jiangXiangArr addObject: @"八等奖"];
        [jiangXiangArr addObject: @"12选2"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fourPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fourPrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fivePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fivePrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sixPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sixPrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sevenPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sevenPrizeZJNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"eightPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twelveSelect2PrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fourPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fourPrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fivePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fivePrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sixPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sixPrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sevenPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sevenPrizeZJAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"eightPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twelveSelect2PrizeAmt"]];
        
    }
    else if ([self.winLotTitle isEqualToString:kLotTitleQLC])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"二等奖"];
        [jiangXiangArr addObject: @"三等奖"];
        [jiangXiangArr addObject: @"四等奖"];
        [jiangXiangArr addObject: @"五等奖"];
        [jiangXiangArr addObject: @"六等奖"];
        [jiangXiangArr addObject: @"七等奖"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fourPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fivePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sixPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sevenPrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fourPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fivePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sixPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sevenPrizeAmt"]];
        
    }
    else if ([self.winLotTitle isEqualToString:kLotTitlePL5])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
    }
    else if ([self.winLotTitle isEqualToString:kLotTitleQXC])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"二等奖"];
        [jiangXiangArr addObject: @"三等奖"];
        [jiangXiangArr addObject: @"四等奖"];
        [jiangXiangArr addObject: @"五等奖"];
        [jiangXiangArr addObject: @"六等奖"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fourPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"fivePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"sixPrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fourPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"fivePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"sixPrizeAmt"]];
    }
    else if([self.winLotTitle isEqualToString:kLotTitle22_5])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"二等奖"];
        [jiangXiangArr addObject: @"三等奖"];
        
        [zhuShuArr addObject:[parserDict objectForKey:@"onePrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"twoPrizeNum"]];
        [zhuShuArr addObject:[parserDict objectForKey:@"threePrizeNum"]];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"threePrizeAmt"]];

    }
    else if([self.winLotTitle isEqualToString:kLotTitleSFC])
    {
        [jiangXiangArr addObject: @"一等奖"];
        [jiangXiangArr addObject: @"二等奖"];
        
        [zhuShuArr addObject:KISDictionaryHaveKey(parserDict, @"onePrizeNum")];
        [zhuShuArr addObject:KISDictionaryHaveKey(parserDict, @"twoPrizeNum")];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
        [winAccountArr addObject:[parserDict objectForKey:@"twoPrizeAmt"]];
    }
    else if([self.winLotTitle isEqualToString:kLotTitleRX9] || [self.winLotTitle isEqualToString:kLotTitleJQC] || [self.winLotTitle isEqualToString:kLotTitle6CB])
    {
        [jiangXiangArr addObject: @"一等奖"];
        
        [zhuShuArr addObject:KISDictionaryHaveKey(parserDict, @"onePrizeNum")];
        
        [winAccountArr addObject:[parserDict objectForKey:@"onePrizeAmt"]];
    }
    m_jiangXiangCount = [jiangXiangArr count];
    
    for(int i = 0; i < [jiangXiangArr count]; i++)
    {
        LotteryDetailView *detailView = [[LotteryDetailView alloc] initWithFrame:CGRectMake(0, i * 30, 480, 30)];
        [m_jiangXianScroll addSubview:detailView];
        detailView.backgroundColor = [ColorUtils parseColorFromRGB:@"#F5F5F5"];
        detailView.jiangXiang = [jiangXiangArr objectAtIndex:i];
        detailView.winZhuShu = [zhuShuArr objectAtIndex:i];
        detailView.winAccountStr = [winAccountArr objectAtIndex:i];
        detailView.tag = DetailTableTag + i;
        [detailView refeshView];
        [detailView release];
    }
    m_jiangXianScroll.contentSize = CGSizeMake(480, [jiangXiangArr count] * 30);
    [jiangXiangArr release];
    [zhuShuArr release];
    [winAccountArr release];
}

@end
