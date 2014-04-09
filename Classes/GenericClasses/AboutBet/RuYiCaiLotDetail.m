//
//  RuYiCaiLotDetail.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiLotDetail.h"

static RuYiCaiLotDetail *s_lotDetail = NULL;

@implementation RuYiCaiLotDetail

@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
@synthesize batchNum = m_batchNum;
@synthesize betCode = m_betCode;
@synthesize moreZuBetCode = m_moreZuBetCode;
@synthesize disBetCode = m_disBetCode;
@synthesize lotNo = m_lotNo;
@synthesize lotMulti = m_lotMulti;
@synthesize amount = m_amount;
@synthesize betType = m_betType;
@synthesize sellWay = m_sellWay;
@synthesize toMobileCode = m_toMobileCode;
@synthesize advice = m_advice;
@synthesize zhuShuNum = m_zhuShuNum;
@synthesize prizeend = m_prizeend;
@synthesize oneAmount = m_oneAmount;

@synthesize isShouYiLv = m_isShouYiLv;

@synthesize moreZuAmount = m_moreZuAmount;
@synthesize subscribeInfo = m_subscribeInfo;

@synthesize moreBetCodeInfor = m_moreBetCodeInfor;
@synthesize moreDisBetCodeInfor = m_moreDisBetCodeInfor;

@synthesize giftContentStr = m_giftContentStr;

@synthesize isDLTOr11X2 = m_isDLTOr11X2;

#pragma mark RuYiCai LotDetail initialization

- (id)init
{
	if (self = [super init])
    {
        m_moreBetCodeInfor = [[NSMutableArray alloc] init];
        m_moreDisBetCodeInfor = [[NSMutableArray alloc] init];
        
        m_batchCode = @"";
        m_batchEndTime = @"";
        m_batchNum = @"";
        m_betCode = @"";
        m_disBetCode = @"";
        m_lotNo = @"";
        m_lotMulti = @"";
        m_amount = @"";
        m_betType = @"";
        m_sellWay = @"";
        m_toMobileCode = @"";
        m_advice = @"";
        m_zhuShuNum = @"";
        m_prizeend = @"";
        m_oneAmount = @"";
        m_moreZuBetCode = @"";
        m_moreZuAmount = @"";
        m_subscribeInfo = @"";
        m_giftContentStr = @"";
        
        m_isDLTOr11X2 = YES;
    }
    return self;
}

+ (RuYiCaiLotDetail*)sharedObject
{
    @synchronized(self) 
    {
		if (s_lotDetail == nil) 
		{
			[[self alloc] init];  //assignment not done here
		}
	}
	return s_lotDetail;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_lotDetail == nil) 
		{
			s_lotDetail = [super allocWithZone:zone];
            
			return s_lotDetail;  //assignment and return on first allocation
		}
	}	
	return nil;  //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release 
{
	//do nothing
}

- (id)autorelease 
{
	return self;
}

@end