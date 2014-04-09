//
//  LotteryOrderAndShow.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-7-17.
//
//

#import "LotteryOrderAndShowCommander.h"
#import "RuYiCaiCommon.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"

@interface LotteryOrderAndShowCommander()

@end

@implementation LotteryOrderAndShowCommander

-(void)dealloc{
    [super dealloc];
}

-(id)init{
    if (self = [super init]) {
    
    }
    return self;
}


-(void)orderAndIsShowFrom:(NSDictionary *)lotStateDic{
    
    NSTrace();
    //存储显示彩种的位置
    NSMutableArray *showLotteryArr = [NSMutableArray array];
    //记录服务器位置信息
    NSMutableDictionary *showLotteryInServersDic = [NSMutableDictionary dictionary];

    

    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleFC3D]
                        lotTitleNo:kLotTitleFC3D];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleSSQ]
                        lotTitleNo:kLotTitleSSQ];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleDLT]
                        lotTitleNo:kLotTitleDLT];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleJCZQ]
                        lotTitleNo:kLotTitleJCZQ];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleBJDC]
                        lotTitleNo:kLotTitleBJDC];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleNMK3]
                        lotTitleNo:kLotTitleNMK3];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleCQ11X5]
                        lotTitleNo:kLotTitleCQ11X5];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitle11YDJ]
                        lotTitleNo:kLotTitle11YDJ];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitle11X5]
                        lotTitleNo:kLotTitle11X5];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleSSC]
                        lotTitleNo:kLotTitleSSC];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleKLSF]
                        lotTitleNo:kLotTitleKLSF];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleGD115]
                        lotTitleNo:kLotTitleGD115];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleQLC]
                        lotTitleNo:kLotTitleQLC];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitlePLS]
                        lotTitleNo:kLotTitlePLS];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitlePL5]
                        lotTitleNo:kLotTitlePL5];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleQXC]
                        lotTitleNo:kLotTitleQXC];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleZC]
                        lotTitleNo:kLotTitleZC];

    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleJCLQ]
                        lotTitleNo:kLotTitleJCLQ];
    [self saveLotterySiteInServers:showLotteryInServersDic
                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitleCQSF]
                        lotTitleNo:kLotTitleCQSF];
//    [self saveLotterySiteInServers:showLotteryInServersDic
//                             index:[self getLotterySiteOfServers:lotStateDic withLotteryNo:kLotTitle22_5]
//                        lotTitleNo:kLotTitle22_5];

    
    
    //排序彩种顺序
    NSArray *sortedArray = [[showLotteryInServersDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for(int i = 0; i < [sortedArray count]; i++)
        
    {
        
        [showLotteryArr addObject:[showLotteryInServersDic objectForKey:[sortedArray objectAtIndex:i]]];
    }
    
    
    //保存新版本中文名顺序
    NSMutableDictionary *lotteryNameOrderDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i< [showLotteryArr count]; i++) {
        NSString *lotteryName =[[CommonRecordStatus commonRecordStatusManager]lotNameWithLotTitle:[showLotteryArr objectAtIndex:i]];
        
        
        [lotteryNameOrderDic setValue:[NSString stringWithFormat:@"%d",i] forKey:lotteryName];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:lotteryNameOrderDic forKey:kDefultLotteryShowDicKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
    
    
    
    //获取本地用户配置的显示彩种
    NSMutableArray *showLotteryInLothostArr = [NSMutableArray array];
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
        showLotteryInLothostArr = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showLotteryInLothostArr = [[NSMutableArray alloc] initWithArray:mutableArr];
    }
    
    
    
    //保存彩种
    NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<[showLotteryArr count]; i++) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        BOOL hasLotHost = NO;
        //遍历本地保存彩种 如果本地已经设置隐藏，则继续隐藏
        for (int j = 0; j< [showLotteryInLothostArr count]; j++) {
            
            NSMutableDictionary *lothostDic = [showLotteryInLothostArr objectAtIndex:j];
            
            if ([[lothostDic allKeys]count] == 0) {
                
                hasLotHost = YES;
                [tempDic setObject:@"1" forKey:[showLotteryArr objectAtIndex:i]];
            }else{
                if ([[showLotteryArr objectAtIndex:i] isEqual:[[lothostDic allKeys]objectAtIndex:0]]) {
                    
                    if ([[lothostDic objectForKey:[showLotteryArr objectAtIndex:i]] isEqual:@"0"]) {
                        
                        hasLotHost = YES;
                        [tempDic setObject:@"0" forKey:[showLotteryArr objectAtIndex:i]];
                    }else{

                        hasLotHost = YES;
                        [tempDic setObject:@"1" forKey:[showLotteryArr objectAtIndex:i]];
                    }
                }
            }
        }
        if (!hasLotHost) {
            
            [tempDic setObject:@"1" forKey:[showLotteryArr objectAtIndex:i]];
        }
        [tempArray addObject:tempDic];
    }
    

    
//    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:kLotteryShowDicKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}


- (NSString *)getLotterySiteOfServers:(NSDictionary *)dic withLotteryNo:(NSString *)lotTitleNo {
    
    NSString *lotNo = [[CommonRecordStatus commonRecordStatusManager]lotNoWithLotTitle:lotTitleNo];
    if(![KISDictionaryHaveKey(dic, lotNo) isEqual:@""]) {

        NSDictionary *lotDic = [NSDictionary dictionary];
        lotDic = KISDictionaryHaveKey(dic, lotNo);
        
        if([[lotDic objectForKey:@"saleState"] isEqual:@"1"]){
            
            NSString *index = [lotDic objectForKey:@"order"];

            
            return index;
        }
    }
    return @"";
}

- (void) saveLotterySiteInServers:(NSMutableDictionary *)dic index:(NSString *)index lotTitleNo:(NSString *)lotTitleNo{
    if (![index isEqual:@""]) {
        [dic setObject:lotTitleNo forKey:index];
    }
}

@end
