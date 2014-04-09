//
//  RYCHighBetView.h
//  RuYiCai
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimationTabView;
@class NormalBetViewController;
@class ZhuiHaoBetViewController;
@class ShouYiLvSetViewController;
#import "CustomSegmentedControl.h"

@interface RYCHighBetView : UIViewController<UITextFieldDelegate, UIAlertViewDelegate,CustomSegmentedControlDelegate>
{
    int              allCount;
    
    AnimationTabView*   m_animationTabView;
    CustomSegmentedControl     *_cusSegmented;
    NormalBetViewController*   m_normalBetViewController;
    ShouYiLvSetViewController *m_shouYiLvViewController;
    ZhuiHaoBetViewController*  m_zhuiHaoViewController;
}

@property (nonatomic, retain) IBOutlet UIScrollView*  normalBetScroll;
@property (nonatomic, retain) IBOutlet UIScrollView*  zhuiHaoBetScroll;
@property (nonatomic, retain) IBOutlet UIScrollView*  shouYilvBetScroll;
@property (nonatomic, retain) CustomSegmentedControl     *cusSegmented;
@property (nonatomic, retain) AnimationTabView*      animationTabView;
@property (nonatomic, retain) ShouYiLvSetViewController *shouYiLvViewController;
@property (nonatomic, retain) NormalBetViewController*  normalBetViewController;
@property (nonatomic, retain) ZhuiHaoBetViewController*  zhuiHaoViewController;

@property (nonatomic, retain) IBOutlet UIButton*   buyButton;

- (IBAction)buyClick:(id)sender;

- (void)back:(id)sender;
- (void)wapPageBuild;

- (void)betCompleteOK:(NSNotification*)notification;
- (void)tabButtonChanged:(NSNotification*)notification;
- (void)computeShouYiLvOK:(NSNotification*)notification;

- (void)betOutTime:(NSNotification*)notification;
 
@end
