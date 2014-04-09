//
//  JZTableViewCell_DataBase.m
//  Boyacai
//
//  Created by qiushi on 13-9-6.
//
//

#import "JZCell_DataBaseModel.h"
#import "RuYiCaiCommon.h"

@implementation JZCell_DataBaseModel

@end

@implementation JZTableViewCell_DataBase
@synthesize indexpath = m_indexpath;
@synthesize dayTime = m_dayTime;
@synthesize dayforamt = m_dayForamt;
@synthesize league = m_league;
@synthesize endTime = m_endTime;
@synthesize homeTeam = m_homeTeam;
@synthesize VisitTeam = m_VisitTeam;
@synthesize week = m_week;

@synthesize teamld = m_teamld;
@synthesize weekld = m_weekld;
@synthesize v0 = m_v0;
@synthesize v1 = m_v1;
@synthesize v3 = m_v3;

@synthesize vf = m_vf;
@synthesize vp = m_vp;
@synthesize vs = m_vs;

@synthesize letPoint = m_letPoint;
@synthesize letVs_v0 = m_letVs_v0;
@synthesize letVs_v3 = m_letVs_v3;
@synthesize Big = m_Big;
@synthesize Small = m_Small;
@synthesize basePoint = m_basePoint;
@synthesize sfc_selectTag = m_sfc_selectTag;
@synthesize confusion_selectTag = m_confusion_selectTag;
@synthesize confusionButtonText = m_confusionButtonText;
@synthesize sfcV01 = m_sfcV01;
@synthesize sfcV02 = m_sfcV02;
@synthesize sfcV03 = m_sfcV03;
@synthesize sfcV04 = m_sfcV04;
@synthesize sfcV05 = m_sfcV05;
@synthesize sfcV06 = m_sfcV06;
@synthesize sfcV11 = m_sfcV11;
@synthesize sfcV12 = m_sfcV12;
@synthesize sfcV13 = m_sfcV13;
@synthesize sfcV14 = m_sfcV14;
@synthesize sfcV15 = m_sfcV15;
@synthesize sfcV16 = m_sfcV16;

@synthesize sxdsV1 = m_sxdsV1;
@synthesize sxdsV2 = m_sxdsV2;
@synthesize sxdsV3 = m_sxdsV3;
@synthesize sxdsV4 = m_sxdsV4;

@synthesize goalArray = m_goalArray;
@synthesize score_S_Array = m_score_S_Array;
@synthesize score_P_Array = m_score_P_Array;
@synthesize score_F_Array = m_score_F_Array;
@synthesize half_Array = m_half_Array;

@synthesize ZQ_S_ButtonIsSelect = m_ZQ_S_ButtonIsSelect;
@synthesize ZQ_P_ButtonIsSelect = m_ZQ_P_ButtonIsSelect;
@synthesize ZQ_F_ButtonIsSelect = m_ZQ_F_ButtonIsSelect;

@synthesize RQZQ_S_ButtonIsSelect = m_RQZQ_S_ButtonIsSelect;
@synthesize RQZQ_P_ButtonIsSelect = m_RQZQ_P_ButtonIsSelect;
@synthesize RQZQ_F_ButtonIsSelect = m_RQZQ_F_ButtonIsSelect;

@synthesize BD_SD_ButtonIsSelect, BD_SS_ButtonIsSelect, BD_XD_ButtonIsSelect, BD_XS_ButtonIsSelect;

@synthesize isUnSupportArry = m_isUnSupportArray;
@synthesize isExpend = m_isExpend;


- (id)init {
    self = [super init];
    if (self)
    {
        m_isExpend = NO;
        m_sfc_selectTag = [[NSMutableArray alloc] initWithCapacity:10];
        
        m_confusion_selectTag = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray* array1 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array2 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array3 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array4 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array5 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        [self.confusion_selectTag addObject:array1];
        [self.confusion_selectTag addObject:array2];
        [self.confusion_selectTag addObject:array3];
        [self.confusion_selectTag addObject:array4];
        [self.confusion_selectTag addObject:array5];
        
        m_goalArray = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_S_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_P_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_F_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_half_Array = [[NSMutableArray alloc] initWithCapacity:10];
        
        m_isUnSupportArray = [[NSMutableArray alloc] initWithCapacity:10];
        m_JC_DanIsSelect = NO;
    }
    return self;
}

- (void)dealloc {
    
    [m_sfc_selectTag release];
    [m_confusion_selectTag release];
    [m_goalArray release];
    [m_score_S_Array release];
    [m_score_P_Array release];
    [m_score_F_Array release];
    [m_half_Array release];
    [m_indexpath release];
    
    [m_isUnSupportArray release];
    [super dealloc];
}

-(BOOL) visitTeamIsSelect
{
    return m_visitTeamIsSelect;
}
-(BOOL) homeTeamIsSelect
{
    return m_homeTeamIsSelect;
}
-(BOOL) JC_DanIsSelect
{
    return m_JC_DanIsSelect;
}
-(void) setJC_DanIsSelect:(BOOL)JC_DanIsSelect
{
    m_JC_DanIsSelect = JC_DanIsSelect;
}

-(void) setVisitTeamIsSelect:(BOOL)visitTeamIsSelect
{
    m_visitTeamIsSelect = visitTeamIsSelect;
}
-(void) setHomeTeamIsSelect:(BOOL)homeTeamIsSelect
{
    m_homeTeamIsSelect = homeTeamIsSelect;
}

- (BOOL)isSelectThisMatch:(int)playType
{
    switch (playType) {
        case IBJDCPlayType_SXDS:
            if (BD_SD_ButtonIsSelect || BD_SS_ButtonIsSelect || BD_XD_ButtonIsSelect || BD_XS_ButtonIsSelect)
                return YES;
            break;
        default:
            break;
    }
    return NO;
}

-(void) appendToBaseUnSupportDuiZhen:(NSString*)lotNo
{
    NSArray* Array =  [lotNo componentsSeparatedByString:@"_"];
    if ([Array count] == 2)
    {
        NSString *lotNo = [Array objectAtIndex:0];
        NSString *typeValue = [Array objectAtIndex:1];
        //0 单关 1多关
        if ([@"0" isEqual:typeValue])
        {
            if ([kLotNoJCLQ_SF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SF_DanGuan]];
            }
            else if([kLotNoJCLQ_RF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_LetPoint_DanGuan]];
            }
            else if([kLotNoJCLQ_SFC isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SFC_DanGuan]];
            }
            else if([kLotNoJCLQ_DXF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_BigAndSmall_DanGuan]];
            }
            
            else if([kLotNoJCZQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_SPF_DanGuan]];
            }
            else if([kLotNoJCZQ_RQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_RQ_SPF_DanGuan]];
            }
            else if([kLotNoJCZQ_ZJQ isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_ZJQ_DanGuan]];
            }
            else if([kLotNoJCZQ_SCORE isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_Score_DanGuan]];
            }
            else if([kLotNoJCZQ_HALF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_HalfAndAll_DanGuan]];
            }
        }
        else if([@"1" isEqual:typeValue])
        {
            if ([kLotNoJCLQ_SF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SF]];
            }
            else if([kLotNoJCLQ_RF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_LetPoint]];
            }
            else if([kLotNoJCLQ_SFC isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SFC]];
            }
            else if([kLotNoJCLQ_DXF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_BigAndSmall]];
            }
            
            else if([kLotNoJCZQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_SPF]];
            }
            else if([kLotNoJCZQ_RQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_RQ_SPF]];
            }
            else if([kLotNoJCZQ_ZJQ isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_ZJQ]];
            }
            else if([kLotNoJCZQ_SCORE isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_Score]];
            }
            else if([kLotNoJCZQ_HALF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_HalfAndAll]];
            }
        }
    }
}
@end

/////////////////////////////////////////////////

@implementation JZTableViewCell_DataArray
@synthesize tableHeaderArray = m_tableHeaderArray;
- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_tableHeaderArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSInteger) baseCount
{
    return [m_tableHeaderArray count];
}
- (void)dealloc {
    [m_tableHeaderArray removeAllObjects];
    [m_tableHeaderArray release];
    [super dealloc];
}
@end