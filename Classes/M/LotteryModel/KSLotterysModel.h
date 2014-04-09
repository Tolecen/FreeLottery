//
//  KSLotterysModel.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import <Foundation/Foundation.h>
#import "KSLotteryModel.h"

typedef enum _PLAY_STYLE_TYPE{
    
    HE_ZHI_PALY_STYLE = 0,//和值玩儿法
    SAN_TONG_HAO_PALY_STYLE ,//三同号
    SAN_TONG_HAO_DAN_XUAN_PALY_STYLE ,//三同号单选
    SAN_TONG_HAO_TONG_XUAN_PALY_STYLE ,//三同号通选
    ER_TONG_HAO_DAN_XUAN_PALY_STYLE ,//二同号单选
    ER_TONG_HAO_FU_XUAN_PALY_STYLE ,//二同号复选
    SAN_BU_TONG_HAO_PALY_STYLE ,//三不同号
    SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE ,//三连号通选
    ER_BU_TONG_HAO_PALY_STYLE ,//二不同号
    
    SAN_BU_TONG_HAO_DAN_PALY_STYLE ,//三不同号-胆拖
    ER_BU_TONG_HAO_DAN_PALY_STYLE ,//二不同号-胆拖
    
}PLAY_STYLE_TYPE;

@interface KSLotterysModel : NSObject

@property (nonatomic, retain) NSMutableArray *lotterys;

@property (nonatomic,retain) NSMutableArray * stateArray;

@property (nonatomic,retain) NSString * betCodeString;

@property (nonatomic,retain) NSString * amountString;

@property (nonatomic, assign) PLAY_STYLE_TYPE playStyle;

@property (nonatomic, assign) BOOL isRemoveLotterys;

@property (nonatomic,retain) NSString * betNumberString;
@property (nonatomic,retain) NSString * betSumStrimng;


+(KSLotterysModel *)shareWithPlayStyle:(PLAY_STYLE_TYPE)type;
-(id)initWithPlayStyle:(PLAY_STYLE_TYPE)type;
-(void)addLottery:(KSLotteryModel *)lotterModel;
-(void)updateLottery:(KSLotteryModel *)lotterModel;
-(void)removeLotter:(KSLotteryModel *)lotterModel;
-(void)removeAll;
-(NSArray *)getLotters;


-(NSInteger)getNormalLottersCount;//获取单选号码注数
-(NSInteger)getCombinationLotterysCount;//获取组合号码注数

@end
