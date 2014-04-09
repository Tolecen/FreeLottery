//
//  KSPlayingStyleSupperViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-10.
//
//

#import <UIKit/UIKit.h>
#import "KSBettingLotteryDelegate.h"
#import "KSChooseLotteryDelegate.h"
#import "KSLotterysModel.h"
#import "KSBettingModel.h"

@protocol KSPlayingStyleSupperViewController

@required
-(void)setupChooseLotterView;//投票按钮界面
-(void)changeFrameByIsYiLou:(BOOL)yilou;//遗漏变换更改frame
-(void)notifyLotteryBasketHasChange:(KSBettingModel *)ksBettingModel;//选号篮变更通知
-(void)setupLotterMap;//M-V映射
@optional
-(void)notifyLotteryHasChange:(KSLotterysModel *)ksLotterysModel;//选号变更通知
-(void)notifyCombinationLotteryHasChange:(KSLotterysModel *)ksLotterysModel;//组合号码变更通知
-(void)notifyNoramlAndCombinationLotteryHasChange:(KSLotterysModel *)ksLotterysModel andKSBettingModel:(KSBettingModel *)ksBettingModel;//普通组合并存的号码通知
@end

@interface KSPlayingStyleSupperViewController : UIViewController <KSPlayingStyleSupperViewController,KSBettingLotteryDelegate>
{
    id <KSChooseLotteryDelegate> _chooseLotteryDelegate;
    NSMutableDictionary *_lotteryModelDic;
}
@property (nonatomic, assign) id <KSChooseLotteryDelegate> chooseLotteryDelegate;
@property (nonatomic, retain) NSMutableDictionary *lotteryModelDic;
@property (nonatomic,assign) NSIndexPath * indexPath;

@property (nonatomic,assign) BOOL isSelectedNumber;

-(void)changeKsBetingModelData;

- (void)getMissNumber:(NSString *)parserString;

@end
