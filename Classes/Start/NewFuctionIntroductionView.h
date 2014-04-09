//
//  NewFuctionIntroductionView.h
//  RuYiCai
//
//  Created by ruyicai on 12-4-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "StyledPageControl.h"
#import "RuYiCaiCommon.h"
#import "ActivityView.h"

@interface NewFuctionIntroductionView : UIView<UIScrollViewDelegate> {
    UIScrollView                    *m_scrollView;
    
    UIButton                        *m_startButton;
    RuYiCaiAppDelegate              *m_delegate;
    StyledPageControl               *_customPageControl;
    
    int times;
}
@property (nonatomic, retain) StyledPageControl   *customPageControl;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) RuYiCaiAppDelegate *delegate;
- (id)initWithFrame:(CGRect)frame FirstTime:(BOOL)ifFirstIn;
-(void)addCloseBtn;
@end
