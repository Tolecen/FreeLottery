//
//  BuyLotteryTableViewCell.h
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-1-17.
//
//

#import <UIKit/UIKit.h>

typedef enum _TodayAddAwardOrOpenPrizeType {
	TodayNothing = 0,
    TodayAddAward ,
    TodayOpenPrize ,
    TodayAddAwardAndOpenPrize 
} TodayAddAwardOrOpenPrizeType;

@interface BuyLotteryTableViewCell : UITableViewCell
{
    UIImageView   *_iconImg;
    NSString      *_lotteryName;
    NSNumber      *_numStage;
    NSDate        *_time;
    NSString      *_endTime;
    NSString      *_kLotNoType;
    NSString      *_lotteryADContent;//彩种宣传语内容
    
    UILabel       *_lotteryLabel;
    UILabel       *_numStageLabel;
    UILabel       *_timeLabel;
    UILabel       *_lotteryAD;//彩种宣传语
    BOOL          _kaijiang;
    BOOL          _jiajiang;
    TodayAddAwardOrOpenPrizeType prizeType;
    //竞猜足球和竞猜篮球返奖率
    NSString       *_jzBackAwardLv;
    NSString       *_jlBackAwardLv;
    NSString       *_bdBackAwardLv;
    
}
@property (nonatomic, retain)NSString      *bdBackAwardLv;
@property (nonatomic, retain)NSString      *jzBackAwardLv;
@property (nonatomic, retain)NSString      *jlBackAwardLv;
@property (nonatomic, retain)UIImageView   *iconImg;
@property (nonatomic, retain)NSString      *lotteryName;
@property (nonatomic, retain)NSNumber      *numStage;
@property (nonatomic, retain)NSDate        *time;
@property (nonatomic, retain)NSString      *endTime;
@property (nonatomic, retain)NSString      *lotteryADContent;
@property (nonatomic, retain)NSString      *kLotNoType;

@property (nonatomic, retain)UILabel       *lotteryLabel;
@property (nonatomic, retain)UILabel       *numStageLabel;
@property (nonatomic, retain)UILabel       *timeLabel;
@property (nonatomic, retain)UILabel       *lotteryAD;
@property (nonatomic, assign)BOOL          kaijiang;
@property (nonatomic, assign)BOOL          jiajiang;
@property (nonatomic, assign)TodayAddAwardOrOpenPrizeType prizeType;
- (void)refreshDate;
@end
