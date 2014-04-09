//
//  LotteryModel.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import <Foundation/Foundation.h>

@interface LotteryModel : NSObject

@property (nonatomic, readonly) NSString *lotteryNum;
@property (nonatomic, readonly) NSString *description;

-(void)setLotteryNum:(NSString *)n;

-(void)setDescription:(NSString *)n;

@end
