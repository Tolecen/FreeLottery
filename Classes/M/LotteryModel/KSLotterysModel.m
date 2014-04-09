//
//  KSLotterysModel.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import "KSLotterysModel.h"
#import "Math.h"

@interface KSLotterysModel ()


@end

@implementation KSLotterysModel

@synthesize playStyle;
@synthesize lotterys;

+(KSLotterysModel *)shareWithPlayStyle:(PLAY_STYLE_TYPE)type{
    
//    static KSLotterysModel *sharedModel;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{ sharedModel = [KSLotterysModel new];});
//    return sharedModel;
    
    static NSMutableDictionary *kSLotterysModelDic;
    static dispatch_once_t dicToken;
    dispatch_once(&dicToken, ^{
        kSLotterysModelDic = [NSMutableDictionary new];
    });
    
    NSString *dicKey = [NSString stringWithFormat:@"PLAY_%d_TYPE",type];
    
    if (![kSLotterysModelDic objectForKey:dicKey]) {
        KSLotterysModel *sharedModel = [[KSLotterysModel alloc]initWithPlayStyle:type];
        [kSLotterysModelDic setObject:sharedModel forKey:dicKey];
    }
    
    return [kSLotterysModelDic objectForKey:dicKey];
}

-(id)init{
    if (self = [super init]) {
//        lotterys = [NSMutableArray new];
    }
    return self;
}
-(id)initWithPlayStyle:(PLAY_STYLE_TYPE)type{
    if (self = [super init]) {
        lotterys = [NSMutableArray new];
        playStyle = type;
        self.stateArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addLottery:(KSLotteryModel *)lotterModel{
    
    [lotterys addObject:lotterModel];
    
}



-(void)updateLottery:(KSLotteryModel *)lotterModel{
    
}
-(void)removeLotter:(KSLotteryModel *)lotterModel{

    [lotterys removeObject:lotterModel];

}


-(void)removeAll{
    [lotterys removeAllObjects];
}
-(NSArray *)getLotters{
    return lotterys;
}


-(NSInteger)getNormalLottersCount{
    return [lotterys count];
}
-(NSInteger)getCombinationLotterysCount{
    
    switch (playStyle) {

        case HE_ZHI_PALY_STYLE:
        case SAN_TONG_HAO_PALY_STYLE:
        case SAN_TONG_HAO_TONG_XUAN_PALY_STYLE:
        case SAN_TONG_HAO_DAN_XUAN_PALY_STYLE:
        case ER_TONG_HAO_FU_XUAN_PALY_STYLE:
        {
            int i = 0;
            for (KSLotteryModel *m in lotterys) {
                i++;
            }
            return i;
        }
            break;

        case ER_TONG_HAO_DAN_XUAN_PALY_STYLE:
        {
            int i = 0;
            int j = 0;
            for (KSLotteryModel *m in lotterys) {
                if ([m.group isEqualToString:@"1"]) i++;
                if ([m.group isEqualToString:@"2"]) j++;
            }
            return i * j;
        }
            break;

        case SAN_BU_TONG_HAO_PALY_STYLE:
        {
            int i = 0;
            for (KSLotteryModel *m in lotterys) {
                if ([m.group isEqualToString:@"1"]) i++;
            }
            NSInteger n = [Math combinationN:i M:3];
            return n;
        }
            break;
        case SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE:
        {
            int i = 0;
            for (KSLotteryModel *m in lotterys) {
                if ([m.group isEqualToString:@"1"]) i++;   
            }
            return i;
        }
            break;
        case ER_BU_TONG_HAO_PALY_STYLE:
        {
            int i = 0;
            for (KSLotteryModel *m in lotterys) {
                if ([m.group isEqualToString:@"1"]) i++;
            }
            NSInteger n = [Math combinationN:i M:2];
            return n;
        }
            break;
        case SAN_BU_TONG_HAO_DAN_PALY_STYLE:
        {
            
        }
            break;
        case ER_BU_TONG_HAO_DAN_PALY_STYLE:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}
@end
