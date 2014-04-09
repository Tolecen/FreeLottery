//
//  BetCompleteViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-5-30.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    TYPE_BASE = 0,
    TYPE_BET,
    TYPE_HM,
    TYPE_GIFT,
    TYPE_LAUNCHHM,
}ViewType;

@interface BetCompleteViewController : UIViewController

@property(nonatomic, retain)NSString*    allAmount;
@property(nonatomic, assign)ViewType     viewType;

@end
