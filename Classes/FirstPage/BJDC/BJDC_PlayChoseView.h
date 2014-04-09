//
//  BJDC_PlayChoseView.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-24.
//
//

#import <UIKit/UIKit.h>

@class BJDC_pickNumViewController;
@interface BJDC_PlayChoseView : UIView
{
    BJDC_pickNumViewController*  m_parentController;
    
    UIButton                                *m_SPFButton;
    UIButton                                *m_AllJinQiuButton;
    UIButton                                *m_ScoreButton;
    UIButton                                *m_HalfAndAllButton;
    UIButton                                *m_UpAndDownButton;
}

@property(nonatomic, retain)BJDC_pickNumViewController*  parentController;

- (void)buttonClick:(UIButton*)tempButton;

@end
