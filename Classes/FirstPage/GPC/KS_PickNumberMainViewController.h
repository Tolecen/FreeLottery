//
//  KS_PickNumberMainViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-13.
//
//

#import <UIKit/UIKit.h>
#import "KSChooseLotteryDelegate.h"

typedef enum _PickNumType {
	PickNumHZ = 0,
    PickNumST,
    PickNumET,
    PickNumSBT,
    PickNumEBT,
} PickNumType;
@protocol SlidingRecognizerDelegate <NSObject>

-(void)swipeActionRecognized;

@end

@class KSPlayingStyleSupperViewController;

@interface KS_PickNumberMainViewController : UIViewController
{
    PickNumType _pickNumType;
    id <SlidingRecognizerDelegate> _delegate;
    id <KSChooseLotteryDelegate> _chooseLotteryDelegate;
}
@property (nonatomic, retain) KSPlayingStyleSupperViewController *ksPlayingStyleSupperViewController;
@property (nonatomic, assign) PickNumType pickType;
@property (nonatomic, assign) id <SlidingRecognizerDelegate> delegate;
@property (nonatomic, assign) id <KSChooseLotteryDelegate> chooseLotteryDelegate;
@property (nonatomic, assign) NSIndexPath * indexPath ;
-(void)motionEnded;
-(void)cleanUpLotteryBasketEvent;
-(IBAction)yaoYiYaoEvent:(id)sender;
-(void)setPickNumType:(PickNumType)n;

@end
