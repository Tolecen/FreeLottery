//
//  JC_TabView.h
//  RuYiCai
//
//  Created by ruyicai on 12-5-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@class ZC_pickNumberViewController;
@interface ZC_TabView : UIView {
    UIButton*                   m_sfc_button;
    UIButton*                   m_rjc_button;
    UIButton*                   m_jqc_button;
    UIButton*                   m_lcb_button;
    
    UIImageView*                m_backImage_white;
    
    ZC_pickNumberViewController            *m_presentViewController;
    
    
    int                         m_selectButtonTag;
    
    RuYiCaiAppDelegate          *m_delegate;
}
@property(nonatomic, assign) int   selectButtonTag;
@property(nonatomic, retain) ZC_pickNumberViewController*   presentViewController;
@property(nonatomic, retain) UIImageView*  backImage_white;

- (void) refreshView;
-(void) changeImage;

@end
