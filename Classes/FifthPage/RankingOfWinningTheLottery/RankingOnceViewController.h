//
//  RankingOnceViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-5-13.
//
//

#import <UIKit/UIKit.h>
typedef enum _RankingType{
    rankingOfWeekType = 0,
    RankingOfMouthType,
    RankingOfTotalType
    
}RankingType;

@interface RankingOnceViewController : UIViewController
{
    RankingType _rankingType;
}

@property (nonatomic, assign) RankingType rankingType;

-(id)initWithRankingType:(RankingType)type;

@end
