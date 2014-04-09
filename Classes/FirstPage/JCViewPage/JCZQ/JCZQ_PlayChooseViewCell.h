//
//  JCZQ_PlayChooseViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-5-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCZQ_PickGameViewController;
@interface JCZQ_PlayChooseViewCell : UIView {
    NSString                                *m_SFTitle;
    NSString                                *m_LetPointTitle;
    NSString                                *m_SFCTitle;
    NSString                                *m_BigAndSmallTitle;
    NSString                                *m_SFTitle_DanGuan;
    NSString                                *m_LetPointTitle_DanGuan;
    NSString                                *m_SFCTitle_DanGuan;
    NSString                                *m_BigAndSmallTitle_DanGuan;
    NSString                                *m_hunheTitle;
    
    UIButton                                *m_hunheButton;
    
    UIButton                                *m_SFButton;
    UIButton                                *m_SPFButton;
    UIButton                                *m_LetPointButton;
    UIButton                                *m_SFCButton;
    UIButton                                *m_BigAndSmallButton;
    
    UIButton                                *m_SFButton_DanGuan;
    UIButton                                *m_SPFButton_DanGuan;
    UIButton                                *m_LetPointButton_DanGuan;
    UIButton                                *m_SFCButton_DanGuan;
    UIButton                                *m_BigAndSmallButton_DanGuan;
    
    int                                     m_PlayTypeTag;
    JCZQ_PickGameViewController            *m_parentController;
}
@property (nonatomic,retain) NSString* SFTitle;
@property (nonatomic,retain) NSString* LetPointTitle;
@property (nonatomic,retain) NSString* SFCTitle;
@property (nonatomic,retain) NSString* BigAndSmallTitle;

@property (nonatomic,retain) NSString* SFTitle_DanGuan;
@property (nonatomic,retain) NSString* LetPointTitle_DanGuan;
@property (nonatomic,retain) NSString* SFCTitle_DanGuan;
@property (nonatomic,retain) NSString* BigAndSmallTitle_DanGuan;
@property (nonatomic,retain) NSString* hunheTitle;

@property (nonatomic,retain) JCZQ_PickGameViewController* parentController;
@property (nonatomic,assign) int PlayTypeTag;

-(void) RefreshCellView;
@end
