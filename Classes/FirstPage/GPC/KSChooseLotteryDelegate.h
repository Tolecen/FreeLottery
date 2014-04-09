//
//  KSChooseLotteryDelegate.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-9.
//
//

#import <Foundation/Foundation.h>
#import "KSLotterysModel.h"
#import "KSBettingModel.h"
@protocol KSChooseLotteryDelegate <NSObject>

- (void)notifyObserverLotteryHasChange:(KSLotterysModel *)kSLotterysModel;
- (void)notifyObserverCombinationLotteryHasChange:(KSLotterysModel *)kSLotterysModel;
- (void)notifyObserverNormalAndCombinationLotteryHasChange:(KSLotterysModel *)kSLotterysModel andKSBettingModel:(KSBettingModel *)ksBettingModel;


- (void)notifyLotteryBasketHasChange:(KSBettingModel *)ksBettingModel;
- (void)notifyObserverRemoveObjects;
@end
