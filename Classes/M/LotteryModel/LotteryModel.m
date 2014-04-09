//
//  LotteryModel.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import "LotteryModel.h"

@implementation LotteryModel

@synthesize lotteryNum = _lotteryNum,description;

-(void)setLotteryNum:(NSString *)n{
    
    if (_lotteryNum != n) {
        [_lotteryNum release];
        _lotteryNum = n;
        [_lotteryNum retain];
    }

}

-(void)setDescription:(NSString *)n{
    description = n;
}


@end
