//
//  KSBettingLotteryInterface.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-2.
//
//

#import <Foundation/Foundation.h>

@protocol KSBettingLotteryDelegate <NSObject>


//实现摇一摇
- (void)bettingLotteryViewMotionEnded;
//实现遗漏处理
- (void)bettingLotteryViewShowYiLou:(BOOL)isShow;
//清空号码蓝
- (void)cleanUpLotteryBasket;

@end
