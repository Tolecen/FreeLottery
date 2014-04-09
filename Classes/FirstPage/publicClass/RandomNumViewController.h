//
//  RandomNumViewController.h
//  RuYiCai
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kNumButtonValue  (32)
//#define kButtonLineSpacing   (4)
//#define kButtonVerticalSpacing (6)
#define kNumButtonValue  (36)
#define kButtonLineSpacing   (0)
#define kButtonVerticalSpacing (0)

#define kButtonTagBase 233

typedef enum
{
    RANDOM_RED_BALL = 0,
    RANDOM_BLUE_BALL
    
} RandomBall;

@interface RandomNumViewController : UIView
{
    UIView*     numListView;
    
    UIButton*   numButton;
    
    NSInteger   startNum;
    NSInteger   numValue;
    
    CGRect      listFrame;
    CGRect      hiddenFrame;
    
    RandomBall randomBall;
}
@property (nonatomic,assign) RandomBall randomBall;

- (void)createNumBallList:(int)num withPerLine:(int)perLine startValue:(int)start withFrame:(CGRect)newframe;
- (void)createNumBallList:(int)num withPerLine:(int)perLine startValue:(int)start  withFrame:(CGRect)newframe andBallType:(RandomBall)type ;
- (void)pressedNumButton:(id)sender;
- (void)jiXuanButtonClick:(id)sender;
- (void)numButtonClick:(id)sender;

@end
