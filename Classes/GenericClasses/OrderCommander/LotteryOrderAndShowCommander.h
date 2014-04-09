//
//  LotteryOrderAndShow.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-7-17.
//
//

#import <Foundation/Foundation.h>

@interface LotteryOrderAndShowCommander : NSObject

//配置 彩票显示状态和顺序
-(void)orderAndIsShowFrom:(NSDictionary *)lotStateDic;
@end
