//
//  TrendView.h
//  RuYiCai
//
//  Created by  on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define batchCodeLabelWidth (80)
#define winNoLabelWidth  (140)

@interface TrendView : UIView
{
    NSInteger    Hnumber;
    NSInteger    Vnumber;
    
    NSMutableArray    *m_batchCodeArray;
    NSMutableArray    *m_winNoArray;
    NSMutableArray    *m_tryCodeArray;
    
    NSMutableArray    *m_bluePointArray;
    BOOL         isRedBallLine;
    
    NSInteger    weiShu;
    
    BOOL         isRedView;
    
    NSString*    m_lotTitle;
}

@property (nonatomic, retain)NSMutableArray    *batchCodeArray;
@property (nonatomic, retain)NSMutableArray    *winNoArray;
@property (nonatomic, retain)NSMutableArray    *bluePointArray;
@property (nonatomic, retain)NSMutableArray    *tryCodeArray;
@property (nonatomic, assign)NSInteger Hnumber;
@property (nonatomic, assign)NSInteger Vnumber;
@property (nonatomic, assign)BOOL  isRedView;
@property (nonatomic, retain) NSString*    lotTitle;

- (void)setBetCodeList;
- (void)setWinNoListView:(NSString*)type;
- (void)setNumberList:(NSInteger)startNum  endNum:(NSInteger)endNum  blueNum:(NSInteger)blueNum type:(NSString*)type;
- (void)setBlueNumberList:(NSInteger)startNum  endNum:(NSInteger)endNum;
- (void)setBallShow:(NSString*)type isRed:(BOOL)isRed;
- (void)setFC3DTryCode;
@end
