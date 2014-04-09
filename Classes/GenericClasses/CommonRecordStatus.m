//
//  CommonRecordStatus.m 
//  RuYiCai
// 
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
/*
 记录常用 的状态值
 
 */

#import "CommonRecordStatus.h"
#import "SBJsonParser.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "ColorUtils.h"
@interface CommonRecordStatus (internal)

@end

@implementation CommonRecordStatus

@synthesize remmberQuitStatus = m_remmberQuitStatus;
@synthesize isGetCashOK = m_isGetCashOK;
@synthesize startImageId = m_startImageId;
@synthesize startImage = m_startImage;
@synthesize useStartImage = m_useStartImage;
@synthesize useADImageIds = m_useADImageIds;
@synthesize useADImage = m_useADtImage;
@synthesize useADImages = m_useADImages;

@synthesize netMissDate = m_netMissDate;
  
@synthesize deviceToken = m_deviceToken;
@synthesize chargeWarnStr = m_chargeWarnStr;

@synthesize topActionDic = m_topActionDic;
@synthesize sampleNetStr = m_sampleNetStr;

@synthesize resultWarn = m_resultWarn;

@synthesize QueryBetlotNO = m_QueryBetlotNO;

@synthesize loginWay = m_loginWay;

@synthesize lotteryInfor = m_lotteryInfor;
@synthesize inProgressActivityCount = m_inProgressActivityCount;

@synthesize changeWay = m_changeWay;

static CommonRecordStatus *s_commonRecordStatusManager = NULL;

- (id)init
{
    self = [super init];
    if (self) 
    {
        //初始化 状态值
        m_remmberQuitStatus = NO;
        m_isGetCashOK = NO;
        m_useStartImage = NO;//默认使用本地开机图片
        m_useADtImage = NO;//默认使用本地开机图片
        
        m_startImageId = @"";
        m_netMissDate = @"";
        m_chargeWarnStr = @"";
        m_sampleNetStr = @"";
        m_deviceToken = @"";
        m_resultWarn = @"";
        m_loginWay = kNormalLogin;
        
        m_lotteryInfor = @"";
        
        m_inProgressActivityCount = @"0";
        
        m_changeWay = 0;
    }
    return self;
}

+ (CommonRecordStatus *)commonRecordStatusManager
{
    @synchronized(self) 
    {
		if (s_commonRecordStatusManager == nil) 
		{
			s_commonRecordStatusManager = [[self alloc] init];
		}
	}
	return s_commonRecordStatusManager;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_commonRecordStatusManager == nil) 
		{
			s_commonRecordStatusManager = [super allocWithZone:zone];
			return s_commonRecordStatusManager;   
		}
	}
    
	return nil;   
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)initADimage{
    self.useADImageIds = [NSMutableDictionary dictionary];
    [self.useADImageIds setObject:@"1" forKey:@"1"];
    [self.useADImageIds setObject:@"2" forKey:@"2"];
//    [self.useADImageIds setObject:@"3" forKey:@"3"];
//    [self.useADImageIds setObject:@"4" forKey:@"4"];
    
    NSData *imageData1 = UIImagePNGRepresentation([UIImage imageNamed:@"ad_c2_Img_1.png"]);
    NSData *imageData2 = UIImagePNGRepresentation([UIImage imageNamed:@"ad_c2_Img_2.png"]);
//    NSData *imageData3 = UIImagePNGRepresentation([UIImage imageNamed:@"ad_c2_Img_3.png"]);
//    NSData *imageData4 = UIImagePNGRepresentation([UIImage imageNamed:@"ad_c2_Img_4.png"]);
    
    self.useADImages = [NSMutableDictionary dictionary];
    [self.useADImages setObject:imageData1 forKey:@"1"];
    [self.useADImages setObject:imageData2 forKey:@"2"];
//    [self.useADImages setObject:imageData3 forKey:@"3"];
//    [self.useADImages setObject:imageData4 forKey:@"4"];
}
#pragma mark 是否为高频彩
- (BOOL)isHeighLot:(NSString*)lotNo
{
    if ([lotNo isEqualToString:kLotNoSSC])
        return YES;
    else if ([lotNo isEqualToString:kLotNo115])
        return YES;
    else if ([lotNo isEqualToString:kLotNoGD115])
        return YES;
    else if ([lotNo isEqualToString:kLotNo11YDJ])
        return YES;
    else if ([lotNo isEqualToString:kLotNoKLSF])
        return YES;
    else if ([lotNo isEqualToString:kLotNoCQSF])
        return YES;
    else if ([lotNo isEqualToString:kLotNoNMK3])
        return YES;
    else if ([lotNo isEqualToString:kLotNoCQ115])
        return YES;
    else
        return NO;
}

- (BOOL)isHeighLotTitle:(NSString*)lotTitle
{
    if ([lotTitle isEqualToString:kLotTitleSSC])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitle11X5])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleGD115])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitle11YDJ])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleKLSF])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleNMK3])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleCQ11X5])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleCQSF])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitlePK10])
        return YES;
    else if ([lotTitle isEqualToString:kLotTitleJXSSC])
        return YES;
    else
        return NO;
}



- (NSString*)lotNoWithLotTitle:(NSString*)lotTitle
{
    if ([lotTitle isEqualToString:kLotTitleSSQ])
        return kLotNoSSQ;
    else if ([lotTitle isEqualToString:kLotTitleFC3D])
        return kLotNoFC3D;
    else if ([lotTitle isEqualToString:kLotTitleDLT])
        return kLotNoDLT;
    else if ([lotTitle isEqualToString:kLotTitleQLC])
        return kLotNoQLC;
    else if ([lotTitle isEqualToString:kLotTitlePLS])
        return kLotNoPLS;
    else if ([lotTitle isEqualToString:kLotTitleZC])
        return kLotNoZC;
    else if ([lotTitle isEqualToString:kLotTitlePL5])
        return kLotNoPL5;
    else if ([lotTitle isEqualToString:kLotTitleQXC])
        return kLotNoQXC;
    else if ([lotTitle isEqualToString:kLotTitleSSC])
        return kLotNoSSC;
    else if ([lotTitle isEqualToString:kLotTitle22_5])
        return kLotNo22_5;
    else if ([lotTitle isEqualToString:kLotTitle11X5])
        return kLotNo115;
    else if ([lotTitle isEqualToString:kLotTitleGD115])
        return kLotNoGD115;
    else if ([lotTitle isEqualToString:kLotTitle11YDJ])
        return kLotNo11YDJ;
    else if ([lotTitle isEqualToString:kLotTitleJCLQ])
        return kLotNoJCLQ;
    else if ([lotTitle isEqualToString:kLotTitleJCZQ])
        return kLotNoJCZQ;
    else if ([lotTitle isEqualToString:kLotTitleKLSF])
        return kLotNoKLSF;
    else if ([lotTitle isEqualToString:kLotTitleNMK3])
        return kLotNoNMK3;
    else if ([lotTitle isEqualToString:kLotTitleBJDC])
        return kLotNoBJDC;
    else if ([lotTitle isEqualToString:kLotTitleCQ11X5])
        return kLotNoCQ115;
    else if ([lotTitle isEqualToString:kLotTitleCQSF])
        return kLotNoCQSF;
    else
        return @"";
}


- (NSString*)lotNameWithLotNo:(NSString*)lotNo
{
    if ([lotNo isEqualToString:kLotNoSSQ])
         return @"双色球";
    else if ([lotNo isEqualToString:kLotNoFC3D])
         return @"福彩3D";
    else if ([lotNo isEqualToString:kLotNoDLT])
         return @"大乐透";
    else if ([lotNo isEqualToString:kLotNoQLC])
         return @"七乐彩";
    else if ([lotNo isEqualToString:kLotNoPLS])
         return @"排列三";
    else if ([lotNo isEqualToString:kLotNoSFC])
         return @"胜负彩";
    else if ([lotNo isEqualToString:kLotNoRX9])
         return @"任选九";
    else if ([lotNo isEqualToString:kLotNoJQC])
         return @"进球彩";
    else if ([lotNo isEqualToString:kLotNoLCB])
         return @"六场半";
    else if ([lotNo isEqualToString:kLotNoPL5])
         return @"排列五";
    else if ([lotNo isEqualToString:kLotNoQXC])
         return @"七星彩";
    else if ([lotNo isEqualToString:kLotNoSSC])
         return @"时时彩";
//    else if ([lotNo isEqualToString:kLotNo22_5])
//         return @"22选5";
    else if ([lotNo isEqualToString:kLotNo115])
         return @"江西11选5";
    else if ([lotNo isEqualToString:kLotNoGD115])
         return @"广东11选5";
    else if ([lotNo isEqualToString:kLotNo11YDJ])
         return @"十一运夺金";
    else if ([lotNo isEqualToString:kLotNoJCLQ])
        return @"竞彩篮球";
    else if ([lotNo isEqualToString:kLotNoJCLQ_CONFUSION])
        return @"竞彩混合篮球";
    else if ([lotNo isEqualToString: kLotNoJCZQ])
        return @"竞彩足球";
    else if ([lotNo isEqualToString:kLotNoJCZQ_CONFUSION])
        return @"竞彩混合足球";
    else if ([lotNo isEqualToString: kLotNoJCLQ_SF])
        return @"竞彩篮球胜负";
    else if ([lotNo isEqualToString: kLotNoJCLQ_RF])
        return @"竞彩篮球让分胜负";
    else if ([lotNo isEqualToString: kLotNoJCLQ_SFC])
        return @"竞彩篮球胜分差";
    else if ([lotNo isEqualToString: kLotNoJCLQ_DXF])
        return @"竞彩篮球大小分";
    else if ([lotNo isEqualToString: kLotNoJCZQ_RQ_SPF])
        return @"竞彩足球让球胜平负";
    else if ([lotNo isEqualToString: kLotNoJCZQ_SPF])
        return @"竞彩足球胜平负";
    else if ([lotNo isEqualToString: kLotNoJCZQ_ZJQ])
        return @"竞彩足球总进球数";
    else if ([lotNo isEqualToString: kLotNoJCZQ_SCORE])
        return @"竞彩足球比分";
    else if ([lotNo isEqualToString: kLotNoJCZQ_HALF])
        return @"竞彩足球半全场";
    else if ([lotNo isEqualToString: kLotNoKLSF])
        return @"广东快乐十分";
    else if ([lotNo isEqualToString: kLotNoNMK3])
        return @"快三";
    else if ([lotNo isEqualToString: kLotNoBJDC])
        return @"北京单场";
    else if ([lotNo isEqualToString: kLotNoBJDC_RQSPF])
        return @"北京单场让球胜平负";
    else if ([lotNo isEqualToString: kLotNoBJDC_JQS])
        return @"北京单场总进球";
    else if ([lotNo isEqualToString: kLotNoBJDC_Score])
        return @"北京单场比分";
    else if ([lotNo isEqualToString: kLotNoBJDC_HalfAndAll])
        return @"北京单场半全场";
    else if ([lotNo isEqualToString: kLotNoBJDC_SXDS])
        return @"北京单场上下单双";
    else if ([lotNo isEqualToString: kLotNoZC])
        return @"足彩";
    else if ([lotNo isEqualToString: kLotNoCQ115])
        return @"重庆11选5";
    else if ([lotNo isEqualToString: kLotNoCQSF])
        return @"重庆快乐十分";
    else
         return @"";
}

- (NSString*)lotNameWithLotTitle:(NSString*)lotTitle
{
    if ([lotTitle isEqualToString:kLotTitleSSQ])
        return @"双色球";
    else if ([lotTitle isEqualToString:kLotTitleFC3D])
        return @"福彩3D";
    else if ([lotTitle isEqualToString:kLotTitleDLT])
        return @"大乐透";
    else if ([lotTitle isEqualToString:kLotTitleQLC])
        return @"七乐彩";
    else if ([lotTitle isEqualToString:kLotTitlePLS])
        return @"排列三";
    else if ([lotTitle isEqualToString:kLotTitleZC])
        return @"足彩";
    else if ([lotTitle isEqualToString:kLotTitleSFC])
        return @"胜负彩";
    else if ([lotTitle isEqualToString:kLotTitleRX9])
        return @"任选九";
    else if ([lotTitle isEqualToString:kLotTitleJQC])
        return @"进球彩";
    else if ([lotTitle isEqualToString:kLotTitle6CB])
        return @"六场半";
    else if ([lotTitle isEqualToString:kLotTitlePL5])
        return @"排列五";
    else if ([lotTitle isEqualToString:kLotTitleQXC])
        return @"七星彩";
    else if ([lotTitle isEqualToString:kLotTitleSSC])
        return @"时时彩";
//    else if ([lotTitle isEqualToString:kLotTitle22_5])
//        return @"22选5";
    else if ([lotTitle isEqualToString:kLotTitle11X5])
        return @"江西11选5";
    else if ([lotTitle isEqualToString:kLotTitleGD115])
        return @"广东11选5";
    else if ([lotTitle isEqualToString:kLotTitle11YDJ])
        return @"十一运夺金";
    else if ([lotTitle isEqualToString:kLotTitleJCLQ])
        return @"竞彩篮球";
    else if ([lotTitle isEqualToString:kLotTitleJCZQ])
        return @"竞彩足球";
    else if ([lotTitle isEqualToString:kLotTitleJCLQ_SF])
        return @"竞彩篮球胜负";
    else if ([lotTitle isEqualToString:kLotTitleJCLQ_RF])
        return @"竞彩篮球让分胜负";
    else if ([lotTitle isEqualToString:kLotTitleJCLQ_SFC])
        return @"竞彩篮球胜分差";
    else if ([lotTitle isEqualToString:kLotTitleJCLQ_DXF])
        return @"竞彩篮球大小分";
    else if ([lotTitle isEqualToString:kLotTitleKLSF])
        return @"广东快乐十分";
    else if ([lotTitle isEqualToString:kLotTitleHM])
        return @"合买大厅";
    else if ([lotTitle isEqualToString:kLotTitleZJJH])
        return @"专家荐号";
    else if ([lotTitle isEqualToString:kLotTitleXYXH])
        return @"幸运选号";
    else if ([lotTitle isEqualToString:kLotTitleNMK3])
        return @"快三";
    else if ([lotTitle isEqualToString:kLotTitleBJDC])
        return @"北京单场";
    else if ([lotTitle isEqualToString:kLotTitleCQ11X5])
        return @"重庆11选5";
    else if ([lotTitle isEqualToString:kLotTitleCQSF])
        return @"重庆快乐十分";
    else
        return @"";
}

- (void)setPayStationArray{
    NSMutableArray *psArr = [NSMutableArray array];
    

    
    NSMutableDictionary *aqzfbDic = [NSMutableDictionary dictionary];
    [aqzfbDic setObject:@"aqzfb" forKey:@"keyStr"];
    [aqzfbDic setObject:@"安全便捷，免输入密码，支持银行卡充值" forKey:@"description"];
    [aqzfbDic setObject:@"手机支付宝" forKey:@"title"];
    [psArr addObject:aqzfbDic];
    
    NSMutableDictionary *ldysDic = [NSMutableDictionary dictionary];
    [ldysDic setObject:@"ldys" forKey:@"keyStr"];
    [ldysDic setObject:@"信用卡充值支持大多数银行，无限额" forKey:@"description"];
    [ldysDic setObject:@"信用卡充值" forKey:@"title"];
    [psArr addObject:ldysDic];
    
    NSMutableDictionary *ylczDic = [NSMutableDictionary dictionary];
    [ylczDic setObject:@"ylcz" forKey:@"keyStr"];
    [ylczDic setObject:@"支持借记卡和信用卡充值，免开通网银" forKey:@"description"];
    [ylczDic setObject:@"银联充值" forKey:@"title"];
    [psArr addObject:ylczDic];
    
    NSMutableDictionary *ylyyDic = [NSMutableDictionary dictionary];
    [ylyyDic setObject:@"ylyy" forKey:@"keyStr"];
    [ylyyDic setObject:@"使用银联DNA手机支付，支持各大银行" forKey:@"description"];
    [ylyyDic setObject:@"易联语音支付" forKey:@"title"];
    [psArr addObject:ylyyDic];
    
    NSMutableDictionary *cftczDic = [NSMutableDictionary dictionary];
    [cftczDic setObject:@"cftcz" forKey:@"keyStr"];
    [cftczDic setObject:@"财付通财付通，免开通网银" forKey:@"description"];
    [cftczDic setObject:@"财付通" forKey:@"title"];
    [psArr addObject:cftczDic];
    

    

    
    NSMutableDictionary *sjczkDic = [NSMutableDictionary dictionary];
    [sjczkDic setObject:@"sjczk" forKey:@"keyStr"];
    [sjczkDic setObject:@"支持联通、移动、电信充值卡" forKey:@"description"];
    [sjczkDic setObject:@"手机充值卡充值" forKey:@"title"];
    [psArr addObject:sjczkDic];
    
//    NSMutableDictionary *zfbwapDic = [NSMutableDictionary dictionary];
//    [zfbwapDic setObject:@"zfbwap" forKey:@"keyStr"];
//    [zfbwapDic setObject:@"支持借记卡和信用卡充值，免开通网银" forKey:@"description"];
//    [zfbwapDic setObject:@"支付宝wap充值" forKey:@"title"];
//    [psArr addObject:zfbwapDic];
    
    NSMutableDictionary *yhzzDic = [NSMutableDictionary dictionary];
    [yhzzDic setObject:@"yhzz" forKey:@"keyStr"];
    [yhzzDic setObject:@"通过银行柜台、ATM或者网上银行转账" forKey:@"description"];
    [yhzzDic setObject:@"银行转账" forKey:@"title"];
    [psArr addObject:yhzzDic];
    

    
    [[NSUserDefaults standardUserDefaults] setObject:psArr forKey:kPayStationShowKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}
#pragma mark 彩种显示数组初始化（安装后第一次进入时，之后若无值时调用）
- (void)setLotShowArray
{
    NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
    for(int i = 0; i < LotCount; i++)
    {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        switch (i)
        {
            case 0:
                [tempDic setObject:@"1" forKey:kLotTitleHM];
                break;
            case 1:
                [tempDic setObject:@"1" forKey:kLotTitleSSQ];
                break;
            case 2:
                [tempDic setObject:@"1" forKey:kLotTitleDLT];
                break;
            case 3:
                [tempDic setObject:@"1" forKey:kLotTitleFC3D];
                break;
            case 4:
                [tempDic setObject:@"1" forKey:kLotTitle11YDJ];
                break;
            case 5:
                [tempDic setObject:@"1" forKey:kLotTitleSSC];
                break;


            default:
                break;
        }
        [tempArray addObject:tempDic];
        [tempDic release];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:kLotShowDicKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}

- (void)setLotteryShowArray
{
    NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
    for(int i = 0; i < LotteryCount; i++)
    {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        switch (i)
        {
            case 0:
                [tempDic setObject:@"1" forKey:kLotTitleSSQ];
                break;
            case 1:
                [tempDic setObject:@"1" forKey:kLotTitleDLT];
                break;
            case 2:
                [tempDic setObject:@"1" forKey:kLotTitleFC3D];
                break;
            case 3:
                [tempDic setObject:@"1" forKey:kLotTitle11YDJ];
                break;
            case 4:
                [tempDic setObject:@"1" forKey:kLotTitleSSC];
                break;
            default:
                break;
        }
        [tempArray addObject:tempDic];
        [tempDic release];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:kLotteryShowDicKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}
- (void)defaultOrderLottery{
    NSMutableDictionary *orderLottery = [NSMutableDictionary dictionary];
    
    [orderLottery setValue:@"0" forKey: @"双色球"];
    [orderLottery setValue:@"1" forKey: @"大乐透"];
    [orderLottery setValue:@"2" forKey: @"福彩3D"];
    [orderLottery setValue:@"3" forKey: @"竞彩足球"];
    [orderLottery setValue:@"4" forKey: @"北京单场"];
    [orderLottery setValue:@"5" forKey: @"快三"];
    [orderLottery setValue:@"6" forKey: @"重庆11选5"];
    [orderLottery setValue:@"7" forKey: @"十一运夺金"];
    [orderLottery setValue:@"8" forKey: @"江西11选5"];
    [orderLottery setValue:@"9" forKey: @"时时彩"];
    [orderLottery setValue:@"10" forKey: @"广东快乐十分"];
    [orderLottery setValue:@"11" forKey: @"广东11选5"];
    [orderLottery setValue:@"12" forKey: @"七乐彩"];
    [orderLottery setValue:@"13" forKey: @"排列三"];
    [orderLottery setValue:@"14" forKey: @"排列五"];
    [orderLottery setValue:@"15" forKey: @"七星彩"];
//    [orderLottery setValue:@"15" forKey: @"22选5"];
    [orderLottery setValue:@"16" forKey: @"足彩"];
    [orderLottery setValue:@"17" forKey: @"竞彩篮球"];
    [orderLottery setValue:@"18" forKey: @"重庆快乐十分"];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:orderLottery forKey:kDefultLotteryShowDicKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}

#pragma mark 购买彩种提醒（安装后第一次进入时，之后若无值时调用）
- (void)setLottoryBetWarnDic
{
    NSMutableDictionary*  tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey];
    if(!tempDic)
    {
        NSMutableDictionary*  dataDic = [[NSMutableDictionary alloc] init];
        [dataDic setObject:@"19:00" forKey:kLotteryBetWarnTimeKey];
        [dataDic setObject:@"0" forKey:kLotteryBetWarnSongKey];
        [dataDic setObject:@"0" forKey:kLotTitleSSQ];
        [dataDic setObject:@"0" forKey:kLotTitleDLT];
        [dataDic setObject:@"0" forKey:kLotTitleFC3D];
        [dataDic setObject:@"0" forKey:kLotTitleQLC];
        [dataDic setObject:@"0" forKey:kLotTitleQXC];
        [dataDic setObject:@"0" forKey:kLotTitlePLS];
        [dataDic setObject:@"0" forKey:kLotTitlePL5];
        [dataDic setObject:@"0" forKey:kLotTitle22_5];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:kLotteryBetWarnKey];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
        
        [dataDic release];
    }
}

#pragma mark 清楚投注数据
- (void)clearBetData
{
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
    
    [RuYiCaiLotDetail sharedObject].batchCode = @"";
    [RuYiCaiLotDetail sharedObject].batchEndTime = @"";
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].betCode = @"";
    [RuYiCaiLotDetail sharedObject].disBetCode = @"";
    [RuYiCaiLotDetail sharedObject].lotNo = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = @"";
    [RuYiCaiLotDetail sharedObject].amount = @"";
    [RuYiCaiLotDetail sharedObject].betType = @"";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    [RuYiCaiLotDetail sharedObject].advice = @"";
    [RuYiCaiLotDetail sharedObject].zhuShuNum = @"";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].oneAmount = @"";
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    [RuYiCaiLotDetail sharedObject].moreZuAmount = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].giftContentStr = @"";
}

#pragma mark 选球页面右上角的view
- (UIImageView*)creatFourButtonView
{
    UIImageView* imgBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 160)]  autorelease];
    imgBg.image = RYCImageNamed(@"jcchooselist_4.png");
    [imgBg setBackgroundColor:[UIColor clearColor]];
    return imgBg;
}
- (UIImageView*)creatThreeButtonView
{
    UIImageView* imgBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 120)]  autorelease];
    imgBg.image = RYCImageNamed(@"tzy_xlmenu_bg.png");
    [imgBg setBackgroundColor:[UIColor clearColor]];
    return imgBg;
}

- (UIButton*)creatIntroButton:(CGRect)rect
{
    UIButton* introButton = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *intro_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    intro_icon.image = RYCImageNamed(@"tzy_wfjs_icon.png");
    [introButton addSubview:intro_icon];
    [intro_icon release];
    introButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [introButton setBackgroundImage:RYCImageNamed(@"tzy_xlmenu_hov_bg.png") forState:UIControlStateHighlighted];
    [introButton setTitle:@"玩法介绍" forState:UIControlStateNormal];
    [introButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return introButton;
    
}


- (UIButton*)creatNewIntroButton:(CGRect)rect
{
    UIButton* introButton = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    //    UIImageView *intro_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    //    intro_icon.image = RYCImageNamed(@"tzy_wfjs_icon.png");
    //    [introButton addSubview:intro_icon];
    //    [intro_icon release];
    //    introButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    //    [introButton setBackgroundImage:RYCImageNamed(@"tzy_xlmenu_hov_bg.png") forState:UIControlStateHighlighted];
    [introButton setTitle:@"玩法介绍" forState:UIControlStateNormal];
    [introButton setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea" ] forState:UIControlStateNormal];
    [introButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#095854"]];
    introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return introButton;
    
}


- (UIButton*)creatJSButton:(CGRect)rect
{
    UIButton* scoreButton  = [[[UIButton alloc] initWithFrame:rect] autorelease];
    UIImageView *scoreButton_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    scoreButton_icon.image = RYCImageNamed(@"jcnowscore_ico.png");
    [scoreButton addSubview:scoreButton_icon];
    [scoreButton_icon release];
    
    scoreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [scoreButton setBackgroundImage:RYCImageNamed(@"tzy_xlmenu_hov_bg.png") forState:UIControlStateHighlighted];
    [scoreButton setTitle:@"即时比分" forState:UIControlStateNormal];
    [scoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
    return scoreButton;
}

- (UIButton*)creatHistoryButton:(CGRect)rect
{
    UIButton* historyButton  = [[[UIButton alloc] initWithFrame:rect] autorelease];
    UIImageView *history_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    history_icon.image = RYCImageNamed(@"tzy_lskj_icon.png");
    [historyButton addSubview:history_icon];
    [history_icon release];
    
    historyButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [historyButton setBackgroundImage:RYCImageNamed(@"tzy_xlmenu_hov_bg.png") forState:UIControlStateHighlighted];
    [historyButton setTitle:@"历史开奖" forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
    return historyButton; 
}

- (UIButton*)creatQuerybetLotButton:(CGRect)rect
{
    UIButton* QuerybetLotButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *QuerybetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    QuerybetLot_icon.image = RYCImageNamed(@"tzy_tzcx_icon.png");
    [QuerybetLotButton addSubview:QuerybetLot_icon];
    [QuerybetLot_icon release];
    QuerybetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [QuerybetLotButton setBackgroundImage:RYCImageNamed(@"tzy_xlmenu_hov_bg.png") forState:UIControlStateHighlighted];
    [QuerybetLotButton setTitle:@"投注查询" forState:UIControlStateNormal];
    [QuerybetLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    QuerybetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return QuerybetLotButton;
}


- (UIButton*)creatNewQuerybetLotButton:(CGRect)rect
{
    UIButton* QuerybetLotButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
//    UIImageView *QuerybetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
//    QuerybetLot_icon.image = RYCImageNamed(@"tzy_tzcx_icon.png");
//    [QuerybetLotButton addSubview:QuerybetLot_icon];
//    [QuerybetLot_icon release];
//    QuerybetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [QuerybetLotButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#095854"]];
    [QuerybetLotButton setTitle:@"投注查询" forState:UIControlStateNormal];
    [QuerybetLotButton setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
    QuerybetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return QuerybetLotButton;
}

- (UIButton*)creatLuckButton:(CGRect)rect
{
    UIButton* QuerybetLotButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *QuerybetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    QuerybetLot_icon.image = RYCImageNamed(@"luckbuttonico.png");
    [QuerybetLotButton addSubview:QuerybetLot_icon];
    [QuerybetLot_icon release];
    QuerybetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [QuerybetLotButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [QuerybetLotButton setTitle:@"幸运选号" forState:UIControlStateNormal];
    [QuerybetLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    QuerybetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
 
    return QuerybetLotButton;
}

- (UIButton*)creatAnalogNumButton:(CGRect)rect//模拟选号
{
    UIButton* AnalogNumButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *AnalogNum_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    AnalogNum_icon.image = RYCImageNamed(@"analog_num_ico.png");
    [AnalogNumButton addSubview:AnalogNum_icon];
    [AnalogNum_icon release];
    AnalogNumButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [AnalogNumButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [AnalogNumButton setTitle:@"模拟选号" forState:UIControlStateNormal];
    [AnalogNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    AnalogNumButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return AnalogNumButton;
}

- (UIButton*)creatPresentSituButton:(CGRect)rect//开奖走势
{
    UIButton* PresentSituButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *PresentSitu_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    PresentSitu_icon.image = RYCImageNamed(@"present_situation_ico.png");
    [PresentSituButton addSubview:PresentSitu_icon];
    [PresentSitu_icon release];
    PresentSituButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [PresentSituButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [PresentSituButton setTitle:@"开奖走势" forState:UIControlStateNormal];
    [PresentSituButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PresentSituButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return PresentSituButton;
}

#pragma mark 第三方跳转
- (NSString*) getAppScheme:(NSString*)appTag
{
//    支付宝安全支付：
//    AppStore91_Alipay
//    RuYiCai91_Alipay
//    BoYaCai_Alipay
//    拉卡拉：
//    AppStore91_Lakala
//    RuYiCai91_Lakala
//    RuYiCai_Lakala
//    注意：appscheme 好像 不支持 下划线！！
    NSString *appScheme = @"";
    if([RuYiCaiOR91 isEqualToString:@"91"] && [appStoreORnormal isEqualToString:@"appStore"])
    {
        if ([appTag isEqualToString:KAppScheme_Alipay]) {
            appScheme = AppStore91_Alipay;
        }
        else if([appTag isEqualToString:KAppScheme_Lakala])
        {
            appScheme = AppStore91_Lakala;
        }
        else if([appTag isEqualToString:KAppScheme_Sina])
        {
            appScheme = AppStore91_Sina;
        }
        else if([appScheme isEqualToString:KAppScheme_WeiXin] )
        {
            appScheme = KAppScheme_WeiXin;
        }
        
    }
    else if([RuYiCaiOR91 isEqualToString:@"91"] && [appStoreORnormal isEqualToString:@"normal"])
    {
        if ([appTag isEqualToString:KAppScheme_Alipay]) {
            appScheme = RuYiCai91_Alipay;
        }
        else if([appTag isEqualToString:KAppScheme_Lakala])
        {
            appScheme = RuYiCai91_Lakala;
        }
        else if([appTag isEqualToString:KAppScheme_Sina])
        {
            appScheme = RuYiCai91_Sina;
        }
        else if([appScheme isEqualToString:KAppScheme_WeiXin] )
        {
            appScheme = KAppScheme_WeiXin;
        }
    }
    else
    {
        if ([appTag isEqualToString:KAppScheme_Alipay]) {
            appScheme = BoYaCai_Alipay;
        }
        else if([appTag isEqualToString:KAppScheme_Lakala])
        {
            appScheme = RuYiCai_Lakala;
        }
        else if([appTag isEqualToString:KAppScheme_Sina])
        {
            appScheme = BoYaCai_Sina;
        }
        else if([appScheme isEqualToString:KAppScheme_WeiXin] )
        {
            appScheme = KAppScheme_WeiXin;
        }
    }
    return appScheme;
}

- (NSString*) getZhifuAppTag:(NSString*)appScheme
{
   
    NSString* appTag = @"";
    if ([appScheme isEqualToString:AppStore91_Alipay] ||
        [appScheme isEqualToString:RuYiCai91_Alipay] ||
        [appScheme isEqualToString:BoYaCai_Alipay]
        ) {
        appTag = KAppScheme_Alipay;
    }
    else if([appScheme isEqualToString:AppStore91_Lakala] ||
            [appScheme isEqualToString:RuYiCai91_Lakala] ||
            [appScheme isEqualToString:RuYiCai_Lakala] )
    {
        appTag = KAppScheme_Lakala;
    }
    else if([appScheme isEqualToString:AppStore91_Sina] ||
            [appScheme isEqualToString:RuYiCai91_Sina] ||
            [appScheme isEqualToString:BoYaCai_Sina] )
    {
        appTag = KAppScheme_Sina;
    }
    else if([appScheme isEqualToString:BoYaCai_Tencent] )
    {
        appTag = KAppScheme_Tencent;
    }


    return appTag;
}

#pragma mark 计算字符串长度
-(NSUInteger) unicodeLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2)
    {
        unicodeLength++;
    }
    return unicodeLength;
}

-(NSUInteger) asciiLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

#pragma mark 控制输入框输入长度
- (NSString*)textMaxLengthWithString:(NSString*)oldString andLength:(NSInteger)maxLength
{
    if(oldString.integerValue >= maxLength)
    {
//        oldString = [oldString substringWithRange:NSMakeRange(0, oldString.length - 1)];
        oldString = [NSString stringWithFormat:@"%d",maxLength];
    }
    return oldString ;
}

@end
