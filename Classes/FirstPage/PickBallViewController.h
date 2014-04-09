//
//  PickBallViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kBallRectWidth     (32)
#define kBallRectHeight    (32)
#define kBallWidth         (32)
#define kBallHeight        (32)

#define kBallTagBase       (1100)
#define kBallTitleFontSize (15)
#define kBallLineSpacing   (4)
#define kBallVerticalSpacing (2)

#define kSmallBallRectWidth       (28)
#define kSmallBallRectHeight      (28)
#define kSmallBallWidth           (28)
#define kSmallBallHeight          (28)

#define kYiLuoHeight        (15)
#define kLabelFont      (12)
#define kLabelStartTag  (200)

typedef enum ball_Type
{
	RED_BALL = 0,
	BLUE_BALL = 1
} ball_Type;

typedef enum ball_Size
{
    BIG_BALL = 0,
    SMALL_BALL = 1
}ball_Size;

typedef enum lView_Frame
{
    RIGHT_FRAME = 0,
    LEFT_FRAME = 1
}lView_Frame;

@interface PickBallViewController : UIViewController {
	NSMutableArray *m_ballState;
    int             m_ballSize;
	int             m_ballType;
    int             m_LViewFrame;
    
	int             m_selectNum;
	int             m_selectMaxNum;
	int             m_randomNumber;
	int             m_ballNum;  //total num of ball
	NSUInteger      m_numPerLine;
    int             m_startValue;
	
	UIView         *m_lBallCount;
	int             m_selectBallCount;
    
    BOOL            isHasYiLuo;
    
    NSInteger             labelCount;//遗落值 上轮创建得总label个数
}
@property (nonatomic, retain) NSMutableArray *ballState;
@property (nonatomic, assign) int m_selectBallCount;
@property (nonatomic, assign) BOOL isHasYiLuo;

- (void)createBallArray:(int)num withPerLine:(int)perLine startValue:(int)start selectBallCount:(int)count;
- (void)createBallArrayDxds:(int)num withPerLine:(int)perLine startValue:(int)start selectBallCount:(int)count;//大小双单
- (void)pressedBallButton:(UIButton*)ballButton;
- (int)ballNumPerLine;
- (void)setBallType:(int)type;
- (void)setBallSize:(int)size;
- (void)setLViewFrame:(int)frame;
- (void)setSelectMaxNum:(int)num;
- (int)getSelectNum;
- (void)randomBall:(int)maxNum;
- (void)clearBallState;
- (NSMutableArray*)selectedBallsArray;
- (NSArray*)selectedIndexArray;
- (BOOL)stateForIndex:(int)index;
- (void)resetStateForIndex:(int)index;

- (void)selectBallForStateArr:(NSArray*)stateArray;

@end

@interface PickBallViewController (PickBallViewController_category)//类别

- (void)bigTwoNumber:(NSArray*)dataA maxOne:(int*)maxOneIndex maxTwo:(int*)maxTwoIndex;
- (void)creatYiLuoViewWithData:(NSArray*)dataArr rowNumber:(NSInteger)rowNumber;

@end
